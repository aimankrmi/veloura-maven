
package com.velouracinema.dao.payment;

import com.velouracinema.model.Payment;
import com.velouracinema.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Aiman
 */
public class PaymentDAO {

    public static Payment getPaymentByBookingId(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id = ?";
        Connection conn = null;
        Payment payment = new Payment();

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                payment.setId(rs.getInt("id"));
                payment.setBookingId(rs.getInt("booking_id"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentDate(rs.getDate("payment_date"));
                payment.setStatus(rs.getString("status"));
                payment.setPaymentMethod(rs.getString("payment_method"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return payment;
    }

    public static int updatePaymentMethod(int bookingId, String paymentMethod) {
        String sql = "UPDATE payments SET payment_method = ? WHERE booking_id = ?";

        Connection conn = null;
        int status = 0;
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, paymentMethod);
            stmt.setInt(2, bookingId);
            status = stmt.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return status;
    }

    public static int insertPayment(int bookingId, double amount) {
        String sql = "INSERT INTO payments (booking_id, amount) VALUES (?, ?);";
        Connection conn = null;
        int paymentId = -1;

        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, bookingId);
            stmt.setDouble(2, amount);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Inserting payment failed, no rows affected.");
            }

            // Get the generated bookingId
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    paymentId = generatedKeys.getInt(1); // Auto-incremented bookingId
                } else {
                    throw new SQLException("Inserting payment failed, no ID obtained.");
                }
            }

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return paymentId;
    }

    public static int updateStatusSuccess(int bookingID) {
        String sql = "UPDATE payments SET status = 'paid' WHERE booking_id = ?";
        int status = 0;

        Connection conn = null;
        try {

            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookingID);

            status = stmt.executeUpdate();

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return status;
    }

    public static int updatePaymentStatus(int bookingID, String paymentStatus) {
        String sql = "UPDATE payments SET status = ? WHERE booking_id = ?";
        int status = 0;

        Connection conn = null;
        try {

            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, paymentStatus);
            stmt.setInt(2, bookingID);

            status = stmt.executeUpdate();

            conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return status;
    }

    // Delete related payment
    public static void deletePayment(int bookingId) {
        String deletePayment = "DELETE FROM payments WHERE booking_id = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement payStmt = conn.prepareStatement(deletePayment)) {
            payStmt.setInt(1, bookingId);
            payStmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
