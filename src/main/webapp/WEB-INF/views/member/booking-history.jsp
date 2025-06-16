<%-- 
    Document   : booking-history
    Created on : 9 Jun 2025, 6:51:30 pm
    Author     : Aiman
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Booking History</title>
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


        <div class="container-fluid px-5 my-4">
            <div class="row">
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/member"><i class="fa-solid fa-circle-chevron-left fa-xl me-2" style="color: var(--color-light-gold);"></i></a>
                    <h1 class="glow-gold d-inline-block">Booking List</h1>
                </div>
            </div>

            <c:if test="${param.message!=null}">
                <div class="row">
                    <div class="alert alert-success" role="alert">
                        <c:out value="${param.message}"/>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty bookings}">

                <div class="row">



                    <table class="table table-dark ">
                        <thead>
                            <tr>
                                <th class="text-center" scope="col">Booking ID</th>
                                <th class="text-center" scope="col">Movie</th>
                                <th class="text-center" scope="col">Date</th>
                                <th class="text-center" scope="col">Booking Status</th>
                                <th class="text-center" scope="col">Booking Seats</th>
                                <th class="text-center" scope="col">Payment Method</th>
                                <th class="text-center" scope="col">Payment Amount</th>
                                <th class="text-center" scope="col">Payment Status</th>
                                <th class="text-center" scope="col">Action</th>

                            </tr>
                        </thead>
                        <tbody class="table-hover">

                            <c:forEach items="${bookings}" var="booking">
                                <c:forEach items="${showtimes}" var="showtime">
                                    <c:if test="${showtime.id == booking.showtimeId}">
                                        <fmt:parseDate value="${ showtime.showDate}" type="both" var="parsedDate" pattern="yyyy-MM-dd"/>
                                        <fmt:parseDate value="${showtime.showTime}" type="time" var="parsedTime" pattern="HH:mm:ss"/>


                                        <tr>
                                            <th class="text-center" scope="row"><c:out value="${booking.id}"/></th>
                                            <td class="text-center"><c:out value="${showtime.movie.title}"/></td>
                                            <td class="text-center"><fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/> | <fmt:formatDate value="${parsedTime}" pattern="h:mm a"/></td>
                                            <td class="text-capitalize text-center"><c:out value="${booking.status}"/></td>
                                            <td class="text-center"> 
                                                |
                                                <c:forEach items="${booking.seats}" var="seat">
                                                    <c:out value="${seat.seatNumber}"/> |
                                                </c:forEach>
                                            </td>
                                            <td class="text-capitalize text-center"><c:out value="${booking.payment.paymentMethod}"/></td>
                                            <td class="text-center"><c:out value="${booking.payment.amount}"/></td>
                                            <td class="text-capitalize text-center">
                                                <c:out value="${booking.payment.status}"/></td>
                                            <td class="text-center">
                                                <c:if test="${booking.status == 'confirmed'}">
                                                    <c:if test="${booking.payment.status == 'paid'}">
                                                        <form action="${pageContext.request.contextPath}/editBooking" method="POST">
                                                            
                                                            <input type="hidden" name="bookingId" value="${booking.id}">
                                                            <input type="hidden" name="action" value="edit">
                                                            <input class="btn btn-primary mb-1" type="submit" value="Edit" ${(!showtime.upcoming || booking.payment.status != 'paid') ? 'disabled' : ''}>
                                                        </form>
                                                    </c:if>

                                                    <!-- Button trigger modal -->
                                                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#cancelModal">
                                                        Cancel
                                                    </button>

                                                    <!-- Modal -->
                                                    <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelModalLabel" aria-hidden="true">
                                                        <div class="modal-dialog  modal-dialog-centered">
                                                            <div class="modal-content bg-dark text-white">
                                                                <div class="modal-body">
                                                                    Do you really want to cancel this booking?
                                                                    <form class="mt-2" action="${pageContext.request.contextPath}/editBooking" method="POST">
                                                                        <input type="hidden" name="bookingId" value="${booking.id}">
                                                                        <input type="hidden" name="action" value="cancel">
                                                                        <button type="button" class="btn btn-warning" data-bs-dismiss="modal">Cancel</button>
                                                                        <input class="btn btn-success " type="submit" value="Yes" >
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>




                                                </c:if>
                                                <c:if test="${booking.status == 'cancelled' || booking.status == 'expired'}">
                                                    NA
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </c:forEach>


                        </tbody>
                    </table>
                </div>
            </c:if>
            <c:if test="${empty bookings}">
                <div class="text-center glow-white my-5">NO BOOKING EXISTS</div>
            </c:if>

        </div>

        <jsp:include page="../../includes/footer.jsp" flush="true" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
