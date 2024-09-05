<!-- 로그인에 실패하면 로그인 창으로 보내기 -->

<%
	response.sendRedirect("login.jsp?error=1");
%>