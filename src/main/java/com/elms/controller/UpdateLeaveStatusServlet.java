package com.elms.controller;

import java.io.IOException;

import com.elms.dao.EmployeeDao;
import com.elms.dao.LeaveRequestDao;
import com.elms.entity.LeaveRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Admin approves or rejects a leave request. On approval, the employee's
 * leave balance is deducted by the number of days requested, completing the
 * "leave balance tracking" requirement and keeping the employee side of the
 * workflow (My Leaves / dashboard) automatically in sync since they read
 * from the same tables.
 */
@WebServlet("/UpdateLeaveStatusServlet")
public class UpdateLeaveStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final LeaveRequestDao leaveRequestDao = new LeaveRequestDao();
	private final EmployeeDao employeeDao = new EmployeeDao();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String redirect = request.getContextPath() + "/admin/viewLeaves.jsp";

		try {
			int leaveId = Integer.parseInt(request.getParameter("id"));
			String action = request.getParameter("action"); // "approve" or "reject"
			String remarks = request.getParameter("remarks");

			String newStatus;
			if ("approve".equalsIgnoreCase(action)) {
				newStatus = "Approved";
			} else if ("reject".equalsIgnoreCase(action)) {
				newStatus = "Rejected";
			} else {
				response.sendRedirect(redirect + "?error=Invalid Action");
				return;
			}

			LeaveRequest lr = leaveRequestDao.getById(leaveId);
			if (lr == null) {
				response.sendRedirect(redirect + "?error=Leave Request Not Found");
				return;
			}
			if (!"Pending".equalsIgnoreCase(lr.getStatus())) {
				response.sendRedirect(redirect + "?error=This Request Has Already Been Processed");
				return;
			}

			boolean status = leaveRequestDao.updateStatus(leaveId, newStatus, remarks);

			if (status && "Approved".equals(newStatus)) {
				employeeDao.adjustLeaveBalance(lr.getEmp_id(), lr.getTotal_days());
			}

			if (status) {
				response.sendRedirect(redirect + "?success=Leave Request " + newStatus);
			} else {
				response.sendRedirect(redirect + "?error=Unable To Update Leave Request");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
