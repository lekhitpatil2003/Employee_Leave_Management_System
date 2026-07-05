package com.elms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.elms.entity.Employee;
import com.elms.util.DbConnection;

public class EmployeeDao {

	/** Adds a new employee. Password must already be hashed by the caller. */
	public boolean addEmployee(Employee employee) throws SQLException {
		boolean status = false;
		String sql = "INSERT INTO employee (emp_id, name, gender, email, mobile_no, department, user_name, password, leave_balance) "
				+ "VALUES (?,?,?,?,?,?,?,?,?)";

		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, employee.getEmp_id());
			ps.setString(2, employee.getName());
			ps.setString(3, employee.getGender());
			ps.setString(4, employee.getEmail());
			ps.setString(5, employee.getMobile_no());
			ps.setString(6, employee.getDepartment());
			ps.setString(7, employee.getUser_name());
			ps.setString(8, employee.getPassword());
			ps.setInt(9, employee.getLeave_balance() > 0 ? employee.getLeave_balance() : 20);

			int row = ps.executeUpdate();
			status = row > 0;
		}
		return status;
	}

	/** Updates employee profile fields (does NOT touch password). */
	public boolean updateEmployee(Employee employee) throws SQLException {
		boolean status = false;
		String sql = "UPDATE employee SET name=?, gender=?, email=?, mobile_no=?, department=? WHERE sr_no=?";

		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, employee.getName());
			ps.setString(2, employee.getGender());
			ps.setString(3, employee.getEmail());
			ps.setString(4, employee.getMobile_no());
			ps.setString(5, employee.getDepartment());
			ps.setInt(6, employee.getSr_no());

			int row = ps.executeUpdate();
			status = row > 0;
		}
		return status;
	}

	public boolean updateProfilePic(int srNo, String fileName) throws SQLException {
		String sql = "UPDATE employee SET profile_pic=? WHERE sr_no=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, fileName);
			ps.setInt(2, srNo);
			return ps.executeUpdate() > 0;
		}
	}

	public boolean updatePassword(int srNo, String hashedPassword) throws SQLException {
		String sql = "UPDATE employee SET password=? WHERE sr_no=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, hashedPassword);
			ps.setInt(2, srNo);
			return ps.executeUpdate() > 0;
		}
	}

	public boolean deleteEmployee(int srNo) throws SQLException {
		String sql = "DELETE FROM employee WHERE sr_no=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, srNo);
			return ps.executeUpdate() > 0;
		}
	}

	public boolean adjustLeaveBalance(int empId, int days) throws SQLException {
		String sql = "UPDATE employee SET leave_balance = leave_balance - ? WHERE sr_no=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, days);
			ps.setInt(2, empId);
			return ps.executeUpdate() > 0;
		}
	}

	public Employee getById(int srNo) throws SQLException {
		String sql = "SELECT * FROM employee WHERE sr_no=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, srNo);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		}
		return null;
	}

	public Employee getByEmail(String email) throws SQLException {
		String sql = "SELECT * FROM employee WHERE email=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, email);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		}
		return null;
	}

	public boolean emailExists(String email) throws SQLException {
		String sql = "SELECT sr_no FROM employee WHERE email=?";
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, email);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next();
			}
		}
	}

	public List<Employee> search(String keyword, String department, int offset, int limit) throws SQLException {
		List<Employee> list = new ArrayList<>();
		StringBuilder sql = new StringBuilder("SELECT * FROM employee WHERE 1=1");
		if (keyword != null && !keyword.isBlank()) {
			sql.append(" AND (name LIKE ? OR email LIKE ? OR emp_id LIKE ? OR user_name LIKE ?)");
		}
		if (department != null && !department.isBlank()) {
			sql.append(" AND department = ?");
		}
		sql.append(" ORDER BY sr_no DESC LIMIT ? OFFSET ?");

		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
			int idx = 1;
			if (keyword != null && !keyword.isBlank()) {
				String kw = "%" + keyword + "%";
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
			}
			if (department != null && !department.isBlank()) {
				ps.setString(idx++, department);
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

	public int countSearch(String keyword, String department) throws SQLException {
		StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM employee WHERE 1=1");
		if (keyword != null && !keyword.isBlank()) {
			sql.append(" AND (name LIKE ? OR email LIKE ? OR emp_id LIKE ? OR user_name LIKE ?)");
		}
		if (department != null && !department.isBlank()) {
			sql.append(" AND department = ?");
		}
		try (Connection con = DbConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
			int idx = 1;
			if (keyword != null && !keyword.isBlank()) {
				String kw = "%" + keyword + "%";
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
				ps.setString(idx++, kw);
			}
			if (department != null && !department.isBlank()) {
				ps.setString(idx++, department);
			}
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() ? rs.getInt(1) : 0;
			}
		}
	}

	public int countAll() throws SQLException {
		String sql = "SELECT COUNT(*) FROM employee";
		try (Connection con = DbConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			return rs.next() ? rs.getInt(1) : 0;
		}
	}

	private Employee mapRow(ResultSet rs) throws SQLException {
		Employee e = new Employee();
		e.setSr_no(rs.getInt("sr_no"));
		e.setEmp_id(rs.getString("emp_id"));
		e.setName(rs.getString("name"));
		e.setGender(rs.getString("gender"));
		e.setEmail(rs.getString("email"));
		e.setMobile_no(rs.getString("mobile_no"));
		e.setDepartment(rs.getString("department"));
		e.setUser_name(rs.getString("user_name"));
		e.setPassword(rs.getString("password"));
		e.setLeave_balance(rs.getInt("leave_balance"));
		e.setProfile_pic(rs.getString("profile_pic"));
		e.setAdded_date(rs.getTimestamp("added_date"));
		return e;
	}
}
