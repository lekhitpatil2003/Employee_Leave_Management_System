package com.elms.controller;

import java.io.IOException;

import com.elms.dao.LeaveTypeDao;
import com.elms.entity.LeaveType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EditLeaveTypeServlet")
public class EditLeaveTypeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final LeaveTypeDao leavedao = new LeaveTypeDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/leaveType.jsp";

		try {
			int leaveId = Integer.parseInt(request.getParameter("leave_id"));
			LeaveType leaveType = new LeaveType();
			leaveType.setLeave_id(leaveId);
			leaveType.setLeave_name(request.getParameter("leave_name"));
			leaveType.setLeave_code(request.getParameter("leave_code"));
			leaveType.setDescription(request.getParameter("description"));

			boolean status = leavedao.updateLeaveType(leaveType);

			if (status) {
				response.sendRedirect(redirect + "?success=Leave Type Updated Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Unable To Update Leave Type");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
