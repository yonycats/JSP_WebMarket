<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=utf-8"%>

<%
	request.setCharacterEncoding("UTF-8");

	// URLEncoder
	// URL 인코딩은 웹 상에서 데이터를 보다 안전하게 전송하기 위해서 설정합니다.
	// URL은 공백 또는 특수문자, ASCII 문자 등을 포함할 수 없으므로 URL에서 사용할 수 있는 문자들로 변환하여 전송합니다.
	// 예를 들어, 공백은 '+' 또는 '%20'으로 변환되어 넘어가야 다시 디코딩 되었을 때 정확하게 공백으로 값을 변환하여 사용할 수 있습니다.
	// URL 내에서 사용할 수 없는 문자들을 안전하게 전송이 가능토록 변환하여 전달해야만 데이터의 손실과 원래의 데이터가 나타날 수 있도록
	// 변조가 되지 않고 전송할 수 있기 때문에 URLEncoder를 이용하여 문자를 인코딩합니다.

	Cookie cartId = new Cookie("Shopping_cartId", 
			URLEncoder.encode(request.getParameter("cartId"), "UTF-8"));
	Cookie name = new Cookie("Shopping_name", 
			URLEncoder.encode(request.getParameter("name"), "UTF-8"));
	Cookie shoppingDate = new Cookie("Shopping_shoppingDate", 
			URLEncoder.encode(request.getParameter("shoppingDate"), "UTF-8"));
	
	Cookie country = new Cookie("Shopping_country", 
			URLEncoder.encode(request.getParameter("country"), "UTF-8"));
	Cookie zipCode = new Cookie("Shopping_zipCode", 
			URLEncoder.encode(request.getParameter("zipCode"), "UTF-8"));
	Cookie addressName = new Cookie("Shopping_addressName", 
			URLEncoder.encode(request.getParameter("addressName"), "UTF-8"));

	// 기간을 하루로 설정
	cartId.setMaxAge(24 * 60 * 60);
	name.setMaxAge(24 * 60 * 60);
	shoppingDate.setMaxAge(24 * 60 * 60);
	
	country.setMaxAge(24 * 60 * 60);
	zipCode.setMaxAge(24 * 60 * 60);
	addressName.setMaxAge(24 * 60 * 60);

	// response로 addCookie를 해야 쿠키가 추가됨
	response.addCookie(cartId);
	response.addCookie(name);
	response.addCookie(shoppingDate);
	
	response.addCookie(country);
	response.addCookie(zipCode);
	response.addCookie(addressName);
	
	response.sendRedirect("orderConfirmation.jsp");
%>