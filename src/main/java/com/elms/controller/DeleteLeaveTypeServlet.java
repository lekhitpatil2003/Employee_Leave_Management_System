package com.elms.controller;

import java.io.IOException;

import com.elms.dao.LeaveTypeDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteLeaveTypeServlet")
public class DeleteLeaveTypeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final LeaveTypeDao leavedao = new LeaveTypeDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/leaveType.jsp";

		try {
			int leaveId = Integer.parseInt(request.getParameter("id"));
			boolean status = leavedao.deleteLeaveType(leaveId);

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
