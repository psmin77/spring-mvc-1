### 프론트 컨트롤러(Front Controller)![](https://velog.velcdn.com/images/psmin77/post/839bdc7f-b97f-4063-9120-ffc8f6d135e7/image.png)
- 서블릿 하나로 클라이언트의 모든 요청을 받음
- 요청에 맞는 컨트롤러를 찾아서 호출
- 공통 처리 가능
- 다른 컨트롤러는 서블릿을 사용하지 않아도 됨

cf. 스프링 웹 MVC의 DispatcherServlet이 프론트 컨트롤러 패턴으로 구현됨

#### 프론트 컨트롤러 도입(v1)
- urlPatterns = "/front-controller/v1/*"
  - /front-controller/v1/ 으로 시작하는 모든 요청을 받음
- _FrontController.controllerMap_
  
~~~ java
public FrontControllerServletV1() {
    // key: 매핑 URL, value: 호출될 컨트롤러
    controllerMap.put("/front-controller/v1/members/new-form", new MemberFormControllerV1());
    controllerMap.put("/front-controller/v1/members/save", new MemberSaveControllerV1());
    controllerMap.put("/front-controller/v1/members", new MemberListControllerV1());
}
~~~
- _FrontControllerV1.service()_
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
- 컨트롤러에서 뷰로 이동하는 중복 코드를 별도 처리하는 객체 생성
- 프론트 컨트롤러에서 컨트롤러 호출 -> 컨트롤러는 뷰 객체 반환 -> view.render() 실행
- _View.render()_
~~~java
public void render(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // 전달받은 URI 경로로 Dispatcher 서블릿을 호출하는 메소드 
    RequestDispatcher dispatcher = request.getRequestDispatcher(viewPath);
    dispatcher.forward(request, response);
}
~~~
<br>

#### Model 추가(v3)
- 서블릿 종속성 제거
  - 컨트롤러가 서블릿 기술을 전혀 사용하지 않도록 함
- 뷰 이름 중복 제거
  - 중복되는 이름을 로직으로 단순화
  - (ex) /WEB-INF/views/new-form.jsp -> new-form
  
![](https://velog.velcdn.com/images/psmin77/post/69fd1b9f-6957-4f46-b07c-e6282f44bf42/image.png)
- v3 구조
  - 컨트롤러 경로 조회 : v1,2와 동일
  - controller.process() : 해당 컨트롤러 실행
  - return ModelView : 로직 실행 후 모델 객체 반환
  - viewResolver : 논리 뷰 -> 물리 뷰 (단순화)
  - view.render()
- ModelView 객체: 뷰 이름, model 객체(map)
- _Controller.process()_
~~~ java
// 각 컨트롤러에서 ModelView 객체 생성
// 논리 뷰 이름과 객체 정보 등을 모델에 담아서 전달
ModelView mv = new ModelView("save-result");
mv.getModel().put("member", member); 
~~~
- _FrontControllerV3_
~~~ java
@Override
protected void service(HttpServletRequest request, HttpServletResponse
response) throws ServletException, IOException {
     (컨트롤러 조회- v1,v2 동일)
   
    // HttpServletRequest의 파라미터 정보를 map으로 변환
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
- _View.render()_
~~~ java
public void render(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    
    // 모델의 데이터를 꺼내서 setAttribute로 담아두기
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

#### 단순/실용 컨트롤러(v4)
- 기본 구조는 v3 동일, 컨트롤러에서 ViewName만 반환
(ModelView 사용하지 않음)
- _Controller.process()_
~~~ java
@Override
public String process(Map<String, String> paramMap, Map<String, Object> model) {
    (컨트롤러 로직)
    ...
    // 전달받은 모델 객체(map)에 데이터를 담고, 논리 뷰 이름만 리턴
    model.put("member", member);
    return "save-result";
}
~~~
- _FrontControllerV4_
~~~ java
(v3와 동일)
...
// 프론트 컨트롤러에서 모델 객체(map) 생성하여 각 컨트롤러에 전달
Map<String, Object> model = new HashMap<>();
String viewName = controller.process(paramMap, model);

MyView view = viewResolver(viewName);
view.render(model, request, response);
~~~
<br>

#### 유연한 컨트롤러(v5)
- 어댑터 패턴(Adapter)
  - 다양한 방식의 컨트롤러를 처리할 수 있음
  - 어댑터를 통해 프레임워크를 유연하고 확장성 있게 설계
  
![](https://velog.velcdn.com/images/psmin77/post/a3d22d55-4f1e-428a-879f-3e98d56d7901/image.png)
- 핸들러 어댑터: 다양한 종류의 컨트롤러를 호환할 수 있도록 하는 어댑터 역할
- 핸들러: 컨트롤러의 이름을 더 넓은 범위로 변경
- _ControllerHandlerAdapter(v3/v4)_
~~~ java
public class ControllerHandlerAdapter {

    // 해당 핸들러(=컨트롤러)를 사용할 수 있는지 판단하는 메서드
    @Override
    public boolean supports(Object handler) {
        return (handler instanceof ControllerV*);
    }
      
    @Override
    ModelView handle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException, IOException {
        // 핸들러를 컨트롤러로 캐스팅
        ControllerV* controller = (ControllerV*)handler;
        Map<String, String> paramMap = createParamMap(request);
        
        // 어댑터를 통해 컨트롤러 호출 후 ModelView 리턴
        // v3
        ModelView mv = controller.process(paramMap);
        
        // v4
        // 뷰 이름을 반환하는 v4에서는 어댑터가 직접 ModelView 객체 생성하여 타입에 맞게 리턴해줌
        HashMap<String, Object> model = new HashMap<>();
        String viewName = controller.process(paramMap, model);
        
        ModelView mv = new ModelView(viewName);
        mv.setModel(model);
        
        return mv; 
    }
} 
~~~
- _FrontControllerV5_
~~~ java
// 어댑터로 호환할 수 있는 모든 컨트롤러 매핑 경로와 어댑터를 생성자로 초기화(등록)
private final Map<String, Object> handlerMappingMap = new HashMap<>();
private final List<MyHandlerAdapter> handlerAdapters = new ArrayList<>();

public FrontControllerServletV5() {
    initHandlerMappingMap();
    initHandlerAdapters();
}

private void initHandlerMappingMap() {
    handlerMappingMap.put("/front-controller/v5/v*/members/new-form", new
MemberFormControllerV3());
    ...
}

private void initHandlerAdapters() {
    handlerAdapters.add(new ControllerV*HandlerAdapter());
    ...
}
~~~

~~~ java
@Override
protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    // 핸들러(컨트롤러) 조회, 없으면 404
    Object handler = getHandler(request);
    if (handler == null) { 
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        return; 
    }
    
    // 어댑터 조회
    MyHandlerAdapter adapter = getHandlerAdapter(handler);
    
    // 어댑터 호출
    ModelView mv = adapter.handle(request, response, handler);
    
    // 뷰 실행
    MyView view = viewResolver(mv.getViewName());
    view.render(mv.getModel(), request, response);
}

private Object getHandler(HttpServletRequest request) {
    String requestURI = request.getRequestURI();
    return handlerMappingMap.get(requestURI);
}

private MyHandlerAdapter getHandlerAdapter(Object handler) {
    for (MyHandlerAdapter adapter : handlerAdapters) {
        if (adapter.supports(handler)) {
            return adapter;
        }
    }
    throw new IllegalArgumentException("handler adapter를 찾을 수 없습니다. handler=" + handler);
}

~~~


<br>

>
[출처] 스프링 MVC 1 - 김영한, 인프런
