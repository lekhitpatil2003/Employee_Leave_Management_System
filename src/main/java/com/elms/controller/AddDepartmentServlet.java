package com.elms.controller;

import java.io.IOException;

import com.elms.dao.DepartmentDao;
import com.elms.entity.Department;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddDepartmentServlet")
public class AddDepartmentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final DepartmentDao departmentDao = new DepartmentDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/manageDepartment.jsp";
		String dept_name = request.getParameter("dept_name");
		String dept_code = request.getParameter("dept_code");
		String description = request.getParameter("description");

		if (dept_name == null || dept_name.isBlank() || dept_code == null || dept_code.isBlank()) {
			response.sendRedirect(redirect + "?error=Department Name And Code Are Required");
			return;
		}

		Department department = new Department();
		department.setDept_name(dept_name);
		department.setDept_code(dept_code);
		department.setDescription(description);

		try {
			boolean status = departmentDao.department(department);
			if (status) {
				response.sendRedirect(redirect + "?success=Department Added Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Unable To Add Department");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
