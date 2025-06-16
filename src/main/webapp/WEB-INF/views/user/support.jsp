<%-- 
    Document   : support
    Created on : Jun 11, 2025, 5:43:55 PM
    Author     : User
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Support - Cinemax</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap & Fonts -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Raleway&family=Vibur&display=swap" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="assets/css/styles.css">
        <link rel="stylesheet" href="assets/css/header.css">
        <link rel="stylesheet" href="assets/css/footer.css">

        <style>
            body {
                background-color: #111;
                color: #f8f9fa;
                font-family: 'Raleway', sans-serif;
            }

            .glow-gold {
                color: #FFD700;
                text-shadow: 0 0 10px #FFD700, 0 0 20px #FFA500;
                font-family: 'Vibur', cursive;
            }

            .glow-box {
                box-shadow: 0 0 15px rgba(255, 215, 0, 0.5), 0 0 25px rgba(255, 105, 180, 0.3);
                border: 1px solid #ffc107;
            }

            .bg-dark-custom {
                background-color: #1c1c1c;
            }

            .form-label, .form-control, .form-select, textarea {
                color: #fff !important;
                background-color: #2c2c2c !important;
                border-color: #444 !important;
            }

            .form-control::placeholder, textarea::placeholder {
                color: #bbb !important;
            }

            .btn-danger {
                background-color: #d63384;
                border: none;
            }

            .btn-danger:hover {
                background-color: #e83e8c;
            }

            hr.bg-light {
                border-color: #ffc107 !important;
            }
        </style>
    </head>
    <body>

        <jsp:include page="../../includes/header.jsp" flush="true"/>

        <!-- Feedback Modal -->
        <div class="modal fade" id="feedbackModal" tabindex="-1" aria-labelledby="feedbackModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" id="modalContent">
                    <div class="modal-header">
                        <h5 class="modal-title" id="feedbackModalLabel">Support Status</h5>
                    </div>
                    <div class="modal-body" id="modalMessage">
                        <!-- Dynamic message inserted here -->
                    </div>
                    <div class="modal-footer">

                        <button type="button" class="btn btn-secondary" onclick="window.location.href = '${pageContext.request.contextPath}/support';">
                            OK
                        </button>

                    </div>
                </div>
            </div>
        </div>

    <c:if test="${param.success == '1'}">
        
        <script>
            window.addEventListener('DOMContentLoaded', () => {
                document.getElementById("modalMessage").innerText = "Support request submitted successfully!";
                document.getElementById("modalContent").classList.add("border-success");
                document.getElementById("modalContent").classList.remove("border-danger");
                document.getElementById("feedbackModalLabel").classList.add("text-success");
                document.getElementById("feedbackModalLabel").classList.remove("text-danger");
                new bootstrap.Modal(document.getElementById("feedbackModal")).show();
            });
        </script>
    </c:if>
        <c:if test="${param.success == '0'}">
        
        <script>
            window.addEventListener('DOMContentLoaded', () => {
                document.getElementById("modalMessage").innerText = "Something went wrong. Please try again.";
                document.getElementById("modalContent").classList.add("border-danger");
                document.getElementById("modalContent").classList.remove("border-success");
                document.getElementById("feedbackModalLabel").classList.add("text-danger");
                document.getElementById("feedbackModalLabel").classList.remove("text-success");
                new bootstrap.Modal(document.getElementById("feedbackModal")).show();
            });
        </script>
        </c:if>

        <div class="container my-5">
            <h1 class="glow-gold display-4 mb-4 text-center">Support</h1>

            <div class="row g-4">
                <!-- Contact Form -->
                <div class="col-md-7">
                    <div class="p-4 glow-box rounded bg-dark-custom h-100">
                        <form action="${pageContext.request.contextPath}/submitSupport" method="post" id="supportForm" onsubmit="return validateForm()">
                            <h4 class="mb-3 text-warning">Contact Us</h4>

                            <div class="mb-3">
                                <label for="name" class="form-label">Name:</label>
                                <input type="text" name="name" id="name" class="form-control" required placeholder="Your Name">
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email / Username:</label>
                                <input type="email" name="email" id="email" class="form-control" required placeholder="your@email.com">
                            </div>

                            <div class="mb-3">
                                <label for="issueType" class="form-label">Issue Type:</label>
                                <select name="issueType" id="issueType" class="form-select" required>
                                    <option value="">-- Select an Issue --</option>
                                    <option value="login problem">Login Problem</option>
                                    <option value="ticket issue">Ticket Issue</option>
                                    <option value="payment issue">Payment Issue</option>
                                    <option value="others">Others</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="message" class="form-label">Message:</label>
                                <textarea name="message" id="message" class="form-control" rows="5" required placeholder="Describe your issue..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-danger w-100">
                                <i class="fas fa-paper-plane"></i> Submit
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Support Info Section -->
                <div class="col-md-5">
                    <div class="p-4 glow-box rounded bg-dark-custom h-100">
                        <h4 class="text-warning">Support Information</h4>
                        <p><i class="fas fa-envelope"></i> Email: support@cinemax.com</p>
                        <p><i class="fas fa-phone"></i> Phone: +6012-345-6789</p>
                        <p><i class="fas fa-clock"></i> Response Time: We reply within 24 hours</p>

                        <hr class="bg-light">

                        <h5 class="text-warning">Frequently Asked Questions</h5>
                        <ul>
                            <li><strong>How do I edit booking?</strong><br>Go to Profile > History Booking, then click Edit.</li>
                            <li><strong>Where is my ticket?</strong><br>Check your email or login to view tickets.</li>
                            <li><strong>Payment failed?</strong><br>Try another card or contact your bank.</li>
                            <li><strong>How can I cancel a booking?</strong><br>Visit History Booking and click "Cancel" beside the ticket.</li>
                            <li><strong>Can I book without creating an account?</strong><br>No. You must register and login first.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../../includes/footer.jsp" flush="true"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                            function validateForm() {
                                const name = document.getElementById("name").value.trim();
                                const email = document.getElementById("email").value.trim();
                                const message = document.getElementById("message").value.trim();
                                const issueType = document.getElementById("issueType").value;

                                if (!name || !email || !message || !issueType) {
                                    showModal("All fields are required.", false);
                                    return false;
                                }

                                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                if (!emailPattern.test(email)) {
                                    showModal("Please enter a valid email.", false);
                                    return false;
                                }

                                return true;
                            }

                            function showModal(message, isSuccess) {
                                const modalContent = document.getElementById("modalContent");
                                const modalTitle = document.getElementById("feedbackModalLabel");

                                document.getElementById("modalMessage").innerText = message;

                                modalContent.classList.remove("border-success", "border-danger");
                                modalTitle.classList.remove("text-success", "text-danger");

                                if (isSuccess) {
                                    modalContent.classList.add("border-success");
                                    modalTitle.classList.add("text-success");
                                } else {
                                    modalContent.classList.add("border-danger");
                                    modalTitle.classList.add("text-danger");
                                }

                                new bootstrap.Modal(document.getElementById("feedbackModal")).show();
                            }
        </script>
    </body>
</html>
