package com.elms.controller;

import java.io.IOException;

import com.elms.dao.EmployeeDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * FIX: manageEmployees.jsp had a Delete button with no backend at all
 * (href="#"). This servlet completes that missing CRUD functionality.
 */
@WebServlet("/DeleteEmployeeServlet")
public class DeleteEmployeeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final EmployeeDao dao = new EmployeeDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/manageEmployees.jsp";

		try {
			int srNo = Integer.parseInt(request.getParameter("id"));
			boolean status = dao.deleteEmployee(srNo);

			if (status) {
				response.sendRedirect(redirect + "?success=Employee Deleted Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Delete Failed");
			}

		} catch (Exception e) {
			e.printStackTrace();
			// FIX: previously this catch block did nothing after logging the
			// error, which left the request hanging with no response body
			// (the "blank page" symptom). Now we always redirect.
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
