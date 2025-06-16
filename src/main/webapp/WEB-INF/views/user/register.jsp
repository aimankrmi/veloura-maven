<%-- 
    Document   : signup
    Created on : May 26, 2025, 12:58:53 PM
    Author     : User
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Velora Cinema - Sign Up</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap & Fonts -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Vibur&display=swap"
            rel="stylesheet">
        <!-- Custom Styles -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">

        <style>

            .signup-box {
                max-width: 520px;
                margin: 70px auto;
                padding: 40px 30px;
                background-color: #0c0c0c;
                border: 1px solid #FFD700;
                border-radius: 12px;
            }

            .signup-box h2 {
                font-weight: bold;
                color: #FFD700;
                text-shadow: 0 0 10px #FFD700;
            }

            .form-control {
                background-color: #111;
                border: 1px solid #FFD700;
                color: #fff;
            }

            .form-control::placeholder {
                color: #aaa;
            }

            .btn-warning {
                font-weight: bold;
                box-shadow: 0 0 10px #FFD700;
            }

            .mobile-group {
                display: flex;
                gap: 10px;
            }

            .mobile-group input:first-child {
                width: 80px;
            }

            .form-label {
                font-weight: 600;
                color: #FFD700;
            }

            .text-muted a {
                color: #7f93ff;
            }
        </style>
    </head>
    <body>

        <jsp:include page="../../includes/header.jsp" flush="true"/>

        <div class="signup-box">
            <h2 class="text-center">Sign Up</h2>
            <c:if test="${param.error!=null}">
                <div class="alert alert-danger my-2" role="alert">
                    <c:out value="${param.error}"/>
                </div>
            </c:if>
            <c:if test="${param.message!=null}">
                <div class="alert alert-success my-2" role="alert">
                    <c:out value="${param.message}"/>
                </div>
            </c:if>
            <p class="text-center text-light">Already a member? <a href="${pageContext.request.contextPath}/login">Log in now</a></p>

            <form action="${pageContext.request.contextPath}/register" method="post"autocomplete="off">
                <div class="mb-3">
                    <label for="fullname" class="form-label">Full Name</label>
                    <input type="text" name="name" id="fullname" class="form-control bg-dark text-white" required placeholder="Enter full name">
                </div>

                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" name="username" id="username" class="form-control bg-dark text-white" required placeholder="Enter username">
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Mobile Number</label>
                    <div class="mobile-group">
                        <input type="text" value="+60" class="form-control bg-dark text-white" disabled>
                        <input type="text" name="phone" id="phone" class="form-control bg-dark text-white" required placeholder="123456789">
                    </div>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" name="email" id="email" class="form-control bg-dark text-white" required placeholder="Enter email">
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" name="password" id="password" class="form-control bg-dark text-white" required placeholder="Enter password">
                </div>

                <button type="submit" class="btn btn-warning w-100 mt-3">Create Account</button>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>

            </form>
        </div>

        <jsp:include page="../../includes/footer.jsp" flush="true"/>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
