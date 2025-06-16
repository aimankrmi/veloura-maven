
package com.velouracinema.dao.booking;

import com.velouracinema.dao.movie.MovieDAO;
import com.velouracinema.dao.payment.PaymentDAO;
import com.velouracinema.model.Showtime;
import com.velouracinema.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Aiman
 */
public class ShowtimeDAO {

    public static List<Showtime> getShowtimesByMovieId(int id) {
        String sql = "SELECT * FROM showtimes WHERE movie_id = ?;";
        List<Showtime> movieShowtimesList = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Showtime showtime = new Showtime();
                showtime.setId(rs.getInt("id"));
                showtime.setMovie(MovieDAO.getMovieById(rs.getInt("movie_id")));
                showtime.setShowDate(rs.getDate("show_date").toString());
                showtime.setShowTime(rs.getDate("show_time").toString());
                showtime.setScreen(rs.getString("screen"));
                movieShowtimesList.add(showtime);
            }

            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movieShowtimesList;
    }

    public static Showtime getShowtimeById(int id) {
        String sql = "SELECT * FROM showtimes WHERE id = ?";

        Showtime showtime = new Showtime();
        try (Connection conn = DBUtil.getConnection();) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                showtime.setId(rs.getInt("id"));
                showtime.setMovie(MovieDAO.getMovieById(rs.getInt("movie_id")));
                showtime.setShowDate(rs.getString("show_date"));
                showtime.setShowTime(rs.getString("show_time"));
                showtime.setScreen(rs.getString("screen"));
                showtime.setSeats(SeatDAO.getSeatsByShowtimes(rs.getInt("id")));
            }

            conn.close();
        } catch (SQLException e) {
        }
        return showtime;
    }

    public static List<String> getMovieDatesById(int id) {
        String sql = "SELECT DISTINCT show_date FROM showtimes WHERE movie_id = ?";
        List<String> movieShowdatesList = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                movieShowdatesList.add(rs.getString(1));
            }

            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movieShowdatesList;
    }

    public static List<String> getMovieTimeById(int id, String movieDate) {
        String sql = "SELECT show_time FROM showtimes WHERE movie_id = ? AND show_date = ?";
        List<String> movieShowtimesList = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.setString(2, movieDate);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                movieShowtimesList.add(rs.getString("show_time"));
            }

            conn.close();
        } catch (SQLException e) {
        }
        return movieShowtimesList;
    }

    public static Showtime getShowtimeByMovieId(int movie_id, String movieDate, String movieTime) {
        String sql = "SELECT * FROM showtimes WHERE movie_id = ? AND show_date = ? AND show_time = ?";

        Showtime showtime = new Showtime();
        try (Connection conn = DBUtil.getConnection();) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, movie_id);
            stmt.setString(2, movieDate);
            stmt.setString(3, movieTime);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                showtime.setId(rs.getInt("id"));
                showtime.setMovie(MovieDAO.getMovieById(rs.getInt("movie_id")));
                showtime.setShowDate(rs.getString("show_date"));
                showtime.setShowTime(rs.getString("show_time"));
                showtime.setScreen(rs.getString("screen"));
                showtime.setSeats(SeatDAO.getSeatsByShowtimes(rs.getInt("id")));
            }

            conn.close();
        } catch (SQLException e) {
        }
        return showtime;
    }

    public static LocalDateTime getShowtimeDateTime(int showtimeId) {
        String sql = "SELECT show_date, show_time FROM showtimes WHERE id = ?";

        try {
            Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, showtimeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                LocalDate date = rs.getObject("show_date", LocalDate.class);
                LocalTime time = rs.getObject("show_time", LocalTime.class);

                return LocalDateTime.of(date, time);
            }

            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // To generate a showtime with seat
    public static int generateShowtime(int movieId, String showDate, String showTime, String screen) {

        String sql = "INSERT INTO showtimes (movie_id, show_date, show_time, screen) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        int showtimeId = -1;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, movieId);
            stmt.setString(2, showDate);
            stmt.setString(3, showTime);
            stmt.setString(4, screen);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Inserting showtimes failed, no rows affected.");
            }

            // Get the generated showtimeId
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    showtimeId = generatedKeys.getInt(1); // Auto-incremented showtimeId
                } else {
                    throw new SQLException("Inserting payment failed, no ID obtained.");
                }
            }

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return showtimeId;
    }

}
