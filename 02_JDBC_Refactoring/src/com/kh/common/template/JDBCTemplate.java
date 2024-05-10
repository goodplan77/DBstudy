package com.kh.common.template;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;

import org.apache.commons.dbcp2.BasicDataSource;

public class JDBCTemplate {
	/*
	 * Refactoring?
	 *  - 기존의 코드를 변경하여 코드를 더 이해하기 쉽고 유지보수하기 쉽게 만드는 과정.
	 *  - 코드중복제거 , 공용메서드 , 클래스 추출 , 변수명 변경 등등 , 코드의 가독성과 유지보수성을 향상시키는게 목적
	 *  - 리팩토링의 결과로 잘 작동하던 코드에 문제가 발생하면 안됨.
	 */

	/*
	 * 커넥션 객체를 생성 (DriverManager.getConnection) 및 종료 (close) 하는 작업은 처리시간이 많이 들고
	 * 자원을 많이 소모하는 고자원이다. 따라서 그때그때 커넥션을 생성 및 종료하는 행위는 효율적이지 못함.
	 * 
	 * 객체를 생성 및 소멸하는 것이 문제 이므로 객체를 "미리" 생성해두고 필요할때마다 꺼내쓰면서 종료시키는게 아니라
	 * 사용한 곳으로 자원을 "반납"하면 된다.
	 * 
	 * DataSource
	 *  - DBMS와의 연결 , 커넥션풀 관리 및 생성 커넥션풀의 커넥션을 활용한 기능들을 정의하기 위한 "인터페이스"
	 *  - 대표 DataSource 인터페이스 구현 클래스 : DBCP , HikariCP , Tomcat DataSource
	 *  - dbcp 라이브러리 다운로드 방법.
	 *  1) Maven repository 접속
	 *  2) Apache commons dbcp 검색 -> 2.9 버전 다운로드
	 *  3) dependcies library 확인 후 함께 다운로드 받아야 되는 jar들 모두 다운로드
	 *  	- apache commons pool2 , apache commons logging
	 *  4) dev 폴더로 이동 시킨후 현재 프로젝트에 추가.
	 *  
	 *  BasicDataSource?
	 *  - javax.sql.DataSource 인터페이스를 구현한 구현 클래스
	 *  - 데이터 베이스에 연결 및 커넥션풀 생성 , 커넥션 생성 및 소멸 관리 등 커넥션 관리 , 커넥션 관련된 예외처리등을
	 *  	효율적으로 다루는 메소드를 제공.
	 */
	
	static String driverClass;
	static String url;
	static String username;
	static String password; 
	
	static { // 프로그램 시작과 동시에 초기화? static 초기화 블럭 영역
		Properties prop = new Properties();
		String filename = "resources/driver.properties";
		
		try {
			prop.load(new FileReader(filename));
			driverClass = prop.getProperty("driver");
			url = prop.getProperty("url");
			username = prop.getProperty("username");
			password = prop.getProperty("password");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static Connection getConnection() {
		Connection conn = null;
		BasicDataSource dataSource = new BasicDataSource();
		
		try {
			//conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe" , "C##JDBC" , "JDBC");
			dataSource.setDriverClassName(driverClass);
			dataSource.setUrl(url);
			dataSource.setUsername(username);
			dataSource.setPassword(password);
			dataSource.setDefaultAutoCommit(false); // 커넥션 생성시 자동 커밋 여부
			dataSource.setRemoveAbandonedTimeout(60); // 시간 제한 있는 커넥션. 사용하고 있지 않는 커넥션 삭제 (정수형. 초)
			dataSource.setInitialSize(10); // 초기 커넥션풀 사이즈 지정
			dataSource.setMaxTotal(30); // 커넥션풀이 가질수 있는 최대 커넥션수 지정
			dataSource.setMaxWaitMillis(60000); // 커넥션풀에 커넥션이 없을때 대기 할 최대 시간 지정. 시간이 지나면 에러? , 밀리초?
			
			/*
			 * 커넥션풀의 장점
			 * - 자원관리	:	사용하고 닫아두지 않는 커넥션들을 일정시간이 지났을때 자동으로 삭제 해주는 기능이 내장되어 있음.
			 * - 성능향상	:	커넥션풀은 데이터베이스 연결을 미리 생성하고 커넥션풀에 유지시킴으로써 애플리케이션 성능을 향상
			 * 				시킬 수 있다. (생성시의 비용 해결)
			 * - 확장성	:	커넥션풀에서 만들어 놓은 다양한 옵션들 통해 원하는 커넥션풀을 생성 할 수 있음.
			 * 
			 * 커넥션풀의 단점
			 * -	유지 자체만으로 자원을 소비한다.
			 * 		많은 커넥션을 만들어 두면 자원을 그만큼 차지하게 되서 성능이 저하된다.
			 * 		커넥션을 생성해둔다는 것은 그 갯수만큼 항상 DBMS 서버와 연결되어 있는 상태에 있는 것.
			 * 		연결상태에 있으면 연결을 유지하기 위한 메모리를 할당받음. 메모리가 많으면 DB는 적절한 SQL 실행계획을 설정하지 못할 수 있음.
			 * -	커넥션풀이 너무 많은 커넥션이 존재하면 사용되지 않는 커넥션이 많아 질 수 있다.
			 * 
			 * -> 	따라서 커넥션은 동시 사용자수 , 트래픽을 잘 모니터링 하여 적절한 수를 유지 하는 것이 중요하다.
			 */
			
			conn = dataSource.getConnection();
			conn.setAutoCommit(false);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return conn;
	}
	

	public static void close(Connection conn) {
		try {
			if(conn != null && !conn.isClosed())
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void close(Statement stmt) {
		try {
			if(stmt != null && !stmt.isClosed()) {
				stmt.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	

	public static void close(ResultSet rset) {
		try {
			if(rset != null && !rset.isClosed()) {
				rset.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	

	public static void close(Connection conn , Statement stmt , ResultSet rset) {
		
		close(rset);
		close(stmt);
		close(conn);
	}
	

	public static void commit(Connection conn) {
		try {
			if(conn != null && !conn.isClosed()) {
				conn.commit();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	

	public static void rollback(Connection conn) {
		try {
			if(conn != null && !conn.isClosed()) {
				conn.rollback();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
