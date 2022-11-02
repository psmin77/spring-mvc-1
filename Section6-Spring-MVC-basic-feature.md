### 요청매핑
- @RestController
  - 반환 값으로 뷰가 아니라 HTTP 메시지 바디에 바로 입력
- @RequestMapping("/매핑경로")
  - 매핑 경로는 배열[]로 다중 설정 가능
  ({"/mapping1", "/mapping2"})

#### HTTP 메서드
- 메서드 속성을 지정하지 않으면 모두 허용
  (GET, POST, HEAD, PUT, PATCH, DELETE)
- @RequestMapping(value="/매핑경로", method = RequestMethod.GET/POST)
- HTTP 메서드 매핑 축약
  - @GetMapping
  - @PostMapping
  - @PutMapping
  - @DeleteMapping
  - @PatchMapping
  
#### PathVariable(경로 변수)
- 매핑경로: @RequestMapping("/mapping/{data}")
- 파라미터: @PathVariable("data") String data
  - 변수명이 같으면 생략 가능
  - @PathVariable data
- 다중 사용
  - /mapping/id/{id}/order/{order}
  - @PathVariable String id, @PathVariable Long order
  
#### 특정 파라미터 조건 매핑
- @GetMapping(value = "/mapping-param", params = "mode=debug")
- params="mode"
- params="!mode"
- params="mode=debug"
- params="mode!=debug"

#### 특정 헤더 조건 매핑
- @GetMapping(value = "/mapping-header", headers = "mode=debug")
- headers="mode",
- headers="!mode"
- headers="mode=debug"
- headers="mode!=debug"

#### 미디어 타입 조건 매핑 (consume)
- HTTP 요청의 Content-Type 헤더 기반으로 전송할 미디어 타입 매핑
- 맞지 않으면 HTTP 415 상태코드 반환
- @PostMapping(value = "/mapping-consume", consumes = "application/json")
  - consumes="application/json", "text/plain" 등
  - consumes={"application/*", "text/plain"} -> 다중 설정
  - MediaType.APPLICATION_JSON_VALUE

#### 미디어 타입 조건 매핑 (produre)
- HTTP 요청의 Accept 헤더 기반으로 수신할 미디어 타입 매핑
- 맞지 않으면 HTTP 406 상태코드 반환
- @PostMapping(value = "/mapping-produce", produces = "text/html")
- produces = "text/plain"
- produces = {"text/plain", "application/*"}
- produces = MediaType.TEXT_PLAIN_VALUE

### 요청 매핑 - API 예시
- 회원 관리 API
  - 회원 전체 조회: GET /users
  - 회원 등록: POST /users
  - 회원 조회: GET /users/{userId}
  - 회원 수정: PATCH /users/{userId}
  - 회원 삭제: DELETE /users/{userId}

### HTTP 요청 - 기본, 헤더조회
- HttpServletRequest
- HttpServletResponse
- HttpMethod
- Local: Locale 정보 조회(언어 등)
- @RequestHeader MultiValueMap<String, String> headerMap: 모든 HTTP 헤더를 조회
- @RequestHeader("host") String host : 특정 헤더 조회
- @CookieValue(value="value", required=false/true) String cookie : 특정 쿠키 조회

### HTTP 요청 파라미터 - 쿼리 파라미터, HTML Form
- GET : 쿼리 파라미터
- POST : HTML Form
- HTTP message body 
<br>

>
[출처] 스프링 MVC 1 - 김영한, 인프런
