package com.velouracinema.dao.movie;

import com.velouracinema.model.TopMovie;
import com.velouracinema.util.DBUtil;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Aiman
 */
public class TopMovieDAO {

    public static List<TopMovie> getAllTopMovie() {
        List<TopMovie> movies = new ArrayList<>();
        String sql = "SELECT * FROM top_movies";
        try (Connection conn = DBUtil.getConnection(); Statement st = conn.createStatement();) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                TopMovie movie = new TopMovie();
                movie.setPosition(rs.getInt("position"));
                movie.setMovieId(rs.getInt("movie_id"));
                movies.add(movie);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TopMovieDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return movies;
    }

    public static void updateTopMovie(List<TopMovie> movies) {
        String sql = "INSERT INTO top_movies(movie_id, position) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnection();  // Get connection
            stmt = conn.prepareStatement(sql);  // Prepare statement

            // Disable autocommit
            conn.setAutoCommit(false);

            // Delete old movies first
            deleteTopMovies();

            // Add the new movies to the batch
            for (TopMovie movie : movies) {
                stmt.setInt(1, movie.getMovieId());
                stmt.setInt(2, movie.getPosition());
                stmt.addBatch();
            }

            // Execute the batch of insert statements
            stmt.executeBatch();

            // Commit the transaction
            conn.commit();

        } catch (SQLException ex) {
            Logger.getLogger(TopMovieDAO.class.getName()).log(Level.SEVERE, null, ex);

            try {
                if (conn != null) {
                    // If an exception occurs, perform a rollback
                    conn.rollback();
                }
            } catch (SQLException rollbackEx) {
                Logger.getLogger(TopMovieDAO.class.getName()).log(Level.SEVERE, null, rollbackEx);
            }
        } finally {
            // Ensure resources are properly closed after operation
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true);  // Reset autocommit back to true
                    conn.close();  // Close connection
                }
            } catch (SQLException ex) {
                Logger.getLogger(TopMovieDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

//    public static void updateTopMovie(List<TopMovie> movies) {
//        String sql = "INSERT INTO top_movies(movie_id, position) VALUES (?, ?)";
//        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {
//
//            deleteTopMovies();
//            for (TopMovie movie : movies) {
//                stmt.setInt(1, movie.getMovieId());
//                stmt.setInt(2, movie.getPosition());
//                stmt.addBatch();
//            }
//            // Create an int[] to hold returned values
//            stmt.executeBatch();
//
//            // Explicitly commit statements to apply changes
//            conn.commit();
//
//        } catch (SQLException ex) {
//            Logger.getLogger(TopMovieDAO.class.getName()).log(Level.SEVERE, null, ex);
//        }
//
//    }
    public static void deleteTopMovies() {
        String sql = "DELETE FROM top_movies";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {

            stmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(TopMovieDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
