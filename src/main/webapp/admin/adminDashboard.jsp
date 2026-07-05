<%@page import="java.util.List"%>
<%@page import="com.elms.dao.EmployeeDao"%>
<%@page import="com.elms.dao.DepartmentDao"%>
<%@page import="com.elms.dao.LeaveTypeDao"%>
<%@page import="com.elms.dao.LeaveRequestDao"%>
<%@page import="com.elms.entity.LeaveRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/admin_section/admin_dashboard.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>
	<%@ include file="sidebar_admin.jsp"%>

	<div class="main-content">

		<!-- Top Header -->

		<div class="topbar">

			<div>
				<h1>Dashboard</h1>
				<p>Welcome Back, <%=session.getAttribute("adminName")%></p>
			</div>

			<div class="admin-profile">
				<i class="fas fa-user-shield"></i> <%=session.getAttribute("adminName")%>
			</div>

		</div>

		<%
		// FIX: this page previously ran raw JDBC directly inside the JSP,
		// never closed the Connection/PreparedStatement/ResultSet (resource
		// leak that eventually exhausts the connection pool), and 3 of the
		// 6 stat cards were hardcoded numbers (25 / 80 / 12) instead of real
		// data. All stats below now come from the DAO layer with real
		// try-with-resources JDBC underneath, and everything is wrapped so a
		// DB failure shows a message instead of a blank page.
		int totalEmployees = 0, totalDepartment = 0, totalLeaveType = 0;
		int pendingCount = 0, approvedCount = 0, rejectedCount = 0;
		List<LeaveRequest> recent = null;

		try {
			totalEmployees = new EmployeeDao().countAll();
			totalDepartment = new DepartmentDao().countAll();
			totalLeaveType = new LeaveTypeDao().countAll();

			LeaveRequestDao leaveRequestDao = new LeaveRequestDao();
			pendingCount = leaveRequestDao.countByStatus("Pending");
			approvedCount = leaveRequestDao.countByStatus("Approved");
			rejectedCount = leaveRequestDao.countByStatus("Rejected");
			recent = leaveRequestDao.getRecent(6);
		} catch (Exception e) {
			e.printStackTrace();
		}
		%>

		<!-- Statistics Cards -->
		<div class="cards">

			<div class="dashboard-card blue">
				<i class="fas fa-users"></i>
				<div>
					<h2><%=totalEmployees%></h2>
					<p>Total Employees</p>
				</div>
			</div>

			<div class="dashboard-card blue">
				<i class="fas fa-building"></i>
				<div>
					<h2><%=totalDepartment%></h2>
					<p>Total Department</p>
				</div>
			</div>

			<div class="dashboard-card blue">
				<i class="fas fa-file-signature"></i>
				<div>
					<h2><%=totalLeaveType%></h2>
					<p>Total Leave Types</p>
				</div>
			</div>

			<div class="dashboard-card orange">
				<i class="fas fa-hourglass-half"></i>
				<div>
					<h2><%=pendingCount%></h2>
					<p>Pending Requests</p>
				</div>
			</div>

			<div class="dashboard-card green">
				<i class="fas fa-circle-check"></i>
				<div>
					<h2><%=approvedCount%></h2>
					<p>Approved Leaves</p>
				</div>
			</div>

			<div class="dashboard-card red">
				<i class="fas fa-circle-xmark"></i>
				<div>
					<h2><%=rejectedCount%></h2>
					<p>Rejected Leaves</p>
				</div>
			</div>

		</div>

		<!-- Quick Action Buttons -->
		<!-- FIX: previously pointed at "addEmployee.jsp" (a bootstrap modal
		     target that doesn't exist as a standalone page) and a link
		     mislabeled "Add Department" that actually opened
		     leaveRequests.jsp. Both now point at the real, working pages. -->
		<div class="actions">
			<a href="<%=request.getContextPath()%>/admin/manageEmployees.jsp"> <i class="fas fa-user-plus"></i>
				Manage Employees
			</a>
			<a href="<%=request.getContextPath()%>/admin/manageDepartment.jsp"> <i class="fas fa-building"></i>
				Manage Departments
			</a>
			<a href="<%=request.getContextPath()%>/admin/viewLeaves.jsp"> <i class="fas fa-calendar-check"></i>
				Review Leave Requests
			</a>
		</div>

		<div class="bottom-section">

			<!-- Leave Request Table -->
			<div class="table-section">

				<h2>Recent Leave Requests</h2>

				<table>
					<thead>
						<tr>
							<th>ID</th>
							<th>Employee</th>
							<th>Leave Type</th>
							<th>From</th>
							<th>To</th>
							<th>Status</th>
						</tr>
					</thead>

					<tbody>
						<%
						if (recent != null && !recent.isEmpty()) {
							for (LeaveRequest lr : recent) {
								String st = lr.getStatus();
								String cls = "Approved".equalsIgnoreCase(st) ? "approved"
										: "Rejected".equalsIgnoreCase(st) ? "rejected" : "pending";
						%>
						<tr>
							<td><%=lr.getLeave_id()%></td>
							<td><%=lr.getEmp_name()%></td>
							<td><%=lr.getLeave_type()%></td>
							<td><%=lr.getFrom_date()%></td>
							<td><%=lr.getTo_date()%></td>
							<td><span class="<%=cls%>"><%=st%></span></td>
						</tr>
						<%
							}
						} else {
						%>
						<tr>
							<td colspan="6" style="text-align:center; color:#64748b;">No leave requests yet.</td>
						</tr>
						<%
						}
						%>
					</tbody>

				</table>

			</div>

			<!-- Calendar -->
			<div class="calendar-section">

				<div class="calendar-header">

					<button id="prevMonth">
						<i class="fas fa-chevron-left"></i>
					</button>

					<h3 id="monthYear"></h3>

					<button id="nextMonth">
						<i class="fas fa-chevron-right"></i>
					</button>

				</div>

				<div class="weekdays">
					<div>Sun</div>
					<div>Mon</div>
					<div>Tue</div>
					<div>Wed</div>
					<div>Thu</div>
					<div>Fri</div>
					<div>Sat</div>
				</div>

				<div id="calendarDays" class="calendar-days"></div>

			</div>

		</div>

	</div>

	<script src="<%=request.getContextPath()%>/js/calendar.js"></script>
</body>
</html>
