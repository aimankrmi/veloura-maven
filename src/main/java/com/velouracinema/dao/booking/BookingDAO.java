package com.velouracinema.dao.booking;

import com.velouracinema.dao.payment.PaymentDAO;
import com.velouracinema.model.Booking;
import com.velouracinema.model.Payment;
import com.velouracinema.model.Seat;
import com.velouracinema.util.DBUtil;
import java.sql.*;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Aiman
 */
public class BookingDAO {

    public static List<Booking> getAllBookings() {

        List<Booking> bookings = new ArrayList<>();

        String sql = "SELECT "
                + "b.id AS booking_id,"
                + "b.showtime_id AS showtime_id,"
                + "u.id AS member_id,"
                + "b.booking_date as booking_date,"
                + "b.status AS booking_status,"
                + "p.payment_method AS payment_method,"
                + "p.amount AS payment_amount,"
                + "p.status AS payment_status"
                + " FROM ((bookings b INNER JOIN payments p ON b.id = p.booking_id) INNER JOIN users u ON b.member_id = u.id) WHERE b.status = 'confirmed' OR b.status = 'cancelled';";
        try (Connection conn = DBUtil.getConnection(); Statement stmt = conn.createStatement();) {
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Booking booking = new Booking();
                Payment payment = new Payment();
                booking.setId(rs.getInt("booking_id"));
                booking.setShowtimeId(rs.getInt("showtime_id"));
                booking.setMemberId(rs.getInt("member_id"));
                booking.setBookingDate(rs.getTimestamp("booking_date").toLocalDateTime());
                booking.setStatus(rs.getString("booking_status"));

                payment.setPaymentMethod(rs.getString("payment_method"));
                payment.setStatus(rs.getString("payment_status"));
                payment.setAmount(rs.getDouble("payment_amount"));

                booking.setPayment(payment);

                bookings.add(booking);
            }
        } catch (SQLException ex) {
        }
        return bookings;
    }

    public static Booking getBookingByMemberId(int bookingId, int memberId) {
        String sql = "SELECT * FROM bookings WHERE id = ? AND member_id = ?";
        Connection conn = null;
        Booking booking = new Booking();

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);
            stmt.setInt(2, memberId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                booking.setId(rs.getInt("id"));
                booking.setMemberId(rs.getInt("member_id"));
                booking.setShowtimeId(rs.getInt("showtime_id"));
                booking.setBookingDate(rs.getTimestamp("booking_date").toLocalDateTime());
                booking.setStatus(rs.getString("status"));
            }
            booking.setPayment(PaymentDAO.getPaymentByBookingId(bookingId));
            List<Seat> seats = new ArrayList<>();
            for (Integer seatId : BookingSeatDAO.getBookedSeatByBooking(bookingId)) {
                seats.add(SeatDAO.getSeatById(seatId));
            }
            booking.setSeats(seats);
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return booking;

    }

    public static Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM bookings WHERE id = ?";
        Booking booking = new Booking();

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {

            stmt.setInt(1, bookingId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                booking.setId(rs.getInt("id"));
                booking.setMemberId(rs.getInt("member_id"));
                booking.setShowtimeId(rs.getInt("showtime_id"));
                booking.setBookingDate(rs.getTimestamp("booking_date").toLocalDateTime());
                booking.setStatus(rs.getString("status"));

            }
            booking.setPayment(PaymentDAO.getPaymentByBookingId(bookingId));
            List<Seat> seats = new ArrayList<>();
            for (Integer seatId : BookingSeatDAO.getBookedSeatByBooking(bookingId)) {
                seats.add(SeatDAO.getSeatById(seatId));
            }
            booking.setSeats(seats);
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return booking;

    }

    public static int insertBooking(int memberId, int showtimeId) {
        String sql = "INSERT INTO bookings (member_id, showtime_id, booking_date, expires_at) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        int bookingId = -1;

        ZoneId zoneId = ZoneId.of("Asia/Kuala_Lumpur");
        LocalDateTime now = LocalDateTime.now(zoneId);
        LocalDateTime expiresAt = now.plusMinutes(15);

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, memberId);
            stmt.setInt(2, showtimeId);
            stmt.setTimestamp(3, Timestamp.valueOf(now));
            stmt.setTimestamp(4, Timestamp.valueOf(expiresAt));
            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Inserting booking failed, no rows affected.");
            }

            // Get the generated bookingId
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    bookingId = generatedKeys.getInt(1); // Auto-incremented bookingId
                } else {
                    throw new SQLException("Inserting booking failed, no ID obtained.");
                }
            }

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return bookingId;
    }

    public static LocalDateTime getBookingDateById(int id) {
        String sql = "SELECT booking_date FROM bookings WHERE id = ?";
        Connection conn = null;
        LocalDateTime bookingDate = null;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Timestamp timestamp = rs.getTimestamp("booking_date");
                if (timestamp != null) {
                    bookingDate = timestamp.toLocalDateTime();
                }
            }

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return bookingDate;
    }

    // Update booking status to confirm
    public static int updateBookingStatus(int bookingId) {
        String sql = "UPDATE bookings SET status = 'confirmed' WHERE id = ?";
        int status = 0;

        Connection conn = null;
        try {

            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);

            status = stmt.executeUpdate();
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return status;
    }

    // To list the booking history
    public static List<Booking> getBookingByMemberId(int memberId) {
        String sql = "SELECT * FROM bookings WHERE member_id = ?";
        List<Booking> bookings = new ArrayList<>();

        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setMemberId(rs.getInt("member_id"));
                booking.setShowtimeId(rs.getInt("showtime_id"));
                booking.setStatus(rs.getString("status"));
                booking.setBookingDate(rs.getTimestamp("booking_date").toLocalDateTime());

                booking.setPayment(PaymentDAO.getPaymentByBookingId(rs.getInt("id")));
                List<Seat> seats = new ArrayList<>();
                for (Integer seatId : BookingSeatDAO.getBookedSeatByBooking(rs.getInt("id"))) {
                    seats.add(SeatDAO.getSeatById(seatId));
                }
                booking.setSeats(seats);

                bookings.add(booking);
            }
            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return bookings;
    }

    public static int cancelBookingByBookingId(int bookingId) {

        String sql = "UPDATE bookings SET status = 'cancelled' WHERE id = ?";

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

    public static void setExpiredBooking(int bookingId) {
        String updateBooking = "UPDATE bookings SET status = 'expired' WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement bookStmt = conn.prepareStatement(updateBooking)) {
            bookStmt.setInt(1, bookingId);
            bookStmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static void removePendingBooking() {
        try (Connection conn = DBUtil.getConnection()) {
            String query = "SELECT b.id, b.booking_date, b.status, p.payment_method, p.status as payment_status, s.show_date, s.show_time "
                    + "FROM bookings b "
                    + "JOIN showtimes s ON b.showtime_id = s.id "
                    + "LEFT JOIN payments p ON b.id = p.booking_id "
                    + "WHERE b.status = 'pending'";

            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Kuala_Lumpur"));

            while (rs.next()) {
                String status = rs.getString("payment_status");
                int bookingId = rs.getInt("id");
                LocalDateTime bookingDate = rs.getTimestamp("booking_date").toLocalDateTime();
                String paymentMethod = rs.getString("payment_method");
                LocalDate showDate = rs.getObject("show_date", LocalDate.class);
                LocalTime showTime = rs.getObject("show_time", LocalTime.class);
                LocalDateTime showDateTime = LocalDateTime.of(showDate, showTime);

                boolean expiredBy15Minutes = Duration.between(bookingDate, now).toMinutes() >= 15;
                boolean within3HoursToShow = Duration.between(now, showDateTime).toHours() < 3;

                // Expire booking if it's unpaid and 15 minutes have passed
                if (expiredBy15Minutes) {
                    System.out.println("SUDAH 15 MINIT BERLALU TANPA PILIH JENIS BAYARAN");
                    SeatDAO.setAvailableSeatsByBookingId(bookingId);// 1. Set seats as available
                    PaymentDAO.deletePayment(bookingId);// 2. Delete related payment
                    setExpiredBooking(bookingId); // 3. Mark booking as expired
                } // If within 3 hours of showtime and payment method is counter or not chosen,
                  // expire it
                else if (within3HoursToShow && (paymentMethod == null || paymentMethod.equals("counter"))
                        && status.equals("not_paid")) {
                    System.out.println("BAYAR DI KAUNTER DAN SUDAH KURANG 3 JAM.");
                    SeatDAO.setAvailableSeatsByBookingId(bookingId);// 1. Set seats as available
                    PaymentDAO.deletePayment(bookingId);// 2. Delete related payment
                    setExpiredBooking(bookingId); // 3. Mark booking as expired
                }
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
