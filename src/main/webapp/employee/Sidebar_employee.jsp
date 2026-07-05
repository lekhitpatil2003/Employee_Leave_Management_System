<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>

<%
String sidebar_employeeName = (String) session.getAttribute("employeeName");

if (sidebar_employeeName == null) {
	response.sendRedirect(request.getContextPath() + "/employee/employee_login.jsp?error=session");
	return;
}

request.setAttribute("employeeName", sidebar_employeeName);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Sidebar</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/employee_section/employeeSidebar.css">
</head>
<body>

	<div class="sidebar">

		<div class="logo-section">

			<div class="logo">
				<img src="<%=request.getContextPath()%>/images/logo.png"
					alt="ELMS Logo">
			</div>

			<h2>ELMS</h2>
			<p>Employee Panel</p>

		</div>

		<ul class="menu">

			<li><a
				href="<%=request.getContextPath()%>/employee/dashboard_employee.jsp">
					<i class="fas fa-gauge-high"></i> <span>Dashboard</span>
			</a></li>

			<li><a
				href="<%=request.getContextPath()%>/employee/applyLeave_employee.jsp">
					<i class="fas fa-file-circle-plus"></i> <span>Apply Leave</span>
			</a></li>

			<li><a
				href="<%=request.getContextPath()%>/employee/myLeave_employee.jsp">
					<i class="fas fa-calendar-check"></i> <span>My Leaves</span>
			</a></li>

			<li><a
				href="<%=request.getContextPath()%>/employee/profile_employee.jsp">
					<i class="fas fa-user"></i> <span>Profile</span>
			</a></li>

			<li><a
				href="<%=request.getContextPath()%>/employee/changePassword_employee.jsp">
					<i class="fas fa-key"></i> <span>Change Password</span>
			</a></li>

		</ul>

		<div class="logout-section">

			<a href="<%=request.getContextPath()%>/EmployeeLogoutServlet"> <i
				class="fas fa-right-from-bracket"></i> <span>Logout</span>
			</a>

		</div>

	</div>

</body>
</html>
