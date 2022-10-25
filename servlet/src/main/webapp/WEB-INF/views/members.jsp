<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <a href="/index.html">메인</a>
    <table border="1">
        <thead>
            <th>ID</th>
            <th>Username</th>
            <th>Age</th>
        </thead>
        <tbody>
            <c:forEach var="item" items="${members}">
            <tr>
                <td>${item.id}</td>
                <td>${item.username}</td>
                <td>${item.age}</td>
            </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>