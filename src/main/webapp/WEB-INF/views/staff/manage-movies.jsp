<%-- Document : manage-movies Created on : 3 Jun 2025, 6:05:11 pm Author : Aiman --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Movies</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">

        <!-- FOR DATEPICKER -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-alpha3/dist/css/bootstrap.min.css"
              rel="stylesheet">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
        <script
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Vibur&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css" />
    </head>
    <body>

        <jsp:include page="../../includes/header.jsp" flush="true" />

        <div class="container-fluid px-5 my-3 ">
            <div class="row ">
                <div class="col-12">
                    <a href="${pageContext.request.contextPath}/staff"><i class="fa-solid fa-circle-chevron-left fa-xl me-2" style="color: var(--color-light-gold);"></i></a>

                    <h1 class="glow-gold d-inline-block">Manage Movies</h1>
                </div>
                <div class="row">
                    <div class="w-100 mt-3 d-flex justify-content-between flex-wrap gap-2">
                        <div class="col-auto">
                            <form>
                                <input class="form-control d-inline-block" type="text" name="movie_name" placeholder="--Filter By Movie Name--" value="${param.movie_name != null ? param.movie_name : ''}" style="width:220px">
                                <input class="btn btn-primary" type="submit" value="Filter">
                            </form>
                        </div>
                        <div>

                            <!-- Button trigger modal -->
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                    data-bs-target="#addMovieModal">
                                Add Movies
                            </button>

                            <!-- Modal -->
                            <form action="${pageContext.request.contextPath}/addMovie" method="POST" enctype="multipart/form-data">
                                <div class="modal fade" id="addMovieModal" tabindex="-1"
                                     aria-labelledby="addMovieModalLabel" aria-hidden="true">
                                    <div class="modal-dialog model-dialog-centered modal-dialog-scrollable scrollbar-gold">
                                        <div class="modal-content bg-dark">
                                            <div class="modal-header">
                                                <h1 class="modal-title fs-5 text-white" id="addMovieModalLabel ">Movie
                                                    Details</h1>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                        aria-label="Close" style="background-color: var(--color-light-gold);"></button>
                                            </div>
                                            <div class="modal-body text-white">


                                                <!-- MOVIE NAME -->
                                                <div class="mb-3">
                                                    <label for="movieNameFormControlInput1" class="form-label">
                                                        Title</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="movieNameFormControlInput1" name="movieTitle" required autocomplete="off">
                                                </div>

                                                <!-- GENRE -->
                                                <div class="mb-3">
                                                    <label class="form-label">Genre</label>
                                                    <c:forTokens items="Action,Sci-Fi,Crime,Drama,Horror,Mystery,Adventure,Animation,Comedy,Fantasy,Romance,Thriller,Documentary,Family,War,Musical" delims="," var="genre">
                                                        <div class="form-check">
                                                            <input class="form-check-input" type="checkbox" name="genre"
                                                                   value="${fn:toLowerCase(genre)}" id="${genre}-genre-input">
                                                            <label class="form-check-label" for="${genre}-genre-input">
                                                                ${genre}
                                                            </label>
                                                        </div>
                                                    </c:forTokens>
                                                </div>
                                                <br>
                                                <!-- Language -->
                                                <div class="mb-3">

                                                    <label class="form-label">Language</label>
                                                    <c:forTokens items="English,Malay,Mandarin,German,Italian,Russian,Hindi,Korean,Japanese,France,Spanish,Arabic" delims="," var="language">
                                                        <div class="form-check">
                                                            <input class="form-check-input " type="radio" name="language" 
                                                                   id="radio${language}" value="${fn:toLowerCase(language)}" ${language eq "English" ? "checked" : ""}>
                                                            <label class="form-check-label" for="radio${language}">
                                                                ${language}
                                                            </label>
                                                        </div>
                                                    </c:forTokens>
                                                </div>
                                                <br>
                                                <!-- MOVIE DURATION -->
                                                <div class="mb-3">
                                                    <label for="movieDurationFormControlInput1" class="form-label">
                                                        Duration</label>
                                                    <input type="number" name="duration" class="form-control bg-dark text-white" min="0"
                                                           max="240" id="movieDurationFormControlInput1" autocomplete="off" required>
                                                </div>

                                                <br>
                                                <!-- MOVIE PRICE -->
                                                <div class="mb-3">
                                                    <label for="moviePriceFormControlInput1" class="form-label ">
                                                        Price</label>
                                                    <input type="number" name="price" class="form-control bg-dark text-white" min="0"
                                                           step="0.01" id="moviePriceFormControlInput1" autocomplete="off" required>
                                                </div>

                                                <br>

                                                <br>
                                                <!-- MOVIE DESCRIPTION -->
                                                <div class="mb-3">
                                                    <label for="descriptionFormControlTextarea1"
                                                           class="form-label">Description</label>
                                                    <textarea class="form-control bg-dark text-white" id="descriptionFormControlTextarea1"
                                                              name="description" rows="3"></textarea>
                                                </div>

                                                <br>
                                                <!-- MOVIE IMAGE PATH -->
                                                <div class="mb-3">
                                                    <!--                                                    <label for="movieImagePathFormControlInput1"
                                                                                                               class="form-label">Image Path
                                                                                                        </label>
                                                                                                        <input type="text" class="form-control bg-dark text-white"
                                                                                                               id="movieImagePathFormControlInput1" name="imagePath" autocomplete="off" required>-->
                                                    <label for="movieImagePathFormControlInput1"
                                                           class="form-label">Image
                                                    </label>
                                                    <input type="file" class="form-control bg-dark text-white"
                                                           id="movieImagePathFormControlInput1" name="image" autocomplete="off" required>
                                                </div>

                                                <br>
                                                <!-- MOVIE RELEASE DATE -->
                                                <div class="mb-3">
                                                    <label for="date" class="col-sm-2 col-form-label ">Release Date</label>
                                                    <div class="col-12">
                                                        <div class="input-group date" id="datepicker">
                                                            <input type="text" class="form-control bg-dark text-white" name="releaseDate" autocomplete="off">
                                                            <span class="input-group-append">
                                                                <span class="input-group-text bg-white d-block">
                                                                    <i class="fa fa-calendar"></i>
                                                                </span>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                            <div class="modal-footer">
                                                <input class="btn btn-warning" type="reset" value="Reset">
                                                <input type="submit" class="btn btn-primary" value="Add Movie">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>
            </div>

            <div class="row my-3 overflow-auto scrollbar-gold">
                <table class="table table-dark text-white rounded ">
                    <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Title</th>
                            <th scope="col">Genre</th>
                            <th scope="col">Language</th>
                            <th scope="col">Duration</th>
                            <th scope="col">Description</th>
                            <th scope="col">Price</th>
                            <th scope="col">Image Path</th>
                            <th scope="col">Release Date</th>
                            <th scope="col">Action</th>
                        </tr>
                    </thead>
                    <tbody class="table-hover table-striped-columns">
                        <c:forEach items="${movies}" var="movie">
                            <c:if test="${param.movie_name == null || param.movie_name == '' || fn:contains(fn:toLowerCase(movie.title), fn:toLowerCase(param.movie_name)) }">

                                <tr>
                                    <th scope="row">${movie.movieId}</th>
                                    <td>${movie.title}</td>
                                    <td class="text-capitalize">${movie.genre}</td>
                                    <td class="text-capitalize">${movie.language}</td>
                                    <td>${movie.duration}</td>
                                    <td>${movie.description}</td>
                                    <td>${movie.price}</td>
                                    <td>${movie.imagePath}</td>
                                    <td>${movie.releaseDate}</td>
                                    <td>

                                        <!-- Button trigger modal -->
                                        <button type="button" class="btn btn-primary m-1" data-bs-toggle="modal"
                                                data-bs-target="#editMovie${movie.movieId}Modal">
                                            Edit Movies
                                        </button>

                                        <!-- Modal -->
                                        <form action="${pageContext.request.contextPath}/editMovie" method="POST"  enctype="multipart/form-data">
                                            <input type="hidden" name="movieId" value="${movie.movieId}">
                                            <div class="modal fade" id="editMovie${movie.movieId}Modal" tabindex="-1"
                                                 aria-labelledby="editMovie${movie.movieId}ModalLabel" aria-hidden="true">
                                                <div class="modal-dialog model-dialog-centered modal-dialog-scrollable">
                                                    <div class="modal-content bg-dark">
                                                        <div class="modal-header">
                                                            <h1 class="modal-title fs-5 text-white" id="editMovie${movie.movieId}ModalLabel ">Movie
                                                                Details</h1>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                                    aria-label="Close" style="background-color: var(--color-light-gold);"></button>
                                                        </div>
                                                        <div class="modal-body text-white">


                                                            <!-- MOVIE NAME -->
                                                            <div class="mb-3">
                                                                <label for="movieNameFormControlInput1" class="form-label">
                                                                    Title</label>
                                                                <input type="text" class="form-control bg-dark text-white"
                                                                       id="movieNameFormControlInput1" name="movieTitle" value="<c:out value='${movie.title}'/>" autocomplete="off" required>
                                                            </div>

                                                            <!-- GENRE -->
                                                            <label class="form-label">Genre</label>
                                                            <div class="mb-3">
                                                                <c:forTokens items="Action,Sci-Fi,Crime,Drama,Horror,Mystery,Adventure,Animation,Comedy,Fantasy,Romance,Thriller,Documentary,Family,War,Musical" delims="," var="genre">
                                                                    <div class="form-check">

                                                                        <input class="form-check-input" type="checkbox" name="genre"
                                                                               value="${fn:toLowerCase(genre)}" id="${genre}-genre-input" ${fn:contains(fn:toLowerCase(movie.genre), fn:toLowerCase(genre) ) ? "checked" : ""}
                                                                               >
                                                                        <label class="form-check-label" for="${genre}-genre-input">
                                                                            ${genre}
                                                                        </label>
                                                                    </div>
                                                                </c:forTokens>
                                                            </div>
                                                            <!-- Language -->
                                                            <div class="mb-3">
                                                                <label class="form-label">Language</label>
                                                                <c:forTokens items="English,Malay,Mandarin,German,Italian,Russian,Hindi,Korean,Japanese,France,Spanish,Arabic" delims="," var="language">
                                                                    <div class="form-check">
                                                                        <input class="form-check-input " type="radio" name="language" 
                                                                               id="radio${language}" value="${fn:toLowerCase(language)}" ${fn:toLowerCase(language) eq fn:toLowerCase(movie.language) ? "checked" : ""}>
                                                                        <label class="form-check-label" for="radio${language}">
                                                                            ${language}
                                                                        </label>
                                                                    </div>
                                                                </c:forTokens>

                                                            </div>
                                                            <!-- MOVIE DURATION -->
                                                            <div class="mb-3">
                                                                <label for="movieDurationFormControlInput1" class="form-label">
                                                                    Duration</label>
                                                                <input type="number" name="duration" class="form-control bg-dark text-white" min="0"
                                                                       max="240" id="movieDurationFormControlInput1"value="<c:out value='${movie.duration}'/>" autocomplete="off" required>
                                                            </div>

                                                            <!-- MOVIE PRICE -->
                                                            <div class="mb-3">
                                                                <label for="moviePriceFormControlInput1" class="form-label">
                                                                    Price</label>
                                                                <input type="number" name="price" class="form-control bg-dark text-white " min="0"
                                                                       step="0.01" id="moviePriceFormControlInput1" value="<c:out value='${movie.price}'/>" autocomplete="off" required>
                                                            </div>


                                                            <!-- MOVIE DESCRIPTION -->
                                                            <div class="mb-3">
                                                                <label for="descriptionFormControlTextarea1"
                                                                       class="form-label">Description</label>
                                                                <textarea class="form-control bg-dark text-white" id="descriptionFormControlTextarea1"
                                                                          name="description"  rows="3"><c:out value='${movie.description}'/></textarea>
                                                            </div>

                                                            <!-- MOVIE IMAGE PATH -->
                                                            <div class="mb-3">
                                                                <input type="hidden"  name="oldImage" value="<c:out value='${movie.imagePath}'/>">
                                                                <label for="movieImagePathFormControlInput1"
                                                                       class="form-label">Image
                                                                </label>
                                                                <input type="file" class="form-control bg-dark text-white"
                                                                       id="movieImagePathFormControlInput1" name="image" >
                                                            </div>

                                                            <br>
                                                            <!-- MOVIE RELEASE DATE -->
                                                            <!-- Parse the date from the form input -->
                                                            <fmt:parseDate var="parsedReleaseDate" value="${movie.releaseDate}" pattern="yyyy-MM-dd" />

                                                            <!-- Format the parsed date into the desired format  -->
                                                            <fmt:formatDate var="formattedReleaseDate" value="${parsedReleaseDate}" pattern="MM/dd/yyyy" />
                                                            <div class="mb-3">
                                                                <label for="date" class="col-sm-2 col-form-label ">Release Date</label>
                                                                <div class="col-12">
                                                                    <div class="input-group date" id="datepicker<c:out value='${movie.movieId}'/>">
                                                                        <input type="text" class="form-control bg-dark text-white" name="releaseDate" value="${formattedReleaseDate}" autocomplete="off">
                                                                        <span class="input-group-append">
                                                                            <span class="input-group-text bg-white d-block">
                                                                                <i class="fa fa-calendar"></i>
                                                                            </span>
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                        </div>
                                                        <div class="modal-footer">
                                                            <input type="submit" class="btn btn-primary" value="Save changes">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>




                                        <a class="btn btn-danger m-1" href="${pageContext.request.contextPath}/deleteMovie?id=${movie.movieId}">Delete</a>
                                    </td>
                                </tr>

                            </c:if>
                        </c:forEach>
                </table>
            </div>



        </div>


        <jsp:include page="../../includes/footer.jsp" flush="true" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript">
            $(function () {
            <c:forEach items="${movies}" var="movie">
                $('#datepicker${movie.movieId}').datepicker();
            </c:forEach>
                $('#datepicker').datepicker();
            });
        </script>
    </body>
</html>