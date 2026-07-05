package com.elms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.elms.entity.LeaveType;
import com.elms.util.DbConnection;

public class LeaveTypeDao {

	public boolean leaveType(LeaveType leaveType) throws SQLException {
		boolean status = false;
		String sql = "insert into leave_type(leave_name, leave_code, description) values(?, ?, ?)";

		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, leaveType.getLeave_name());
			ps.setString(2, leaveType.getLeave_code());
			ps.setString(3, leaveType.getDescription());

			int row = ps.executeUpdate();
			status = row > 0;
		}
		return status;
	}

	public boolean updateLeaveType(LeaveType leaveType) throws SQLException {
		String sql = "UPDATE leave_type SET leave_name=?, leave_code=?, description=? WHERE leave_id=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, leaveType.getLeave_name());
			ps.setString(2, leaveType.getLeave_code());
			ps.setString(3, leaveType.getDescription());
			ps.setInt(4, leaveType.getLeave_id());
			return ps.executeUpdate() > 0;
		}
	}

	public boolean deleteLeaveType(int leaveId) throws SQLException {
		String sql = "DELETE FROM leave_type WHERE leave_id=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, leaveId);
			return ps.executeUpdate() > 0;
		}
	}

	public LeaveType getById(int leaveId) throws SQLException {
		String sql = "SELECT * FROM leave_type WHERE leave_id=?";
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

	public List<LeaveType> getAll() throws SQLException {
		List<LeaveType> list = new ArrayList<>();
		String sql = "SELECT * FROM leave_type ORDER BY leave_name";
		try (Connection con = DbConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				list.add(mapRow(rs));
			}
		}
		return list;
	}

	public int countAll() throws SQLException {
		String sql = "SELECT COUNT(*) FROM leave_type";
		try (Connection con = DbConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			return rs.next() ? rs.getInt(1) : 0;
		}
	}

	private LeaveType mapRow(ResultSet rs) throws SQLException {
		LeaveType lt = new LeaveType();
		lt.setLeave_id(rs.getInt("leave_id"));
		lt.setLeave_name(rs.getString("leave_name"));
		lt.setLeave_code(rs.getString("leave_code"));
		lt.setDescription(rs.getString("description"));
		return lt;
	}
}
