<%@page import="java.util.List"%>
<%@page import="com.elms.dao.LeaveRequestDao"%>
<%@page import="com.elms.entity.LeaveRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Approved Leaves</title>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/admin_section/manage_employee.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

	<%@ include file="sidebar_admin.jsp"%>

	<div class="main-content">

		<div class="page-header">
			<div>
				<h1>Approved Leaves</h1>
				<p>All leave requests that have been Approved</p>
			</div>
		</div>

		<%
		String keyword = request.getParameter("q");
		int currentPage = 1;
		try {
			currentPage = Integer.parseInt(request.getParameter("page"));
		} catch (Exception ignore) {
		}
		if (currentPage < 1) currentPage = 1;
		int pageSize = 10;
		int offset = (currentPage - 1) * pageSize;

		List<LeaveRequest> requests = null;
		int totalRecords = 0;

		try {
			LeaveRequestDao dao = new LeaveRequestDao();
			requests = dao.search(keyword, "Approved", offset, pageSize);
			totalRecords = dao.countSearch(keyword, "Approved");
		} catch (Exception e) {
			e.printStackTrace();
		}
		int totalPages = (int) Math.ceil(totalRecords / (double) pageSize);
		if (totalPages < 1) totalPages = 1;
		%>

		<form class="filter-bar" method="get" action="<%=request.getContextPath()%>/admin/approvedLeaves.jsp">
			<div class="search-box" style="margin-bottom:0;">
				<i class="fas fa-magnifying-glass"></i>
				<input type="text" name="q" placeholder="Search by employee name, ID, or leave type..."
					value="<%=keyword == null ? "" : keyword%>">
			</div>
			<button type="submit" class="add-btn" style="border:none;">Search</button>
		</form>

		<div class="table-card">

			<table>
				<thead>
					<tr>
						<th>ID</th>
						<th>Employee</th>
						<th>Department</th>
						<th>Leave Type</th>
						<th>From</th>
						<th>To</th>
						<th>Days</th>
						<th>Reason</th>
						<th>Admin Remarks</th>
						<th>Status</th>
					</tr>
				</thead>

				<tbody>
					<%
					if (requests != null && !requests.isEmpty()) {
						for (LeaveRequest lr : requests) {
					%>
					<tr>
						<td><%=lr.getLeave_id()%></td>
						<td><%=lr.getEmp_name()%></td>
						<td><%=lr.getDepartment()%></td>
						<td><%=lr.getLeave_type()%></td>
						<td><%=lr.getFrom_date()%></td>
						<td><%=lr.getTo_date()%></td>
						<td><%=lr.getTotal_days()%></td>
						<td><%=lr.getReason()%></td>
						<td><%=lr.getAdmin_remarks() == null ? "-" : lr.getAdmin_remarks()%></td>
						<td><span class="approved"><%=lr.getStatus()%></span></td>
					</tr>
					<%
						}
					} else {
					%>
					<tr>
						<td colspan="10" style="text-align:center; color:#64748b;">No Approved leave requests found.</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>

			<% if (totalPages > 1) { %>
			<div class="pagination">
				<% for (int p = 1; p <= totalPages; p++) {
					String qs = "?page=" + p
							+ (keyword != null ? "&q=" + java.net.URLEncoder.encode(keyword, java.nio.charset.StandardCharsets.UTF_8) : "");
				%>
				<a class="<%=p == currentPage ? "active" : ""%>" href="<%=qs%>"><%=p%></a>
				<% } %>
			</div>
			<% } %>

		</div>

	</div>
</body>
</html>
