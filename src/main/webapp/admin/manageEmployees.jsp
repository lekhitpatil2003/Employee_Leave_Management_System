<%@page import="java.util.List"%>
<%@page import="com.elms.dao.EmployeeDao"%>
<%@page import="com.elms.dao.DepartmentDao"%>
<%@page import="com.elms.entity.Employee"%>
<%@page import="com.elms.entity.Department"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Employees</title>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/admin_section/manage_employee.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>

	<%@ include file="sidebar_admin.jsp"%>

	<div class="main-content">

		<div class="page-header">

			<div>
				<h1>Manage Employees</h1>
				<p>View and manage employee records</p>
			</div>

			<!-- Add Employee Button  -->
			<button class="add-btn" data-bs-toggle="modal"
				data-bs-target="#addEmployeeModal">

				<i class="fas fa-user-plus"></i> Add Employee

			</button>

		</div>

		<%
		String error = request.getParameter("error");
		String success = request.getParameter("success");
		if (error != null) {
		%>
		<div class="error-message">
			<i class="fas fa-circle-exclamation"></i>
			<%=error%></div>
		<%
		}
		if (success != null) {
		%>
		<div class="success-message">
			<i class="fas fa-circle-check"></i>
			<%=success%></div>
		<%
		}

		String keyword = request.getParameter("q");
		String deptFilter = request.getParameter("dept");
		int currentPage = 1;

		try {
		currentPage = Integer.parseInt(request.getParameter("page"));
		} catch (Exception ignore) {
		}

		if (currentPage < 1) {
		currentPage = 1;
		}
		int pageSize = 8;
		int offset = (currentPage - 1) * pageSize;

		List<Employee> employees = null;
		int totalRecords = 0;
		List<Department> departments = null;

		try {
		EmployeeDao employeeDao = new EmployeeDao();
		employees = employeeDao.search(keyword, deptFilter, offset, pageSize);
		totalRecords = employeeDao.countSearch(keyword, deptFilter);
		departments = new DepartmentDao().getAll();
		} catch (Exception e) {
		e.printStackTrace();
		}
		int totalPages = (int) Math.ceil(totalRecords / (double) pageSize);
		if (totalPages < 1)
		totalPages = 1;
		%>

		<form class="filter-bar" method="get"
			action="<%=request.getContextPath()%>/admin/manageEmployees.jsp">
			<div class="search-box" style="margin-bottom: 0;">
				<i class="fas fa-magnifying-glass"></i> <input type="text" name="q"
					placeholder="Search by name, email, ID or username..."
					value="<%=keyword == null ? "" : keyword%>">
			</div>

			<select name="dept" onchange="this.form.submit()">
				<option value="">All Departments</option>
				<%
				if (departments != null) {
					for (Department d : departments) {
						boolean sel = d.getDept_name().equals(deptFilter);
				%>
				<option value="<%=d.getDept_name()%>" <%=sel ? "selected" : ""%>><%=d.getDept_name()%></option>
				<%
				}
				}
				%>
			</select>

			<button type="submit" class="add-btn" style="border: none;">Search</button>
		</form>

		<div class="table-card">

			<table>

				<thead>

					<tr>
						<th>ID</th>
						<th>Name</th>
						<th>Gender</th>
						<th>Email</th>
						<th>Mobile</th>
						<th>Department</th>
						<th>User Name</th>
						<th>Leave Balance</th>
						<th>Action</th>
					</tr>

				</thead>

				<tbody>

					<%
					if (employees != null && !employees.isEmpty()) {
						for (Employee emp : employees) {
					%>

					<tr>
						<td><%=emp.getEmp_id()%></td>
						<td><%=emp.getName()%></td>
						<td><%=emp.getGender()%></td>
						<td><%=emp.getEmail()%></td>
						<td><%=emp.getMobile_no()%></td>
						<td><%=emp.getDepartment()%></td>
						<td><%=emp.getUser_name()%></td>
						<td><%=emp.getLeave_balance()%></td>

						<td><a href="javascript:void(0);" class="edit-btn"
							data-bs-toggle="modal" data-bs-target="#editEmployeeModal"
							data-srno="<%=emp.getSr_no()%>" data-name="<%=emp.getName()%>"
							data-gender="<%=emp.getGender()%>"
							data-email="<%=emp.getEmail()%>"
							data-mobile="<%=emp.getMobile_no()%>"
							data-dept="<%=emp.getDepartment()%>"
							onclick="fillEditModal(this)"> <i class="fas fa-pen"></i>
						</a> <a
							href="<%=request.getContextPath()%>/DeleteEmployeeServlet?id=<%=emp.getSr_no()%>"
							class="delete-btn"
							onclick="return confirm('Delete this employee? This cannot be undone.');">
								<i class="fas fa-trash"></i>
						</a></td>
					</tr>

					<%
					}
					} else {
					%>
					<tr>
						<td colspan="9" style="text-align: center; color: #64748b;">No
							employees found.</td>
					</tr>
					<%
					}
					%>

				</tbody>

			</table>

			<!-- FIX (#10 Pagination) -->
			<%
			if (totalPages > 1) {
			%>
			<div class="pagination">
				<%
				for (int p = 1; p <= totalPages; p++) {
					String qs = "?page=" + p
					+ (keyword != null
							? "&q=" + java.net.URLEncoder.encode(keyword, java.nio.charset.StandardCharsets.UTF_8)
							: "")
					+ (deptFilter != null
							? "&dept=" + java.net.URLEncoder.encode(deptFilter, java.nio.charset.StandardCharsets.UTF_8)
							: "");
				%>
				<a class="<%=p == currentPage ? "active" : ""%>" href="<%=qs%>"><%=p%></a>
				<%
				}
				%>
			</div>
			<%
			}
			%>

		</div>

	</div>

	<!-- Add Employee Modal -->
	<div class="modal fade" id="addEmployeeModal" tabindex="-1">

		<div class="modal-dialog modal-lg">

			<div class="modal-content">

				<div class="modal-header">

					<h4 class="modal-title">Add New Employee</h4>

					<button type="button" class="btn-close" data-bs-dismiss="modal">
					</button>

				</div>

				<form action="<%=request.getContextPath()%>/AddEmployeeServlet"
					method="post">

					<div class="modal-body">

						<div class="row">

							<div class="col-md-6 mb-3">

								<label>Employee ID</label> <input type="text" name="emp_id"
									class="form-control" required>

							</div>

							<div class="col-md-6 mb-3">

								<label>Full Name</label> <input type="text" name="name"
									class="form-control" required>

							</div>

						</div>

						<div class="row">

							<div class="col-md-6 mb-3">

								<label>Gender</label> <select name="gender" class="form-select"
									required>

									<option>Male</option>
									<option>Female</option>
									<option>Other</option>

								</select>

							</div>

							<div class="col-md-6 mb-3">

								<label>Email</label> <input type="email" name="email"
									class="form-control" required>

							</div>

						</div>

						<div class="row">

							<div class="col-md-6 mb-3">

								<label>Mobile No.</label> <input type="text" name="mobile_no"
									class="form-control" required>

							</div>

							<div class="col-md-6 mb-3">

								<label>Department</label> <select name="department"
									class="form-select" required>

									<option value="">-- Select Department --</option>

									<%
									if (departments != null) {
										for (Department d : departments) {
									%>

									<option value="<%=d.getDept_name()%>">
										<%=d.getDept_name()%>
									</option>

									<%
									}
									}
									%>
								</select>
							</div>

						</div>

						<div class="row">

							<div class="col-md-6 mb-3">

								<label>Username</label> <input type="text" name="username"
									class="form-control" required>

							</div>

							<div class="col-md-6 mb-3">

								<label>Password</label> <input type="password" name="password"
									class="form-control" required minlength="6">

							</div>

						</div>

					</div>

					<div class="modal-footer">

						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Close</button>

						<button type="submit" class="btn btn-danger">Save
							Employee</button>

					</div>

				</form>

			</div>

		</div>

	</div>

	<!-- Edit Employee Modal (FIX: previously did not exist at all) -->
	<div class="modal fade" id="editEmployeeModal" tabindex="-1">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Edit Employee</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<form action="<%=request.getContextPath()%>/EditEmployeeServlet"
					method="post" id="editEmployeeForm">
					<input type="hidden" name="sr_no" id="edit_sr_no">

					<div class="modal-body">
						<div class="row">
							<div class="col-md-6 mb-3">
								<label>Full Name</label> <input type="text" name="name"
									id="edit_name" class="form-control" required>
							</div>
							<div class="col-md-6 mb-3">
								<label>Gender</label> <select name="gender" id="edit_gender"
									class="form-select" required>
									<option>Male</option>
									<option>Female</option>
									<option>Other</option>
								</select>
							</div>
						</div>

						<div class="row">
							<div class="col-md-6 mb-3">
								<label>Email</label> <input type="email" name="email"
									id="edit_email" class="form-control" required>
							</div>
							<div class="col-md-6 mb-3">
								<label>Mobile No.</label> <input type="text" name="mobile_no"
									id="edit_mobile" class="form-control">
							</div>
						</div>

						<div class="row">
							<div class="col-md-6 mb-3">
								<label>Department</label> <select name="department"
									id="edit_dept" class="form-select" required>
									<%
									if (departments != null) {
										for (Department d : departments) {
									%>
									<option value="<%=d.getDept_name()%>"><%=d.getDept_name()%></option>
									<%
									}
									}
									%>
								</select>
							</div>
						</div>
					</div>

					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Close</button>
						<button type="submit" class="btn btn-danger">Save Changes</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
		function fillEditModal(el) {
			document.getElementById('edit_sr_no').value = el
					.getAttribute('data-srno');
			document.getElementById('edit_name').value = el
					.getAttribute('data-name');
			document.getElementById('edit_gender').value = el
					.getAttribute('data-gender');
			document.getElementById('edit_email').value = el
					.getAttribute('data-email');
			document.getElementById('edit_mobile').value = el
					.getAttribute('data-mobile');
			document.getElementById('edit_dept').value = el
					.getAttribute('data-dept');
		}
	</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
