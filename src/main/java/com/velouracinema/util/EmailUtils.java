package com.velouracinema.util;

import com.velouracinema.dao.booking.ShowtimeDAO;
import com.velouracinema.model.Booking;
import com.velouracinema.model.Seat;
import com.velouracinema.model.SupportRequest;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author Aiman
 */
public class EmailUtils {

    private static final String EMAIL_FROM = System.getenv("USER EMAIL");
    private static final String APP_PASSWORD = System.getenv("PASS_EMAIL");

    public static void sendEmailBookingConfirm(Booking booking, String recipientEmail) {

        String subject = "Booking Confirmation for "
                + ShowtimeDAO.getShowtimeById(booking.getShowtimeId()).getMovie().getTitle();

        String formattedDate = ShowtimeDAO.getShowtimeById(booking.getShowtimeId()).getFormattedShowDate();
        String formattedTime = ShowtimeDAO.getShowtimeById(booking.getShowtimeId()).getFormattedShowTime();

        String seatListString = booking.getSeats().stream()
                .map(Seat::getSeatNumber)
                .collect(Collectors.joining(", "));

        String htmlBody = """
                <h2 style="color: #2e4053;">Veloura Cinema Web Booking Confirmation</h2>
                <h4>Thank you for your booking!</h4>

                <table border="1" cellpadding="10" cellspacing="0" style="border-collapse: collapse; font-family: Arial, sans-serif; font-size: 14px;">
                    <tr>
                        <th align="left">Booking ID</th>
                        <td>%s</td>
                    </tr>
                    <tr>
                        <th align="left">Booking Date</th>
                        <td>%s</td>
                    </tr>
                    <tr>
                        <th align="left">Movie</th>
                        <td>%s</td>
                    </tr>
                    <tr>
                        <th align="left">Date</th>
                        <td>%s</td>
                    </tr>
                    <tr>
                        <th align="left">Time</th>
                        <td>%s</td>
                    </tr>
                    <tr>
                        <th align="left">Hall</th>
                        <td>%s</td>
                    </tr>
                    <tr>
                        <th align="left">Seat</th>
                        <td>%s</td>
                    </tr>
                    <tr>
                        <th align="left">Total Payment</th>
                        <td>RM %.2f</td>
                    </tr>
                </table>

                <p style="margin-top: 20px;">We look forward to seeing you.
                """
                .formatted(
                        booking.getId(),
                        booking.getBookingDateFormatted(),
                        ShowtimeDAO.getShowtimeById(booking.getShowtimeId()).getMovie().getTitle(),
                        formattedDate, // e.g. "Monday, 15 April 2024"
                        formattedTime, // e.g. "08:00 PM"
                        ShowtimeDAO.getShowtimeById(booking.getShowtimeId()).getScreen(), // or "Hall A"
                        seatListString, // e.g. "A1, A2"
                        booking.getPayment().getAmount());

        if (booking.getPayment().getPaymentMethod().equals("counter")) {
            htmlBody += "Please pay at the counter prior 3 hours before showtime to avoid cancellation.</p>";
        } else {
            htmlBody += "Please show this email at the entrance.</p>";
        }

        sendEmail(recipientEmail, subject, htmlBody);

    }

    public static void sendSupportResponseEmail(SupportRequest request, String staffReply) {

        String subject = "Response to Your Support Request";

        String htmlBody = """
                    <h2>Support Response from Veloura Cinema</h2>

                    <p>Dear %s,</p>
                    <p>Thank you for contacting us regarding the issue below:</p>

                    <table border="1" cellpadding="10" cellspacing="0" style="border-collapse: collapse; font-family: Arial, sans-serif; font-size: 14px;">
                        <tr>
                            <th align="left">Name</th>
                            <td>%s</td>
                        </tr>
                        <tr>
                            <th align="left">Email</th>
                            <td>%s</td>
                        </tr>
                        <tr>
                            <th align="left">Issue Type</th>
                            <td>%s</td>
                        </tr>
                        <tr>
                            <th align="left">Message</th>
                            <td>%s</td>
                        </tr>
                    </table>

                    <h4 style="margin-top: 20px;">Our Response:</h4>
                    <p>%s</p>

                    <p style="margin-top: 30px;">If you need further help, feel free to reply to this email.</p>
                    <p>Best regards,<br>Veloura Cinema Support Team</p>
                """
                .formatted(
                        request.getName(),
                        request.getName(),
                        request.getEmail(),
                        request.getIssueType(),
                        request.getMessage().replace("\n", "<br>"),
                        staffReply.replace("\n", "<br>"));

        sendEmail(request.getEmail(), subject, htmlBody);
    }

    private static void sendEmail(String to, String subject, String htmlContent) {
        try {
            Message message = new MimeMessage(getEmailSession());
            message.setFrom(new InternetAddress(EMAIL_FROM));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
        } catch (AddressException ex) {
            Logger.getLogger(EmailUtils.class.getName()).log(Level.SEVERE, null, ex);
        } catch (MessagingException ex) {
            Logger.getLogger(EmailUtils.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    private static Session getEmailSession() {
        return Session.getInstance(getGmailProperties(), new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM, APP_PASSWORD);
            }
        });
    }

    private static Properties getGmailProperties() {
        Properties prop = new Properties();
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        return prop;
    }

}
