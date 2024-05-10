package com.kh.chap03_MVC.model.service;

import java.sql.Connection;
import java.util.List;

import com.kh.chap03_MVC.model.dao.MemberDao;
import com.kh.common.template.JDBCTemplate;
import static com.kh.common.template.JDBCTemplate.*;
import com.kh.model.vo.Member;

/*
 * Service :	컨트롤러에 의해 호출되는 최초의 메서드.
 * 				여러 dao에 존재하는 메서드를 호출하여 논리적으로 연관이 있는 비즈니스 로직을 만든다.
 * 				처리 결과 값을 컨트롤러에게 반환 해주는 역할을 한다.
 */

public class MemberService {
	
	private MemberDao mDao = new MemberDao();

	public int insertMember(Member m) {
		// Connection 객체 생성
		Connection conn = JDBCTemplate.getConnection();
		
		// DAO 호출시 Connection 객체와 기존에 넘기고자 했던 매개변수(m)을 같이 넘겨준다.
		int result = mDao.insertMember(conn , m);
		
		if (result > 0) {
			JDBCTemplate.commit(conn);
		} else {
			JDBCTemplate.rollback(conn);
		}
		
		JDBCTemplate.close(conn);
		
		return result;
	}

	public List<Member> selectAll() {
		Connection conn = getConnection();
		
		List<Member> list = mDao.selectAll(conn);
		
		close(conn);
		
		return list;
	}

	public Member selectByUserId(String userId) {
		Connection conn = getConnection();
		
		Member m = mDao.selectbyUserId(conn , userId);
		
		close(conn);
		
		return m;
	}

	public List<Member> selectByUserName(String keyword) {
		
		Connection conn = getConnection();
		
		List<Member> list = mDao.selectByUserName(conn , keyword);
		
		close(conn);
		
		return list;
	}

	public int selectByUser(String userId, String userPwd) {
		
		Connection conn = getConnection();
		
		int result = mDao.selectByUser(conn , userId , userPwd);
		
		close(conn);
		
		return result;
	}

	public int updateMember(Member m) {
		
		Connection conn = getConnection();
		
		int result = mDao.updateMember(conn , m);
		
		if (result > 0) {
			commit(conn);
		} else {
			rollback(conn);
		}
		
		close(conn);	
		
		return result;
	}
	
	public int deleteMember(String userId , String userPwd) {
		
		Connection conn = getConnection();
		
		int result = mDao.deleteMember(conn , userId , userPwd);
		
		if (result > 0) {
			commit(conn);
		} else {
			rollback(conn);
		}
		
		close(conn);	
		
		return result;
	}

}
