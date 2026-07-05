<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Profile</title>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/admin_section/admin_profile.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

</head>
<body>

	<%@ include file="sidebar_admin.jsp"%>
	<div class="main-content">

		<%
		// FIX: this page previously showed only a change-password form with
		// no admin details at all. Now shows the logged-in admin's name and
		// username (from the session set by AdminLoginServlet), plus
		// success/error banners for the change-password action.
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

		<div class="profile-info-card">
			<i class="fas fa-user-shield avatar"></i>
			<div>
				<h2><%=session.getAttribute("adminName")%></h2>
				<p>Username: <%=session.getAttribute("adminUsername")%></p>
			</div>
		</div>

		<div class="change-password-card">

			<h3>
				<i class="fas fa-key"></i> Change Password
			</h3>

			<form action="<%=request.getContextPath()%>/ChangePasswordServlet"
				method="post">

				<div class="form-group">
					<label>Current Password</label> <input type="password"
						name="currentPassword" required>
				</div>

				<div class="form-group">
					<label>New Password</label> <input type="password"
						name="newPassword" required minlength="6">
				</div>

				<div class="form-group">
					<label>Confirm Password</label> <input type="password"
						name="confirmPassword" required minlength="6">
				</div>

				<button type="submit" class="change-btn">
					<i class="fas fa-save"></i> Update Password
				</button>

			</form>

		</div>
	</div>

</body>
</html>
