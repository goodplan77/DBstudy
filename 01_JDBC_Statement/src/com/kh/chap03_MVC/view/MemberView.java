package com.kh.chap03_MVC.view;

import java.util.Scanner;

import com.kh.chap03_MVC.controller.MemberController;

/*
 * View : 사용자가 보게 될 시각적인 요소를 담당. (화면 => 입력 , 출력)
 */
public class MemberView {
	
	private Scanner sc = new Scanner(System.in);
	
	private MemberController mc = new MemberController();
	
	/**
	 * 사용자가 보게 될 메인 화면
	 */
	public void mainMenu() {
		while(true) {
			System.out.println("***** 회원 프로그램 *****");
			System.out.println("1. 회원 추가");
			System.out.println("2. 회원 전체 조회");
			System.out.println("3. 회원 아이디로 검색");
			System.out.println("4. 회원 이름 키워드 검색");
			System.out.println("5. 회원 정보 변경");
			System.out.println("6. 회원 탈퇴 기능");
			System.out.println("9. 프로그램 종료");
			System.out.println("----------------------");
			
			System.out.print("이용할 메뉴 선택 : ");
			int menu = Integer.parseInt(sc.nextLine());
			
			switch(menu) {
			case 1:
				insertMember();
				break;
			case 2:
				//selectAll();
				break;
			case 3:
				//selectByUserId();
				break;
			case 4:
				//selectByUserName();
				break;
			case 5:
				//updateMember();
				break;
			case 6:
				//deleteMember();
				break;
			case 9:
				System.out.println("프로그램을 종료합니다.");
				return;
			default:
				System.out.println("잘못된 메뉴를 선택했습니다. 다시 입력해주세요.");
				break;
			}
		}
	}

	
	/**
	 * 회원 추가용 View <br>
	 * 추가하고자 하는 회원의 정보를 입력받아 controller에 회원 추가 요청을 할 수 있는 화면
	 */
	private void insertMember() {
		System.out.println("----- 회원 추가 -----");
		
		System.out.print("아이디 : ");
		String userId = sc.nextLine();
		
		System.out.print("비밀번호 : ");
		String userPwd = sc.nextLine();
		
		System.out.print("이름 : ");
		String userName = sc.nextLine();
		
		System.out.print("성별(M/F) : ");
		char gender = sc.nextLine().toUpperCase().charAt(0);
		
		System.out.print("이메일 : ");
		String email = sc.nextLine();
		
		System.out.print("생일 : ");
		String birthday = sc.nextLine();
		
		System.out.print("핸드폰번호 : ");
		String phone = sc.nextLine();
		
		System.out.print("주소 : ");
		String address = sc.nextLine();
		
		// 입력 받은 정보를 컨트롤러에게 넘겨서 회원 추가 요청.
		mc.insertMember(userId , userPwd , userName , gender , email , birthday , phone , address);
	}


	//-----------------------------------------------
	
	/**
	 * 서비스 요청 성공시 보게 될 화면
	 * @param string
	 */
	public void displaySuccess(String string) {
		System.out.println("\n 서비스 요청 성공 ! " + string);
	}


	/**
	 * 서비스 요청 실패시 보게 될 화면
	 * @param string
	 */
	public void displayFail(String string) {
		System.out.println("\n 서비스 요청 실패 ! " + string);
	}

}
