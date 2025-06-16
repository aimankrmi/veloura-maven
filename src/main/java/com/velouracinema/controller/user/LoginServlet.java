/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.user;

import com.velouracinema.dao.user.UserDAO;
import com.velouracinema.model.User;
import com.velouracinema.util.Utils;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Aiman
 */
public class LoginServlet extends HttpServlet {

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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String time = request.getParameter("time-show") != null ? request.getParameter("time-show") : "";
        String date = request.getParameter("date-show") != null ? request.getParameter("date-show") : "";
        String movieId = request.getParameter("movieId") != null ? request.getParameter("movieId") : "";

        if (!date.equals("") && !time.equals("") && !movieId.equals("")) {
            request.setAttribute("movieId", movieId);
            request.setAttribute("time", time);
            request.setAttribute("date", date);
        }
        
        if (request.getParameter("error") != null) {
            request.setAttribute("error", request.getParameter("error"));
        }
        if (request.getParameter("message") != null) {
            request.setAttribute("message", request.getParameter("message"));
        }

        if (user == null || user.getId() == 0) {
            request.getRequestDispatcher("WEB-INF/views/user/login.jsp").forward(request, response);
        } else {
            // Redirect user based on role
            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else if ("staff".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/staff");
            } else if ("member".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/member"); // default for member 
            } else {
                String error = "User does not exists";
                response.sendRedirect(request.getContextPath() + "/login?error=" + error);
            }
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = new User();
        String username = request.getParameter("username");
        
        if (username != null) {
            String password = Utils.SHA256Hash(request.getParameter("password"));
            user = UserDAO.getUser(username, password);
        }

//        boolean urlRedirect = Boolean.parseBoolean(request.getParameter("urlRedirect"));
        String time = request.getParameter("time-show") != null ? request.getParameter("time-show") : "";
        String date = request.getParameter("date-show") != null ? request.getParameter("date-show") : "";
        String movieId = request.getParameter("movieId") != null ? request.getParameter("movieId") : "";

        if (user.getId() == 0) {

            if (!date.equals("") && !time.equals("") && !movieId.equals("")) {
                String message = "Please login first";
                response.sendRedirect(request.getContextPath() + "/login?message=" + message+"&time-show="+time+"&date-show="+date+"&movieId="+movieId);
            } else {
                String error = "User does not exists";
                response.sendRedirect(request.getContextPath() + "/login?error=" + error);
            }
        } else {

            HttpSession session = request.getSession();

            session.setAttribute("user", user);

            // Redirect user based on role
            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else if ("staff".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/staff");
            } else if ("member".equalsIgnoreCase(user.getRole())) {
                if (!date.equals("") && !time.equals("") && !movieId.equals("")) {
                    response.sendRedirect(request.getContextPath() + "/booking?id=" + movieId + "&date=" + date + "&time=" + time);
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/member"); // default for member 
            } else {
                String error = "User does not exists";
                response.sendRedirect(request.getContextPath() + "/login?error=" + error);
            }
        }

    }

}
