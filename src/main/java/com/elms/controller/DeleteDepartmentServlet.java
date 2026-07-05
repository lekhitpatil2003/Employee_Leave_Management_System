package com.elms.controller;

import java.io.IOException;

import com.elms.dao.DepartmentDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteDepartmentServlet")
public class DeleteDepartmentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final DepartmentDao departmentDao = new DepartmentDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/manageDepartment.jsp";

		try {
			int dept_id = Integer.parseInt(request.getParameter("id"));
			boolean status = departmentDao.deleteDepartment(dept_id);

			if (status) {
				response.sendRedirect(redirect + "?success=Deleted Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Delete Failed");
			}

		} catch (Exception e) {
			e.printStackTrace();
			// FIX: previously no response was sent on exception -> blank page.
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
