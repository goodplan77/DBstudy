package com.kh.chap03_MVC.controller;

import java.util.ArrayList;
import java.util.List;

import com.kh.chap03_MVC.model.service.MemberService;
import com.kh.chap03_MVC.view.MemberView;
import com.kh.model.vo.Member;

/*
 * Controller :	View 를 통해서 요청받은 기능을 담당
 * 				해당 메소드로 전달된 데이터들을 가공처리 한 후 , Service 메소드 호출시 전달한다.
 * 				Service 로 부터 반환 받은 결과에 따라 사용자가 보게될 응답화면을 지정.
 */
public class MemberController {
	
	private MemberService mService = new MemberService();
	// private MemberView view = new MemberView();

	/**
	 * 사용자의 회원 추가 요청을 처리 해주는 메소드.
	 * @param userId : 추가할 아이디
	 * @param userPwd : 추가할 비밀 번호
	 * @param userName : 이름
	 * @param gender : 성별 (M /F)
	 * @param email : 이메일
	 * @param birthday : 생일
	 * @param phone : 핸드폰 번호
	 * @param address : 주소
	 */
	
	public void insertMember(String userId, String userPwd, String userName, char gender, String email, String birthday,
			String phone, String address) {
		
		// controller 순서
		// 1. 전달 받은 데이터 가공 처리
		Member m = new Member();
		m.setUserId(userId);
		m.setUserPwd(userPwd);
		m.setUserName(userName);
		m.setGender(gender);
		m.setEmail(email);
		m.setBirthday(birthday);
		m.setPhone(phone);
		m.setAddress(address);
		
		// 2. Service의 insertMember 메소드 호출하기.
		int result = mService.insertMember(m);
		
		// 3. 결과 값에 따라서 사용자가 보게 될 화면을 지정
		if(result > 0) { // 성공
			//성공 메세지 띄워주는 화면을 호출
			new MemberView().displaySuccess("회원 추가 성공");
			
		} else { // 실패
			// 실패메세지를 띄워주는 화면을 호출
			new MemberView().displayFail("회원 추가 실패");
		}
		
	}

	/**
	 * 사용자의 회원 전체 요청기능을 처리하는 메서드
	 */
	public void selectAll() {
		// 결과 값을 담을 변수
		List<Member> list = null;
		
		list = mService.selectAll();
		
		if(list.isEmpty()) {
			new MemberView().displayNoData("조회 결과가 없습니다.");
		} else {
			new MemberView().displayList(list);
		}
		
	}

	/**
	 * 사용자의 아이디로 검색 요청을 해주는 메소드
	 * @param userId : 사용자가 입력했던 검색하고자 하는 아이디
	 */
	public void selectByUserId(String userId) {
		
		Member m = mService.selectByUserId(userId);
		
		if(m == null) { // 조회 결과 일치하는 Member 객체가 없는 경우
			new MemberView().displayNoData(userId + "에 해당하는 조회 결과가 없습니다.");
		} else { //
			new MemberView().displayOne(m);
		}
	}
	
	/** 사용자가 검색한 키워드로 이름을 검색해 해당하는 회원들 목록을 요청하는 메소드
	 * @param keyword : 사용자가 입력한 키워드
	 */
	public void selectByUserName(String keyword) {
		
		List<Member> list = null;
		
		list = mService.selectByUserName(keyword);
		
		if(list.isEmpty()) {
			new MemberView().displayNoData(keyword + "로 검색된 결과가 없습니다.");
		} else { //
			new MemberView().displayList(list);
		}
		
	}

	public void updateMember(String userId, String userPwd, String email, String phone, String address) {
		// 가공처리
		Member m = new Member();
		m.setUserId(userId);
		m.setUserPwd(userPwd);
		m.setEmail(email);
		m.setPhone(phone);
		m.setAddress(address);
		
		// 회원의 아이디와 비밀번호를 가지고 인증된 사용자 인지 검사.
		// SELECT COUNT(*) FROM MEMBER WHERE USER_ID = ? AND WHERE USER_PWD = ? AND STATUS = 'Y'
		
		int result = mService.selectByUser(userId , userPwd);
		
		// 존재하는 회원
		if(result > 0) {
			result = mService.updateMember(m);
			
			if (result > 0) {
				new MemberView().displaySuccess("회원 정보 변경 성공");
			} else {
				new MemberView().displayFail("회원 정보 변경 실패");
			}
		} else {
			new MemberView().displayFail("존재 하지 않는 회원 입니다.");
		}
		
	}
	
	public void deleteMember(String userId, String userPwd) {
		
		Member m = new Member();
		m.setUserId(userId);
		m.setUserPwd(userPwd);
		
		int result = mService.selectByUser(userId , userPwd);
		
		if(result > 0) {
			result = mService.deleteMember(userId , userPwd);
			
			if (result > 0) {
				new MemberView().displaySuccess("회원 탈퇴 성공");
			} else {
				new MemberView().displayFail("회원 탈퇴 실패");
			}
		} else {
			new MemberView().displayFail("존재 하지 않는 회원 입니다.");
		}
	}

}
