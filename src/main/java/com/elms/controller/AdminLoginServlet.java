package com.elms.controller;

import java.io.IOException;

import com.elms.dao.AdminDao;
import com.elms.entity.Admin;
import com.elms.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles admin login. FIXED: now uses PasswordUtil to verify hashed
 * passwords, wraps DB access in try/catch so a DB failure shows a proper
 * error message instead of a blank page, and stores adminId/username in
 * the session (needed by AdminAuthFilter and the profile page).
 */
@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final AdminDao adminDao = new AdminDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");

		try {
			Admin admin = adminDao.findByUsername(username);

			if (admin != null && PasswordUtil.verifyPassword(password, admin.getPassword())) {
				HttpSession session = request.getSession();
				session.setAttribute("adminId", admin.getAdmin_id());
				session.setAttribute("adminName", admin.getFull_name());
				session.setAttribute("adminUsername", admin.getUsername());

				response.sendRedirect(request.getContextPath() + "/admin/adminDashboard.jsp");
			} else {
				response.sendRedirect(request.getContextPath() + "/admin/admin_login.jsp?error=invalid");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/admin/admin_login.jsp?error=server");
		}
	}
}
