/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.payment;

import com.velouracinema.dao.payment.PaymentDAO;
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
public class UpdatePaymentServlet extends HttpServlet {

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
        if (!Utils.authorizeUser(request, response, "staff")) {
            response.sendError(401);
            return;
        }

        String paymentStatus = request.getParameter("paymentStatus");
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        int status = PaymentDAO.updatePaymentStatus(bookingId, paymentStatus);
        if (status == 0) {
            response.sendError(404);
        } else {
            response.sendRedirect(request.getContextPath() + "/reviewPayment");
        }

    }
}
