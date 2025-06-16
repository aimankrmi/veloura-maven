
package com.velouracinema.dao.booking;

import com.velouracinema.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Aiman
 */
public class BookingSeatDAO {
    public static int removeBookedSeatsByBookingId(int bookingId) {
        String sql = "DELETE FROM booking_seats WHERE booking_id = ?";

        int status = 0;
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);

            status = stmt.executeUpdate();
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return status;

    }

    public static List<Integer> getBookedSeatByBooking(int bookingId) {
        String sql = "SELECT seat_id FROM booking_seats WHERE booking_id = ?";

        List<Integer> bookedSeats = new ArrayList<>();

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                bookedSeats.add(rs.getInt("seat_id"));
            }

            conn.close();

        } catch (SQLException ex) {
            Logger.getLogger(SeatDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return bookedSeats;
    }

    // To insert booked seat (edit booking)
    public static int insertBookedSeat(int bookingId, int seatId) {
        String sql = "INSERT INTO booking_seats (booking_id, seat_id) VALUES (?, ?)";
        Connection conn = null;
        int status = 0;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);
            stmt.setInt(2, seatId);

            status = stmt.executeUpdate();

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return status;
    }

    // To remove booked seat (edit booking)
    public static int removeBookedSeat(int bookingId, int seatId) {
        String sql = "DELETE FROM booking_seats WHERE booking_id = ? AND seat_id ?";
        Connection conn = null;
        int status = 0;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);
            stmt.setInt(2, seatId);

            status = stmt.executeUpdate();

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return status;
    }
}
