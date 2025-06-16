<%-- Document : payment Created on : 24 May 2025, 7:27:56 pm Author : Aiman --%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix = "fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payment</title>
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
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.payment/3.0.0/jquery.payment.min.js"></script>

    </head>
    <body>
        <jsp:include page="../../includes/header.jsp" />
        <%--<jsp:useBean id="booking" class="com.velouracinema.model.Booking" scope="request"/>--%>
        <%--<jsp:useBean id="showtime" class="com.velouracinema.model.Showtime" scope="request"/>--%>
        <fmt:parseDate value="${showtime.showDate}" type="both" var="parsedDate" pattern="yyyy-MM-dd"/>
        <fmt:parseDate value="${showtime.showTime}" type="time" var="parsedTime" pattern="HH:mm:ss"/>
        <div class="fluid-container">
            <div class="row justify-content-center py-3">
                <h2 class=" text-center mx-auto booking-title"><span class="glow-gold display-4">PAYMENT
                        DETAILS</span></h2>
            </div>
            <c:if test="${error!=null}">
                <div class="row">
                    ${error} 
                </div>
            </c:if>
            <div class="row justify-content-center gap-4 border-bottom mx-5 detail-wrapper">
                <div class="col-8 col-md-5 col-xl-4 pe-5 ">
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
                                <th class="col-12 col-sm-6 text-center text-sm-start" scope="row">Total Amount
                                </th>
                                <td class="col-12 col-sm-6 text-center text-sm-start"><fmt:formatNumber type="number" groupingUsed="false" maxFractionDigits="2" minFractionDigits="2" value="${booking.payment.amount}"/></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
            <div class="row justify-content-center py-3">
                <h2 class=" text-center mx-auto booking-title"><span class="glow-gold display-4">PAYMENT
                        METHODS</span></h2>
            </div>
            <div class="row">
                <div class="col-6 d-flex p-5 flex-justify-content-center align-items-center border-end">

                    <!-- Button trigger modal -->
                    <button type="button" class="btn btn-primary mx-auto" data-bs-toggle="modal"
                            data-bs-target="#staticBackdrop">
                        Pay with Credit/Debit Card
                    </button>

                    <!-- Modal -->
                    <form action="paymentProcess" method="POST">
                        <input type="hidden" name="showtimeId" value="${showtime.id}">
                        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false"
                             tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content bg-dark ">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5 text-white" id="staticBackdropLabel">Credit/Debit Card
                                            Payment</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">





                                        <div class="padding p-1">
                                            <div class="row">
                                                <div class="container-fluid d-flex justify-content-center">
                                                    <div class="col-10">
                                                        <div class="card bg-dark text-white border-0">
                                                            <div class="card-header">

                                                                <div class="row">
                                                                  
                                                                    <div class="col-md-6 text-right" style="margin-top: -5px;">

                                                                        <img src="https://img.icons8.com/color/36/000000/visa.png">
                                                                        <img src="https://img.icons8.com/color/36/000000/mastercard.png">
                                                                        <img src="https://img.icons8.com/color/36/000000/amex.png">

                                                                    </div>      

                                                                </div>    

                                                            </div>
                                                            <div class="card-body" style="height: 350px">
                                                                <input type="hidden" name="paymentMethod" value="online">
                                                                <input type="hidden" name="bookingId" value="${booking.id}">
                                                                <div class="form-group ">
                                                                    <label for="cc-number" class="control-label">Card Number</label>
                                                                    <input id="cc-number" min="16" max="16" type="tel" class="input-lg form-control cc-number" autocomplete="cc-number" placeholder="&bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull;" required>
                                                                </div>

                                                                <div class="row pt-3">

                                                                    <div class="col-md-6">
                                                                        <div class="form-group">
                                                                            <label for="cc-exp" class="control-label">Expiration Date</label>
                                                                            <input id="cc-exp" type="tel" class="input-lg form-control cc-exp" autocomplete="cc-exp" placeholder="&bull;&bull; / &bull;&bull;" required>
                                                                        </div>


                                                                    </div>

                                                                    <div class="col-md-6">
                                                                        <div class="form-group">
                                                                            <label for="cc-cvc" class="control-label">CVV</label>
                                                                            <input id="cc-cvc" type="tel" class="input-lg form-control cc-cvc" autocomplete="off" placeholder="&bull;&bull;&bull;&bull;" required>
                                                                        </div>
                                                                    </div>

                                                                </div>


                                                                <div class="form-group pt-3">
                                                                    <label for="numeric" class="control-label">Card Holder Name</label>
                                                                    <input  type="text" class="input-lg form-control">
                                                                </div>

                                                                <div class="form-group mt-3">

                                                                    <input  value="Pay Now" type="submit" class="btn btn-primary btn-lg form-control fs-6 fw-bold" style="font-size: .8rem;">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>






                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-danger"
                                                data-bs-dismiss="modal">Cancel</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="col-6 d-flex p-5 justify-content-center align-items-center ">
                    <form action="paymentProcess" method="POST">
                        <input type="hidden" name="bookingId" value="${booking.id}">
                        <input type="hidden" name="paymentMethod" value="counter">
                        <input type="hidden" name="showtimeId" value="${showtime.id}">
                        <input type="submit" class="btn btn-primary mx-auto" value="Pay At Counter"  <c:if test="${not allowCounterPayment}">disabled </c:if>>

                        </form>
                    </div>
                </div>
            </div>



            <script>
                $(function ($) {
                    $('[data-numeric]').payment('restrictNumeric');
                    $('.cc-number').payment('formatCardNumber');
                    $('.cc-exp').payment('formatCardExpiry');
                    $('.cc-cvc').payment('formatCardCVC');
                    $.fn.toggleInputError = function (erred) {
                        this.parent('.form-group').toggleClass('has-error', erred);
                        return this;
                    };
                    $('form').submit(function (e) {
                        
                        var cardType = $.payment.cardType($('.cc-number').val());
                        $('.cc-number').toggleInputError(!$.payment.validateCardNumber($('.cc-number').val()));
                        $('.cc-exp').toggleInputError(!$.payment.validateCardExpiry($('.cc-exp').payment('cardExpiryVal')));
                        $('.cc-cvc').toggleInputError(!$.payment.validateCardCVC($('.cc-cvc').val(), cardType));
                        $('.cc-brand').text(cardType);
                        $('.validation').removeClass('text-danger text-success');
                        $('.validation').addClass($('.has-error').length ? 'text-danger' : 'text-success');
                    });
                });
            </script>
        <jsp:include page="../../includes/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>