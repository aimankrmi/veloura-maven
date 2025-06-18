
package com.velouracinema.model;

import com.velouracinema.util.Utils;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Aiman
 */
public class Showtime implements java.io.Serializable {

    private int id;
    private String showDate;
    private String showTime;
    private String screen;
    private Movie movie;
    List<Seat> seats = new ArrayList<>();

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }

    public String getFormattedShowDate() {
        return Utils.formatDate(this.showDate);
    }

    public String getFormattedShowTime() {
        return Utils.formatTime(this.showTime);
    }

    public String getShowDate() {
        return showDate;
    }

    public void setShowDate(String showDate) {
        this.showDate = showDate;
    }

    public String getShowTime() {
        return showTime;
    }

    public void setShowTime(String showTime) {
        this.showTime = showTime;
    }

    public String getScreen() {
        return screen;
    }

    public void setScreen(String screen) {
        this.screen = screen;
    }

    public List<Seat> getSeats() {
        return seats;
    }

    public void setSeats(List<Seat> seats) {
        this.seats = seats;
    }

    public boolean isUpcoming() {

        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

        try {
            LocalDate date = LocalDate.parse(showDate, dateFormatter);
            LocalTime time = LocalTime.parse(showTime, timeFormatter);
            LocalDateTime showDateTime = LocalDateTime.of(date, time);

            return showDateTime.isAfter(LocalDateTime.now(ZoneId.of("Asia/Kuala_Lumpur")));
        } catch (Exception e) {
            return false;
        }
    }

}
