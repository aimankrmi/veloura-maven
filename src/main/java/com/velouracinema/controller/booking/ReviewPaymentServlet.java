/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.booking;

import com.velouracinema.dao.booking.BookingDAO;
import com.velouracinema.dao.booking.ShowtimeDAO;
import com.velouracinema.model.Booking;
import com.velouracinema.model.Showtime;
import com.velouracinema.util.Utils;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Aiman
 */
public class ReviewPaymentServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!Utils.authorizeUser(request, response, "staff")) {
            response.sendError(401);
            return;
        }

        List<Booking> bookings = BookingDAO.getAllBookings();

        request.setAttribute("bookings", bookings);
        List<Showtime> showtimes = new ArrayList<>();
        for (Booking booking : bookings) {
            showtimes.add(ShowtimeDAO.getShowtimeById(booking.getShowtimeId()));
        }
        request.setAttribute("showtimes", showtimes);
        request.getRequestDispatcher("WEB-INF/views/payment/review-payment.jsp").forward(request, response);
    }

}
