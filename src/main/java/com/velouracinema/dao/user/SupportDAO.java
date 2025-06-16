
package com.velouracinema.dao.user;

import com.velouracinema.model.SupportRequest;
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
public class SupportDAO {

    public static List<SupportRequest> getAllSupports() {
        String sql = "SELECT * FROM support";
        List<SupportRequest> supports = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                SupportRequest support = new SupportRequest();
                support.setId(rs.getInt("id"));
                support.setName(rs.getString("name"));
                support.setEmail(rs.getString("email"));
                support.setIssueType(rs.getString("issue_type"));
                support.setMessage(rs.getString("message"));
                support.setReviewStatus(rs.getString("review_status"));
                support.setSubmittedAt(rs.getTimestamp("submitted_at").toLocalDateTime());
                supports.add(support);
            }
        } catch (SQLException ex) {
            Logger.getLogger(SupportDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return supports;
    }

    public static SupportRequest getSupportById(int id) {
        String sql = "SELECT * FROM support WHERE id = ?";
        SupportRequest support = new SupportRequest();

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                support.setId(rs.getInt("id"));
                support.setName(rs.getString("name"));
                support.setEmail(rs.getString("email"));
                support.setIssueType(rs.getString("issue_type"));
                support.setMessage(rs.getString("message"));
                support.setReviewStatus(rs.getString("review_status"));
                support.setSubmittedAt(rs.getTimestamp("submitted_at").toLocalDateTime());
            }
        } catch (SQLException ex) {
            Logger.getLogger(SupportDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return support;
    }

    public static boolean submitSupport(SupportRequest support) {
        String sql = "INSERT INTO support (name, email, issue_type, message) VALUES (?, ?, ?, ?)";
        boolean status = false;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {

            stmt.setString(1, support.getName());
            stmt.setString(2, support.getEmail());
            stmt.setString(3, support.getIssueType());
            stmt.setString(4, support.getMessage());
            status = stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static boolean updateStatus(int id, String ticketStatus) {
        String sql = "UPDATE support SET "
                + "review_status = ? "
                + "WHERE id = ?";
        boolean status = false;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {

            stmt.setString(1, ticketStatus);
            stmt.setInt(2, id);
            status = stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static boolean deleteSupport(int id) {
        String sql = "DELETE FROM support WHERE id = ?";
        boolean status = false;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {

            stmt.setInt(1, id);
            status = stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

}
