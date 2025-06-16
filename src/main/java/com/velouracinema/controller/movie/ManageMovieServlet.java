/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.velouracinema.controller.movie;

import com.velouracinema.dao.movie.MovieDAO;
import com.velouracinema.model.Movie;
import com.velouracinema.util.Utils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author Aiman
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 15) // 15MB
public class ManageMovieServlet extends HttpServlet {

    private final String IMAGE_DIR = "/assets/images";

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!Utils.authorizeUser(request, response, "staff")) {
            response.sendError(401);
            return;
        }
    }

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
        processRequest(request, response);
        String path = request.getServletPath();

        if (path.equals("/viewMovies")) {

            List<Movie> movies = MovieDAO.getAllMovies();
            request.setAttribute("movies", movies);
            request.getRequestDispatcher("WEB-INF/views/staff/manage-movies.jsp").forward(request, response);

        } else if (path.equals("/deleteMovie")) {

            try {
                int id = Integer.parseInt(request.getParameter("id"));
                int status = MovieDAO.deleteMovieById(id);

                if (status == 0) {
                    System.out.println("Movie delete failed.");
                } else {
                    System.out.println("Movie delete successful.");
                }

                response.sendRedirect(request.getContextPath() + "/viewMovies");
            } catch (NumberFormatException e) {
                System.out.println("Movie ID does not found.");
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
        processRequest(request, response);
        String path = request.getServletPath();
        String movieIdString;
        String title;
        String[] genreArr;
        String genre;
        String language;
        String durationString;
        String releaseDateString;
        String priceString;
        String description;
        String imagePath;

        Part image;
        String imageName;
        String extension;
        String uniqueImageName;
        String finalImageName;
        String imageFolder;
        File imageDir;

        int status;
        Movie movie;
        if (path.equals("/addMovie")) {

            title = request.getParameter("movieTitle");
            genreArr = request.getParameterValues("genre");
            genre = (genreArr != null) ? String.join(", ", genreArr) : "";
            language = request.getParameter("language");
            durationString = request.getParameter("duration");
            releaseDateString = request.getParameter("releaseDate");
            priceString = request.getParameter("price");
            description = request.getParameter("description");

            image = request.getPart("image");
            imageName = image.getSubmittedFileName();
            extension = imageName.substring(imageName.lastIndexOf(".")); // e.g. ".jpg"

            uniqueImageName = System.currentTimeMillis() + "_" + UUID.randomUUID() + extension;

            imageFolder = getServletContext().getRealPath(IMAGE_DIR);
            imagePath = imageFolder + File.separator + uniqueImageName;

            imageDir = new File(imageFolder);

            if (!imageDir.exists()) {
                imageDir.mkdirs(); // create if doesn't exist
            }
            // SAVE IMAGE TO FILE
            try (
                    InputStream is = image.getInputStream();
                    FileOutputStream fos = new FileOutputStream(imagePath)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }

            try {

                int duration = Integer.parseInt(durationString);

                double price = Double.parseDouble(priceString);

                movie = new Movie();
                movie.setTitle(title);
                movie.setGenre(genre);
                movie.setLanguage(language);
                movie.setDuration(duration);
                movie.setReleaseDateFromString(releaseDateString);
                movie.setPrice(price);
                movie.setDescription(description);
                movie.setImagePath(uniqueImageName);
                status = MovieDAO.insertMovie(movie);
                if (status == 0) {
                    System.out.println("MOVIE INSERT FAILED");
                } else {
                    System.out.println("MOVIE INSERT SUCCESS");
                }
                response.sendRedirect(request.getContextPath() + "/viewMovies");
                return;
            } catch (IOException | NumberFormatException e) {
                e.printStackTrace();
            }

        } else if (path.equals("/editMovie")) {

            movieIdString = request.getParameter("movieId");
            title = request.getParameter("movieTitle");
            genreArr = request.getParameterValues("genre");
            genre = (genreArr != null) ? String.join(", ", genreArr) : "";
            language = request.getParameter("language");
            durationString = request.getParameter("duration");
            releaseDateString = request.getParameter("releaseDate");
            priceString = request.getParameter("price");
            description = request.getParameter("description");
            // imagePath = request.getParameter("imagePath");
            String oldImageName = request.getParameter("oldImage");
            finalImageName = oldImageName;
            image = request.getPart("image");
            imageName = image.getSubmittedFileName();

            imageFolder = getServletContext().getRealPath(IMAGE_DIR);
            imageDir = new File(imageFolder);
            if (!imageDir.exists()) {
                imageDir.mkdirs(); // create if doesn't exist
            }

            // If new image uploaded
            if (imageName != null && !imageName.isEmpty()) {
                // Build unique file name with timestamp + UUID
                extension = imageName.substring(imageName.lastIndexOf("."));
                uniqueImageName = System.currentTimeMillis() + "_" + UUID.randomUUID() + extension;

                // Save new image
                try (InputStream is = image.getInputStream();
                        FileOutputStream fos = new FileOutputStream(imageFolder + File.separator + uniqueImageName)) {

                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = is.read(buffer)) != -1) {
                        fos.write(buffer, 0, bytesRead);
                    }
                }

                // Delete old image file if exists
                File oldFile = new File(imageFolder + File.separator + oldImageName);
                if (oldFile.exists()) {
                    oldFile.delete();
                }

                finalImageName = uniqueImageName;
            }

            movie = new Movie();
            try {
                int id = Integer.parseInt(movieIdString);
                int duration = Integer.parseInt(durationString);
                double price = Double.parseDouble(priceString);
                movie.setMovieId(id);
                movie.setTitle(title);
                movie.setGenre(genre);
                movie.setLanguage(language);
                movie.setDuration(duration);
                movie.setReleaseDateFromString(releaseDateString);
                movie.setPrice(price);
                movie.setDescription(description);
                movie.setImagePath(finalImageName);

                status = MovieDAO.updateMovie(movie);

                if (status == 0) {
                    System.out.println("MOVIE UPDATE FAILED");
                } else {
                    System.out.println("MOVIE UPDATE SUCCESS");
                }

                response.sendRedirect(request.getContextPath() + "/viewMovies");

            } catch (Exception e) {
            }
        }
    }

}
