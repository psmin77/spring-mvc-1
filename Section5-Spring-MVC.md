### 스프링 MVC 전체 구조![](https://velog.velcdn.com/images/psmin77/post/7fd6ec9b-c72b-471c-9e16-1c002a52e973/image.png)
- DispatcherServlet (=프론트 컨트롤러)
  - DispatcherServlet > FrameworkServlet > HttpServletBean > HttpServlet 상속
  - 서블릿이 호출되면 HttpServlet.service() 호출
  - service()를 오버라이드한 DispatcherServlet.doDispatch() 호출
  - 프론트 컨트롤러와 동일한 로직 수행  (핸들러 조회, 어댑터 조회, 실행 등)
- 동작 순서
  - 핸들러 조회
  - 핸들러 어댑터 조회
  - 핸들러 어댑터 실행
  - 핸들러 실행
  - ModelAndView 반환
  - viewResolver 호출
    - JSP에서는 InternalResourceViewResolver
    - Thymeleaf에서는 ThymeleafResolver
  - View 반환
    - JSP에서는 InternalResourceView(JstlView) 반환
  - 뷰 렌더링
<br>

### 핸들러 매핑과 핸들러 어댑터
- HandlerMapping 
  - 0 = RequestMappingHandlerMapping
    - @RequestMapping 애노테이션 기반의 컨트롤러 조회
  - 1 = BeanNameUrlHandlerMapping
    - 스프링 빈 이름의 핸들러 조회
- HandlerAdapter 
  - 0 = RequestMappingHandlerAdapter
    - @RequestMapping 애노테이션 기반의 컨트롤러 사용
  - 1 = HttpRequestHandlerAdapter 
    - HttpRequestHandler 처리
  - 2 = SimpleControllerHandlerAdapter
    - Controller 인터페이스 처리 (애노테이션X, 과거 사용)
- 현재 실무에서는 대부분 애노테이션 기반으로 사용
<br>

### 뷰 리졸버
- 스프링 부트는 뷰 리졸버를 통해 application.properties 설정 정보를 등록하여 사용
  - 1 = BeanNameViewResolver
    - 빈 이름으로 뷰 조회하여 반환
  - 2 = InternalResourceViewResolver
    - JSP를 처리할 수 있는 뷰 반환
 - _application.properties_
~~~ java
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
~~~
 - 동작 순서
   - 뷰 리졸버 호출
   - InternalResourceViewResolver
   - InternalResourceView.forward()
   - view.render()
<br>

### 스프링 MVC 시작하기
- @RequestMapping 
  - 요청 정보를 매핑, 실무에서 가장 많이 사용하는 방식
  - 클래스/메소드 단위 모두 매핑 가능
    - 클래스 단위(중복 경로) + 메소드 단위 조합 가능
    - (ex) "/springmvc/v1/" + "/save", "/list"
  - @GetMapping("경로"), @PostMapping("경로")
  - @RequestParam("name") == request.getParameter("name")
- @Controller 
  - 스프링이 자동으로 스프링 빈 등록 
  (컴포넌트 스캔의 대상이 됨)
- ModelAndView
  - 모델과 뷰 정보를 담아서 반환
  - addObject("name", value)

<br>

>
[출처] 스프링 MVC 1 - 김영한, 인프런
