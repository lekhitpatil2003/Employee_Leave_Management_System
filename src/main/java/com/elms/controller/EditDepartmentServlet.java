package com.elms.controller;

import java.io.IOException;

import com.elms.dao.DepartmentDao;
import com.elms.entity.Department;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditDepartmentServlet")
public class EditDepartmentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final DepartmentDao departmentDao = new DepartmentDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/manageDepartment.jsp";

		try {
			int deptId = Integer.parseInt(request.getParameter("dept_id"));
			Department department = new Department();
			department.setDept_id(deptId);
			department.setDept_name(request.getParameter("dept_name"));
			department.setDept_code(request.getParameter("dept_code"));
			department.setDescription(request.getParameter("description"));

			boolean status = departmentDao.updateDepartment(department);

			if (status) {
				response.sendRedirect(redirect + "?success=Department Updated Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Unable To Update Department");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
