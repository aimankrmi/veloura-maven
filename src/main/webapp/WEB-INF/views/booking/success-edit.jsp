<%-- 
    Document   : success-edit
    Created on : 26 May 2025, 7:54:32 pm
    Author     : Aiman
--%>

<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Veloura Cinema</title>
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
        <link rel="stylesheet" href="assets/css/booking.css" />
    </head>
    <body>
        <c:set var="paymentMethod" value="${param.paymentMethod}"/>
        <c:set var="bookingId" value="${param.bookingId}"/>
        <jsp:include page="../../includes/header.jsp" />
        <div class="container-fluid justify-content-center align-items-center py-4">
            <p class="display-3 glow-white" style="font-size:24px;">Edit Booking Completed</p>
            <p class="text-center">You will be redirected in 5 seconds... If you are not redirected, <a href="index.jsp" class="link-offset-2 link-offset-3-hover link-underline link-underline-opacity-0 link-underline-opacity-75-hover">click here</a></p>
        </div>
        <script>
            setTimeout(function () {
                window.location.href = 'index.jsp';
            }, 5000); // 5000 milliseconds = 5 seconds
        </script>

        <jsp:include page="../../includes/footer.jsp" />
    </body>
</html>
