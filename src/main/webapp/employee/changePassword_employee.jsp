<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>

<% request.setAttribute("pageTitle", "Change Password"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Password</title>

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
			<p>Update your account password. You'll need to know your current password.</p>
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

		<div class="form-card" style="max-width:500px; margin:auto;">
			<form action="<%=request.getContextPath()%>/EmployeeChangePasswordServlet" method="post">

				<div class="form-group">
					<label>Current Password</label>
					<input type="password" name="currentPassword" required>
				</div>

				<div class="form-group">
					<label>New Password</label>
					<input type="password" name="newPassword" minlength="6" required>
				</div>

				<div class="form-group">
					<label>Confirm New Password</label>
					<input type="password" name="confirmPassword" minlength="6" required>
				</div>

				<button type="submit" class="btn btn-primary"><i class="fas fa-key"></i> Update Password</button>
			</form>
		</div>

	</div>
</body>
</html>
