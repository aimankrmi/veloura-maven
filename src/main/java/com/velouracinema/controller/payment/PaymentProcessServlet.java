/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.payment;

import com.velouracinema.dao.booking.BookingDAO;
import com.velouracinema.dao.payment.PaymentDAO;
import com.velouracinema.dao.booking.ShowtimeDAO;
import com.velouracinema.dao.user.UserDAO;
import com.velouracinema.model.Booking;
import com.velouracinema.util.EmailUtils;
import com.velouracinema.util.Utils;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Aiman
 */
public class PaymentProcessServlet extends HttpServlet {

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
            response.sendError(401);
            return;
        }

        int status = 0;
        if (request.getParameter("bookingId") != null) {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String paymentMethod = request.getParameter("paymentMethod");
            request.setAttribute("paymentMethod", paymentMethod);
            request.setAttribute("bookingId", bookingId);
            status = PaymentDAO.updatePaymentMethod(bookingId, paymentMethod);
            if (paymentMethod.equals("online")) {
                status = PaymentDAO.updateStatusSuccess(bookingId);
                if (status > 0) {
                    sendEmail(bookingId);
                    status = BookingDAO.updateBookingStatus(bookingId);
                    if (status > 0) {

                        request.getRequestDispatcher("WEB-INF/views/payment/success-payment.jsp").forward(request,
                                response);
                    } else {
                        response.sendRedirect("booking");
                    }
                }

            } else {
                int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
                LocalDateTime showtimeTime = ShowtimeDAO.getShowtimeDateTime(showtimeId);
                if (LocalDateTime.now(ZoneId.of("Asia/Kuala_Lumpur")).plusHours(3).isAfter(showtimeTime)) {
                    // Too close to showtime, reject
                    request.setAttribute("error", "Cannot choose Pay at Counter for showtimes within 3 hours.");
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                    return;
                }

                status = BookingDAO.updateBookingStatus(bookingId);
                if (status > 0) {
                    sendEmail(bookingId);
                    request.getRequestDispatcher("WEB-INF/views/payment/success-payment.jsp").forward(request,
                            response);

                }
            }

        }
    }

    public void sendEmail(int bookingId) {
        Booking booking = BookingDAO.getBookingById(bookingId);
        String recipientEmail = UserDAO.getUserById(booking.getMemberId()).getEmail();
        EmailUtils.sendEmailBookingConfirm(booking, recipientEmail);
    }

}
