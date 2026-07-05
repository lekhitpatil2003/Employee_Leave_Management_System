package com.elms.controller;

import java.io.IOException;

import com.elms.dao.EmployeeDao;
import com.elms.entity.Employee;
import com.elms.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EmployeeChangePasswordServlet")
public class EmployeeChangePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final EmployeeDao employeeDao = new EmployeeDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String redirect = request.getContextPath() + "/employee/changePassword_employee.jsp";

		if (session == null || session.getAttribute("srNo") == null) {
			response.sendRedirect(request.getContextPath() + "/employee/employee_login.jsp?error=session");
			return;
		}

		int srNo = (int) session.getAttribute("srNo");
		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		try {
			Employee emp = employeeDao.getById(srNo);

			if (emp == null || !PasswordUtil.verifyPassword(currentPassword, emp.getPassword())) {
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

			boolean status = employeeDao.updatePassword(srNo, PasswordUtil.hashPassword(newPassword));

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
