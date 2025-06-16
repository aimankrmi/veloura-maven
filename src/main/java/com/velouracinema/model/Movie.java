package com.velouracinema.model;

import com.velouracinema.util.Utils;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class Movie implements java.io.Serializable {

    private int movieId;
    private String title;
    private String genre;
    private int duration;
    private String description;
    private String language;
    private double price;
    private String imagePath;
    private Date releaseDate;
    private final int expiredDay = 14;

    // Getters and Setters
    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public int getHours() {
        return Utils.calcDurationHours(this.duration);
    }

    public int getMinutes() {
        return Utils.calcDurationMinutes(this.duration);
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {

        this.releaseDate = releaseDate;
    }

    // Method to assign the release date from the string input
    public void setReleaseDateFromString(String releaseDateString) {
        // Define the input format: dd/MM/yyyy
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy");

        // Parse the string to LocalDate
        LocalDate localDate = LocalDate.parse(releaseDateString, formatter);

        // Convert LocalDate to java.sql.Date (this matches the format MySQL expects)
        this.releaseDate = Date.valueOf(localDate);
    }

    public String getStatus() {
        // return releaseDate.toLocalDate().isAfter(LocalDate.now()) ? "Coming Soon" :
        // "On Going";

        LocalDate today = LocalDate.now();
        LocalDate release = releaseDate.toLocalDate(); // Convert sql.Date to LocalDate

        if (today.isBefore(release)) {
            return "Coming Soon";
        } else if (today.isBefore(release.plusDays(expiredDay - 1))) {
            return "Ongoing";
        } else {
            return "Expired";
        }

    }

    // To get for 4 days after today
    public List<String> getAvailableDates() {

        List<String> availableDates = new ArrayList<>();

        if (getStatus().equalsIgnoreCase("Ongoing")) {

            LocalDate todayDate = LocalDate.now();
            LocalDate lastDate = LocalDate.now().plusDays(3);

            for (LocalDate availableDate = todayDate; !availableDate.isAfter(lastDate); availableDate = availableDate
                    .plusDays(1)) {

                availableDates.add(availableDate.toString());
            }

        }
        return availableDates;
    }

}
