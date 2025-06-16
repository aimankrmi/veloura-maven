/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.booking;

import com.velouracinema.dao.booking.BookingDAO;
import com.velouracinema.dao.booking.SeatDAO;
import com.velouracinema.dao.booking.ShowtimeDAO;
import com.velouracinema.dao.payment.PaymentDAO;
import com.velouracinema.model.Booking;
import com.velouracinema.model.Seat;
import com.velouracinema.model.User;
import com.velouracinema.util.Utils;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Aiman
 */
public class EditBookingServlet extends HttpServlet {

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
        HttpSession session = request.getSession();

        User userSession = (User) session.getAttribute("user");

        if (!Utils.authorizeUser(request, response, "member")) {
            response.sendError(401, "Unauthorized.");
            return;
        }

        int member_id = userSession.getId();
        int booking_id = Integer.parseInt(request.getParameter("bookingId"));

        Booking booking = BookingDAO.getBookingByMemberId(booking_id, member_id);

        String action = request.getParameter("action");

        if (action.equals("edit")) {
            if (ShowtimeDAO.getShowtimeById(booking.getShowtimeId()).getMovie().getStatus()
                    .equalsIgnoreCase("Expired")) {
                response.sendError(501, "Expired movie to be update");
            }

            int showtimeId = booking.getShowtimeId();
            request.setAttribute("seatRowByShowtime", seatRowByShowtime(showtimeId));

            request.setAttribute("booking", booking);
            request.setAttribute("showtime", ShowtimeDAO.getShowtimeById(booking.getShowtimeId()));
            request.getRequestDispatcher("WEB-INF/views/booking/edit-booking.jsp").forward(request, response);
        } else if (action.equals("cancel")) {

            SeatDAO.setAvailableSeatsByBookingId(booking_id);
            PaymentDAO.deletePayment(booking_id);
            BookingDAO.cancelBookingByBookingId(booking_id);
            response.sendRedirect(request.getContextPath() + "/viewBookingHistory");

        }

    }

    public Map<String, List<Seat>> seatRowByShowtime(int showTimeId) {

        Map<String, List<Seat>> seatMap = new LinkedHashMap<>();

        for (Seat seat : SeatDAO.getSeatsByShowtimes(showTimeId)) {
            String row = seat.getSeatNumber().substring(0, 1);
            seatMap.computeIfAbsent(row, k -> new ArrayList<>()).add(seat);
        }

        return seatMap;

    }

}
