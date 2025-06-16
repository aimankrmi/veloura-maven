<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:useBean id="user" class="com.velouracinema.model.User" scope="session"/>


<header class="d-flex p-0 sticky-top">
    <nav class="navbar navbar-expand-lg bg-body-tertiary w-100 h-100 justify-content-center">
        <div class="container-fluid">
            <a class="navbar-brand logo" href="${pageContext.request.contextPath}"><b>Ve<span>l</span>oura&nbsp;Ci<span>n</span>ema</b></a>
            <button class="navbar-toggler custom-toggler" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbarNav" aria-controls="navbarNav"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon custom-toggler-icon"></span>

            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto ms-auto mb-2 mb-lg-0">
                    <li class="nav-item ">
                        <a class="nav-link me-2 ms-2" href="${pageContext.request.contextPath}">Movies</a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link me-2 ms-2" href="${pageContext.request.contextPath}/support">Support</a>
                    </li>
                    <c:if test="${user.id != 0}">
                    <li class="nav-item">
                        <a class="nav-link ms-2 me-2" href="${pageContext.request.contextPath}/${fn:toLowerCase(user.role)}">Account</a>
                    </li>
                        
                    </c:if>
                </ul>

                        <a class="btn btn-sign-in ps-3" href="${pageContext.request.contextPath}/${user.id!=0?"logout":"login"}"><i class="fa-regular fa-circle-user user-icon fa-lg" style="color: #ffffff;"></i>${user.id!=0?"Log Out":"Sign In"}</a>


            </div>
        </div>
</header>
