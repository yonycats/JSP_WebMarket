<%@page import="java.util.ArrayList"%>
<%@page import="vo.Product"%>
<%@page import="dao.ProductRepository"%>
<%@ page language="java" pageEncoding="UTF-8"%>

<%
	// 상품 id 얻어오기
	String id = request.getParameter("id");

	if (id == null || id.trim().equals("")) {
		response.sendRedirect("products.jsp");
		return;
	}
	
	ProductRepository dao = ProductRepository.getInstance();
	
	// 상품 id로 상품 조회
	Product product = dao.getProductById(id);
	if (product == null) {
		response.sendRedirect("exceptionNoProductId.jsp");
	}
	
	ArrayList<Product> list = (ArrayList<Product>)session.getAttribute("cartList");
	if (list == null) {
		list = new ArrayList<Product>();
		session.setAttribute("cartList", list);
	}
		
	// 세션에서 얻어온 cartList에서 index에 해당하는 Product를 꺼내 goodQnt 변수에 주소 전달
	// 그 주소에 같은 상품일 경우 수량만 카운트해서 셋팅
	int cnt = 0;
	for (int i=0; i<list.size(); i++) {
		Product goodsQnt = list.get(i); // 장바구니 안에 들어있는 상품
		
		if (goodsQnt.getProductId().equals(id)) {
			cnt++;
			goodsQnt.setQuantity(goodsQnt.getQuantity() + 1);
		}
	}
	
	// 첫 상품을 주문할 때
	if (cnt == 0) {
		product.setQuantity(1);
		list.add(product);
	}
	response.sendRedirect("product.jsp?id=" + id);
%>