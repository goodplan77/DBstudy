package com.kh.chap02_CRUD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import com.kh.model.vo.Member;

public class CRUD {
	
	public static void main(String[] args) {
		CRUD crud = new CRUD();
		// crud.insertMember();
		
		Scanner sc = new Scanner(System.in);
		
		/*
		System.out.print("이메일 : ");
		String email = sc.nextLine();
		
		System.out.print("핸드폰 : ");
		String phone = sc.nextLine();
		
		System.out.print("주소 : ");
		String address = sc.nextLine();
		*/
		
		// System.out.print("아이디 : ");
		// String userid = sc.nextLine();
		
		// crud.updateMember(email, phone, address, userid);
		// crud.deleteMember(userid);
		// crud.selectOne(userid);
		
		// crud.selectAll();
		// crud.execPlSql();
		
		System.out.print("사번 : ");
		int empId = sc.nextInt();
		
		crud.execProcedure(empId);
	}
	
	
	/**
	 * 회원가입 메서드<br>
	 * DML(INSERT , UPDATE , DELETE) JDBC 코딩 흐름<br>
	 * 1) 드라이버(생략가능)<br>
	 * 2) DBMS연결 == Connection 객체 생성<br>
	 * 3) AutoCommit 설정 변경 : true(기본값) / false<br>
	 * 4) Statement객체 생성<br>
	 * 5) SQL문 실행 -> execute(sql) || executeUpdate(sql)<br>
	 * 6) 트랜잭션 처리<br>
	 * 7) 자원반납<br>
	 *
	 */
	public void insertMember() {
		
		try {
			// 2) DBMS연결 == Connection 객체 생성
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe"
					,"C##JDBC","JDBC");
			// 3) AutoCommit 설정
			conn.setAutoCommit(false);
			
			// 4) Statement 객체 생성
			Statement stmt = conn.createStatement();
			
			// 5+6) DB에 완성된 SQL문 전달하면서 처리 결과값(처리된 행의 갯수) 돌려받기
			// Statement ? 실행할 sql문장을 완전한 형태로 만들어서 실행 해야 하는 클래스
			String sql = "INSERT INTO MEMBER VALUES(SEQ_UNO.NEXTVAL , 'user02' , 'pass02' , '홍길동' , 'user02@naver.com' "
					+ " , '900213' , 'M' , '010-1234-1234' , '서울시 마포구 공덕동' , SYSDATE , SYSDATE , DEFAULT)";
			int result = stmt.executeUpdate(sql);
			
			System.out.println("처리 결과 : " + result);
			
			// 7) 트랜잭션 처리
			if(result > 0) { // 성공시
				conn.commit();
			} else { // 실패시
				conn.rollback();
			}
			
			// 8) 다쓴 자원 반납
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	/*
	 * 4) PreparedStatement객체 생성
	 */
	public void updateMember(String email , String phone , String address , String userId) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe" , "C##JDBC" , "JDBC");
			conn.setAutoCommit(false);
			
			// 4-1) PreparedStatement객체 생성
			/*
			 * PreparedStatement ?
			 * - Prepared -> 준비된 ? 준비된 Statement. SQL문을 미리 준비해둔 클래스
			 * - Statement 인터페이스를 확장한 인터페이스. 즉 더 많은 기능이 있으며 Statement 단점을 개선한 인터페이스.
			 * 
			 * Statement 단점
			 * 	1. 하드코딩한 데이터가 그대로 들어가 있어서 가독성이 안좋음
			 *  2. 재사용성이 좋지 못함. (실행계획?)
			 *  3. sql 인젝션을 방어 할 수 없음.
			 *  
			 * - 객체 생성시 "미완성된" 상태의 sql 문을 미리 전달하여 실행계획을 "준비시키고" , 실행하기 전에 완성된 형태로 가공한후 실행한다.
			 */
			
			sql = "UPDATE MEMBER SET EMAIL = ? , PHONE = ? , ADDRESS = ? WHERE USER_ID = ?";
			// 하드 코딩한 경우 (상단) -> Statement 실행할 때마다 실행 계획 설정 -> 비용 비쌈
			// Prepared 설정의 경우 -> 미리 설정된 계획만 한번만 실행하고 그 이후는 설정하지 않음
			pstmt = conn.prepareStatement(sql);
			
			// 4-2) 미완성된 쿼리문 완성된 형태로 변환하기.
			// pstmt.setXXX(?의 위치 , 넣어줄 값);
			// '' 자동으로 붙여줌
			pstmt.setString(1, email);
			pstmt.setString(2, phone);
			pstmt.setString(3, address);
			pstmt.setString(4, userId);
			
			// 5+6) executeUpdate
			int result = pstmt.executeUpdate();
			
			
			// 6) 트랜잭션 처리
			if(result > 0) {
				conn.commit();
			} else {
				conn.rollback();
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally { // 7) 자원 반납
			try {
				pstmt.close();
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public void deleteMember(String userId) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		String sql = null;
		
		try {
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe" , "C##JDBC" , "JDBC");
			conn.setAutoCommit(false);
			
			// SQL Injection 알아보기
			// 1) Statement로 객체 생성
			stmt = conn.createStatement();
			
			// 쿼리문 실행
			// int result = stmt.executeUpdate("DELETE FROM MEMBER WHERE USER_ID = '" + userId + "'");
			// userId == " ' OR (1=1) -- "
			
			// 2) PrepareStatement 객체 생성
			sql = "DELETE FROM MEMBER WHERE USER_ID = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,userId);
			// SQL Injection 방어 가능해짐
			
			int result = pstmt.executeUpdate(); // 함수 실행시 쿼리문은 다시 미완성된 상태로 돌아감.
				
			System.out.println("처리된 행의 갯수 : " + result);
			
			// 미완성된 쿼리문 재사용
			pstmt.setString(1,userId);
			int result2 = pstmt.executeUpdate();
			System.out.println("처리된 행의 갯수 : " + result);
			
			int total = result * result2;
			// 각 트랜잭션의 값을 곱해서 처리를 어떻게 할지 결정함
			// 하나라도 0 : 오류 발생 , 따라서 롤백
			
			if(total > 0) {
				conn.commit();
			} else {
				conn.rollback();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 회원 한명 조회하는 메소드 <br>
	 * 
	 * DQL(SELECT) 시 JDBC 코딩 흐름 <br>
	 * 1) Driver 등록(생략가능) <br>
	 * 2) DBMS 연결 <br>
	 * 3) PreparedStatement 객체 생성 <br>
	 * 4) SQL 실행 <br>
	 * 5) 결과값 반환 <br>
	 * 6) ResultSet 객체를 알맞은 vo 클래스로 매핑 <br>
	 * 7) 다 쓴 자원 반납 <br>
	 */
	public void selectOne(String userId) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		Member m = null;
		String sql = null;
		
		try {
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe" , "C##JDBC" , "JDBC");
		
			sql = "SELECT * FROM MEMBER WHERE USER_ID = ?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, userId);
			
			rset = pstmt.executeQuery();
			
			/*
			 * ResultSet ?
			 * - SELECT 를 호출한 결과값이 담겨 있는 객체
			 * - 커서(Cursor) 를 사용하여 ResultSet의 각 "행"에 접근하여 데이터를 읽어 올 수 있음.
			 * 	* cursor? ResultSet 내부에서 특정 "행"을 가리키는 포인터 (배열 인덱스?)
			 * - 커서의 위치를 변경하는 메서드들
			 * 	1) next() : boolean -> 커서의 위치를 "다음" 행으로 이동시키고 이동시킨 자리에 행이 있으면 true , 없으면 false 반환
			 * 	2) previous() : boolean -> 커서의 위치를 "이전" 행으로 이동시키고 이동시킨 자리에 행이 있으면 true , 없으면 false 반환
			 * 	3) first() : boolean -> 커서를 첫번째 행으로 이동.
			 * 	4) last() : boolean -> 커서를 마지막 행으로 이동. 
			 * 	5) absolute(int row) : boolean -> 커서를 지정된 행으로 이동시키고 행이 있으면 true , 없으면 false 반환
			 * 	6) relative(int rows) : boolean -> 커서를 "현재" 위치에서 지정된 수 만큼 이동시키고 행이 있으면 true , 없으면 false 반환
			 */
			
			// 6) rset을 vo 객체로 매핑
			if(rset.next()) {
				
				// 데이터가 존재한다면 현재 행의 데이터를 뽑아서 Member 객체로 변환.
				
				
				// rset으로 부터 어떤 칼럼에 해당하는 값을 뽑을건지 제시
				// 컬럼명 , 컬럼의 순번
				// 권장사항 : 컬럼명(대문자) 으로 쓰는 것을 권장.
				
				m = new Member();
				m.setUserNo(rset.getInt("USER_NO"));
				m.setUserId(rset.getString("USER_ID"));
				m.setUserPwd(rset.getString("USER_PWD"));
				m.setUserName(rset.getString("USER_NAME"));
				m.setGender(rset.getString("GENDER").charAt(0));
				m.setEmail(rset.getString("EMAIL"));
				m.setBirthday(rset.getString("BIRTHDAY"));
				m.setPhone(rset.getString("PHONE"));
				m.setAddress(rset.getString("ADDRESS"));
				m.setEnrollDate(rset.getDate("ENROLL_DATE"));
				m.setModifyDate(rset.getDate("MODIFY_DATE"));
				m.setStatus(rset.getString("STATUS").charAt(0));
				
			}
			
			System.out.println(m);
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// 추가된 역순으로 닫아주기
			try {
				rset.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
	}

	// 한번에 여러행 데이터 조회하기
	public void selectAll() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		String sql = null;
		List<Member> list = new ArrayList<>();
		
		try {
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe" , "C##JDBC" , "JDBC");
			
			sql = "SELECT * FROM MEMBER";
			pstmt = conn.prepareStatement(sql);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				
				Member m = new Member();
				m.setUserNo(rset.getInt("USER_NO"));
				m.setUserId(rset.getString("USER_ID"));
				m.setUserPwd(rset.getString("USER_PWD"));
				m.setUserName(rset.getString("USER_NAME"));
				m.setGender(rset.getString("GENDER").charAt(0));
				m.setEmail(rset.getString("EMAIL"));
				m.setBirthday(rset.getString("BIRTHDAY"));
				m.setPhone(rset.getString("PHONE"));
				m.setAddress(rset.getString("ADDRESS"));
				m.setEnrollDate(rset.getDate("ENROLL_DATE"));
				m.setModifyDate(rset.getDate("MODIFY_DATE"));
				m.setStatus(rset.getString("STATUS").charAt(0));
				
				list.add(m);			
			}
			System.out.println("회원 list 의 길이 : " + list.size());
			System.out.println(list);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				rset.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	// JDBC로 PL/SQL 문 호출하기
	public void execPlSql() {
		try {
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe" , "C##JDBC" , "JDBC");
			
			String sql = "BEGIN UPDATE MEMBER SET USER_NAME = ?; END;";
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,"강경호");
			
			boolean result = pstmt.execute();
			// pstmt.executeQuery();
			
			pstmt.close();
			conn.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// JDBC로 내장 프로시져를 실행
	// KH계정의 PRO_SELECT_EMP 프로시저 실행
	public void execProcedure(int empId) {
		try {
			Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe" , "C##KH" , "KH");
			
			// 3) CallableStatement 객체 생성.
			// CallableStatement ?
			//	- 저장된 프로시저를 호출할 때 사용.
			String sql = "{CALL PRO_SELECT_EMP(?,?,?,?)}"; // 1번 위치홀더 : IN , 2,3,4번 위치 홀더 : OUT
			CallableStatement cstmt = conn.prepareCall(sql);
			cstmt.setInt(1, empId);
			cstmt.registerOutParameter(2, Types.VARCHAR); // EMP_NAME -> VARCHAR2
			cstmt.registerOutParameter(3, Types.INTEGER); // SALARY -> NUMBER
			cstmt.registerOutParameter(4, Types.DOUBLE); // BONUS -> NUMBER
			
			// 프로시저 실행
			cstmt.execute();
			
			String name = cstmt.getString(2);
			int salary = cstmt.getInt(3);
			Double bonus = cstmt.getDouble(4);
				
			System.out.println(name + " , " + salary + " , " + bonus);
				
			cstmt.close();
			conn.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
}
