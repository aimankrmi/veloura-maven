/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.user;

import com.velouracinema.dao.movie.MovieDAO;
import com.velouracinema.dao.movie.TopMovieDAO;
import com.velouracinema.model.Movie;
import com.velouracinema.model.TopMovie;
import com.velouracinema.model.User;
import com.velouracinema.util.Utils;
import java.io.IOException;
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
public class StaffServlet extends HttpServlet {

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        staffDashboard(request, response);
    }

    
    public void staffDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (!Utils.authorizeUser(request, response, "staff")) {
            response.sendError(401);
            return;
        }
        List<TopMovie> topMovies = new ArrayList<>();
        topMovies = TopMovieDAO.getAllTopMovie();
        List<Movie> movies = new ArrayList<>();
        movies = MovieDAO.getAllMovies();
        request.setAttribute("movies", movies);
        request.setAttribute("topMovies", topMovies);
        request.setAttribute("staff", user);
        request.getRequestDispatcher("WEB-INF/views/staff/staff-dashboard.jsp").forward(request, response);
    }
    
}
