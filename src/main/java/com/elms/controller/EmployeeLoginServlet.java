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

/**
 * FIXED (root cause of the reported "blank page / 404 after employee login"
 * bug): the previous version redirected back to
 * "employee/employee_login.jsp" on a SUCCESSFUL login instead of forwarding
 * the user to the dashboard, and used a relative path instead of the
 * context path. It also never wrapped the JDBC calls' failure path in a
 * response, so a DB error left the page blank. Both are fixed below.
 */
@WebServlet("/EmployeeLoginServlet")
public class EmployeeLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final EmployeeDao employeeDao = new EmployeeDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");
		String password = request.getParameter("password");

		try {
			Employee emp = employeeDao.getByEmail(email);

			if (emp != null && PasswordUtil.verifyPassword(password, emp.getPassword())) {

				HttpSession session = request.getSession();
				session.setAttribute("srNo", emp.getSr_no());
				session.setAttribute("empId", emp.getSr_no());
				session.setAttribute("empCode", emp.getEmp_id());
				session.setAttribute("employeeName", emp.getName());
				session.setAttribute("empName", emp.getName());
				session.setAttribute("email", emp.getEmail());
				session.setAttribute("mobileNo", emp.getMobile_no());
				session.setAttribute("department", emp.getDepartment());
				session.setAttribute("username", emp.getUser_name());
				session.setAttribute("leaveBalance", emp.getLeave_balance());
				session.setAttribute("profilePic", emp.getProfile_pic());

				// FIX: redirect to the dashboard (not back to the login page),
				// and always go through the context path so the URL resolves
				// correctly no matter which page issued the request.
				response.sendRedirect(request.getContextPath() + "/employee/dashboard_employee.jsp");

			} else {
				response.sendRedirect(request.getContextPath() + "/employee/employee_login.jsp?error=invalid");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/employee/employee_login.jsp?error=server");
		}
	}
}
