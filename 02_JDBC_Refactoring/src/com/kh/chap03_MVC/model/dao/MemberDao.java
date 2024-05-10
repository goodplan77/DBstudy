package com.kh.chap03_MVC.model.dao;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.InvalidPropertiesFormatException;
import java.util.List;
import java.util.Properties;

import com.kh.common.template.JDBCTemplate;
import static  com.kh.common.template.JDBCTemplate.*;
import com.kh.model.vo.Member;

/*
 * DAO(Data Access Object)?
 * - Service 에 의해 호출되며 , 맡은 기능을 수행 하기 위해 DB에 직접 접근하여 sql 문을
 * 	호출한 후 처리 결과값을 반환시켜주는 객체
 */
public class MemberDao {
	
	private Properties prop = new Properties();
	
	public MemberDao() {
		try {
			prop.loadFromXML(new FileInputStream("resources/member_mapper.xml"));
		} catch (InvalidPropertiesFormatException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 사용자가 view 에서 입력한 값을 가지고 DB에 INSERT 문을 실행하는 메소드
	 * @param conn
	 * @param m
	 * @return 처리된 행의 갯수
	 */
	public int insertMember(Connection conn , Member m) {
		
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("insertMember");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,m.getUserId());
			pstmt.setString(2,m.getUserPwd());
			pstmt.setString(3,m.getUserName());
			pstmt.setString(4,m.getEmail());
			pstmt.setString(5,m.getBirthday());
			pstmt.setString(6,String.valueOf(m.getGender()));
			pstmt.setString(7,m.getPhone());
			pstmt.setString(8,m.getAddress());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}

	/**
	 * 사용자가 회원전체 요청시 select 문을 통해 전체 회원을 조회하는 메서드
	 * @param conn
	 * @return
	 */
	public List<Member> selectAll(Connection conn) {
		
		Member m = null;
		List<Member> list = new ArrayList<>();
		PreparedStatement pstmt = null;
		String sql = "";
		ResultSet rset = null;
		
		sql = prop.getProperty("selectAll");
		try {
			pstmt = conn.prepareStatement(sql);
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				
				// 현재 rset의 커서가 가라키는 지점에서 데이터 추출
				
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
				
				list.add(m);
				
				/*
				list.add(new Member(rset.getInt("USER_NO"),
						rset.getString("USER_ID"),
						rset.getString("USER_PWD"),
						rset.getString("USER_NAME"),
						rset.getString("BIRTHDAY"),
						rset.getString("EMAIL"),
						rset.getString("GENDER").charAt(0),
						rset.getString("PHONE"),
						rset.getString("ADDRESS"),
						rset.getDate("ENROLL_DATE"),
						rset.getDate("MODIFY_DATE"),
						rset.getString("STATUS").charAt(0)));
						*/
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(null , pstmt , rset);
			// 생성한 위치에서 닫아줘야한다. service에서 해결해야 한다?
			// null 에 대한 예외 처리를 해줌으로써 Connection 객체는 닫히지 않음
			
			// close(rset);
			// close(pstmt);
		}
		
		return list;
	}

	public Member selectbyUserId(Connection conn, String userId) {
		Member m = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rset = null;
		
		sql = prop.getProperty("selectbyUserId");
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				m = new Member();
				m.setUserId(rset.getString("USER_ID"));
				m.setUserName(rset.getString("USER_NAME"));
				m.setPhone(rset.getString("PHONE"));
				m.setAddress(rset.getString("ADDRESS"));
			} 
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close (null , pstmt , rset);
		}
		
		return m;
	}

	public List<Member> selectByUserName(Connection conn, String keyword) {
		
		Member m = null;
		List<Member> list = new ArrayList<>();
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rset = null;
		
		sql = prop.getProperty("selectByUserName");
		// sql = "SELECT * FROM MEMBER WHERE INSTR(USER_NAME , ?) > 0 AND STATUS = 'Y'";
		// pstmt.setString(1, keyword);
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"  + keyword + "%");
			
			rset = pstmt.executeQuery();
			
			while(rset.next()) {
				
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
				
				list.add(m);
			} 
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close (null , pstmt , rset);
		}
		
		return list;
	}

	public int selectByUser(Connection conn, String userId, String userPwd) {
		Member m = null;
		PreparedStatement pstmt = null;
		String sql = null;
		int result = 0;
		ResultSet rset = null;
		
		sql = prop.getProperty("selectByUser");
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setString(2, userPwd);
			
			rset = pstmt.executeQuery();
			
			if(rset.next()) {
				result = rset.getInt(1);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close (pstmt);
		}
		
		return result;
	}

	public int updateMember(Connection conn, Member m) {
		
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("updateMember");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,m.getEmail());
			pstmt.setString(2,m.getPhone());
			pstmt.setString(3,m.getAddress());
			pstmt.setString(4,m.getUserId());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(pstmt);
		}
		
		return result;
	}
	
	public int deleteMember(Connection conn, String userId , String userPwd) {
		
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("deleteMember");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,userId);
			pstmt.setString(2,userPwd);
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(pstmt);
		}
		
		return result;
	}
	
}


