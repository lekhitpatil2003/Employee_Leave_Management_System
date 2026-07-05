package com.elms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.elms.entity.LeaveRequest;
import com.elms.util.DbConnection;

public class LeaveRequestDao {

	/** Employee applies for leave. Sets status=Pending and applied_date=NOW(). */
	public boolean apply(LeaveRequest lr) throws SQLException {
		String sql = "INSERT INTO leave_request (emp_id, leave_type, from_date, to_date, total_days, reason, status, applied_date) "
				+ "VALUES (?,?,?,?,?,?, 'Pending', NOW())";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, lr.getEmp_id());
			ps.setString(2, lr.getLeave_type());
			ps.setDate(3, lr.getFrom_date());
			ps.setDate(4, lr.getTo_date());
			ps.setInt(5, lr.getTotal_days());
			ps.setString(6, lr.getReason());
			return ps.executeUpdate() > 0;
		}
	}

	/** Employee cancels their own leave request, only while it is still Pending. */
	public boolean cancel(int leaveId, int empId) throws SQLException {
		String sql = "UPDATE leave_request SET status='Cancelled', updated_date=NOW() WHERE leave_id=? AND emp_id=? AND status='Pending'";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, leaveId);
			ps.setInt(2, empId);
			return ps.executeUpdate() > 0;
		}
	}

	/** Admin approves or rejects a leave request. */
	public boolean updateStatus(int leaveId, String status, String remarks) throws SQLException {
		String sql = "UPDATE leave_request SET status=?, admin_remarks=?, updated_date=NOW() WHERE leave_id=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setString(2, remarks);
			ps.setInt(3, leaveId);
			return ps.executeUpdate() > 0;
		}
	}

	public LeaveRequest getById(int leaveId) throws SQLException {
		String sql = "SELECT lr.*, e.name AS emp_name, e.department AS department FROM leave_request lr "
				+ "JOIN employee e ON lr.emp_id = e.sr_no WHERE lr.leave_id=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, leaveId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		}
		return null;
	}

	/** Leave history for one employee, most recent first, optional status filter. */
	public List<LeaveRequest> getByEmployee(int empId, String status) throws SQLException {
		List<LeaveRequest> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder("SELECT * FROM leave_request WHERE emp_id=?");
		if (status != null && !status.isBlank()) {
			sql.append(" AND status=?");
		}
		sql.append(" ORDER BY leave_id DESC");

		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
			ps.setInt(1, empId);
			if (status != null && !status.isBlank()) {
				ps.setString(2, status);
			}
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}
		}
		return list;
	}

	/** All leave requests (admin view) joined with employee info, with search/status filter + pagination. */
	public List<LeaveRequest> search(String keyword, String status, int offset, int limit) throws SQLException {
		List<LeaveRequest> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder(
				"SELECT lr.*, e.name AS emp_name, e.department AS department FROM leave_request lr "
						+ "JOIN employee e ON lr.emp_id = e.sr_no WHERE 1=1");
		if (keyword != null && !keyword.isBlank()) {
			sql.append(" AND (e.name LIKE ? OR e.emp_id LIKE ? OR lr.leave_type LIKE ?)");
		}
		if (status != null && !status.isBlank()) {
			sql.append(" AND lr.status = ?");
		}
		sql.append(" ORDER BY lr.leave_id DESC LIMIT ? OFFSET ?");

		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
			int idx = 1;
			if (keyword != null && !keyword.isBlank()) {
				String kw = "%" + keyword + "%";
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
			}
			if (status != null && !status.isBlank()) {
				ps.setString(idx++, status);
			}
			ps.setInt(idx++, limit);
			ps.setInt(idx, offset);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}
		}
		return list;
	}

	public int countSearch(String keyword, String status) throws SQLException {
		StringBuilder sql = new StringBuilder(
				"SELECT COUNT(*) FROM leave_request lr JOIN employee e ON lr.emp_id = e.sr_no WHERE 1=1");
		if (keyword != null && !keyword.isBlank()) {
			sql.append(" AND (e.name LIKE ? OR e.emp_id LIKE ? OR lr.leave_type LIKE ?)");
		}
		if (status != null && !status.isBlank()) {
			sql.append(" AND lr.status = ?");
		}
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
			int idx = 1;
			if (keyword != null && !keyword.isBlank()) {
				String kw = "%" + keyword + "%";
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
			}
			if (status != null && !status.isBlank()) {
				ps.setString(idx++, status);
			}
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() ? rs.getInt(1) : 0;
			}
		}
	}

	/** Most recent N leave requests for the admin dashboard widget. */
	public List<LeaveRequest> getRecent(int limit) throws SQLException {
		List<LeaveRequest> list = new ArrayList<>();
		String sql = "SELECT lr.*, e.name AS emp_name, e.department AS department FROM leave_request lr "
				+ "JOIN employee e ON lr.emp_id = e.sr_no ORDER BY lr.leave_id DESC LIMIT ?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, limit);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}
		}
		return list;
	}

	public int countByStatus(String status) throws SQLException {
		String sql = "SELECT COUNT(*) FROM leave_request WHERE status=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, status);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() ? rs.getInt(1) : 0;
			}
		}
	}

	public int countAll() throws SQLException {
		String sql = "SELECT COUNT(*) FROM leave_request";
		try (Connection con = DbConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			return rs.next() ? rs.getInt(1) : 0;
		}
	}

	private LeaveRequest mapRow(ResultSet rs) throws SQLException {
		LeaveRequest lr = new LeaveRequest();
		lr.setLeave_id(rs.getInt("leave_id"));
		lr.setEmp_id(rs.getInt("emp_id"));
		lr.setLeave_type(rs.getString("leave_type"));
		lr.setFrom_date(rs.getDate("from_date"));
		lr.setTo_date(rs.getDate("to_date"));
		lr.setTotal_days(rs.getInt("total_days"));
		lr.setReason(rs.getString("reason"));
		lr.setStatus(rs.getString("status"));
		lr.setAdmin_remarks(rs.getString("admin_remarks"));
		lr.setApplied_date(rs.getTimestamp("applied_date"));
		lr.setUpdated_date(rs.getTimestamp("updated_date"));
		try {
			lr.setEmp_name(rs.getString("emp_name"));
			lr.setDepartment(rs.getString("department"));
		} catch (SQLException ignore) {
			// columns not present when query doesn't join employee table
		}
		return lr;
	}
}
