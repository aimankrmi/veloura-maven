<%-- 
    Document   : manage-member.jsp
    Created on : 9 Jun 2025, 6:29:44 pm
    Author     : Aiman
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Membership</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Vibur&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="assets/css/styles.css">
        <link rel="stylesheet" href="assets/css/header.css" />
        <link rel="stylesheet" href="assets/css/footer.css" />
    </head>
    <body>
        <jsp:include page="../../includes/header.jsp" flush="true" />

        <div class="container-fluid px-5 my-3 ">
            <c:if test="${error!=null}">
                <div class="alert alert-danger" role="alert">
                    Error occurred: <c:out value="${error}"/>
                </div>
            </c:if>
            <c:if test="${message!=null}">
                <div class="alert alert-success" role="alert">
                    <c:out value="${message}"/>
                </div>
            </c:if>

            <div class="row">
                <div class="col-12">
                    <a href="${pageContext.request.contextPath}/admin"><i class="fa-solid fa-circle-chevron-left fa-xl me-2" style="color: var(--color-light-gold);"></i></a>
                    <h1 class="glow-gold d-inline-block">View Member</h1>
                </div>
                <c:if test="${not empty members}">
                    <div class="row">
                        <div class="w-100 mt-3">
                            <div class="col-auto">
                                <form>
                                    <input class="form-control d-inline-block" type="text" name="member_name" placeholder="--Filter By Name--" value="${param.member_name != null ? param.member_name : ''}" style="width:220px">
                                    <input class="btn btn-primary" type="submit" value="Filter">
                                </form>
                            </div>
                        </div>
                    </div>                
                </c:if>
            </div>



            <c:if test="${not empty members}">

                <div class="row my-3 overflow-auto scrollbar-gold">
                    <table class="table table-dark text-white rounded text-center">
                        <thead>
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Name</th>
                                <th scope="col">Username</th>
                                <th scope="col">Email</th>
                                <th scope="col">Phone No</th>
                                <th scope="col">Action</th>
                            </tr>
                        </thead>
                        <tbody class="table-hover table-striped-columns">
                            <c:forEach items="${members}" var="member">
                                <c:if test="${param.member_name == null || param.member_name == '' || fn:contains(fn:toLowerCase(member.name), fn:toLowerCase(param.member_name)) }">
                                    <tr>
                                        <th scope="row">${member.id}</th>
                                        <td>${member.name}</td>
                                        <td>${member.username}</td>
                                        <td>${member.email}</td>
                                        <td>${member.phoneNo}</td>
                                        <td>
                                            <a class="btn btn-danger m-1" href="${pageContext.request.contextPath}/deleteMember?id=${member.id}">Delete</a>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                    </table>
                </div>
            </c:if>
                <c:if test="${empty members}">
                    <div class="text-center glow-white my-5">NO MEMBER EXISTS</div>
                </c:if>
        </div>
        <jsp:include page="../../includes/footer.jsp" flush="true" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
