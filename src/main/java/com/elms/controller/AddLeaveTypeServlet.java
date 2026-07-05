package com.elms.controller;

import java.io.IOException;

import com.elms.dao.LeaveTypeDao;
import com.elms.entity.LeaveType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddLeaveTypeServlet")
public class AddLeaveTypeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final LeaveTypeDao leavedao = new LeaveTypeDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/leaveType.jsp";
		String leave_name = request.getParameter("leave_name");
		String leave_code = request.getParameter("leave_code");
		String description = request.getParameter("description");

		if (leave_name == null || leave_name.isBlank() || leave_code == null || leave_code.isBlank()) {
			response.sendRedirect(redirect + "?error=Leave Type Name And Code Are Required");
			return;
		}

		LeaveType leavetype = new LeaveType();
		leavetype.setLeave_name(leave_name);
		leavetype.setLeave_code(leave_code);
		leavetype.setDescription(description);

		try {
			// FIX: message previously said "Employee Added" on a Leave Type page
			boolean status = leavedao.leaveType(leavetype);
			if (status) {
				response.sendRedirect(redirect + "?success=Leave Type Added Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Unable To Add Leave Type");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
