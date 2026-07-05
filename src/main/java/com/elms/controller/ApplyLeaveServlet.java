package com.elms.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import com.elms.dao.LeaveRequestDao;
import com.elms.entity.LeaveRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * FIX: applyLeave_employee.jsp posted to this servlet, but it never existed
 * -> every leave application produced a 404. This implements the complete
 * "employee applies for leave" step of the workflow: validates the dates,
 * computes total days server-side (never trusts the client), saves it as
 * Pending, and it will immediately show up for the admin because both
 * sides read from the same leave_request table.
 */
@WebServlet("/ApplyLeaveServlet")
public class ApplyLeaveServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final LeaveRequestDao leaveRequestDao = new LeaveRequestDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String redirect = request.getContextPath() + "/employee/applyLeave_employee.jsp";

		if (session == null || session.getAttribute("srNo") == null) {
			response.sendRedirect(request.getContextPath() + "/employee/employee_login.jsp?error=session");
			return;
		}

		int empId = (int) session.getAttribute("srNo");

		String leaveType = request.getParameter("leave_type");
		String fromDateStr = request.getParameter("from_date");
		String toDateStr = request.getParameter("to_date");
		String reason = request.getParameter("reason");

		if (isBlank(leaveType) || isBlank(fromDateStr) || isBlank(toDateStr) || isBlank(reason)) {
			response.sendRedirect(redirect + "?error=All Fields Are Required");
			return;
		}

		try {
			LocalDate fromDate = LocalDate.parse(fromDateStr);
			LocalDate toDate = LocalDate.parse(toDateStr);

			if (toDate.isBefore(fromDate)) {
				response.sendRedirect(redirect + "?error=To Date Cannot Be Before From Date");
				return;
			}
			if (fromDate.isBefore(LocalDate.now())) {
				response.sendRedirect(redirect + "?error=From Date Cannot Be In The Past");
				return;
			}

			int totalDays = (int) (ChronoUnit.DAYS.between(fromDate, toDate) + 1);

			LeaveRequest lr = new LeaveRequest();
			lr.setEmp_id(empId);
			lr.setLeave_type(leaveType);
			lr.setFrom_date(Date.valueOf(fromDate));
			lr.setTo_date(Date.valueOf(toDate));
			lr.setTotal_days(totalDays);
			lr.setReason(reason);

			boolean status = leaveRequestDao.apply(lr);

			if (status) {
				response.sendRedirect(
						request.getContextPath() + "/employee/myLeave_employee.jsp?success=Leave Request Submitted Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Unable To Submit Leave Request");
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
