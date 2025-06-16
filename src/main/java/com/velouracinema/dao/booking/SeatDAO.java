
package com.velouracinema.dao.booking;

import com.velouracinema.model.Seat;
import com.velouracinema.util.DBUtil;
import java.util.List;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Aiman
 */
public class SeatDAO {

    private SeatDAO() {
    }

    public static Seat getSeatById(int seatId) {
        String sql = "SELECT * FROM seats WHERE id = ?";
        Seat seat = new Seat();
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, seatId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                seat.setSeatId(rs.getInt("id"));
                seat.setShowtimeId(rs.getInt("showtime_id"));
                seat.setSeatNumber(rs.getString("seat_number"));
                seat.setIsAvailable(rs.getBoolean("is_available"));
            }

            conn.close();
        } catch (SQLException e) {
        }
        return seat;
    }

    public static List<Seat> getSeatsByShowtimes(int showtimeId) {

        List<Seat> seats = new ArrayList<>();
        Connection conn = null;
        String sql = "SELECT * FROM seats WHERE showtime_id = ? ORDER BY SUBSTRING(seat_number, 1, 1), CAST(SUBSTRING(seat_number, 2) AS UNSIGNED)";
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, showtimeId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Seat seat = new Seat();
                seat.setSeatNumber(rs.getString("seat_number"));
                seat.setShowtimeId(rs.getInt("showtime_id"));
                seat.setIsAvailable(rs.getBoolean("is_available"));
                seats.add(seat);
            }
            conn.close();
        } catch (SQLException e) {
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println("Error closing connection: " + e.getMessage());
            }
        }

        return seats;

    }

    // 1. Set seats as available
    public static void setAvailableSeatsByBookingId(int bookingId) {
        String updateSeats = "UPDATE seats SET is_available = TRUE WHERE id IN "
                + "(SELECT seat_id FROM booking_seats WHERE booking_id = ?)";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement seatStmt = conn.prepareStatement(updateSeats)) {
            seatStmt.setInt(1, bookingId);
            seatStmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public static boolean getStatusById(int seatId) {

        String sql = "SELECT is_available FROM seats WHERE id = ?";
        Connection conn = null;
        boolean status = false;
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, seatId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                status = rs.getBoolean(1);
            }

            conn.close();

        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return status;
    }

    public static void changeStatusById(int seatId) {

        String sql;
        boolean status = getStatusById(seatId);

        Connection conn = null;

        try {
            if (status) {
                sql = "UPDATE seats SET is_available = FALSE WHERE id = ?";
            } else {
                sql = "UPDATE seats SET is_available = TRUE WHERE id = ?";
            }
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, seatId);

            stmt.executeUpdate();

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public static int getSeatId(int showtimeId, String seatNumber) {

        int seatId = 0;
        String sql = "SELECT id FROM seats WHERE showtime_id = ? AND seat_number= ?";
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, showtimeId);
            stmt.setString(2, seatNumber);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                seatId = rs.getInt("id");
            }

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return seatId;
    }

    public static void generateSeatForEachShowtime(int showtimeId, String screen) {

        String sql = "INSERT INTO seats (showtime_id, seat_number) VALUES (?, ?)";
        char lastRow = 'A';
        int numOfSeatPerRow = 9;
        if ("Hall A".equalsIgnoreCase(screen)) {
            lastRow = 'E';
        } else if ("Hall B".equalsIgnoreCase(screen)) {
            lastRow = 'F';
        } else if ("Hall C".equalsIgnoreCase(screen)) {
            lastRow = 'G';
        } else if ("Hall D".equalsIgnoreCase(screen)) {
            lastRow = 'H';
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {

            conn.setAutoCommit(false);

            for (char alpha = 'A'; alpha <= lastRow; alpha++) {
                // For each row
                for (int i = 1; i <= numOfSeatPerRow; i++) {
                    stmt.setInt(1, showtimeId);
                    stmt.setString(2, String.valueOf(alpha) + i);

                    stmt.addBatch();
                }

            }

            stmt.executeBatch();
            conn.commit();
            System.out.println("Generate seat for showtime ID " + showtimeId + " is successful.");

        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
}
