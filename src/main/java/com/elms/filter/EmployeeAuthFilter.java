package com.elms.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Protects every page under /employee/* so it cannot be opened directly
 * without a valid employee session (requirement #5, Employee module).
 * employee_login.jsp is excluded so employees can reach the login form.
 */
@WebFilter("/employee/*")
public class EmployeeAuthFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;

		String uri = request.getRequestURI();

		if (uri.endsWith("/employee/employee_login.jsp")) {
			chain.doFilter(req, res);
			return;
		}

		HttpSession session = request.getSession(false);
		boolean loggedIn = session != null && session.getAttribute("srNo") != null;

		if (loggedIn) {
			chain.doFilter(req, res);
		} else {
			response.sendRedirect(request.getContextPath() + "/employee/employee_login.jsp?error=session");
		}
	}

	@Override
	public void destroy() {
	}
}
