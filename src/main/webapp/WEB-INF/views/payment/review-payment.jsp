<%-- 
    Document   : review-payment
    Created on : 8 Jun 2025, 3:03:07 am
    Author     : Aiman
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Booking Review</title>
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
        <style>
            .btn-check:disabled + .status-item {
                background-color: var(--color-bright-gray) !important;
                color: var(--color-black);
            }

            .selected {
                background-color: var(--color-light-gold) !important;
                color: var(--color-black);
            }

            .btn-check:checked + .status-item {
                background-color: var(--color-dark-gold) !important;
                color: var(--color-black);
            }
            .btn-check:hover + .status-item {
                background-color: var(--color-light-gold) !important;
                color: var(--color-black);
            }
        </style>
    </head>
    <body>
        <jsp:include page="../../includes/header.jsp" flush="true" />


        <div class="container-fluid px-5 my-4">
            <div class="row">
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/staff"><i class="fa-solid fa-circle-chevron-left fa-xl me-2" style="color: var(--color-light-gold);"></i></a>
                    <h1 class="glow-gold d-inline-block">Booking List</h1>
                </div>
            </div>
            <div class="row">

                <form class="col-auto my-3">

                    <input class="form-control mb-2" type="text" name="bookingID" value="${param.status != null ? param.bookingID : ''}" placeholder="Search by booking ID">
                    <select name="status" class="form-select d-inline-block" aria-label="Default select" style="width:200px;">
                        <option value="">--Filter by status--</option>
                        <option value="not_paid" ${param.status == 'not_paid' ? 'selected' : ''}>Not Paid</option>
                        <option value="paid" ${param.status == 'paid' ? 'selected' : ''}>Paid</option>
                        <option value="refunded" ${param.status == 'refunded' ? 'selected' : ''}>Refunded</option>
                    </select>
                    <input class="btn btn-primary" type="submit" value="Filter">
                </form>

                <table class="table table-dark ">
                    <thead>
                        <tr>
                            <th class="text-center" scope="col">Booking ID</th>
                            <th class="text-center" scope="col">Member ID</th>
                            <th class="text-center" scope="col">Movie</th>
                            <th class="text-center" scope="col">Movie Date</th>
                            <th class="text-center" scope="col">Booking Date</th>
                            <th class="text-center" scope="col">Booking Status</th>
                            <th class="text-center" scope="col">Payment Method</th>
                            <th class="text-center" scope="col">Payment Amount</th>
                            <th class="text-center" scope="col">Payment Status</th>
                        </tr>
                    </thead>
                    <tbody class="table-hover">

                        <c:forEach items="${bookings}" var="booking">

                            <c:if test="${(param.status == null || param.status == '' || booking.payment.status == param.status) && (param.bookingID == null || param.bookingID == '' || param.bookingID == booking.id)}">
                                <c:forEach items="${showtimes}" var="showtime">
                                    <c:if test="${booking.showtimeId == showtime.id}">


                                        <fmt:parseDate value="${showtime.showDate}" type="both" var="parsedDate" pattern="yyyy-MM-dd"/>
                                        <fmt:parseDate value="${showtime.showTime}" type="time" var="parsedTime" pattern="HH:mm:ss"/>
                                        <tr>
                                            <th class="text-center" scope="row"><c:out value="${booking.id}"/></th>
                                            <td class="text-center"><c:out value="${booking.memberId}"/></td>
                                            <td class="text-center text-capitalize"><c:out value="${showtime.movie.title}"/></td>
                                            <td class="text-center"><fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/> | <fmt:formatDate value="${parsedTime}" pattern="h:mm a"/></td>
                                            <td class="text-center text-uppercase"><c:out value="${booking.bookingDateFormatted}"/></td>
                                            <td class="text-center text-capitalize"><c:out value="${booking.status}"/></td>
                                            <td class="text-center text-capitalize"><c:out value="${booking.payment.paymentMethod}"/></td>
                                            <td class="text-center"><c:out value="${booking.payment.amount}"/></td>
                                            <td class="text-center">

                                                <!-- Button trigger modal -->
                                                <button type="button" class="btn btn-primary text-capitalize" data-bs-toggle="modal" data-bs-target="#payment-${booking.id}-Modal">
                                                    <c:out value="${booking.payment.status}"/>
                                                </button>

                                                <form action="${pageContext.request.contextPath}/updatePayment" method="POST">
                                                    <!-- Modal -->
                                                    <div class="modal fade" id="payment-${booking.id}-Modal" tabindex="-1" aria-labelledby="payment-${booking.id}-ModalLabel" aria-hidden="true">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content bg-dark text-white">
                                                                <div class="modal-header">
                                                                    <h1 class="modal-title fs-5" id="payment-${booking.id}-ModalLabel">Change Payment Status</h1>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body d-flex justify-content-center gap-3">
                                                                    <input type="hidden" name="bookingId" value="${booking.id}">
                                                                    <input type="radio" class="btn-check " name="paymentStatus" id="not_paid-${booking.id}" value="not_paid" autocomplete="off" ${booking.payment.status == 'not_paid' ? 'disabled' : ''}>
                                                                    <label class="btn btn-secondary status-item" for="not_paid-${booking.id}">Not Paid</label>
                                                                    <input type="radio" class="btn-check" name="paymentStatus" id="paid-${booking.id}" value="paid" autocomplete="off" ${booking.payment.status == 'paid' ? 'disabled' : ''}>
                                                                    <label class="btn btn-secondary status-item" for="paid-${booking.id}">Paid</label>
                                                                    <input type="radio" class="btn-check" name="paymentStatus" id="refunded-${booking.id}" value="refunded" autocomplete="off" ${booking.payment.status == 'refunded' ? 'disabled' : ''}>
                                                                    <label class="btn btn-secondary status-item" for="refunded-${booking.id}">Refunded</label>

                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cancel</button>
                                                                    <input type="submit" value="Update" class="btn btn-primary">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </form>

                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach> 
                            </c:if>
                        </c:forEach>


                    </tbody>
                </table>
            </div>
        </div>

        <jsp:include page="../../includes/footer.jsp" flush="true" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
