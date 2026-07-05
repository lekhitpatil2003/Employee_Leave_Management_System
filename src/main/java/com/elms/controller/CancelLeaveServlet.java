package com.elms.controller;

import java.io.IOException;

import com.elms.dao.LeaveRequestDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** Lets an employee cancel their own leave request while it is still Pending. */
@WebServlet("/CancelLeaveServlet")
public class CancelLeaveServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final LeaveRequestDao leaveRequestDao = new LeaveRequestDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String redirect = request.getContextPath() + "/employee/myLeave_employee.jsp";

		if (session == null || session.getAttribute("srNo") == null) {
			response.sendRedirect(request.getContextPath() + "/employee/employee_login.jsp?error=session");
			return;
		}

		int empId = (int) session.getAttribute("srNo");

		try {
			int leaveId = Integer.parseInt(request.getParameter("id"));
			boolean status = leaveRequestDao.cancel(leaveId, empId);

			if (status) {
				response.sendRedirect(redirect + "?success=Leave Request Cancelled");
			} else {
				response.sendRedirect(redirect + "?error=Only Pending Requests Can Be Cancelled");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
