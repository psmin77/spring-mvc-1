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

>
[출처] 스프링 MVC 1 - 김영한, 인프런
