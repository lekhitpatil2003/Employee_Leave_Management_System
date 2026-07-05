<%@page import="java.util.List"%>
<%@page import="com.elms.dao.DepartmentDao"%>
<%@page import="com.elms.entity.Department"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Department</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/admin_section/leave_type.css">

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
				<h1>Manage Department</h1>
				<p>View and manage Departments</p>
			</div>

			<button class="add-btn" data-bs-toggle="modal"
				data-bs-target="#addDepartmentModal">

				<i class="fas fa-plus-circle"></i> Add Department

			</button>

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

		List<Department> departments = null;
		try {
			departments = new DepartmentDao().getAll();
		} catch (Exception e) {
			e.printStackTrace();
		}
		%>

		<div class="table-card">

			<table>

				<thead>

					<tr>
						<th>Department</th>
						<th>Department Code</th>
						<th>Description</th>
						<th>Action</th>
					</tr>

				</thead>

				<tbody>

					<%
					if (departments != null && !departments.isEmpty()) {
						for (Department d : departments) {
					%>

					<tr>

						<td><%=d.getDept_name()%></td>

						<td><%=d.getDept_code()%></td>

						<td><%=d.getDescription() == null ? "-" : d.getDescription()%></td>

						<!-- FIX: no Edit action existed at all for departments. -->
						<td>
							<a href="javascript:void(0);" class="edit-btn"
								data-bs-toggle="modal" data-bs-target="#editDepartmentModal"
								data-id="<%=d.getDept_id()%>"
								data-name="<%=d.getDept_name()%>"
								data-code="<%=d.getDept_code()%>"
								data-desc="<%=d.getDescription() == null ? "" : d.getDescription()%>"
								onclick="fillEditDept(this)">
								<i class="fas fa-pen"></i>
							</a>
							<a href="<%=request.getContextPath()%>/DeleteDepartmentServlet?id=<%=d.getDept_id()%>"
								class="delete-btn"
								onclick="return confirm('Are you sure you want to delete this Department?')">
								<i class="fas fa-trash"></i>
							</a>
						</td>

					</tr>

					<%
						}
					} else {
					%>
					<tr>
						<td colspan="4" style="text-align:center; color:#64748b;">No departments found.</td>
					</tr>
					<%
					}
					%>

				</tbody>

			</table>

		</div>

	</div>

	<!-- Add Department Modal -->

	<div class="modal fade" id="addDepartmentModal" tabindex="-1">

		<div class="modal-dialog modal-lg">

			<div class="modal-content">

				<div class="modal-header">

					<h4 class="modal-title">Add New Department</h4>

					<button type="button" class="btn-close" data-bs-dismiss="modal">
					</button>

				</div>

				<form action="<%=request.getContextPath()%>/AddDepartmentServlet"
					method="post">

					<div class="modal-body">

						<div class="row">

							<div class="col-md-6 mb-3">

								<label>Department Name</label> <input type="text"
									name="dept_name" class="form-control" required>

							</div>

							<div class="col-md-6 mb-3">

								<label>Department Code</label> <input type="text"
									name="dept_code" class="form-control" required>

							</div>

						</div>

						<div class="row">

							<div class="col-md-12 mb-3">

								<label>Description</label>

								<textarea name="description" class="form-control" rows="3"></textarea>

							</div>

						</div>

					</div>

					<div class="modal-footer">

						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Close</button>

						<!-- FIX: button previously said "Save Leave Type" on
						     the Department page (copy/paste error). -->
						<button type="submit" class="btn btn-danger">Save Department</button>

					</div>

				</form>

			</div>

		</div>

	</div>

	<!-- Edit Department Modal (FIX: did not exist before) -->
	<div class="modal fade" id="editDepartmentModal" tabindex="-1">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Edit Department</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<form action="<%=request.getContextPath()%>/EditDepartmentServlet" method="post">
					<input type="hidden" name="dept_id" id="edit_dept_id">

					<div class="modal-body">
						<div class="row">
							<div class="col-md-6 mb-3">
								<label>Department Name</label>
								<input type="text" name="dept_name" id="edit_dept_name" class="form-control" required>
							</div>
							<div class="col-md-6 mb-3">
								<label>Department Code</label>
								<input type="text" name="dept_code" id="edit_dept_code" class="form-control" required>
							</div>
						</div>

						<div class="row">
							<div class="col-md-12 mb-3">
								<label>Description</label>
								<textarea name="description" id="edit_dept_desc" class="form-control" rows="3"></textarea>
							</div>
						</div>
					</div>

					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
						<button type="submit" class="btn btn-danger">Save Changes</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
		function fillEditDept(el) {
			document.getElementById('edit_dept_id').value = el.getAttribute('data-id');
			document.getElementById('edit_dept_name').value = el.getAttribute('data-name');
			document.getElementById('edit_dept_code').value = el.getAttribute('data-code');
			document.getElementById('edit_dept_desc').value = el.getAttribute('data-desc');
		}
	</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
