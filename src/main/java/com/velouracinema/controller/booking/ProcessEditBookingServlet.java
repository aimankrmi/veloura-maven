/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.booking;

import com.velouracinema.dao.booking.BookingSeatDAO;
import com.velouracinema.dao.booking.SeatDAO;
import com.velouracinema.util.Utils;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Aiman
 */
public class ProcessEditBookingServlet extends HttpServlet {

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

        if (!Utils.authorizeUser(request, response, "member")) {
            response.sendError(401, "Unauthorized.");
            return;
        }

        String paymentStatus = request.getParameter("payment-status");

        if ("paid".equals(paymentStatus)) {

            int showtimeId = Integer.parseInt(request.getParameter("showtime-id"));
            int bookingId = Integer.parseInt(request.getParameter("booking-id"));
            String[] newSeats = request.getParameterValues("seat");
            String[] bookedSeats = request.getParameterValues("booked-seat");

            BookingSeatDAO.removeBookedSeatsByBookingId(bookingId);

            for (String seat : bookedSeats) {
                int seatId = Integer.parseInt(seat);
                SeatDAO.changeStatusById(seatId);
                BookingSeatDAO.removeBookedSeat(bookingId, seatId);
            }
            for (String seat : newSeats) {
                int seatId = SeatDAO.getSeatId(showtimeId, seat);
                SeatDAO.changeStatusById(seatId);
                BookingSeatDAO.insertBookedSeat(bookingId, seatId);
            }

        } else {
            response.sendError(401, "Unauthorized.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/viewBookingHistory?message=Succesfully edit");
    }

}
