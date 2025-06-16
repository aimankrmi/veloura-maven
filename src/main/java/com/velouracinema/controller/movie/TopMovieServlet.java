/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.movie;

import com.velouracinema.dao.movie.TopMovieDAO;
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
public class TopMovieServlet extends HttpServlet {

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

        // List<Integer> position = new ArrayList<>();
        // List<Integer> topMovieId = new ArrayList<>();
        List<TopMovie> topMovies = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            TopMovie topMovie = new TopMovie();
            topMovie.setMovieId(Integer.parseInt(request.getParameter("topMovie" + i)));
            topMovie.setPosition(Integer.parseInt(request.getParameter("position" + i)));
            topMovies.add(topMovie);
        }
        TopMovieDAO.updateTopMovie(topMovies);

        response.sendRedirect(request.getContextPath() + "/staff");

    }

}
