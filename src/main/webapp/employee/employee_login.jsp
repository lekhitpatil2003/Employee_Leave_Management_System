<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Login</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/login/employee_login.css">

</head>
<body>
	<div class="container">

		<div class="login-card">

			<div class="header">

				<div class="icon-box">
					<i class="fas fa-user"></i>
				</div>

				<h1>Employee Login</h1>

				<p>Welcome back! Login to manage your leave requests.</p>

			</div>

			<%
			String error = request.getParameter("error");
			String success = request.getParameter("success");
			if ("invalid".equals(error)) {
			%>
			<div class="error-message">Invalid Email or Password!</div>
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

			<!-- FIX: was a fragile relative path "../EmployeeLoginServlet";
			     now always resolves correctly regardless of how this page was reached. -->
			<form action="<%=request.getContextPath()%>/EmployeeLoginServlet" method="post">

				<div class="input-group">
					<i class="fas fa-envelope"></i> <input type="text" name="email"
						placeholder="Email" required>
				</div>

				<div class="input-group">
					<i class="fas fa-lock"></i> <input type="password" name="password"
						placeholder="Password" required>
				</div>

				<div class="options">

					<a href="#">Forgot Password?</a>

				</div>

				<button type="submit" class="login-btn">Login</button>

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