package filter;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.security.auth.message.callback.PrivateKeyCallback.Request;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

import com.sun.net.httpserver.HttpServer;

// 로그 파일을 만들어주는 필터
public class LogFileFilter implements Filter {
	
	private PrintWriter writer;
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		System.out.println("LogFileFilter 초기화!");
		
		String filename = filterConfig.getInitParameter("filename");
		
		if (filename == null) {
			throw new ServletException("로그 파일의 이름을 찾을 수 없습니다!");
		}
		
		try {
			// PrintWriter
			// 두번째 매개변수 : autoFlush 여부 (true/false)
			
			// FileWriter
			// 두번째 매개변수 : append 여부 (true/false)
			writer = new PrintWriter(new FileWriter(filename, true), true);
		} catch (IOException e) {
			throw new ServletException("로그 파일을 열 수 없습니다!");
		}
	
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		System.out.println("LogFileFilter 수행!");

		
		writer.println(" 접속한 클라이언트 IP : " + request.getRemoteAddr());
		
		long start = System.currentTimeMillis();
		writer.println(" 접근한 URL 경로 : " + getURLPath(request));
		writer.println(" 요청 처리 시작 시간 : " + getCurrentTime());
		
		chain.doFilter(request, response);
		
		long end = System.currentTimeMillis();
		writer.println(" 요청 처리 종료 시간 : " + getCurrentTime());
		writer.println(" 요청 처리 소요 시간 : " + (end - start) + "ms");
		writer.println("------------------------------------------");
	}
	
	private String getURLPath(ServletRequest request) {
		HttpServletRequest req;
		String currentPath = "";
		String queryString = "";

		if (request instanceof HttpServletRequest) {
			req = (HttpServletRequest) request;
			currentPath = req.getRequestURI();
			queryString = req.getQueryString();
			queryString = queryString == null ? "" : "?" + queryString;
		}
		return currentPath + queryString;
	}
	
	
	// 현재 날짜 가져오기
	private String getCurrentTime() {
		DateFormat fomatter = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Calendar calendar = Calendar.getInstance();
		calendar.setTimeInMillis(System.currentTimeMillis());
		return fomatter.format(calendar.getTime());
	}
	
	@Override
	public void destroy() {
		System.out.println("LogFileFilter 해제!");
		
		writer.close();
	}

}
