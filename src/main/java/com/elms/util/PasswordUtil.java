package com.elms.util;

import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * Utility class for securely hashing and verifying passwords using PBKDF2WithHmacSHA256.
 *
 * Stored format: iterations:base64(salt):base64(hash)
 *
 * This avoids storing plain-text passwords in the database and uses only
 * classes bundled with the standard JDK (no extra libraries required).
 */
public class PasswordUtil {

	private static final int ITERATIONS = 65536;
	private static final int KEY_LENGTH = 256; // bits
	private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
	private static final SecureRandom RANDOM = new SecureRandom();

	private PasswordUtil() {
	}

	/**
	 * Hashes a plain text password with a freshly generated random salt.
	 */
	public static String hashPassword(String plainPassword) {
		try {
			byte[] salt = new byte[16];
			RANDOM.nextBytes(salt);

			byte[] hash = pbkdf2(plainPassword.toCharArray(), salt, ITERATIONS, KEY_LENGTH);

			String saltStr = Base64.getEncoder().encodeToString(salt);
			String hashStr = Base64.getEncoder().encodeToString(hash);

			return ITERATIONS + ":" + saltStr + ":" + hashStr;
		} catch (Exception e) {
			throw new RuntimeException("Error while hashing password", e);
		}
	}

	/**
	 * Verifies a plain text password against a stored hash produced by hashPassword().
	 * Also supports legacy plain-text comparison so that any pre-existing plain
	 * text passwords in an older database still work until they are reset.
	 */
	public static boolean verifyPassword(String plainPassword, String storedHash) {
		if (plainPassword == null || storedHash == null) {
			return false;
		}

		if (!storedHash.contains(":")) {
			// Legacy plain-text password fallback (older rows / manual DB edits)
			return storedHash.equals(plainPassword);
		}

		try {
			String[] parts = storedHash.split(":");
			if (parts.length != 3) {
				return false;
			}
			int iterations = Integer.parseInt(parts[0]);
			byte[] salt = Base64.getDecoder().decode(parts[1]);
			byte[] hash = Base64.getDecoder().decode(parts[2]);

			byte[] testHash = pbkdf2(plainPassword.toCharArray(), salt, iterations, hash.length * 8);

			// Constant-time comparison to avoid timing attacks
			int diff = hash.length ^ testHash.length;
			for (int i = 0; i < hash.length && i < testHash.length; i++) {
				diff |= hash[i] ^ testHash[i];
			}
			return diff == 0;
		} catch (Exception e) {
			return false;
		}
	}

	private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLength) throws Exception {
		PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, keyLength);
		SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
		return factory.generateSecret(spec).getEncoded();
	}
}
