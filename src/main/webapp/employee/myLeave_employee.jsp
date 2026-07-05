<%@page import="java.util.List"%>
<%@page import="com.elms.dao.LeaveRequestDao"%>
<%@page import="com.elms.entity.LeaveRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>

<% request.setAttribute("pageTitle", "My Leaves"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Leaves</title>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/employee_section/employeeStyle.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
	<%@ include file="Sidebar_employee.jsp"%>
	<%@ include file="Topbar_employee.jsp"%>

	<div class="main-content">

		<div class="page-header">
			<h1></h1>
			<p>Track the status of every leave request you've submitted</p>
		</div>

		<%
		String error = request.getParameter("error");
		String success = request.getParameter("success");
		if (error != null) {
		%>
		<div class="error-message"><i class="fas fa-circle-exclamation"></i> <%=error%></div>
		<%
		}
		if (success != null) {
		%>
		<div class="success-message"><i class="fas fa-circle-check"></i> <%=success%></div>
		<%
		}
		%>

		<div class="table-card">
			<table>
				<thead>
					<tr>
						<th>Leave Type</th>
						<th>From</th>
						<th>To</th>
						<th>Days</th>
						<th>Reason</th>
						<th>Status</th>
						<th>Admin Remarks</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<%
					int empId = (int) session.getAttribute("srNo");
					List<LeaveRequest> list = null;
					try {
						LeaveRequestDao dao = new LeaveRequestDao();
						list = dao.getByEmployee(empId, null);
					} catch (Exception e) {
						e.printStackTrace();
					}

					if (list != null && !list.isEmpty()) {
						for (LeaveRequest lr : list) {
							String st = lr.getStatus();
							String cls = "Approved".equalsIgnoreCase(st) ? "approved"
									: "Rejected".equalsIgnoreCase(st) ? "rejected"
									: "Cancelled".equalsIgnoreCase(st) ? "badge-muted" : "pending";
					%>
					<tr>
						<td><%=lr.getLeave_type()%></td>
						<td><%=lr.getFrom_date()%></td>
						<td><%=lr.getTo_date()%></td>
						<td><%=lr.getTotal_days()%></td>
						<td><%=lr.getReason()%></td>
						<td><span class="<%=cls%>"><%=st%></span></td>
						<td><%=lr.getAdmin_remarks() == null ? "-" : lr.getAdmin_remarks()%></td>
						<td>
							<%
							if ("Pending".equalsIgnoreCase(st)) {
							%>
							<a class="cancel-btn" href="<%=request.getContextPath()%>/CancelLeaveServlet?id=<%=lr.getLeave_id()%>"
								onclick="return confirm('Cancel this pending leave request?');">
								<i class="fas fa-ban"></i> Cancel
							</a>
							<%
							} else {
							%>
							&mdash;
							<%
							}
							%>
						</td>
					</tr>
					<%
						}
					} else {
					%>
					<tr>
						<td colspan="8" style="text-align:center; color:#64748b;">You haven't applied for any leave yet.</td>
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
