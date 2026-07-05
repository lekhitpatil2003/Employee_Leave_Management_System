<%@page import="java.util.List"%>
<%@page import="com.elms.dao.LeaveTypeDao"%>
<%@page import="com.elms.entity.LeaveType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Leave Types</title>

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
				<h1>Manage Leave Types</h1>
				<p>View and manage leave type records</p>
			</div>

			<button class="add-btn" data-bs-toggle="modal"
				data-bs-target="#addLeaveTypeModal">

				<i class="fas fa-plus-circle"></i> Add Leave Type

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

		List<LeaveType> leaveTypes = null;
		try {
			leaveTypes = new LeaveTypeDao().getAll();
		} catch (Exception e) {
			e.printStackTrace();
		}
		%>

		<div class="table-card">

			<table>

				<thead>

					<tr>
						<th>Leave Type</th>
						<th>Leave Code</th>
						<th>Description</th>
						<th>Action</th>
					</tr>

				</thead>

				<tbody>

					<%
					if (leaveTypes != null && !leaveTypes.isEmpty()) {
						for (LeaveType lt : leaveTypes) {
					%>

					<tr>

						<td><%=lt.getLeave_name()%></td>

						<td><%=lt.getLeave_code()%></td>

						<td><%=lt.getDescription() == null ? "-" : lt.getDescription()%></td>

						<!-- FIX: no Edit action existed at all for leave types. -->
						<td>
							<a href="javascript:void(0);" class="edit-btn"
								data-bs-toggle="modal" data-bs-target="#editLeaveTypeModal"
								data-id="<%=lt.getLeave_id()%>"
								data-name="<%=lt.getLeave_name()%>"
								data-code="<%=lt.getLeave_code()%>"
								data-desc="<%=lt.getDescription() == null ? "" : lt.getDescription()%>"
								onclick="fillEditLeaveType(this)">
								<i class="fas fa-pen"></i>
							</a>
							<a href="<%=request.getContextPath()%>/DeleteLeaveTypeServlet?id=<%=lt.getLeave_id()%>"
								class="delete-btn"
								onclick="return confirm('Are you sure you want to delete this leave type?')">
								<i class="fas fa-trash"></i>
							</a>
						</td>

					</tr>

					<%
						}
					} else {
					%>
					<tr>
						<td colspan="4" style="text-align:center; color:#64748b;">No leave types found.</td>
					</tr>
					<%
					}
					%>

				</tbody>

			</table>

		</div>

	</div>

	<!-- Add Leave Type Modal -->

	<div class="modal fade" id="addLeaveTypeModal" tabindex="-1">

		<div class="modal-dialog modal-lg">

			<div class="modal-content">

				<div class="modal-header">

					<h4 class="modal-title">Add New Leave Type</h4>

					<button type="button" class="btn-close" data-bs-dismiss="modal">
					</button>

				</div>

				<form action="<%=request.getContextPath()%>/AddLeaveTypeServlet"
					method="post">

					<div class="modal-body">

						<div class="row">

							<div class="col-md-6 mb-3">

								<label>Leave Type Name</label> <input type="text"
									name="leave_name" class="form-control" required>

							</div>

							<div class="col-md-6 mb-3">

								<label>Leave Code</label> <input type="text"
									name="leave_code" class="form-control" required>

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

						<button type="submit" class="btn btn-danger">Save Leave
							Type</button>

					</div>

				</form>

			</div>

		</div>

	</div>

	<!-- Edit Leave Type Modal (FIX: did not exist before) -->
	<div class="modal fade" id="editLeaveTypeModal" tabindex="-1">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Edit Leave Type</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<form action="<%=request.getContextPath()%>/EditLeaveTypeServlet" method="post">
					<input type="hidden" name="leave_id" id="edit_leave_id">

					<div class="modal-body">
						<div class="row">
							<div class="col-md-6 mb-3">
								<label>Leave Type Name</label>
								<input type="text" name="leave_name" id="edit_leave_name" class="form-control" required>
							</div>
							<div class="col-md-6 mb-3">
								<label>Leave Code</label>
								<input type="text" name="leave_code" id="edit_leave_code" class="form-control" required>
							</div>
						</div>

						<div class="row">
							<div class="col-md-12 mb-3">
								<label>Description</label>
								<textarea name="description" id="edit_leave_desc" class="form-control" rows="3"></textarea>
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
		function fillEditLeaveType(el) {
			document.getElementById('edit_leave_id').value = el.getAttribute('data-id');
			document.getElementById('edit_leave_name').value = el.getAttribute('data-name');
			document.getElementById('edit_leave_code').value = el.getAttribute('data-code');
			document.getElementById('edit_leave_desc').value = el.getAttribute('data-desc');
		}
	</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
