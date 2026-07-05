<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>

<% request.setAttribute("pageTitle", "My Profile"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile</title>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/employee_section/employeeStyle.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
	.profile-pic-wrapper { text-align:center; margin-bottom: 20px; }
	.profile-pic-wrapper img {
		width: 110px; height: 110px; border-radius: 50%; object-fit: cover;
		border: 4px solid #f1f5f9;
	}
	.toggle-edit { display:none; }
</style>
</head>
<body>
	<%@ include file="Sidebar_employee.jsp"%>
	<%@ include file="Topbar_employee.jsp"%>

	<div class="main-content">

		<div class="page-header">
			<h1></h1>
			<p>View and update your personal information</p>
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

		String name = (String) session.getAttribute("employeeName");
		String email = (String) session.getAttribute("email");
		String mobile = (String) session.getAttribute("mobileNo");
		String department = (String) session.getAttribute("department");
		String empCode = String.valueOf(session.getAttribute("empCode"));
		String username = (String) session.getAttribute("username");
		String profilePic = (String) session.getAttribute("profilePic");
		Object leaveBalance = session.getAttribute("leaveBalance");
		%>

		<div class="profile-card" id="viewMode">

			<div class="profile-pic-wrapper">
				<% if (profilePic != null && !profilePic.isEmpty()) { %>
					<img src="<%=request.getContextPath()%>/uploads/profile_pics/<%=profilePic%>" alt="Profile Picture">
				<% } else { %>
					<div class="profile-icon"><i class="fas fa-circle-user"></i></div>
				<% } %>
			</div>

			<table class="profile-table">
				<tr><th>Employee ID</th><td><%=empCode%></td></tr>
				<tr><th>Full Name</th><td><%=name%></td></tr>
				<tr><th>Username</th><td><%=username%></td></tr>
				<tr><th>Email</th><td><%=email%></td></tr>
				<tr><th>Mobile No</th><td><%=mobile == null ? "-" : mobile%></td></tr>
				<tr><th>Department</th><td><%=department == null ? "-" : department%></td></tr>
				<tr><th>Leave Balance</th><td><span class="balance-badge"><%=leaveBalance%> Days</span></td></tr>
			</table>

			<div class="profile-actions">
				<a href="javascript:void(0);" class="btn-red" onclick="toggleEdit()"><i class="fas fa-pen"></i> Edit Profile</a>
				<a href="<%=request.getContextPath()%>/employee/changePassword_employee.jsp" class="btn-red"><i class="fas fa-key"></i> Change Password</a>
			</div>
		</div>

		<div class="form-card toggle-edit" id="editMode" style="margin-top:25px;">
			<h2 style="margin-bottom:20px;">Edit Profile</h2>

			<!-- FIX: this form previously had no backend at all; now posts to
			     EmployeeEditProfileServlet which updates the DB and refreshes
			     the session so the sidebar/topbar update immediately. -->
			<form action="<%=request.getContextPath()%>/EmployeeEditProfileServlet" method="post" enctype="multipart/form-data">

				<div class="row">
					<div class="form-group">
						<label>Full Name</label>
						<input type="text" name="name" value="<%=name%>" required>
					</div>
					<div class="form-group">
						<label>Gender</label>
						<select name="gender">
							<option>Male</option>
							<option>Female</option>
							<option>Other</option>
						</select>
					</div>
				</div>

				<div class="row">
					<div class="form-group">
						<label>Email</label>
						<input type="email" name="email" value="<%=email%>" required>
					</div>
					<div class="form-group">
						<label>Mobile No</label>
						<input type="text" name="mobile_no" value="<%=mobile == null ? "" : mobile%>">
					</div>
				</div>

				<div class="row">
					<div class="form-group">
						<label>Department</label>
						<input type="text" name="department" value="<%=department == null ? "" : department%>">
					</div>
					<div class="form-group">
						<label>Profile Picture</label>
						<input type="file" name="profile_pic" accept="image/*">
					</div>
				</div>

				<button type="submit" class="btn btn-primary"><i class="fas fa-floppy-disk"></i> Save Changes</button>
				<a href="javascript:void(0);" class="btn" style="background:#e2e8f0;" onclick="toggleEdit()">Cancel</a>
			</form>
		</div>

	</div>

	<script>
		function toggleEdit() {
			document.getElementById('viewMode').style.display =
				document.getElementById('viewMode').style.display === 'none' ? '' : 'none';
			var edit = document.getElementById('editMode');
			edit.style.display = edit.style.display === 'block' ? 'none' : 'block';
		}
	</script>

</body>
</html>
