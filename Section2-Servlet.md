### 서블릿 환경 구성 (스프링 부트)
- @ServletComponenScan : 서블릿 자동 등록
- @WebServlet : 서블릿 어노테이션
  - name : 서블릿 이름
  - urlPatterns : URL 매핑
 
### HttpServletRequest
- 서블릿은 HTTP 요청 메시지를 편리하게 사용할 수 있도록 파싱한 후 HttpServletRequest 객체로 제공
- HTTP 요청 메시지
  - Start Line (HTTP 메소드, URL, 쿼리스트링, 프로토콜 등)
  - 헤더
  - 바디 (form 파라미터 형식 조회, 메시지 바디 조회 등)
- 임시 저장소 기능: setAttribute, getAttribute
- 세션 관리 기능: getSession

### HTTP 요청 데이터
#### GET - 쿼리 파라미터
- /url?parametername=value&name2=value2
- 메시지 바디 없이 URL 쿼리 파라미터에 데이터 전달
- 검색, 필터, 페이징 등에서 주로 사용
- 조회 메서드
  - 단일 파라미터 조회: getParameter("name")
  - 복수 파라미터 조회: (배열 형태) String[] names = getParameterValues("name")
  - 모든 파라미터 조회: getParameterNames(), getparameterMap()
  - 복수 값일 때 단일 파라미터로 조회할 경우 첫 번째 값만 반환함
  
#### POST - HTML Form
- content-type: application/x-www-form-urlencoded
- 메시지 바디를 쿼리 파라미터 형식으로 전달
- 회원가입, 상품주문 등에서 주로 사용
- 조회 메서드
  - GET 쿼리 파라미터 조회 메서드와 동일하게 사용
  - content-type 지정  
  
#### HTTP message body
- 주로 JSON 사용하고 이외에 XML, TEXT 등
- HTTP API에서 주로 사용
- POST, PUT, PATCH

<br>

>
[출처] 스프링 MVC 1 - 김영한, 인프런
