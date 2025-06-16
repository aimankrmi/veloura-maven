<%-- 
    Document   : login
    Created on : May 26, 2025, 1:25:42 PM
    Author     : User
--%>

<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Velora Cinema - Login</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap & Fonts -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link
            href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Vibur&display=swap"
            rel="stylesheet">
        <!-- Custom Styles -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css"/>

        <style>

            .login-box {
                max-width: 450px;
                margin: 80px auto;
                padding: 30px;
                border: 1px solid var(--color-light-gold);
                border-radius: 10px;


            }

            .login-box h2 {
                color: var(--color-light-gold);
                text-shadow: 0 0 10px #FFD700;
            }

            .form-control {
                background-color: #111;
                border: 1px solid #FFD700;
                color: #fff;
            }

            .form-control::placeholder {
                color: #ccc;
            }

            .btn-warning {
                font-weight: bold;
                box-shadow: 0 0 10px #FFD700;
            }

            .forgot,
            .signup-link a {
                color: var(--color-dark-gold);
                font-size: 0.9em;
                text-decoration: underline;
            }

        </style>
    </head>
    <body>
        
        <!-- Include Header -->
        <jsp:include page="../../includes/header.jsp" flush="true"/>
        <!-- Page Title -->
        <h1 class="glow-gold mt-3 display-4" style="text-align: left; padding-left: 2.5rem;">Sign In</h1>

        <!-- Login Form -->
        <div class="login-box text-center">
            <h2>LOGIN</h2>
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
            <p class=" text-light">Login with your credentials to continue booking. If you are not registered, sign up first.</p>
            
            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="movieId" value="${movieId}">
                <input type="hidden" name="date-show" value="${date}">
                <input type="hidden" name="time-show" value="${time}">
                <label for="username">Username</label>
                <input type="text" name="username" class="form-control" id="username" required placeholder="Enter username">

                <div class="form-group text-left mt-3">
                    <label for="password">Password</label>
                    <input type="password" name="password" class="form-control" id="password" required placeholder="Enter password">
                </div>
                <div class="mb-2 mt-2 text-end">
                    <a href="forgotPassword.jsp" class="forgot">Forgot Password?</a>
                </div>
                <button type="submit" class="btn btn-warning w-100 mt-2">Login</button>
            </form>
            <div class="signup-link mt-3">
                Not registered? <a href="${pageContext.request.contextPath}/register">Create an account</a>
            </div>
        </div>

        <!-- Include Footer -->
        <jsp:include page="../../includes/footer.jsp" flush="true"/>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
