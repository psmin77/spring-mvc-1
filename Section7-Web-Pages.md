### 요구사항 분석
#### 상품 도메인 모델
- 상품 ID
- 상품 명
- 상품 가격
- 상품 수량

#### 상품 관리 기능
- 상품 목록
- 상품 상세
- 상품 등록
- 상품 수정

#### 서비스 제공 흐름![](https://velog.velcdn.com/images/psmin77/post/18e15b86-f2be-4f17-954f-056e253cc850/image.png)
<br>

### 상품 도메인 개발
- _Item_ 상품 객체(VO)
- _ItemRepository_ 상품 저장소
  - 상품 등록, 상품 조회, 전체 상품 조회, 상품 수정
- 상품 서비스 HTML
  - _items.html_ 전체 상품 조회
  - _item.html_ 상품 조회
  - _addForm.html_ 상품 등록
  - _editForm.html_ 상품 수정

### 타임리프
- 순수 HTML을 유지하면서 뷰 템플릿도 사용할 수 있는 내추럴 템플릿(Natural Templates)
- 경로: /resources/templates/
- 사용 선언
  ~~~ html
  <html xmlns:th="http://www.thymeleaf.org">
  ~~~
- 속성 변경
  - 대부분의 HTML 속성 사용 가능-> th:XXX
  - th:xxx가 붙은 코드는 서버 사이드에서 렌더링
- 표현식
  - URL 링크1 - @{...}
  - URL 링크2 - @{{파라미터}(파라미터=${파라미터})}
   ~~~
   th:href="@{/items/{itemId}(itemId=${item.id})}"
   ~~~ 
  - URL 링크3 - @{|...|}
    ~~~
    th:href="@{|/item/${item.id}|}"
    ~~~
  - 리터럴 대체 - |...|
    - 문자와 표현식을 분리하지 않고 사용 가능
  - 반복 출력 - th:each
    ~~~
    th:each="item:${items}"
    ~~~
  - 변수 표현식 - ${...}
    - 모델 값이나 타임리프 변수 선언 값을 사용 가능
  - 내용 사용 - th:text
    ~~~
    <td th:text="${item.price}"> item.price의 값 </td>
    ~~~
  - 속성 - th:value
  - 폼 제출 - th:action
    - action 값을 생략하면 현재 URL에 데이터 전송
    - 등록 폼 URL과 실제 등록하는 URL을 동일하게 맞추고 HTTP 메서드로 구분할 수 있음
      - 등록 폼: GET /basic/items/add
      - 등록 처리: POST /basic/items/add

### @ModelAttribute
- 요청 파라미터의 값을 프로퍼티 접근법(setter)으로 입력하여 객체로 생성
- 자동으로 model에 해당 객체를 넣어줌
  - model.addAttribute(...) 생략 가능
  - 클래스의 첫 글자를 소문자로 변경하여 등록(Item -> item)
- name(value) 속성으로 이름 지정 가능

### 리다이렉트
- 경로: redirect:/...
- 컨트롤러에 매핑된 @PathVariable 값 사용 가능


<br>

>
[출처] 스프링 MVC 1 - 김영한, 인프런
