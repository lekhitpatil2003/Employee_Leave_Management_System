<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>

<%
String adminName = (String) session.getAttribute("adminName");

// FIX: previously redirected to "adminLogin.jsp", a file that does not
// exist (the real file is admin_login.jsp) -> this caused a 404 whenever
// a session expired while the user was on any admin page. Also switched
// to an absolute, context-path-based redirect so it works no matter
// which admin page included this sidebar.
if (adminName == null) {
	response.sendRedirect(request.getContextPath() + "/admin/admin_login.jsp?error=session");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>sidebar</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/admin_section/adminSidebar.css">
</head>
<body>
	<div class="sidebar">

		<div class="logo-section">

			<div class="logo">
				<img src="<%=request.getContextPath()%>/images/logo.png" alt="ELMS Logo">
			</div>

			<h2>ELMS</h2>
			<p>Admin Panel</p>

		</div>

		<ul class="menu">

			<li><a href="<%=request.getContextPath()%>/admin/adminDashboard.jsp"> <i
					class="fas fa-gauge-high"></i> <span>Dashboard</span>
			</a></li>

			<li><a href="<%=request.getContextPath()%>/admin/manageEmployees.jsp"> <i class="fas fa-users"></i>
					<span>Manage Employees</span>
			</a></li>

			<li><a href="<%=request.getContextPath()%>/admin/leaveType.jsp"> <i
					class="fas fa-file-signature"></i> <span>Leave Types</span>
			</a></li>

			<li><a href="<%=request.getContextPath()%>/admin/manageDepartment.jsp"> <i
					class="fas fa-building"></i> <span>Department Management</span>
			</a></li>

			<!-- Leave Management Dropdown -->
			<li class="submenu"><a href="javascript:void(0);"
				class="submenu-btn">

					<div>
						<i class="fas fa-calendar-check"></i> <span>Leave
							Management</span>
					</div> <i class="fas fa-chevron-down arrow"></i>

			</a>

				<ul class="submenu-items">

					<li><a href="<%=request.getContextPath()%>/admin/viewLeaves.jsp"> <i class="fas fa-eye"></i>
							View Leaves
					</a></li>

					<li><a href="<%=request.getContextPath()%>/admin/approvedLeaves.jsp"> <i
							class="fas fa-circle-check"></i> Approved Leaves
					</a></li>

					<li><a href="<%=request.getContextPath()%>/admin/rejectedLeaves.jsp"> <i
							class="fas fa-circle-xmark"></i> Rejected Leaves
					</a></li>

				</ul></li>

			<li><a href="<%=request.getContextPath()%>/admin/adminProfile.jsp"> <i class="fas fa-user-gear"></i>
					<span>Profile</span>
			</a></li>

		</ul>

		<div class="logout-section">

			<a href="<%=request.getContextPath()%>/AdminLogoutServlet"> <i
				class="fas fa-right-from-bracket"></i> <span>Logout</span>
			</a>

		</div>

	</div>
	<script src="<%=request.getContextPath()%>/js/script.js"></script>
</body>
</html>
