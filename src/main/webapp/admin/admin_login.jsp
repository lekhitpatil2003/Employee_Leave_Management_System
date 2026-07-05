<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Login - ELMS</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/login/admin_login.css">

</head>
<body>

	<div class="container">

		<div class="login-card">

			<div class="header">

				<div class="icon-box">
					<i class="fas fa-user-shield"></i>
				</div>

				<h1>Admin Login</h1>

				<p>Employee Leave Management System</p>

			</div>

			<%
			String error = request.getParameter("error");
			String success = request.getParameter("success");
			if ("invalid".equals(error)) {
			%>
			<div class="error-message">Invalid Username or Password!</div>
			<%
			} else if ("session".equals(error)) {
			%>
			<div class="error-message">Your session has expired. Please login again.</div>
			<%
			} else if ("server".equals(error)) {
			%>
			<div class="error-message">Something went wrong. Please try again.</div>
			<%
			}
			if ("loggedout".equals(success)) {
			%>
			<div class="success-message">You have been logged out successfully.</div>
			<%
			}
			%>

			<form action="<%=request.getContextPath()%>/AdminLoginServlet"
				method="post">

				<div class="input-group">

					<i class="fas fa-user"></i> <input type="text" name="username"
						placeholder="Admin Username" required>

				</div>

				<div class="input-group">

					<i class="fas fa-lock"></i> <input type="password" name="password"
						placeholder="Admin Password" required>

				</div>

				<div class="options">

					<a href="#"> Forgot Password? </a>

				</div>

				<button type="submit" class="login-btn">Login As Admin</button>

			</form>

			<div class="footer">

				<a href="<%=request.getContextPath()%>/index.jsp"> <i
					class="fas fa-arrow-left"></i> Back To Home
				</a>

			</div>

		</div>

	</div>

</body>
</html>