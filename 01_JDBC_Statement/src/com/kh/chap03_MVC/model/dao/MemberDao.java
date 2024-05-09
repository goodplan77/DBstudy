package com.kh.chap03_MVC.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.kh.common.template.JDBCTemplate;
import com.kh.model.vo.Member;

/*
 * DAO(Data Access Object)?
 * - Service 에 의해 호출되며 , 맡은 기능을 수행 하기 위해 DB에 직접 접근하여 sql 문을
 * 	호출한 후 처리 결과값을 반환시켜주는 객체
 */
public class MemberDao {
	
	
	/**
	 * 사용자가 view 에서 입력한 값을 가지고 DB에 INSERT 문을 실행하는 메소드
	 * @param conn
	 * @param m
	 * @return 처리된 행의 갯수
	 */
	public int insertMember(Connection conn , Member m) {
		
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = "INSERT INTO MEMBER VALUES("
				+ "SEQ_UNO.NEXTVAL,?,?,?,?,?,?,?,?,SYSDATE,SYSDATE,DEFAULT)";
		
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
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCTemplate.close(pstmt);
		}
		
		return result;
	}
}
