<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Something Went Wrong - ELMS</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
	body { margin:0; min-height:100vh; display:flex; align-items:center; justify-content:center;
		background: linear-gradient(135deg,#1e293b,#0f172a); font-family:'Segoe UI',sans-serif; }
	.box { background:#fff; padding:50px 40px; border-radius:16px; text-align:center; max-width:420px;
		box-shadow:0 20px 50px rgba(0,0,0,0.35); }
	.box i { font-size:56px; color:#dc2626; margin-bottom:16px; }
	.box h1 { margin:0 0 10px; color:#0f172a; font-size:24px; }
	.box p { color:#64748b; margin-bottom:24px; }
	.box a { display:inline-block; background:#dc2626; color:#fff; text-decoration:none; padding:12px 24px;
		border-radius:10px; font-weight:600; }
	.box a:hover { background:#b91c1c; }
</style>
</head>
<body>
	<div class="box">
		<i class="fas fa-triangle-exclamation"></i>
		<h1>Oops, Something Went Wrong</h1>
		<p>The page you were looking for couldn't be loaded. This has been logged; please try again.</p>
		<a href="<%=request.getContextPath()%>/index.jsp"><i class="fas fa-house"></i> Back To Home</a>
	</div>
</body>
</html>
