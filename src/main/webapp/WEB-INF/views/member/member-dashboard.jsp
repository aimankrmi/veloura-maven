<%-- 
    Document   : member-dashboard
    Created on : 3 Jun 2025, 3:41:44 pm
    Author     : Aiman
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Member</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link
            href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Vibur&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="assets/css/styles.css">
        <link rel="stylesheet" href="assets/css/header.css"/>
        <link rel="stylesheet" href="assets/css/footer.css"/>
    </head>
    <body>
        <jsp:include page="../../includes/header.jsp" flush="true"/>


        <div class="container py-5">
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
            <h1 class="glow-gold display-4 mb-4" style="text-align: left;">Welcome ${member.name},</h1>
            <p class="lead"> Here's your profile.</p>
            <div class="row g-4 mt-4 justify-content-center gap-3" >

                <!-- Card: Review booking history -->
                <div class="col-md-4">
                    <div class="card text-bg-dark h-100 shadow-lg rounded-4">
                        <div class="card-body text-center">
                            <i class="fas fa-money-check-alt fa-3x mb-3 text-warning"></i>
                            <h5 class="card-title">Booking History</h5>
                            <p class="card-text">View and edit booking.</p>
                            <a href="${pageContext.request.contextPath}/viewBookingHistory" class="btn btn-warning text-dark rounded-pill px-4">Go</a>
                        </div>
                    </div>
                </div>

                <!-- Card: Review profile page -->
                <div class="col-md-4">
                    <div class="card text-bg-dark h-100 shadow-lg rounded-4">
                        <div class="card-body text-center">
                            <i class="fas fa-film fa-3x mb-3 text-warning"></i>
                            <h5 class="card-title">Profile</h5>
                            <p class="card-text">View or edit profile.</p>

                            <!-- Button trigger modal -->
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#viewProfileModal">
                                View
                            </button>

                            <!-- Modal -->
                            <form action="${pageContext.request.contextPath}/updateMember" method="POST" >
                                <input type="hidden" name="id" value="${member.id}">
                                <div class="modal fade" id="viewProfileModal" tabindex="-1"
                                     aria-labelledby="viewProfileModalLabel" aria-hidden="true">
                                    <div class="modal-dialog model-dialog-centered modal-dialog-scrollable">
                                        <div class="modal-content bg-dark">
                                            <div class="modal-header">
                                                <h1 class="modal-title fs-5 text-white" id="viewProfileModalLabel ">Member
                                                    Details</h1>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                        aria-label="Close" style="background-color: var(--color-light-gold);"></button>
                                            </div>
                                            <div class="modal-body text-white">


                                                <!-- member NAME -->
                                                <div class="mb-3">
                                                    <label for="memberNameFormControlInput" class="form-label">
                                                        Name</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="memberNameFormControlInput" name="memberName" value="<c:out value='${member.name}'/>" required>
                                                </div>

                                                <!-- USERNAME -->
                                                <div class="mb-3">
                                                    <label for="memberUsernameFormControlInput" class="form-label">Username</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="memberUsernameFormControlInput" name="memberUsername" value="<c:out value='${member.username}'/>" required>
                                                </div>

                                                 <!-- PASSWORD -->
                                                <div class="mb-3">
                                                    <label for="memberPasswordFormControlInput" class="form-label">Password (only if you want to change)</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="memberPasswordFormControlInput" name="memberPassword" value="">
                                                </div>

                                                
                                                <!-- EMAIL -->
                                                <div class="mb-3">
                                                    <label for="memberEmailFormControlInput" class="form-label">Email</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="memberEmailFormControlInput" name="memberEmail" value="<c:out value='${member.email}'/>" required>

                                                </div>

                                                <!-- PHONE NO -->
                                                <div class="mb-3">
                                                    <label for="memberPhoneNoFormControlInput" class="form-label">
                                                        Phone No</label>
                                                    <input type="text" class="form-control bg-dark text-white"
                                                           id="memberPhoneNoFormControlInput" name="memberPhoneNo" value="<c:out value='${member.phoneNo}'/>" required>
                                                </div>



                                            </div>
                                            <div class="modal-footer">
                                                <input type="submit" class="btn btn-primary" value="Save changes">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>

                        </div>
                    </div>
                </div>

            </div>
            <div class="row justify-content-center mt-4">

                <button type="button" class="btn btn-danger " style="width: 200px;" data-bs-toggle="modal" data-bs-target="#deleteModal">
                    Delete Your Account
                </button>

                <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content bg-dark text-white">
                            <div class="modal-header bg-danger text-white">
                                <h5 class="modal-title" id="deleteModalLabel">Confirm Deletion</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body ">
                                <p class="mb-0">Are you sure you want to delete your account? This action cannot be undone.</p>
                            </div>
                            <div class="modal-footer ">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <a class="btn btn-danger " href="${pageContext.request.contextPath}/deleteMember?id=${member.id}">Delete Your Account</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <jsp:include page="../../includes/footer.jsp" flush="true"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
