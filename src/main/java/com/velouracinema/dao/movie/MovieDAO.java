
package com.velouracinema.dao.movie;

/**
 *
 * @author sitif
 */
import com.velouracinema.dao.booking.SeatDAO;
import com.velouracinema.dao.booking.ShowtimeDAO;
import com.velouracinema.model.Movie;
import com.velouracinema.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MovieDAO {

    public static int insertMovie(Movie movie) {

        List<String> screen = Arrays.asList("Hall A", "Hall B", "Hall C", "Hall D");
        List<String> showTime = Arrays.asList("10:30", "11:45", "13:20", "14:00", "15:30", "16:45", "18:00", "20:00",
                "21:30");

        String sql = "INSERT INTO movies (title, genre, language, duration, release_date, description, price, image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int status = 0;
        Connection conn = null;
        int movieId = -1;
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, movie.getTitle());
            stmt.setString(2, movie.getGenre());
            stmt.setString(3, movie.getLanguage());
            stmt.setInt(4, movie.getDuration());
            stmt.setDate(5, movie.getReleaseDate());
            stmt.setString(6, movie.getDescription());
            stmt.setDouble(7, movie.getPrice());
            stmt.setString(8, movie.getImagePath());

            status = stmt.executeUpdate();
            // Get the generated bookingId
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    movieId = generatedKeys.getInt(1); // Auto-incremented showtimeId
                } else {
                    throw new SQLException("Inserting payment failed, no ID obtained.");
                }
            }
            conn.close();

        } catch (SQLException ex) {
            Logger.getLogger(MovieDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (status != 0) {
            LocalDate releaseDate = movie.getReleaseDate().toLocalDate();
            LocalDate endDate = releaseDate.plusDays(13);

            for (LocalDate date = releaseDate; !date.isAfter(endDate); date = date.plusDays(1)) {

                String dateString = date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

                // Create a modifiable copy (since Arrays.asList returns a fixed-size list)
                List<String> timeList = new ArrayList<>(showTime);

                // Shuffle to randomize the list
                Collections.shuffle(timeList);

                // Pick the first 4 elements and sort them
                List<String> selected = new ArrayList<>(timeList.subList(0, 4));
                Collections.sort(selected);

                System.out.println("try to generate showtime...");
                for (String time : selected) {
                    String randomScreen = screen.get(new Random().nextInt(screen.size()));
                    int showtimeId = ShowtimeDAO.generateShowtime(movieId, dateString, time, randomScreen);
                    System.out.println("For showtime ID: " + showtimeId);
                    SeatDAO.generateSeatForEachShowtime(showtimeId, randomScreen);
                    System.out.println("Done generate seat");

                }

            }
        }

        return status;
    }

    public static int deleteMovieById(int id) {
        String sql = "DELETE FROM movies WHERE id = ?";
        int status = 0;
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);

            status = stmt.executeUpdate();

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(MovieDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return status;
    }

    public static int updateMovie(Movie movie) {

        String sql = "UPDATE movies SET "
                + "title = ?,"
                + "genre = ?,"
                + "duration = ?,"
                + "release_date = ?,"
                + "language = ?,"
                + "description = ?,"
                + "image_path = ?,"
                + "price = ?"
                + "WHERE id = ?;";

        int status = 0;
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, movie.getTitle());
            stmt.setString(2, movie.getGenre());
            stmt.setInt(3, movie.getDuration());
            stmt.setDate(4, movie.getReleaseDate());
            stmt.setString(5, movie.getLanguage());
            stmt.setString(6, movie.getDescription());
            stmt.setString(7, movie.getImagePath());
            stmt.setDouble(8, movie.getPrice());
            stmt.setInt(9, movie.getMovieId());

            status = stmt.executeUpdate();

            conn.close();

        } catch (SQLException ex) {
            Logger.getLogger(MovieDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return status;
    }

    public static List<Movie> getAllMovies() {
        List<Movie> movies = new ArrayList<>();

        String sql = "SELECT * FROM movies";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Movie movie = new Movie();
                movie.setMovieId(rs.getInt("id"));
                movie.setTitle(rs.getString("title"));
                movie.setGenre(rs.getString("genre"));
                movie.setLanguage(rs.getString("language"));
                movie.setDuration(rs.getInt("duration"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setDescription(rs.getString("description"));
                movie.setPrice(rs.getFloat("price"));
                movie.setImagePath(rs.getString("image_path"));

                movies.add(movie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return movies;
    }

    public static Movie getMovieById(int id) {
        String sql = "SELECT * FROM movies WHERE id = ?";
        Movie movie = new Movie();
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                movie.setMovieId(rs.getInt("id"));
                movie.setTitle(rs.getString("title"));
                movie.setGenre(rs.getString("genre"));
                movie.setLanguage(rs.getString("language"));
                movie.setDuration(rs.getInt("duration"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setDescription(rs.getString("description"));
                movie.setPrice(rs.getFloat("price"));
                movie.setImagePath(rs.getString("image_path"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("Error closing connection: " + e.getMessage());
            }
        }
        return movie;
    }

    public static double getMoviePriceById(int id) {
        String sql = "SELECT price FROM movies WHERE id = ?";
        Connection conn = null;
        double price = 0;
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                price = rs.getDouble("price");
            }
        } catch (SQLException ex) {
            Logger.getLogger(MovieDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return price;
    }

    public static List<Integer> getMovieIds() {
        String sql = "SELECT id FROM movies WHERE release_date >= CURRENT_DATE - INTERVAL 1 MONTH";
        List<Integer> ids = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ids.add(rs.getInt("id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ids;
    }

}
