<%-- Document : selectSeats Created on : 16 May 2025, 6:54:46 pm Author : Aiman --%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Booking</title>
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
        <link rel="stylesheet" href="assets/css/booking.css"/>
        <script src="assets/js/booking.js" type="text/javascript" defer></script>
    </head>
    <body>
        <%--<jsp:useBean id="movie" class="com.velouracinema.model.Movie" scope="request"/>--%>
        <%--<jsp:useBean id="movieShowtime" class="com.velouracinema.model.Showtime" scope="request"/>--%>
        <%--<jsp:setProperty name="movieShowtime" property="movie" value="${movie}"/>--%>
        <%--<jsp:setProperty name="movieShowtime" property="showDate" value="${param.date}"/>--%>
        <%--<jsp:setProperty name="movieShowtime" property="showTime" value="${param.time}"/>--%>

        <jsp:include page="../../includes/header.jsp"  flush="true"/>

        
        <!--Form to book-->
        <form action="${pageContext.request.contextPath}/${user.id==0 ? "login?message=Please login first":"payment" }" id="bookingForm" method="POST">
            <input type="hidden" name="bookingToken" value="${bookingToken}" />
            <input type="hidden" name="bookingTokenTime" value="${bookingTokenTime}" />
            <div class="fluid-container pt-3">
                <div class="row w-100 m-0">
                    <!--MOVIE PICTURE-->
                    <section class="w-100 mt-3 mx-auto px-0 movie-picture-section d-flex align-items-center justify-content-center">
                        <a href="booking?id=${previousMovieId}&next=false" class="btn bg-transparent border-none btn-left"><i class="fa-solid fa-chevron-left fa-lg" style="color: #d9a93f;"></i></a>
                        <div class=" movie-picture-wrapper  overflow-hidden " style="height: 750px;">
                            <img src="${pageContext.request.contextPath}/assets/images/${movie.imagePath!=null? movie.imagePath:'default'}" class="img-fluid movie-img" alt="Movie Image">
                        </div>
                        <a href="booking?id=${nextMovieId}&next=true" class="btn bg-transparent btn-right"><i class="fa-solid fa-chevron-right fa-lg" style="color: #d9a93f;"></i></a>
                    </section>

                    <!-- MOVIE DESCRIPTION -->
                    <section class="movie-desc-wrapper mt-3 d-flex flex-sm-column flex-column justify-content-center align-items-center">
                        <div class="movie-title">
                            <h1 class="glow-gold fs-1 text-start text-capitalize" >${movie.title}</h1>
                            <input type="hidden" name="showtime-movie-id" value="${showtime.movie.movieId}">
                        </div>
                        <div class="movie-desc d-flex flex-sm-row flex-column py-1">
                            <div class="movie-genre  glow-white fs-5 text-center">${movie.genre}</div>
                            <div class="movie-duration  glow-white fs-5 text-center">${movie.hours}h ${movie.minutes}min</div>
                            <div class="movie-lang text-capitalize glow-white fs-5 text-center">${movie.language}</div>
                        </div>
                        <hr style="border-color:white;" class="w-75 hr">
                        <div class="movie-description w-75 py-2 text-center">${movie.description}</div>
                        <hr style="border-color:white;" class="w-50 hr">
                    </section>

                    <!--Movie time/date and seat legend-->
                    <section class="row justify-content-center mx-auto">

                        <!--Form to book-->
                        <div class="col-12 col-sm-12 col-lg-7 d-flex flex-column justify-content-evenly align-items-center">

                            
                            <!-- MOVIE DATE -->
                            <section class="showtimes-wrapper d-flex flex-column justify-content-center align-items-center mx-auto">
                                <div class="showtimes-title">
                                    <h1 class="glow-gold mt-3 fs-1 " >Available Date </h1>
                                </div>
                                <div class="showtimes-list mt-1 gap-2 d-flex flex-sm-row flex-column">
                                    <c:if test="${movie.status eq 'Coming Soon'}">
                                        <p>COMING SOON</p>
                                    </c:if>
                                    <c:if test="${movie.status eq 'Ongoing'}">
                                        <c:forEach items="${movie.availableDates}" var="availableDate" varStatus="status">
                                            <fmt:parseDate value="${availableDate}" type="both" var="parsedDate" pattern="yyyy-MM-dd"/>
                                            <input onchange="checkDate()" type="radio" class="btn-check date-input" name="date" id="showtime_date_${status.index + 1}" value="${availableDate}" data-date="${availableDate}" autocomplete="off">
                                            <label class="btn btn-secondary showtimes-item date-label" for="showtime_date_${status.index + 1}"><fmt:formatDate value="${parsedDate}" pattern="dd MMMM yyyy (EEEE)"/></label>
                                        </c:forEach>
                                    </c:if>

                                </div>
                            </section>
                            <c:if test="${param.date!=null}">
                                <c:if test="${empty showTimesByDate}">
                                    <div class="text-center glow-white mt-4">NO BOOKING AVAILABLE ON THIS DATE</div>
                                </c:if>
                                <c:if test="${not empty showTimesByDate}">

                                    <!-- MOVIE SHOWTIMES -->
                                    <section class="showtimes-wrapper d-flex flex-column justify-content-center align-items-center my-3">
                                        <div class="showtimes-title">
                                            <h1 class="glow-gold mt-3 fs-1 " >Available Showtimes</h1>
                                        </div>
                                        <div class="showtimes-list mt-1 gap-2 d-flex flex-sm-row flex-column">
                                            <c:forEach items="${showTimesByDate}" var="time" varStatus="status">

                                                <fmt:parseDate value="${time}" type="time" var="parsedTime" pattern="HH:mm:ss"/>
                                                <input onclick="checkTime()" type="radio" class="btn-check time-input" name="time" id="showtime_time_${status.index+1}" value="${time}" autocomplete="off" data-time="${time}" >
                                                <label class="btn btn-secondary showtimes-item time-label" for="showtime_time_${status.index+1}" ><fmt:formatDate value="${parsedTime}" pattern="h:mm a"/></label>

                                            </c:forEach>
                                        </div>
                                    </section>
                                </c:if>

                            </c:if>
                        </div>
                        <c:if test="${param.date!=null && param.time!=null}">
                            
                            <jsp:include page="../../includes/seat-legend.jsp" flush="true" />
                            <input type="hidden" id="time" name="time-show" value="${param.time}">
                            <input type="hidden" id="date" name="date-show" value="${param.date}">

                        </c:if>


                    </section>
                    <c:if test="${param.date!=null && param.time!=null && !showtime.upcoming}">
                        <p class="text-center glow-white fs-4 mt-4">NOT AVAILABLE</p>
                    </c:if>
                    <c:if test="${param.date!=null && param.time!=null && showtime.upcoming}">
                        <input type="hidden" name="showtime-id" value="${showtime.id}">
                        <!-- SEAT SELECTION -->
                        <section class="seat-selection-section w-100 mt-4 px-5 ">
                            <div class="seat-selection-title">
                                <h1 class="glow-gold mt-3 fs-1 text-center">Select Your Seats</h1>
                            </div>
                            <div class="screen mx-auto my-4 pt-4 text-center">Screen</div>
                            <!--<div class="seat-selection-wrapper pb-2 row mx-auto overflow-auto row seat-row mx-4 flex-nowrap">-->
                            <!--<div class="seat-selection-wrapper pb-2 fluid-container mx-auto overflow-auto">-->
                            <div class="seat-selection-wrapper scrollbar-gold pb-2 fluid-container mx-auto overflow-auto">   
                                <c:forEach items="${seatRowByShowtime}" var="row">
                                    <c:set var="seatRow" value="${row.key}"/>
                                    <div class="row seat-row mx-4 flex-nowrap" data-seat="${seatRow}">
                                        <c:if test="${user.id==0}">
                                            <input type="hidden" name="movieId" value="${movie.movieId}">
                                        </c:if>

                                        <c:forEach items="${row.value}" var="seat" varStatus="status">
                                            <c:set var="seatNumber" value="${seat.seatNumber}" />

                                            <div class="col-1">
                                                <input type="checkbox" class="btn-check" onchange='${user.id==0 ? 'document.getElementById("bookingForm").submit(); '
                                                                                                     :"addSeat(this.id)"}'

                                                       name="seat" value="${seatNumber}" id="${seatNumber}"
                                                       data-price="${showtime.movie.price}"
                                                       ${seat.isAvailable ? "" : "disabled"} />
                                                <label class="btn seat-icon ${seat.isAvailable ? 'available' : 'reserved'}"
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
                                                <span id="seat-selected-list" class="text-light"></span>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Edit</button>
                                            <!--<button type="button" class="btn btn-primary">Confirm</button>-->
                                            <input class="btn btn-primary" id="confirmButton" type="submit" value="Checkout">
                                        </div>
                                    </div>
                                </div>
                            </div>





                            <!--Selected Seat-->
                            <section class="text-center my-4 selected-seat-text">
                                <p class="fs-6">You selected: <span id="seat-selected-list-text" class="seat-selected-list"></span></p>
                            </section>

                        </section>

                        <section class="w-100 d-flex justify-content-center">
                            <!-- Button trigger modal -->
                            <button type="button" class="btn btn-primary" id="submitButton" data-bs-toggle="modal" data-bs-target="#confirmModal">
                                Book Now
                            </button>
                        </section>
                    </c:if>
                </div>
            </div>
        </form>
        <jsp:include page="../../includes/footer.jsp" flush="true"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
