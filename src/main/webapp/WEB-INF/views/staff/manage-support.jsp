<%-- 
    Document   : manage-support
    Created on : 12 Jun 2025, 2:01:16 am
    Author     : Aiman
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Support Tickets</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Raleway:ital,wght@0,100..900;1,100..900&family=Vibur&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css"/>
        <style>

            .table-container {
                padding: 2rem;
                background-color: #212529;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(237, 222, 128, 0.4);
                transition: box-shadow 0.3s ease-in-out;
            }

            .table-container:hover {
                box-shadow: 0 0 30px rgba(217, 196, 63, 0.6);
            }

            table {
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }

            th {
                background-color: #def0e7;
                color: #000;
            }

            select, input[type="submit"] {
                border-radius: 5px;
            }

            .btn-update {
                background-color: var(--color-light-gold);
                color: var(--color-black);
            }

            .btn-update:hover{
                background-color: var(--color-dark-gold);
                color: var(--color-black);
            }

            .btn-delete {
                background-color: #e06c75;
                color: white;
            }

            /*            .glow-gold {
                            color: #e1b12c;
                            font-family: 'Vibur', cursive;
                            text-shadow: 1px 1px 4px rgba(0,0,0,0.2);
                        }*/
        </style>
    </head>
    <body>
        ${param.success}
        <jsp:include page="../../includes/header.jsp" flush="true"/>


        <div class="table-container container my-5">
        <div>
            <a href="${pageContext.request.contextPath}/staff"><i class="fa-solid fa-circle-chevron-left fa-xl mx-2" style="color: var(--color-light-gold);"></i></a>

            <h1 class="glow-gold my-4 display-4 d-inline-block" style="text-align: left; ">Support Tickets</h1>

        </div>
            <c:if test="${success==1}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    Successfully update
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${success==2}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    Successfully deleted
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <!-- Filter form -->
            <form class="row mb-4">
                <div class="col-md-4">
                    <label for="filterIssueType" class="form-label">Filter by Issue Type:</label>
                    <select name="issue_type" id="filterIssueType" class="form-select">
                        <option value="">-- All --</option>
                        <option value="login problem" <%= "login problem".equals(request.getParameter("issue_type")) ? "selected" : ""%>>Login Problem</option>
                        <option value="ticket issue" <%= "ticket issue".equals(request.getParameter("issue_type")) ? "selected" : ""%>>Ticket Issue</option>
                        <option value="payment" <%= "payment".equals(request.getParameter("issue_type")) ? "selected" : ""%>>Payment</option>
                        <option value="others" <%= "others".equals(request.getParameter("issue_type")) ? "selected" : ""%>>Others</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label for="filterReviewStatus" class="form-label">Filter by Review Status:</label>
                    <select name="review_status" id="filterReviewStatus" class="form-select">
                        <option value="">-- All --</option>
                        <option value="pending" <%= "Pending".equals(request.getParameter("review_status")) ? "selected" : ""%>>Pending</option>
                        <option value="resolved" <%= "resolved".equals(request.getParameter("review_status")) ? "selected" : ""%>>Resolved</option>
                    </select>
                </div>

                <div class="col-md-2 align-self-end">
                    <input type="submit" value="Filter" class="btn btn-primary w-100">
                </div>
            </form>

            <div class="row overflow-auto scrollbar-gold">

                <table class="table table-bordered table-dark text-white overflow-auto scrollbar-gold">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Issue Type</th>
                            <th>Message</th>
                            <th>Submitted At</th>
                            <th>Review Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${supports}" var="support">
                            <c:if test="${(param.review_status == null || param.review_status == '' || param.review_status == support.reviewStatus) && (param.issue_type == null || param.issue_type =='' ||param.issue_type == support.issueType)}">


                                <tr>
                                    <td><c:out value="${support.id}"/></td>
                                    <td><c:out value="${support.name}"/></td>
                                    <td><c:out value="${support.email}"/></td>
                                    <td class="text-capitalize"><c:out value="${support.issueType}"/></td>
                                    <td><c:out value="${support.message}"/></td>
                                    <td><c:out value="${support.submittedAt}"/></td>
                                    <td class="text-capitalize"><c:out value="${support.reviewStatus}"/></td>
                                    <!--                                <td class="">
                                                                        <form class="d-flex flex-column justify-content-center align-items-center gap-1" method="post" action="${pageContext.request.contextPath}/updateSupport">
                                                                            <input type="hidden" name="support_id" value="${support.id}">
                                                                            <select name="review_status" class="form-select">
                                                                                <option value="pending" ${ support.reviewStatus == "pending" ? "selected" : ""}>Pending</option>
                                                                                <option value="resolved" ${ support.reviewStatus == "resolved" ? "selected" : ""}>Resolved</option>
                                                                            </select>
                                                                            <input type="submit" value="Update" class="btn btn-update btn-sm">
                                                                        </form>
                                                                    </td>-->
                                    <td >

                                        <c:if test="${support.reviewStatus != 'resolved'}">

                                            <!-- Button trigger modal -->
                                            <button type="button" class="btn btn-primary mb-1" data-bs-toggle="modal" data-bs-target="#replyModal">
                                                Reply
                                            </button>

                                            <!-- Modal -->
                                            <form method="post" action="${pageContext.request.contextPath}/updateSupport" >
                                                <input type="hidden" name="support_id" value="${support.id}">

                                                <div class="modal fade" id="replyModal" tabindex="-1" aria-labelledby="replyModalLabel" aria-hidden="true">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content bg-dark text-white">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title" id="replyModalLabel">Support</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="card mb-3">
                                                                    <div class="card-body bg-dark text-white">
                                                                        Issue Type: <c:out value="${support.issueType}"/>
                                                                        <br>
                                                                        Issue Message: <c:out value="${support.message}"/>
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="solutionFormControlTextarea1" class="form-label">Solution</label>
                                                                    <textarea name="resolve" class="form-control bg-dark text-white" id="solutionFormControlTextarea1" rows="3"></textarea>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-primary">Send reply</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>

                                        </c:if>








                                        <form method="post" action="${pageContext.request.contextPath}/deleteSupport" onsubmit="return confirm('Are you sure you want to delete this ticket?');">
                                            <input type="hidden" name="support_id" value="${support.id}">
                                            <input type="submit" value="Delete" class="btn btn-delete">
                                        </form>

                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <jsp:include page="../../includes/footer.jsp" flush="true"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
