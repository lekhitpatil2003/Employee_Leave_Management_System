<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Leave Management System</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/login/login.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

</head>
<body>

	<div class="container">

		<div class="login-card">

			<div class="logo-section">
				<i class="fas fa-calendar-check"></i>
				<h1>ELMS</h1>
				<p>Employee Leave Management System</p>
			</div>

			<div class="role-section">

				<a href="<%=request.getContextPath()%>/employee/employee_login.jsp" class="role-card employee"> <i
					class="fas fa-user"></i>

					<h2>Employee Login</h2>

				</a> <a href="<%=request.getContextPath()%>/admin/admin_login.jsp" class="role-card admin"> <i
					class="fas fa-user-shield"></i>

					<h2>Admin Login</h2>

				</a>

			</div>

		</div>

	</div>

</body>
</html>