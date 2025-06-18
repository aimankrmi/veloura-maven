<%-- 
    Document   : homepage
    Created on : 26 May 2025, 1:00:35?pm
    Author     : sitif
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Veloura Cinema</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Vibur&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/styles.css">
        <link rel="stylesheet" href="assets/css/header.css"/>
        <link rel="stylesheet" href="assets/css/footer.css"/>
        <link rel="stylesheet" href="assets/css/movie.css">
    </head>

    <body>
        <!-- Intro Container -->
        <div id="intro-container">
            <h1>Veloura Cinema</h1>
            <p>Experience Like Never Before</p>
        </div>

        <!-- Main Content -->
        <div id="main-content">
            <jsp:include page="includes/header.jsp" flush="true" />

            <!-- Hero Section -->
            <section class="hero-section px-3 pt-4 pb-5">
                <div class="carousel-container">
                    <img
                        src="assets/images/LFD.jpg"
                        alt="Valoura Cinema Image"
                        id="carousel-image"
                        />
                </div>
            </section>

            <div class="hero-intro">
                Experience movies like never before
            </div>

            <div class="row py-4 homepage-container flex-wrap">
                <div class="col-md-6 col-12 col-sm-12">

                    <!-- Now Showing Custom Scroll Carousel -->
                    <h3 class="glow-gold mb-3">Now Showing</h3><br/>
                    <div class="neon-legend-box" id="nowShowingContainer">
                        <div class="movie-scroll-wrapper">
                            <c:forEach var="movie" items="${movies}">
                                <c:if test="${movie.status eq 'Ongoing'}">
                                    <div class="movie-card">
                                        <img
                                            src="${pageContext.request.contextPath}/assets/images/${movie.imagePath}"
                                            alt="${movie.title} Poster"
                                            />
                                        <div class="movie-info  text-capitalize">
                                            <div class="details text-wrap">
                                                Genre: ${movie.genre}<br />
                                                Duration: ${movie.hours} hr ${movie.minutes} mins
                                                <br />
                                                Language: ${movie.language}<br />
                                                Subtitle: English, Malay
                                            </div>
                                            <a
                                                class="btn btn-primary"
                                                href="${pageContext.request.contextPath}/booking?id=${movie.movieId}"
                                                >Buy Now</a
                                            >
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-12 col-sm-12">

                    <!-- Now Showing Custom Scroll Carousel -->
                    <h3 class="glow-gold mb-3">Coming Soon</h3><br/>
                    <div class="neon-legend-box" id="nowShowingContainer">
                        <div class="movie-scroll-wrapper">
                            <c:forEach var="movie" items="${movies}">
                                <c:if test="${movie.status eq 'Coming Soon'}">

                                    <div class="movie-card">
                                        <img
                                            src="${pageContext.request.contextPath}/assets/images/${movie.imagePath}"
                                            alt="${movie.title} Poster"
                                            />
                                        <div class="movie-info text-capitalize">
                                            <div class="details">
                                                Genre: ${movie.genre}<br />
                                                Duration: ${movie.hours} hr ${movie.minutes} mins
                                                <br />
                                                Language: ${movie.language}<br />
                                                Subtitle: English, Malay
                                            </div>
                                            <a
                                                class="btn btn-primary"
                                                href="${pageContext.request.contextPath}/booking?id=${movie.movieId}"
                                                >Buy Now</a
                                            >
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Top 5 Ranking Section -->
            <!-- Top 10 Ranking Section -->
            <section class="top-movies-section container mb-5">
                <h2 class="glow-gold mb-4">Top 10 Movies</h2>

                <div class="row">
                    <c:forEach items="${topMovies}" var="topMovie" varStatus="status">
                        <div class="col-md-6 col-12 col-sm-12 movie-rank">
                            <span class="glow-white">${status.index +1}</span> ${topMovie.movie.title}
                            <span class="badge ${topMovie.movie.status == "Ongoing" ? "now" : "coming"}">${topMovie.movie.status}</span>
                        </div>
                    </c:forEach>
            </section>

            <jsp:include page="includes/footer.jsp" flush="true" />
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                setTimeout(() => {
                    document.body.classList.add('intro-complete');
                }, 6000); // 6 seconds for intro animation

                document.querySelectorAll('.star-rating').forEach((star) => {
                    const rating = parseFloat(star.getAttribute('data-rating'));
                    const percent = (Math.min(rating, 5) / 5) * 100;
                    star.style.setProperty('--percent', `${percent}%`);
                });
            });

            function scrollMovies(direction) {
                const container = document.querySelector('.movie-scroll-wrapper');
                const scrollAmount =
                        container.querySelector('.movie-card').offsetWidth + 20;
                container.scrollBy({
                    left: direction * scrollAmount,
                    behavior: 'smooth',
                });
            }

            // Carousel image switcher
            const carouselImage = document.getElementById("carousel-image");
            let currentIndex = 0;
            let images = ["LLS.jpg", "LMI.jpg", "LT.jpg", "LFD.jpg", "LBB.jpg"];

            setInterval(() => {

                console.log("2" + images);
                currentIndex = (currentIndex + 1) % images.length;
                carouselImage.src = `assets/images/\${images[currentIndex]}`;
                currentIndex++;
            }, 4000); // switch image every 4 seconds
        </script>

    </body>
</html>