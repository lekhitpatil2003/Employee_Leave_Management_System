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

@WebServlet("/AddEmployeeServlet")
public class AddEmployeeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final EmployeeDao dao = new EmployeeDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/manageEmployees.jsp";

		String emp_id = request.getParameter("emp_id");
		String name = request.getParameter("name");
		String gender = request.getParameter("gender");
		String email = request.getParameter("email");
		String mobile_no = request.getParameter("mobile_no");
		String department = request.getParameter("department");
		String username = request.getParameter("username");
		String password = request.getParameter("password");

		if (isBlank(emp_id) || isBlank(name) || isBlank(email) || isBlank(username) || isBlank(password)) {
			response.sendRedirect(redirect + "?error=All Required Fields Must Be Filled");
			return;
		}

		try {
			if (dao.emailExists(email)) {
				response.sendRedirect(redirect + "?error=An Employee With This Email Already Exists");
				return;
			}

			Employee emp = new Employee();
			emp.setEmp_id(emp_id);
			emp.setName(name);
			emp.setGender(gender);
			emp.setEmail(email);
			emp.setMobile_no(mobile_no);
			emp.setDepartment(department);
			emp.setUser_name(username);
			emp.setPassword(PasswordUtil.hashPassword(password)); // FIX: never store plain text
			emp.setLeave_balance(20);

			boolean status = dao.addEmployee(emp);

			if (status) {
				response.sendRedirect(redirect + "?success=Employee Added Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Unable To Add Employee");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}

	private boolean isBlank(String s) {
		return s == null || s.trim().isEmpty();
	}
}
