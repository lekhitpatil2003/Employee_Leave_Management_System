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
 * Protects every page under /admin/* so it cannot be opened directly by
 * typing the URL (or via a stale bookmark/session) without a valid admin
 * session. admin_login.jsp itself is excluded so admins can actually reach
 * the login form. This is requirement #5 (Session Management & Security):
 * "Prevent unauthorized access to pages" / "Redirect users to login page
 * when session expires" for the Admin module.
 */
@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;

		String uri = request.getRequestURI();

		if (uri.endsWith("/admin/admin_login.jsp")) {
			chain.doFilter(req, res);
			return;
		}

		HttpSession session = request.getSession(false);
		boolean loggedIn = session != null && session.getAttribute("adminId") != null;

		if (loggedIn) {
			chain.doFilter(req, res);
		} else {
			response.sendRedirect(request.getContextPath() + "/admin/admin_login.jsp?error=session");
		}
	}

	@Override
	public void destroy() {
	}
}
