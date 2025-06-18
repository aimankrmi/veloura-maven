/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.user;

import com.velouracinema.dao.booking.BookingDAO;
import com.velouracinema.dao.booking.ShowtimeDAO;
import com.velouracinema.model.Booking;
import com.velouracinema.model.Showtime;
import com.velouracinema.model.User;
import com.velouracinema.util.Utils;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
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
public class MemberServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        HttpSession session = request.getSession();
        User userSession = (User) session.getAttribute("user");

        if (!Utils.authorizeUser(request, response, "member")) {
            response.sendError(401);
            return;
        }

        if (path.equals("/member")) {
            String error = request.getParameter("error");
            String message = request.getParameter("message");
            if (error != null) {
                request.setAttribute("error", error);
            }
            if (message != null) {
                request.setAttribute("message", message);
            }
            request.setAttribute("member", userSession);
            request.getRequestDispatcher("WEB-INF/views/member/member-dashboard.jsp").forward(request, response);
        } else if (path.equals("/viewBookingHistory")) {
            List<Booking> bookings = BookingDAO.getBookingByMemberId(userSession.getId());

            Map<Integer, Showtime> showtimeMap = new HashMap<>();
            for (Booking booking : bookings) {
                Showtime st = ShowtimeDAO.getShowtimeById(booking.getShowtimeId());
                showtimeMap.put(booking.getShowtimeId(), st);
            }
            request.setAttribute("bookings", bookings);
            request.setAttribute("showtimeMap", showtimeMap);

//            List<Showtime> showtimes = new ArrayList<>();
//            for (Booking booking : bookings) {
//                showtimes.add(ShowtimeDAO.getShowtimeById(booking.getShowtimeId()));
//            }
//
//            request.setAttribute("showtimes", showtimes);
            request.getRequestDispatcher("WEB-INF/views/member/booking-history.jsp").forward(request, response);

        }
    }

}
