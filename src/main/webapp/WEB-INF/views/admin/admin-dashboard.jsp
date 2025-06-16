<%-- 
    Document   : adminDashboard
    Created on : Jun 2, 2025, 5:25:25 PM
    Author     : User
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Veloura Cinema</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;600&family=Vibur&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/styles.css">
        <link rel="stylesheet" href="assets/css/header.css"/>
        <link rel="stylesheet" href="assets/css/footer.css"/>
        <style>
            .dashboard-container {
                padding-top: 4rem;
                padding-bottom: 4rem;
            }

            .dashboard-title {
                font-family: 'Raleway', sans-serif;
                font-weight: 600;
                text-align: center;
                color: #f0c674;
                margin-bottom: 3rem;
                text-shadow: 0 0 10px rgba(255, 215, 0, 0.4);
            }

            .card-custom {
                background-color: #1e1e2f;
                border: 1px solid #f0c674;
                color: #fff;
                border-radius: 20px;
                box-shadow: 0 4px 20px rgba(240, 198, 116, 0.2);
                transition: all 0.3s ease;
            }

            .card-custom:hover {
                transform: scale(1.03);
                box-shadow: 0 6px 25px rgba(240, 198, 116, 0.4);
            }

            .card-custom .btn-warning {
                background-color: #f0c674;
                border: none;
                color: #000;
            }

            .card-custom .btn-warning:hover {
                background-color: #e3b947;
            }

            .fa-3x {
                color: #f0c674;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../../includes/header.jsp" flush="true"/>
        <p class="lead m-2 glow-white">Welcome, <strong>Admin</strong>! Manage your staff and oversee the system below.</p>
        <div class="container dashboard-container">
            <h1 class="dashboard-title">Admin Dashboard</h1>
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5">
                    <div class="card card-custom text-center p-4">
                        <div class="card-body">
                            <i class="fa-solid fa-users-cog fa-3x mb-3"></i>
                            <h5 class="card-title mb-3">Manage Staff</h5>
                            <p class="card-text">View, add, edit, or delete staff accounts in the system.</p>
                            <a href="${pageContext.request.contextPath}/viewStaff" class="btn btn-warning">Go to Manage Staff</a>
                        </div>

                    </div>
                </div>
                <div class="col-md-6 col-lg-5">
                    <div class="card card-custom text-center p-4">
                        <div class="card-body">
                            <i class="fa-solid fa-users-cog fa-3x mb-3"></i>
                            <h5 class="card-title mb-3">View Member</h5>
                            <p class="card-text">View member accounts in the system.</p>
                            <a href="${pageContext.request.contextPath}/viewMember" class="btn btn-warning">Go to Manage Member</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../../includes/footer.jsp" flush="true"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
