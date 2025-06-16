
package com.velouracinema.util;

import com.velouracinema.model.User;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Month;
import java.time.format.DateTimeFormatter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Aiman
 */
public class Utils {
    // public class TimeCalculator {

    private Utils() {
    }

    public static boolean authorizeUser(HttpServletRequest request, HttpServletResponse response, String role) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getId() == 0 || user.getRole() == null || !user.getRole().equals(role)) {
            return false;
        }
        return true;

    }

    public static String SHA256Hash(String input) {
        try {
            // Create a MessageDigest instance for SHA-256
            MessageDigest digest = MessageDigest.getInstance("SHA-256");

            // Perform the hash computation
            byte[] encodedhash = digest.digest(input.getBytes());

            // Convert byte array into a hexadecimal string
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedhash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    public static int calcDurationHours(int totalMinutes) {
        int hours = totalMinutes / 60; // Calculate hours
        return hours;
    }

    public static int calcDurationMinutes(int totalMinutes) {
        int minutes = totalMinutes % 60; // Calculate hours
        return minutes;
    }

    public static String capitalize(String str) {
        return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }

    public static String formatDate(String str) {
        try {
            LocalDate formattedDate = LocalDate.parse(str);
            // Get day from date
            int day = formattedDate.getDayOfMonth();

            // Get month from date
            Month month = formattedDate.getMonth();

            // Get year from date
            int year = formattedDate.getYear();

            String dayString = formattedDate.getDayOfWeek().toString();
            return String.valueOf(day) + " " + Utils.capitalize(month.toString()) + " " + String.valueOf(year) + " ("
                    + Utils.capitalize(dayString) + ")";
        } catch (NullPointerException ex) {
        }
        return "";
    }

    public static String formatTime(String str) {
        LocalTime time = LocalTime.parse(str);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("h:mm a");
        return time.format(formatter);

    }
}
