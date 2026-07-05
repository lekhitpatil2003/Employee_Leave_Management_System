<%@page import="java.util.List"%>
<%@page import="com.elms.dao.LeaveRequestDao"%>
<%@page import="com.elms.entity.LeaveRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>

<% request.setAttribute("pageTitle", "Dashboard"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Dashboard</title>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/employee_section/employeeStyle.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

</head>
<body>
	<%@ include file="Sidebar_employee.jsp"%>
	<%@ include file="Topbar_employee.jsp"%>

	<div class="main-content">

		<%
		int empId = (int) session.getAttribute("srNo");
		int leaveBalance = 0;
		int pendingCount = 0, approvedCount = 0, rejectedCount = 0;
		List<LeaveRequest> recent = null;

		try {
			LeaveRequestDao leaveRequestDao = new LeaveRequestDao();
			List<LeaveRequest> all = leaveRequestDao.getByEmployee(empId, null);

			for (LeaveRequest lr : all) {
				if ("Pending".equalsIgnoreCase(lr.getStatus())) pendingCount++;
				else if ("Approved".equalsIgnoreCase(lr.getStatus())) approvedCount++;
				else if ("Rejected".equalsIgnoreCase(lr.getStatus())) rejectedCount++;
			}
			recent = all.size() > 5 ? all.subList(0, 5) : all;

			Object lb = session.getAttribute("leaveBalance");
			leaveBalance = lb != null ? (int) lb : 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		%>

		<div class="cards">

			<div class="card blue">
				<i class="fas fa-wallet"></i>
				<div>
					<h2><%=leaveBalance%></h2>
					<p>Leave Balance (Days)</p>
				</div>
			</div>

			<div class="card orange">
				<i class="fas fa-hourglass-half"></i>
				<div>
					<h2><%=pendingCount%></h2>
					<p>Pending Requests</p>
				</div>
			</div>

			<div class="card green">
				<i class="fas fa-circle-check"></i>
				<div>
					<h2><%=approvedCount%></h2>
					<p>Approved Leaves</p>
				</div>
			</div>

			<div class="card red">
				<i class="fas fa-circle-xmark"></i>
				<div>
					<h2><%=rejectedCount%></h2>
					<p>Rejected Leaves</p>
				</div>
			</div>

		</div>

		<div class="page-header">
			<h1>Recent Leave Requests</h1>
			<p>Your most recently submitted leave requests</p>
		</div>

		<div class="table-card">
			<table>
				<thead>
					<tr>
						<th>Leave Type</th>
						<th>From</th>
						<th>To</th>
						<th>Days</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<%
					if (recent != null && !recent.isEmpty()) {
						for (LeaveRequest lr : recent) {
					%>
					<tr>
						<td><%=lr.getLeave_type()%></td>
						<td><%=lr.getFrom_date()%></td>
						<td><%=lr.getTo_date()%></td>
						<td><%=lr.getTotal_days()%></td>
						<td>
							<%
							String st = lr.getStatus();
							String cls = "Approved".equalsIgnoreCase(st) ? "approved"
									: "Rejected".equalsIgnoreCase(st) ? "rejected"
									: "Cancelled".equalsIgnoreCase(st) ? "badge-muted" : "pending";
							%>
							<span class="<%=cls%>"><%=st%></span>
						</td>
					</tr>
					<%
						}
					} else {
					%>
					<tr>
						<td colspan="5" style="text-align:center; color:#64748b;">No leave requests yet. Click "Apply Leave" to get started.</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>

	</div>

</body>
</html>
