/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.payment;

import com.velouracinema.dao.booking.BookingDAO;
import com.velouracinema.dao.booking.BookingSeatDAO;
import com.velouracinema.dao.movie.MovieDAO;
import com.velouracinema.dao.payment.PaymentDAO;
import com.velouracinema.dao.booking.SeatDAO;
import com.velouracinema.dao.booking.ShowtimeDAO;
import com.velouracinema.model.Booking;
import com.velouracinema.model.Payment;
import com.velouracinema.model.Seat;
import com.velouracinema.model.Showtime;
import com.velouracinema.model.User;
import com.velouracinema.util.Utils;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Aiman
 */
public class PaymentServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int showtimeId;
        HttpSession session = request.getSession();

        String date = request.getParameter("date-show");
        String time = request.getParameter("time-show");
        request.setAttribute("date", date);
        request.setAttribute("time", time);

        User user = (User) session.getAttribute("user");
        // Check if the user has logged in or not AND to check if the user is not a
        // member (staff/admin) cannot book
        if (!Utils.authorizeUser(request, response, "member")) {
            response.sendRedirect(request.getContextPath() + "/logout");
            return;
        }

        String formToken = request.getParameter("bookingToken");

        String sessionToken = (String) session.getAttribute("bookingToken");
        Long tokenTime = (Long) session.getAttribute("bookingTokenTime");

        if (tokenTime == null) {
            response.sendError(409, "Duplicate or expired booking token.");
            return;
        }

        // Check if token is expired (e.g., after 15 minutes = 900000 ms)
        long now = System.currentTimeMillis();
        if (now - tokenTime > 15 * 60 * 1000) {
            session.removeAttribute("bookingToken");
            session.removeAttribute("bookingTokenTime");
            // response.sendRedirect("error.jsp?msg=TokenExpired");
            response.sendError(409, "Duplicate or expired booking token.");
            return;
        }

        if (sessionToken == null || !sessionToken.equals(formToken) || tokenTime == null) {
            response.sendError(409, "Duplicate or expired booking token.");
            return;
        }

        List<Seat> seatsBooked = new ArrayList<>();

        double totalAmount = 0;
        int movieId = Integer.parseInt(request.getParameter("showtime-movie-id"));

        int memberId = user.getId(); // Just for temporary
        showtimeId = Integer.parseInt(request.getParameter("showtime-id"));
        String[] seats = request.getParameterValues("seat");
        int seatId;
        int bookingId = BookingDAO.insertBooking(memberId, showtimeId); // Obtain booking ID while insert booking
        // Store bookingId in session or pass as parameter to payment page
        // session.setAttribute("currentBookingId", bookingId);

        // Invalidate token now - no more booking insertions allowed with this token
        // session.removeAttribute("bookingToken");
        LocalDateTime bookingDate = BookingDAO.getBookingDateById(bookingId);
        for (String seat : seats) {
            seatId = SeatDAO.getSeatId(showtimeId, seat);
            SeatDAO.changeStatusById(seatId);
            seatsBooked.add(SeatDAO.getSeatById(seatId));
            BookingSeatDAO.insertBookedSeat(bookingId, seatId);
            totalAmount += MovieDAO.getMoviePriceById(movieId);
        }

        int paymentId = PaymentDAO.insertPayment(bookingId, totalAmount);// Obtain booking ID while insert payment
        session.removeAttribute("bookingToken");
        session.removeAttribute("bookingTokenTime");
        Payment payment = new Payment();
        payment.setId(paymentId);
        payment.setAmount(totalAmount);
        payment.setBookingId(bookingId);

        Booking booking = new Booking();
        booking.setId(bookingId);
        booking.setBookingDate(bookingDate);
        booking.setMemberId(memberId);
        booking.setShowtimeId(showtimeId);
        booking.setSeats(seatsBooked);
        booking.setPayment(payment);

        Showtime showtime = ShowtimeDAO.getShowtimeById(showtimeId);
        // Showtime showtime = new Showtime();
        // showtime.setMovie(MovieDAO.getMovieById(movieId));
        // showtime.setShowDate(date);
        // showtime.setShowTime(time);

        // To check if the showtime is less than 3 hours
        LocalDateTime showtimeTime = ShowtimeDAO.getShowtimeDateTime(showtimeId);
        LocalDateTime nowTime = LocalDateTime.now();

        boolean allowCounterPayment = nowTime.plusHours(3).isBefore(showtimeTime);
        // Store flag in request/session
        request.setAttribute("allowCounterPayment", allowCounterPayment);

        request.setAttribute("showtime", showtime);
        request.setAttribute("booking", booking);

        request.getRequestDispatcher("WEB-INF/views/payment/payment.jsp").forward(request, response);

    }
}
