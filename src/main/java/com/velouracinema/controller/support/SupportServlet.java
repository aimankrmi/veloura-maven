/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.support;

import com.velouracinema.dao.user.SupportDAO;
import com.velouracinema.model.SupportRequest;
import com.velouracinema.util.EmailUtils;
import com.velouracinema.util.Utils;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Aiman
 */
public class SupportServlet extends HttpServlet {

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

        String path = request.getServletPath();
        if (path.equals("/support")) {
            String success = request.getParameter("success");
            if (success != null) {
                request.setAttribute("success", success);
            }
            // Forward back to support.jsp with success indicator
            request.getRequestDispatcher("WEB-INF/views/user/support.jsp").forward(request, response);
        } else if (path.equals("/viewSupport")) {
            if (!Utils.authorizeUser(request, response, "staff")) {
                response.sendError(401);
                return;
            }
            List<SupportRequest> supports = SupportDAO.getAllSupports();
            String message = request.getParameter("message");
            request.setAttribute("message", message);
            request.setAttribute("supports", supports);
            request.getRequestDispatcher("WEB-INF/views/staff/manage-support.jsp").forward(request, response);
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

        String path = request.getServletPath();
        if (path.equals("/updateSupport")) {
        int supportId = Integer.parseInt(request.getParameter("support_id"));
            if (!Utils.authorizeUser(request, response, "staff")) {
                response.sendError(401);
                return;
            }

            String resolve = request.getParameter("resolve");
            SupportRequest support = SupportDAO.getSupportById(supportId);

            EmailUtils.sendSupportResponseEmail(support, resolve);
            SupportDAO.updateStatus(supportId, "resolved");
            response.sendRedirect(request.getContextPath() + "/viewSupport?message=Succesfully resolved an issue");
            return;
        } else if (path.equals("/deleteSupport")) {
        int supportId = Integer.parseInt(request.getParameter("support_id"));
            if (!Utils.authorizeUser(request, response, "staff")) {
                response.sendError(401);
                return;
            }
            SupportDAO.deleteSupport(supportId);
            response.sendRedirect(request.getContextPath() + "/viewSupport");
            return;
        } else if (path.equals("/submitSupport")) {
            SupportRequest support = new SupportRequest();

            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String message = request.getParameter("message");
            String issueType = request.getParameter("issueType");

            support.setName(name);
            support.setEmail(email);
            support.setIssueType(issueType);
            support.setMessage(message);

            SupportDAO.submitSupport(support);
            response.sendRedirect(request.getContextPath() + "/support?success=1");
        }

    }
}
