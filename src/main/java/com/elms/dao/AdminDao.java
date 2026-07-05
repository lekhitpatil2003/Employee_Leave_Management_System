package com.elms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.elms.entity.Admin;
import com.elms.util.DbConnection;

public class AdminDao {

	public Admin findByUsername(String username) throws SQLException {
		String sql = "SELECT * FROM admin WHERE username=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, username);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		}
		return null;
	}

	public Admin getById(int adminId) throws SQLException {
		String sql = "SELECT * FROM admin WHERE admin_id=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, adminId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		}
		return null;
	}

	public boolean updatePassword(int adminId, String hashedPassword) throws SQLException {
		String sql = "UPDATE admin SET password=? WHERE admin_id=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, hashedPassword);
			ps.setInt(2, adminId);
			return ps.executeUpdate() > 0;
		}
	}

	private Admin mapRow(ResultSet rs) throws SQLException {
		Admin a = new Admin();
		a.setAdmin_id(rs.getInt("admin_id"));
		a.setFull_name(rs.getString("full_name"));
		a.setUsername(rs.getString("username"));
		a.setPassword(rs.getString("password"));
		try {
			a.setEmail(rs.getString("email"));
		} catch (SQLException ignore) {
		}
		return a;
	}
}
