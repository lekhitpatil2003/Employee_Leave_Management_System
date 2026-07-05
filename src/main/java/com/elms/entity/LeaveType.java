package com.elms.entity;

public class LeaveType {
	private int leave_id;
	private String leave_name;
	private String leave_code;
	private String description;

	public int getLeave_id() {
		return leave_id;
	}

	public void setLeave_id(int leave_id) {
		this.leave_id = leave_id;
	}

	public String getLeave_name() {
		return leave_name;
	}

	public void setLeave_name(String leave_name) {
		this.leave_name = leave_name;
	}

	public String getLeave_code() {
		return leave_code;
	}

	public void setLeave_code(String leave_code) {
		this.leave_code = leave_code;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

}
