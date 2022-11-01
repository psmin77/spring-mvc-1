#### 로그 라이브러리
- 스프링 부트에서는 로깅 라이브러리(spring-boot-starter-logging)를 기본으로 포함
  - SLF4J (로그 인터페이스)
  - Logback
  
#### 로그 선언
- private Logger log = LoggerFactory.getLogger(getClass());
- private static final Logger log = LoggerFactory.getLogger(Xxx.class);
- @Slf4j : 롬복 사용 가능

#### 로그 레벨
  - Trace > Debug > Info > Warn > Error
  - 개발 서버는 Debug
  - 운영 서버는 Info 권장
  - 로그 레벨 설정
    - application.properties
    - 전체 로그 레벨(기본 info)
      - loggin.level.root=info
    - 패키지 또는 하위 레벨 설정
      - loggin.level.hello.springmvc=debug

#### 로그 호출
- log.info("내용")
- log.trace("trace log={}", 내용)
  - trace, debug, info, warn, error 가능
  - log.info("log="+내용) -> a+b 계산 로직이 먼저 실행되므로 사용하면 안됨

#### 테스트
- 로그가 출력되는 포맷 확인
- 시간, 로그 레벨, 프로세스ID, 쓰레드명, 클래스명, 로그 메시지 등
  
#### 로그 사용 장점
- 로그 레벨에 따라 서버에 맞게 조절 가능
- 콘솔뿐만 아니라 파일이나 네트워크, 로그 등 별도 위치에도 가능
- System.out보다 성능이 좋음 
-> 실무에서는 반드시 로그 사용
<br>

>
[출처] 스프링 MVC 1 - 김영한, 인프런
