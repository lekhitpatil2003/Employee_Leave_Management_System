<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="true"%>
<%
String pageTitle = (String) request.getAttribute("pageTitle");
String employeeName = (String) request.getAttribute("employeeName");
String topbar_empCode = String.valueOf(session.getAttribute("empCode"));
Object topbar_leaveBalanceObj = session.getAttribute("leaveBalance");
String topbar_profilePic = (String) session.getAttribute("profilePic");
%>

<div class="topbar">

	<div>
		<h1><%=pageTitle == null ? "Dashboard" : pageTitle%></h1>
		<p>
			Welcome,
			<%=employeeName%></p>
	</div>

	<div class="profile-box dropdown-wrapper"
		onclick="document.getElementById('empProfileMenu').classList.toggle('open')">

		<%
		if (topbar_profilePic != null && !topbar_profilePic.isEmpty()) {
		%>
		<img class="topbar-avatar"
			src="<%=request.getContextPath()%>/uploads/profile_pics/<%=topbar_profilePic%>"
			alt="Profile">
		<%
		} else {
		%>
		<i class="fas fa-circle-user"></i>
		<%
		}
		%>

		<span><%=employeeName%> <small>(ID: <%=topbar_empCode%>)
		</small></span> <i class="fas fa-chevron-down" style="font-size: 12px;"></i>

		<div class="dropdown-menu" id="empProfileMenu">
			<a href="<%=request.getContextPath()%>/employee/profile_employee.jsp"><i
				class="fas fa-user"></i> My Profile</a> <a
				href="<%=request.getContextPath()%>/employee/changePassword_employee.jsp"><i
				class="fas fa-key"></i> Change Password</a> <a
				href="<%=request.getContextPath()%>/EmployeeLogoutServlet"><i
				class="fas fa-right-from-bracket"></i> Logout</a>
		</div>
	</div>

</div>
