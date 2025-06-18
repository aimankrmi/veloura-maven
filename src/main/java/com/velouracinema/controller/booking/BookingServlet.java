/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.booking;

import com.velouracinema.dao.movie.MovieDAO;
import com.velouracinema.dao.booking.SeatDAO;
import com.velouracinema.dao.booking.ShowtimeDAO;
import com.velouracinema.model.Seat;
import com.velouracinema.model.Showtime;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Aiman
 */
public class BookingServlet extends HttpServlet {

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

        try {
            int id = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id"))
                    : MovieDAO.getMovieIds().get(0);

            // To avoid expired movie
            if (MovieDAO.getMovieById(id).getStatus().equalsIgnoreCase("Expired")
                    || MovieDAO.getMovieById(id).getStatus().equalsIgnoreCase("Coming Soon")) {
                String next = request.getParameter("next") != null ? request.getParameter("next") : null;
                if (next != null) {
                    if (next.equals("true")) {
                        response.sendRedirect(
                                request.getContextPath() + "/booking?id=" + getNextMovieId(id) + "&next=true");
                        return;
                    } else {
                        response.sendRedirect(
                                request.getContextPath() + "/booking?id=" + getPreviousMovieId(id) + "&next=false");
                        return;

                    }
                }
            }

            String date = request.getParameter("date");
            String time = request.getParameter("time");

            if (date != null) {

                List<String> showTimesByDate = getShowTimesByDate(id, date);
                request.setAttribute("showTimesByDate", showTimesByDate);

                if (time != null) {
                    int showtimeId = ShowtimeDAO.getShowtimeByMovieId(id, date, time).getId();
                    request.setAttribute("seatRowByShowtime", seatRowByShowtime(showtimeId));

                    Showtime st = ShowtimeDAO.getShowtimeByMovieId(id, date, time);
                    request.setAttribute("showtime", st);
                }

            }

            String bookingToken = UUID.randomUUID().toString();
            HttpSession session = request.getSession();
            session.setAttribute("bookingToken", bookingToken);
            request.setAttribute("bookingToken", bookingToken);
            session.setAttribute("bookingTokenTime", System.currentTimeMillis());
            request.setAttribute("movie", MovieDAO.getMovieById(id));
            request.setAttribute("previousMovieId", getPreviousMovieId(id));
            request.setAttribute("nextMovieId", getNextMovieId(id));

            // response.sendRedirect(request.getContextPath()+"/views/booking.jsp");
            request.getRequestDispatcher("WEB-INF/views/booking/booking.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath());
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

    // This method return the time for a movie and a date
    public List<String> getShowTimesByDate(int movieId, String showDate) {
        return ShowtimeDAO.getMovieTimeById(movieId, showDate);
    }

    public int getPreviousMovieId(int movieId) {
        List<Integer> ids = MovieDAO.getMovieIds();
        int index = ids.indexOf(movieId);

        if (index > 0) {
            return ids.get(index - 1);
        } else {
            return ids.get(ids.size() - 1);
        }
    }

    public int getNextMovieId(int movieId) {
        List<Integer> ids = MovieDAO.getMovieIds();
        int index = ids.indexOf(movieId);

        if (index + 1 == ids.size()) {
            return ids.get(0);
        } else {
            return ids.get(index + 1);
        }

    }

}
