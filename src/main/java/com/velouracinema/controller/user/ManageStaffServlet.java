/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.user;

import com.velouracinema.dao.user.UserDAO;
import com.velouracinema.model.User;
import com.velouracinema.util.Utils;
import java.io.IOException;
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
public class ManageStaffServlet extends HttpServlet {

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
        String path = request.getServletPath();

        if (path.equals("/viewStaff")) {

            if (!Utils.authorizeUser(request, response, "admin")) {
                response.sendError(401);
                return;
            }

            List<User> staffs = UserDAO.getStaffs();
            request.setAttribute("staffs", staffs);
            String error = request.getParameter("error");
            String message = request.getParameter("message");
            if (error != null) {
                request.setAttribute("error", error);
            }
            if (message != null) {
                request.setAttribute("message", message);
            }
            request.getRequestDispatcher("WEB-INF/views/admin/manage-staff.jsp").forward(request, response);

        } else if (path.equals("/deleteStaff")) {

            if (!Utils.authorizeUser(request, response, "admin")) {
                response.sendError(401);
                return;
            }

            int id = Integer.parseInt(request.getParameter("id"));
            int status = UserDAO.deleteUserById(id, "staff");

            if (status != 0) {
                response.sendRedirect(request.getContextPath() + "/viewStaff?message=Successfully deleted a staff");
            } else {
                response.sendError(501);
            }
        }

    }

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
        String path = request.getServletPath();
        HttpSession session = request.getSession();

        if (path.equals("/addStaff")) {
            if (!Utils.authorizeUser(request, response, "admin")) {
                response.sendError(401);
                return;
            }
            String name = request.getParameter("staffName");
            String username = request.getParameter("staffUsername");
            String email = request.getParameter("staffEmail");
            String password = request.getParameter("staffPassword");
            String role = "staff";
            String phoneNo = request.getParameter("staffPhoneNo");

            if (UserDAO.isEmailUsed(email)) {
                response.sendRedirect(request.getContextPath() + "/viewStaff?error=Email has been used");
                return;
            }
            if (UserDAO.isUsernameUsed(username)) {
                response.sendRedirect(request.getContextPath() + "/viewStaff?error=Username has been used");
                return;
            }

            User staff = new User();
            staff.setName(name);
            staff.setUsername(username);
            staff.setEmail(email);
            staff.setPassword(password);
            staff.setRole(role);
            staff.setPhoneNo(phoneNo);

            int status = UserDAO.registerUser(staff);

            if (status != 0) {
                response.sendRedirect(request.getContextPath() + "/viewStaff?message=Successfully added new staff");
            } else {
                response.sendError(501);
            }

        } else if (path.equals("/updateStaff")) {
            if (!Utils.authorizeUser(request, response, "staff")) {
                response.sendError(401);
                return;
            }
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("staffName");
            String username = request.getParameter("staffUsername");
            String password = request.getParameter("staffPassword");
            String email = request.getParameter("staffEmail");
            String role = "staff";
            String phoneNo = request.getParameter("staffPhoneNo");
            System.out.println(UserDAO.getUserById(id).getEmail());
            System.out.println(email);
            if (UserDAO.isEmailUsed(email)) {
                if (!UserDAO.getUserById(id).getEmail().equals(email)) {
                    response.sendRedirect(request.getContextPath() + "/staff?error=Email has been used");
                    return;
                }
            }
            if (UserDAO.isUsernameUsed(username)) {
                if (!UserDAO.getUserById(id).getUsername().equals(username)) {
                    response.sendRedirect(request.getContextPath() + "/staff?error=Username has been used");
                    return;
                }
            }
            User staff = new User();
            staff.setId(id);
            staff.setName(name);
            staff.setUsername(username);
            if (password != "") {
                staff.setPassword(password);
            }
            staff.setEmail(email);
            staff.setRole(role);
            staff.setPhoneNo(phoneNo);

            int status = UserDAO.updateUser(staff);

            if (status != 0) {
                session.setAttribute("user", staff);
                response.sendRedirect(
                        request.getContextPath() + "/staff?message=Successfully updated " + staff.getUsername());
            } else {
                response.sendError(501);
            }

        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
