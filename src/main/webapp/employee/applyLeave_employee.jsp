<%@page import="java.util.List"%>
<%@page import="com.elms.dao.LeaveTypeDao"%>
<%@page import="com.elms.entity.LeaveType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>

<% request.setAttribute("pageTitle", "Apply Leave"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Apply Leave</title>

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
			<p>Submit a new leave request. It will appear in your manager's queue immediately.</p>
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

		<div class="form-card">
			<!-- FIX: this form previously had no working submission target at
			     all -> ApplyLeaveServlet did not exist, so every submission
			     produced a 404. It now posts to the real, implemented servlet. -->
			<form action="<%=request.getContextPath()%>/ApplyLeaveServlet" method="post" id="applyLeaveForm">

				<div class="row">
					<div class="form-group">
						<label>Leave Type</label>
						<select name="leave_type" required>
							<option value="">-- Select Leave Type --</option>
							<%
							try {
								LeaveTypeDao leaveTypeDao = new LeaveTypeDao();
								List<LeaveType> types = leaveTypeDao.getAll();
								for (LeaveType lt : types) {
							%>
							<option value="<%=lt.getLeave_name()%>"><%=lt.getLeave_name()%> (<%=lt.getLeave_code()%>)</option>
							<%
								}
							} catch (Exception e) {
								e.printStackTrace();
							}
							%>
						</select>
					</div>

					<div class="form-group">
						<label>Total Days</label>
						<input type="text" id="totalDaysPreview" readonly placeholder="Auto-calculated">
					</div>
				</div>

				<div class="row">
					<div class="form-group">
						<label>From Date</label>
						<input type="date" name="from_date" id="fromDate" required>
					</div>

					<div class="form-group">
						<label>To Date</label>
						<input type="date" name="to_date" id="toDate" required>
					</div>
				</div>

				<div class="form-group">
					<label>Reason</label>
					<textarea name="reason" rows="4" required placeholder="Briefly describe the reason for your leave"></textarea>
				</div>

				<button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Submit Request</button>
			</form>
		</div>

	</div>

	<script>
		// Client-side convenience preview only; the server always
		// recomputes and validates total days independently.
		var fromDate = document.getElementById('fromDate');
		var toDate = document.getElementById('toDate');
		var preview = document.getElementById('totalDaysPreview');

		var today = new Date().toISOString().split('T')[0];
		fromDate.setAttribute('min', today);

		function updatePreview() {
			toDate.setAttribute('min', fromDate.value || today);
			if (fromDate.value && toDate.value) {
				var d1 = new Date(fromDate.value);
				var d2 = new Date(toDate.value);
				var diff = Math.round((d2 - d1) / (1000 * 60 * 60 * 24)) + 1;
				preview.value = diff > 0 ? diff + ' day(s)' : 'Invalid range';
			}
		}
		fromDate.addEventListener('change', updatePreview);
		toDate.addEventListener('change', updatePreview);
	</script>

</body>
</html>
