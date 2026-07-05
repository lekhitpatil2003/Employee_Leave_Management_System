package com.elms.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import com.elms.dao.EmployeeDao;
import com.elms.entity.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Lets a logged-in employee update their own profile details and,
 * optionally, upload a new profile picture.
 */
@WebServlet("/EmployeeEditProfileServlet")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024) // 2 MB
public class EmployeeEditProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final EmployeeDao employeeDao = new EmployeeDao();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String redirect = request.getContextPath() + "/employee/profile_employee.jsp";

		if (session == null || session.getAttribute("srNo") == null) {
			response.sendRedirect(request.getContextPath() + "/employee/employee_login.jsp?error=session");
			return;
		}

		int srNo = (int) session.getAttribute("srNo");

		try {
			Employee emp = new Employee();
			emp.setSr_no(srNo);
			emp.setName(request.getParameter("name"));
			emp.setGender(request.getParameter("gender"));
			emp.setEmail(request.getParameter("email"));
			emp.setMobile_no(request.getParameter("mobile_no"));
			emp.setDepartment(request.getParameter("department"));

			if (emp.getName() == null || emp.getName().isBlank() || emp.getEmail() == null
					|| emp.getEmail().isBlank()) {
				response.sendRedirect(redirect + "?error=Name And Email Are Required");
				return;
			}

			boolean status = employeeDao.updateEmployee(emp);

			// Optional profile picture upload
			Part filePart = request.getPart("profile_pic");
			if (filePart != null && filePart.getSize() > 0) {
				String uploadDir = getServletContext().getRealPath("/uploads/profile_pics");
				Path uploadPath = Paths.get(uploadDir);
				if (!Files.exists(uploadPath)) {
					Files.createDirectories(uploadPath);
				}

				String submitted = filePart.getSubmittedFileName();
				String ext = "";
				if (submitted != null && submitted.contains(".")) {
					ext = submitted.substring(submitted.lastIndexOf('.'));
				}
				String fileName = "emp_" + srNo + "_" + UUID.randomUUID() + ext;

				try (var in = filePart.getInputStream()) {
					Files.copy(in, uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
				}

				employeeDao.updateProfilePic(srNo, fileName);
				session.setAttribute("profilePic", fileName);
			}

			// Refresh session attributes so the sidebar/topbar reflect changes immediately
			session.setAttribute("employeeName", emp.getName());
			session.setAttribute("empName", emp.getName());
			session.setAttribute("email", emp.getEmail());
			session.setAttribute("mobileNo", emp.getMobile_no());
			session.setAttribute("department", emp.getDepartment());

			if (status) {
				response.sendRedirect(redirect + "?success=Profile Updated Successfully");
			} else {
				response.sendRedirect(redirect + "?error=Unable To Update Profile");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(redirect + "?error=Server Error, Please Try Again");
		}
	}
}
