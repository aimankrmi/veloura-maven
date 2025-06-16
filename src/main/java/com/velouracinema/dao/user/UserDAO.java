
package com.velouracinema.dao.user;

import com.velouracinema.model.User;
import com.velouracinema.util.DBUtil;
import com.velouracinema.util.Utils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Aiman
 */
public class UserDAO {

    public static User getUser(String username, String password) {
        User user = new User();
        Connection conn = null;
        String sql = "SELECT * FROM users WHERE username=? AND password=? ";

        try {

            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setPhoneNo(rs.getString("phone_no"));
            }

            conn.close();

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return user;
    }

    public static User getUserById(int id) {
        User user = new User();
        Connection conn = null;
        String sql = "SELECT * FROM users WHERE id=? ";

        try {

            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setPhoneNo(rs.getString("phone_no"));
            }

            conn.close();

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return user;
    }

    public static int registerUser(User user) {

        String sql = "INSERT INTO users (name, username, email, password, role, phone_no) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        int status = 0;
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, Utils.SHA256Hash(user.getPassword()));
            stmt.setString(5, user.getRole());
            stmt.setString(6, user.getPhoneNo());

            status = stmt.executeUpdate();

            conn.close();

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return status;
    }

    public static int updateUser(User user) {
        String sql;
        if (user.getPassword() != null) {
            sql = "UPDATE users SET "
                    + "name = ?,"
                    + "username = ?,"
                    + "password = ?,"
                    + "email = ?,"
                    + "phone_no = ?"
                    + "WHERE id=? AND role=?";
        } else {
            sql = "UPDATE users SET "
                    + "name = ?,"
                    + "username = ?,"
                    + "email = ?,"
                    + "phone_no = ?"
                    + "WHERE id=? AND role=?";
        }

        Connection conn = null;
        int status = 0;
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getUsername());
            if (user.getPassword() != null) {
                stmt.setString(3, user.getPassword());
                stmt.setString(4, user.getEmail());
                stmt.setString(5, user.getPhoneNo());
                stmt.setInt(6, user.getId());
                stmt.setString(7, user.getRole());
            } else {
                stmt.setString(3, user.getEmail());
                stmt.setString(4, user.getPhoneNo());
                stmt.setInt(5, user.getId());
                stmt.setString(6, user.getRole());
            }

            status = stmt.executeUpdate();

            conn.close();

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return status;
    }

    public static int deleteUserById(int id, String role) {

        String sql = "DELETE FROM users WHERE id = ? AND role = ?";

        Connection conn = null;
        int status = 0;
        try {
            conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.setString(2, role);

            status = stmt.executeUpdate();

            conn.close();

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return status;
    }

    public static boolean isEmailUsed(String email) {
        boolean used = false;

        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                used = true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return used;
    }

    public static boolean isUsernameUsed(String username) {
        boolean used = false;

        String sql = "SELECT * FROM users WHERE username = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                used = true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return used;
    }

    public static List<User> getStaffs() {
        List<User> staffs = new ArrayList<>();

        String sql = "SELECT * FROM users WHERE role='staff'";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User staff = new User();

                staff.setId(rs.getInt("id"));
                staff.setName(rs.getString("name"));
                staff.setUsername(rs.getString("username"));
                staff.setEmail(rs.getString("email"));
                staff.setPhoneNo(rs.getString("phone_no"));

                staffs.add(staff);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return staffs;
    }

    public static List<User> getMembers() {
        List<User> members = new ArrayList<>();

        String sql = "SELECT * FROM users WHERE role='member'";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User member = new User();

                member.setId(rs.getInt("id"));
                member.setName(rs.getString("name"));
                member.setUsername(rs.getString("username"));
                member.setEmail(rs.getString("email"));
                member.setPhoneNo(rs.getString("phone_no"));

                members.add(member);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return members;
    }
}
