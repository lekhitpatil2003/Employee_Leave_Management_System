package com.elms.controller;

import java.io.IOException;

import com.elms.dao.EmployeeDao;
import com.elms.entity.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * FIX: manageEmployees.jsp had an Edit button with no backend at all
 * (href="#"). This servlet, together with the edit modal added to
 * manageEmployees.jsp, completes that missing CRUD functionality.
 */
@WebServlet("/EditEmployeeServlet")
public class EditEmployeeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final EmployeeDao dao = new EmployeeDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/manageEmployees.jsp";

		try {
			int srNo = Integer.parseInt(request.getParameter("sr_no"));
			String name = request.getParameter("name");
			String gender = request.getParameter("gender");
			String email = request.getParameter("email");
			String mobile_no = request.getParameter("mobile_no");
			String department = request.getParameter("department");

			if (name == null || name.isBlank() || email == null || email.isBlank()) {
				response.sendRedirect(redirect + "?error=Name And Email Are Required");
				return;
			}

			Employee emp = new Employee();
			emp.setSr_no(srNo);
			emp.setName(name);
			emp.setGender(gender);
			emp.setEmail(email);
			emp.setMobile_no(mobile_no);
			emp.setDepartment(department);

			boolean status = dao.updateEmployee(emp);

			if (status) {
				response.sendRedirect(redirect + "?success=Employee Updated Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Unable To Update Employee");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
