package com.elms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.elms.entity.Department;
import com.elms.util.DbConnection;

public class DepartmentDao {

	public boolean department(Department department) throws SQLException {
		boolean status = false;
		String sql = "insert into department(dept_name, dept_code, description) values(?, ?, ?)";

		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, department.getDept_name());
			ps.setString(2, department.getDept_code());
			ps.setString(3, department.getDescription());

			int row = ps.executeUpdate();
			status = row > 0;
		}
		return status;
	}

	public boolean updateDepartment(Department department) throws SQLException {
		String sql = "UPDATE department SET dept_name=?, dept_code=?, description=? WHERE dept_id=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, department.getDept_name());
			ps.setString(2, department.getDept_code());
			ps.setString(3, department.getDescription());
			ps.setInt(4, department.getDept_id());
			return ps.executeUpdate() > 0;
		}
	}

	public boolean deleteDepartment(int deptId) throws SQLException {
		String sql = "DELETE FROM department WHERE dept_id=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, deptId);
			return ps.executeUpdate() > 0;
		}
	}

	public Department getById(int deptId) throws SQLException {
		String sql = "SELECT * FROM department WHERE dept_id=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, deptId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		}
		return null;
	}

	public List<Department> getAll() throws SQLException {
		List<Department> list = new ArrayList<>();
		String sql = "SELECT * FROM department ORDER BY dept_name";
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
		String sql = "SELECT COUNT(*) FROM department";
		try (Connection con = DbConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			return rs.next() ? rs.getInt(1) : 0;
		}
	}

	private Department mapRow(ResultSet rs) throws SQLException {
		Department d = new Department();
		d.setDept_id(rs.getInt("dept_id"));
		d.setDept_name(rs.getString("dept_name"));
		d.setDept_code(rs.getString("dept_code"));
		d.setDescription(rs.getString("description"));
		return d;
	}
}
