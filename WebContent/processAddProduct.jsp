<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.DiskFileUpload"%>
<%@page import="java.io.File"%>
<%@page import="vo.Product"%>
<%@page import="dao.ProductRepository"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");

	// 1. workspace/.../
	// 2. C:/upload/file..
	// 3. 배포된 서버경로
	// 2번은 명시적으로 사용하지 않고, 1번과 3번이 사용가능하며, 3번을 사용할 것임

	// 파일 업로드 하기
	String realFolder = request.getServletContext().getRealPath("/resources/images");
	String encType = "UTF-8"; // 인코딩 타입
	int maxSize = 5 * 1024 * 1024; // 최대 업로드될 파일을 크기 (5MB)

	File file = new File(realFolder);
	if (!file.exists()) { // 폴더 경로가 존재하지 않다면
		file.mkdirs();	  // 폴더 생성
	}
	
	DiskFileUpload upload = new DiskFileUpload();
	upload.setSizeMax(4 * 1024 * 1024);
	upload.setSizeThreshold(4 * 1024 * 1024);
	upload.setRepositoryPath(realFolder);
	
	// MultipartRequest: Apache Commons FileUpload 라이브러리와 같은 파일 업로드 라이브러리에서 제공하는 기능
	// request 객체를 분석하여 클라이언트가 서버로 전송한 파일과 기타 폼 데이터를 추출하는 기능
	// multipart/form-data 형식으로 전송된 데이터를 처리할 수 있게 해주며,
	// 파싱된 결과는 일반적으로 List 형식으로 반환되며, 이 리스트에는 업로드된 파일과 폼 필드의 정보가 포함된다.
	List items = upload.parseRequest(request);
	Iterator params = items.iterator();
	
	// 일반 데이터와 파일 데이터를 받을 때 사용하는 방법
	String productId = "";
	String pname = "";
	String unitPrice = "";
	String description = "";
	String manufacturer = "";
	String category = "";
	String unitsInStock = "";
	String condition = "";
	String fileName = "";
	
	while (params.hasNext()) {
		FileItem item = (FileItem) params.next();
		
		if (item.isFormField()) { // 일반 데이터일 때
			String fieldName = item.getFieldName();
			
			if (fieldName.equals("productId")) {
				productId = item.getString(encType);
			} else if (fieldName.equals("pname")) {
				pname = item.getString(encType);
			} else if (fieldName.equals("unitPrice")) {
				unitPrice = item.getString(encType);
			} else if (fieldName.equals("description")) {
				description = item.getString(encType);
			} else if (fieldName.equals("manufacturer")) {
				manufacturer = item.getString(encType);
			} else if (fieldName.equals("category")) {
				category = item.getString(encType);
			} else if (fieldName.equals("unitsInStock")) {
				unitsInStock = item.getString(encType);
			} else if (fieldName.equals("condition")) {
				condition = item.getString(encType);
			}
		} else { // 파일일 때
			fileName = item.getName(); // 파일명
			File saveFile = new File(realFolder + "/" + fileName);
			item.write(saveFile); // 파일 복사
		}		
		
	}
	

/* 
	// 일반 데이터만 받을 때 사용하는 방법 
	String productId = request.getParameter("productId");
	String pname = request.getParameter("pname");
	String unitPrice = request.getParameter("unitPrice");
	String description = request.getParameter("description");
	String manufacturer = request.getParameter("manufacturer");
	String category = request.getParameter("category");
	String unitsInStock = request.getParameter("unitsInStock");
	String condition = request.getParameter("condition");
 */
	Integer price;
	
	if (unitPrice.isEmpty()) {
		price = 0;
	} else {
		price = Integer.valueOf(unitPrice);
	}
	
	long stock;
	
	if (unitsInStock.isEmpty()) {
		stock = 0;
	} else {
		stock = Long.valueOf(unitsInStock);
	}
	
	ProductRepository dao = ProductRepository.getInstance();
	Product newProduct = new Product();
	
	newProduct.setProductId(productId);
	newProduct.setPname(pname);
	newProduct.setUnitPrice(price);
	newProduct.setDescription(description);
	newProduct.setManufacturer(manufacturer);
	newProduct.setCategory(category);
	newProduct.setUnitsInStock(stock);
	newProduct.setCondition(condition);
	newProduct.setFilename(fileName);
    
    dao.addProduct(newProduct);
    
    response.sendRedirect("products.jsp");
%>
    
    
    