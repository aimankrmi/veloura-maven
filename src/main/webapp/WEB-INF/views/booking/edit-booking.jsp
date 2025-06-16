<%-- Document : edit-booking Created on : 23 May 2025, 10:40:02 pm Author : Aiman --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Seats</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Vibur&display=swap"
            rel="stylesheet">
        <link rel="stylesheet"
              href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=info" />
        <link rel="stylesheet" href="assets/css/styles.css">
        <link rel="stylesheet" href="assets/css/header.css" />
        <link rel="stylesheet" href="assets/css/footer.css" />
        <link rel="stylesheet" href="assets/css/booking.css" />
        <script src="assets/js/booking.js" type="text/javascript" defer></script>
        <script src="assets/js/edit-booking.js" type="text/javascript" defer></script>
    </head>
    <body>
        <%--<jsp:useBean id="booking" class="com.velouracinema.model.Booking" scope="request"/>--%>
    <fmt:parseDate value="${showtime.showDate}" type="both" var="parsedDate" pattern="yyyy-MM-dd"/>
    <fmt:parseDate value="${showtime.showTime}" type="time" var="parsedTime" pattern="HH:mm:ss"/>

    <jsp:include page="../../includes/header.jsp" />
    <div class="fluid-container">
        <div class="row justify-content-center py-3">
            <a href="${pageContext.request.contextPath}/viewBookingHistory" class="ms-3"><i class="fa-solid fa-circle-chevron-left fa-xl me-2" style="color: var(--color-light-gold);"></i></a>

            <h2 class=" text-center mx-auto booking-title"><span class="glow-gold display-4">BOOKING
                    DETAILS</span></h2>
        </div>
        <div class="row justify-content-center gap-4 border-bottom mx-5 detail-wrapper">
            <div class="col-5 col-lg-3 pe-5 ">
                <table class="table table-borderless details-table">

                    <tbody class="container-fluid">
                        <tr class="row">
                            <th class="col-12 col-sm-6 text-center text-sm-start" scope="row">Order ID</th>
                            <td class="col-12 col-sm-6 text-center text-sm-start"><c:out value="${booking.id}"/></td>

                        </tr>
                        <tr class="row">
                            <th class="col-12 col-sm-6 text-center text-sm-start" scope="row">Payment ID</th>
                            <td class="col-12 col-sm-6 text-center text-sm-start"><c:out value="${booking.payment.id}"/></td>
                        </tr>
                        <tr class="row">
                            <th class="col-12 col-sm-6 text-center text-sm-start" scope="row">Order Description
                            </th>
                            <td class="col-12 col-sm-6 text-center text-sm-start"><c:out value="${showtime.movie.title}"/><br>
                    <fmt:formatDate value="${parsedDate}" pattern="dd MMMM yyyy"/> <fmt:formatDate value="${parsedTime}" pattern="h:mm a"/>
                    </td>
                    </tr>
                    <tr class="row">
                        <th class="col-12 col-sm-6 text-center text-sm-start" scope="row">Seat
                        </th>
                        <td class="col-12 col-sm-6 text-center text-sm-start">
                            |
                            <c:forEach items="${booking.seats}" var="seat">
                                ${seat.seatNumber} | 
                            </c:forEach>
                        </td>
                    </tr>
                    </tbody>

                </table>
            </div>
            <div class="col-auto">
                <div
                    class="info-box border rounded d-flex flex-column justify-content-center align-items-center p-2">
                    <span class="material-symbols-outlined">
                        info
                    </span>
                    <p>
                        changing seats are only available 3 hours prior showing time.
                    </p>
                </div>
            </div>
        </div>
        <hr class="line" >
        <div class="row">
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/processEditBooking" method="POST"> 
        <input type="hidden" name="showtime-id" value="${showtime.id}">
        <c:forEach items="${booking.seats}" var="seat">
            <input type="hidden" name="booked-seat" value="${seat.seatId}">
        </c:forEach>
        <input type="hidden" name="payment-status" value="${booking.payment.status}">
        <input type="hidden" name="booking-id" value="${booking.id}">
        <!-- SEAT SELECTION -->
        <section class="seat-selection-section w-100 mt-4 px-5 ">
            <div class="seat-selection-title">
                <h1 class="glow-gold mt-3 fs-1 text-center">Select Your Seats</h1>
            </div>
            <div class="screen mx-auto my-4 pt-4 text-center">Screen</div>
            <div class="seat-selection-wrapper pb-2 fluid-container mx-auto overflow-auto" data-seat-booked="${booking.seats.size()}">   
                <c:forEach items="${seatRowByShowtime}" var="row">
                    <c:set var="seatRow" value="${row.key}"/>
                    <div class="row seat-row mx-4 flex-nowrap" data-seat="${seatRow}">
                        <c:forEach items="${row.value}" var="seat" varStatus="status">
                            <c:set var="bookedSeat" value="${false}"/>
                            <c:set var="seatNumber" value="${seat.seatNumber}" />
                            <c:forEach items="${booking.seats}" var="seatBooked">
                                <c:if test="${seatBooked.seatNumber==seat.seatNumber}">
                                    <c:set var="bookedSeat" value="${true}"/>
                                </c:if>
                            </c:forEach>
                            <div class="col-1">
                                <input type="checkbox" class="btn-check"
                                       name="seat" value="${seatNumber}" id="${seatNumber}"
                                       onchange="addSeat(this.id)" data-price="${showtime.movie.price}"
                                       <c:if test="${!seat.isAvailable && !bookedSeat}">
                                           disabled 
                                       </c:if>
                                       />
                                <label class="btn seat-icon 
                                       <c:choose>
                                           <c:when test="${seat.isAvailable || bookedSeat}">
                                               available
                                           </c:when>
                                           <c:otherwise>
                                               reserved
                                           </c:otherwise>
                                       </c:choose>"
                                       for="${seatNumber}">${seatNumber}</label> 

                            </div>
                            <c:if test="${status.index==1 || status.index==6}">
                                <!--aisle-->
                                <div class="col-1">
                                </div>
                            </c:if>


                        </c:forEach>
                    </div>
                </c:forEach> 

            </div>






            <!-- Modal -->
            <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content bg-dark">
                        <div class="modal-header">
                            <h1 class="modal-title fs-2 fw-bold text-center display-3 text-light" id="confirmModalLabel">Selected Seat</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <table class="table table-dark table-hover">
                                <tbody>
                                <span id="edit-seat-selected-list" class="text-light"></span>
                                </tbody>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <!--<button type="button" class="btn btn-primary">Confirm</button>-->
                            <input class="btn btn-primary" id="confirmButton" type="submit" value="Edit">
                        </div>
                    </div>
                </div>
            </div>


            <!--Selected Seat-->
            <section class="text-center my-4 selected-seat-text">
                <p class="fs-6">You selected: <span id="seat-selected-list-text" class="seat-selected-list"></span></p>
            </section>
            <section class="w-100 d-flex justify-content-center">
                <!-- Button trigger modal -->
                <button type="button" class="btn btn-primary" id="submitButton" data-bs-toggle="modal" data-bs-target="#confirmModal">
                    Edit Seat
                </button>
            </section>
        </section>
    </form>


    <jsp:include page="../../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>