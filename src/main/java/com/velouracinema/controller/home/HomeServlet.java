/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.home;

import com.velouracinema.dao.movie.MovieDAO;
import com.velouracinema.dao.movie.TopMovieDAO;
import com.velouracinema.model.Movie;
import com.velouracinema.model.TopMovie;
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
public class HomeServlet extends HttpServlet {

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
        List<TopMovie> topMovieList = new ArrayList<>();
        topMovieList = TopMovieDAO.getAllTopMovie();
        List<Movie> movieList = MovieDAO.getAllMovies();
        request.setAttribute("movies", movieList);
        request.setAttribute("topMovies", topMovieList);
        request.getRequestDispatcher("WEB-INF/index.jsp").forward(request, response);

    }

}
