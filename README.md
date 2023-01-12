# 투두창
![Group 1](https://user-images.githubusercontent.com/54075367/211333924-4eb16d8f-5a6e-4037-ab7f-1de03ac4a626.png)
* 할 일을 날짜별로 업로드하여 공유할 수 있습니다.
* 할 일을 생성, 수정, 삭제, 검색할 수 있습니다.
* 사이드 메뉴를 통해 나의 정보를 확인할 수 있습니다.
* 앱스토어 링크 : https://apps.apple.com/kr/app/%ED%88%AC%EB%91%90%EC%B0%BD/id1658165242
* 노션 링크: https://inexpensive-octagon-6dd.notion.site/892bb558c8c44be3a3956397e156f234
## 주요기능
* 달력
  * UICollectionView를 이용하여 구현
  * 좌우 스크롤로 달력 넘기기
  * 달력 Title 클릭 시 오늘 날짜로 이동
  * 날짜에 할 일 목록 유무 표시
  * 날짜 클릭시 해당 날짜의 할 일 목록을 표시
  
* 할 일 목록
  * UITableView를 이용하여 구현
  * 할 일 목록 생성 / 수정 / 삭제
  * Strapi를 사용하여 Backend 구현
  * 로딩 애니메이션
  
* 검색
  * Combine을 사용하여 검색기능 구현
  * 검색된 아이템 클릭 시 해당 날짜로 이동
  
* 로그인 / 회원가입 / 로그아웃 / 계정삭제
  * UserDefault를 사용하여 최초1회 로그인 후 자동로그인
  * 회원가입 성공하면 Lottie를 이용한 애니메이션 실행
  * 사이드메뉴에서 로그아웃, 계정삭제 
  
* 사이드 메뉴 계정 정보표시
  * SideMenu라이브러리를 사용하여 사용자의 계정정보를 간략히 표시
  * 로그인된 계정으로 추가된 할 일만 표시되는 "나의 오늘 할일" 표시
  * UITableView로 계정설정화면 구현 (프로필변경 추가 예정)
  
## 사용 기술 및 라이브러리
* Swift, IOS
* UIKit, SwiftUI
* AutoLayout
* Combine
* Alamofire
* SideMenu
* Strapi

## History
### 2023.01.09 
  * _v1.0.2 버전 업데이트_
  * 로그인, 회원가입, 로그아웃, 계정삭제기능 추가
  * 달력 기능 개선
  * 할 일 목록 검색 기능 추가
  * 사이드메뉴 추가
### 2022.12.10
  * 앱 등록
