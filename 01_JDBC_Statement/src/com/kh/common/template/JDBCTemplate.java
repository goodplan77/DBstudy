package com.kh.common.template;

import java.sql.*;

public class JDBCTemplate {
	/*
	 * Template ?
	 * - JDBC 과정중 반복적으로 쓰이는 구문들을 각각의 메소드로 정의한 클래스.
	 */
	
	// 공통되는 소스코드
	// 1) DB와 연결하여 Connection 객체를 반환 하는 부분.
	
	public static Connection getConnection() {
		Connection conn = null;
		
		try {
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe" , "C##JDBC" , "JDBC");
			conn.setAutoCommit(false);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return conn;
	}
	
	// 2. 전달받은 JDBC용 객체를 대신 반납시켜주는 메소드
	// 2-1) Connection 객체를 반납 시켜주는 메소드
	public static void close(Connection conn) {
		try {
			if(conn != null && !conn.isClosed())
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	// 2-2) Statement 객체를 반납 시켜주는 메소드
	// + PreparedStatement -> Statement를 상속 받음
	// + CallableStatement -> PreparedStatement 를 상속 받음
	// 따라서 , 최상위 부모 객체인 Statement만 설정해도 다형성에 의해 따로 선언을 안해줘도 됨
	public static void close(Statement stmt) {
		try {
			if(stmt != null && !stmt.isClosed()) {
				stmt.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	// 2-3) ResultSet 객체를 반납시켜주는 메소드
	public static void close(ResultSet rset) {
		try {
			if(rset != null && !rset.isClosed()) {
				rset.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	// 2-4) 통합
	public static void close(Connection conn , Statement stmt , ResultSet rset) {
		
		close(rset);
		close(stmt);
		close(conn);
	}
	
	// 3. 전달받은 Connection 을 활용해서 commit , rollback 메소드
	// 3-1) 전달받은 Connection을 가지고 COMMIT 시켜주는 메소드
	public static void commit(Connection conn) {
		try {
			if(conn != null && !conn.isClosed()) {
				conn.commit();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	// 3-2) 전달받은 Connection을 가지고 ROLLBACK 시켜주는 메소드
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
