
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
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {

            deleteTopMovies();
            for (TopMovie movie : movies) {
                stmt.setInt(1, movie.getMovieId());
                stmt.setInt(2, movie.getPosition());
                stmt.addBatch();
            }
            // Create an int[] to hold returned values
            stmt.executeBatch();

            // Explicitly commit statements to apply changes
            conn.commit();

        } catch (SQLException ex) {
            Logger.getLogger(TopMovieDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public static void deleteTopMovies() {
        String sql = "DELETE FROM top_movies";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {

            stmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(TopMovieDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
