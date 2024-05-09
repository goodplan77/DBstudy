package com.kh.chap03_MVC.controller;

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

}
