### 프론트 컨트롤러(Front Controller)![](https://velog.velcdn.com/images/psmin77/post/839bdc7f-b97f-4063-9120-ffc8f6d135e7/image.png)
- 서블릿 하나로 클라이언트의 모든 요청을 받음
- 요청에 맞는 컨트롤러를 찾아서 호출
- 공통 처리 가능
- 다른 컨트롤러는 서블릿을 사용하지 않아도 됨

cf. 스프링 웹 MVC의 DispatcherServlet이 프론트 컨트롤러 패턴으로 구현됨

#### 프론트 컨트롤러 도입(v1)
- urlPatterns = "/front-controller/v1/*"
  - /front-controller/v1/ 으로 시작하는 모든 요청을 받음
- controllerMap
  
~~~ java
public FrontControllerServletV1() {
    // key: 매핑 URL, value: 호출될 컨트롤러
    controllerMap.put("/front-controller/v1/members/new-form", new MemberFormControllerV1());
    controllerMap.put("/front-controller/v1/members/save", new MemberSaveControllerV1());
    controllerMap.put("/front-controller/v1/members", new MemberListControllerV1());
}
~~~
- service()
~~~ java
@Override
protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    // ControllerMap에서 requestURI 찾은 뒤 컨트롤러 실행
    String requestURI = request.getRequestURI();
    ControllerV1 controller = controllerMap.get(requestURI);
    
    // 없는 경로면 404
    if (controller == null) {
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        return;
    }
    
    controller.process(request, response);
}
~~~
<br>

#### View 분리(v2)
- 컨트롤러에서 뷰로 이동하는 중복 코드를 별도 처리하는 객체
- 프론트 컨트롤러에서 컨트롤러 호출 -> 컨트롤러는 뷰 객체 반환 -> view.render() 실행
~~~java
public void render(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // 전달받은 URI 경로로 Dispatcher 서블릿을 호출하는 메소드 
    RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
    dispatcher.forward(request, response);
}
~~~
<br>

#### Model 추가(v3)![](https://velog.velcdn.com/images/psmin77/post/69fd1b9f-6957-4f46-b07c-e6282f44bf42/image.png)
- 서블릿 종속성 제거
  - 컨트롤러가 서블릿 기술을 전혀 사용하지 않도록 함
- 뷰 이름 중복 제거
  - 중복되는 이름을 로직으로 단순화
  - (ex) /WEB-INF/views/new-form.jsp -> new-form
- ModelView 객체: 뷰 이름, model 객체(map)
~~~ java
(회원가입 컨트롤러)
...
// 완료 후 이동할 경로 (논리 뷰 이름 전달)
ModelView mv = new ModelView("save-result");

// 회원가입 완료된 member 객체 전달
mv.getModel().put("member", member); 
~~~
- 각각의 컨트롤러에서 ModelView 객체를 생성하며 논리 뷰 이름(new-form, save-result 등)을 전달
- 뷰에서 필요한 객체 정보를 모델에 담아서 전달
- 프론트 컨트롤러(Front Controller V3)
~~~ java
@Override
protected void service(HttpServletRequest request, HttpServletResponse
response) throws ServletException, IOException {
     
    (컨트롤러 조회- v1,v2 동일)
   
    // HttpServletRequest의 모든 파라미터 정보를 꺼내서 map으로 변환하고 
    // 해당 컨트롤러 호출
    Map<String, String> paramMap = createParamMap(request);
    ModelView mv = controller.process(paramMap);
    
    // 논리 뷰 이름 가져오기
    String viewName = mv.getViewName();
        
    // 물리 뷰로 반환하기(중복 경로 단순화)
    MyView view = viewResolver(viewName);
        
    // 뷰 객체를 통해 HTML화면 렌더링
    view.render(mv.getModel(), request, response);
}

private Map<String, String> createParamMap(HttpServletRequest request) {
    Map<String, String> paramMap = new HashMap<>();
    request.getParameterNames().asIterator()
           .forEachRemaining(paramName -> paramMap.put(paramName, request.getParameter(paramName)));
    return paramMap;
}

private MyView viewResolver(String viewName) {
          return new MyView("/WEB-INF/views/" + viewName + ".jsp");
}
~~~
- 뷰 객체(MyView)
~~~ java
public void render(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    
    // 모델의 데이터를 꺼내서 서블릿 setAttribute로 담아두기
    modelToRequestAttribute(model, request);
    
    // 해당 경로로 이동
    RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
    dispatcher.forward(request, response);
}

private void modelToRequestAttribute(Map<String, Object> model, HttpServletRequest request) {
    model.forEach((key, value) -> request.setAttribute(key, value));
}
~~~


<br>

>
[출처] 스프링 MVC 1 - 김영한, 인프런
