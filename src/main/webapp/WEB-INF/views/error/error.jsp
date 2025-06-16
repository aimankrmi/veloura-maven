<%-- 
    Document   : error
    Created on : 25 May 2025, 6:43:48 pm
    Author     : Aiman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Error Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
        
        <style>
            .custom-bg {
                background: linear-gradient(to right, #e2e8f0, #e5e7eb);
            }

            .custom-btn:hover {
                background-color: #f3e8ff !important;
                transition: background-color 0.3s ease-in-out;
            }

            @media (prefers-color-scheme: dark) {
                .custom-bg {
                    background: linear-gradient(to right, #1f2937, #111827);
                    color: white !important;
                }

                .custom-btn {
                    background-color: #374151 !important;
                    color: white !important;
                }

                .custom-btn:hover {
                    background-color: #4b5563 !important;
                }
            }
        </style>
    </head>
    <body>
        <div class="custom-bg text-dark">
            <div class="d-flex align-items-center justify-content-center min-vh-100 px-2">
                <div class="text-center">
                    <h1 class="display-1 fw-bold">Error occured</h1>
                    <p class="fs-2 fw-medium mt-4">Oops! Page not found</p>
                    <p class="mt-4 mb-5">The page you're looking for doesn't exist or has been moved.</p>
                    <a href="index.jsp" class="btn btn-light fw-semibold rounded-pill px-4 py-2 custom-btn">
                        Go Home
                    </a>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
    </body>
</html>