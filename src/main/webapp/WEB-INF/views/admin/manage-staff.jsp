<%-- 
    Document   : manage-staff
    Created on : 9 Jun 2025, 12:26:33 am
    Author     : Aiman
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Staff</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Vibur&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="assets/css/styles.css">
        <link rel="stylesheet" href="assets/css/header.css" />
        <link rel="stylesheet" href="assets/css/footer.css" />
    </head>
    <body>
        <jsp:include page="../../includes/header.jsp" flush="true" />

        <div class="container-fluid px-5 my-3 ">
            <c:if test="${error!=null}">
                <div class="alert alert-danger" role="alert">
                    Error occurred: <c:out value="${error}"/>
                </div>
            </c:if>
            <c:if test="${message!=null}">
                <div class="alert alert-success" role="alert">
                    <c:out value="${message}"/>
                </div>
            </c:if>

            <div class="row">
                <div class="col-12">
                    <a href="${pageContext.request.contextPath}/admin"><i class="fa-solid fa-circle-chevron-left fa-xl me-2" style="color: var(--color-light-gold);"></i></a>
                    <h1 class="glow-gold d-inline-block">Manage Staff</h1>
                </div>
                <div class="row">
                    <div class="w-100 mt-3 d-flex justify-content-between flex-wrap gap-2">
                        <c:if test="${not empty staffs}">
                            <div class="col-auto">
                                <form>
                                    <input class="form-control d-inline-block" type="text" name="staff_name" placeholder="--Filter By Name--" value="${param.staff_name != null ? param.staff_name : ''}" style="width:220px">
                                    <input class="btn btn-primary" type="submit" value="Filter">
                                </form>
                            </div>
                        </c:if>
                        <div>

                            <!-- Button trigger modal -->
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                    data-bs-target="#addMovieModal">
                                Add Staff
                            </button>

                            <!-- Modal -->
                            <form action="${pageContext.request.contextPath}/addStaff" method="POST" >
                                <div class="modal fade" id="addMovieModal" tabindex="-1"
                                     aria-labelledby="addMovieModalLabel" aria-hidden="true">
                                    <div class="modal-dialog model-dialog-centered modal-dialog-scrollable scrollbar-gold">
                                        <div class="modal-content bg-dark">
                                            <div class="modal-header">
                                                <h1 class="modal-title fs-5 text-white" id="addMovieModalLabel ">Staff
                                                    Details</h1>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                        aria-label="Close" style="background-color: var(--color-light-gold);"></button>
                                            </div>
                                            <div class="modal-body text-white">


                                                <!-- STAFF NAME -->
                                                <div class="mb-3">
                                                    <label for="staffNameFormControlInput" class="form-label">
                                                        Name</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="staffNameFormControlInput" name="staffName" required>
                                                </div>

                                                <!-- USERNAME -->
                                                <div class="mb-3">
                                                    <label for="staffUsernameFormControlInput" class="form-label">Username</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="staffUsernameFormControlInput" name="staffUsername"  required>
                                                </div>

                                                <!-- PASSWORD -->
                                                <div class="mb-3">
                                                    <label for="staffPasswordFormControlInput" class="form-label">Password</label>
                                                    <input type="password" class="form-control bg-dark text-white"
                                                           id="staffPasswordFormControlInput" name="staffPassword"  required>
                                                </div>

                                                <!-- EMAIL -->
                                                <div class="mb-3">
                                                    <label for="staffEmailFormControlInput" class="form-label">Email</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="staffEmailFormControlInput" name="staffEmail"  required>

                                                </div>
                                                <!-- staff DURATION -->
                                                <div class="mb-3">
                                                    <label for="staffPhoneNoFormControlInput" class="form-label">
                                                        Phone No</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="staffPhoneNoFormControlInput" name="staffPhoneNo"  required>
                                                </div>


                                            </div>
                                            <div class="modal-footer">
                                                <input class="btn btn-warning" type="reset" value="Reset">
                                                <input type="submit" class="btn btn-primary" value="Add Staff">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>                

            </div>


            <c:if test="${not empty staffs}">

                <div class="row my-3 overflow-auto scrollbar-gold">
                    <table class="table table-dark text-white rounded text-center">
                        <thead>
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Name</th>
                                <th scope="col">Username</th>
                                <th scope="col">Email</th>
                                <th scope="col">Phone No</th>
                                <th scope="col">Action</th>
                            </tr>
                        </thead>
                        <tbody class="table-hover table-striped-columns">
                            <c:forEach items="${staffs}" var="staff">
                                <c:if test="${param.staff_name == null || param.staff_name == '' || fn:contains(fn:toLowerCase(staff.name), fn:toLowerCase(param.staff_name)) }">

                                    <tr>
                                        <th scope="row">${staff.id}</th>
                                        <td>${staff.name}</td>
                                        <td>${staff.username}</td>
                                        <td>${staff.email}</td>
                                        <td>${staff.phoneNo}</td>
                                        <td>

                                            <a class="btn btn-danger m-1" href="${pageContext.request.contextPath}/deleteStaff?id=${staff.id}">Delete</a>
                                        </td>
                                    </tr>

                                </c:if>
                            </c:forEach>
                    </table>
                </div>
            </c:if>
            <c:if test="${ empty staffs}">
            <div class="text-center glow-white my-5">NO STAFF EXISTS</div>
            </c:if>
            </div>
            <jsp:include page="../../includes/footer.jsp" flush="true" />

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
        </body>
    </html>
