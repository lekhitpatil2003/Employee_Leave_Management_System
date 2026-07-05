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

@WebServlet("/ChangePasswordServlet")
public class AdminChangePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final AdminDao adminDao = new AdminDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String redirect = request.getContextPath() + "/admin/adminProfile.jsp";

		if (session == null || session.getAttribute("adminId") == null) {
			response.sendRedirect(request.getContextPath() + "/admin/admin_login.jsp?error=session");
			return;
		}

		int adminId = (int) session.getAttribute("adminId");
		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		try {
			Admin admin = adminDao.getById(adminId);

			if (admin == null || !PasswordUtil.verifyPassword(currentPassword, admin.getPassword())) {
				response.sendRedirect(redirect + "?error=Current Password Is Incorrect");
				return;
			}
			if (newPassword == null || newPassword.length() < 6) {
				response.sendRedirect(redirect + "?error=New Password Must Be At Least 6 Characters");
				return;
			}
			if (!newPassword.equals(confirmPassword)) {
				response.sendRedirect(redirect + "?error=New Password And Confirm Password Do Not Match");
				return;
			}

			boolean status = adminDao.updatePassword(adminId, PasswordUtil.hashPassword(newPassword));

			if (status) {
				response.sendRedirect(redirect + "?success=Password Updated Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Unable To Update Password");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
