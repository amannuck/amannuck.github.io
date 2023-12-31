<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*, javax.servlet.ServletOutputStream, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Stocks</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #D8BFD8;">
<%
    /* Checking the user credentials */
    String userType = (String) session.getAttribute("usertype");
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userType == null || !userType.equals("admin")) {
        response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");
    } else if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
    }
%>

<jsp:include page="header.jsp" />

<div class="text-center" style="color: green; font-size: 24px; font-weight: bold;">Stock Products</div>
<div class="container-fluid">
    <div class="table-responsive">
        <table class="table table-hover table-sm">
            <thead style="background-color: #2c6c4b; color: white; font-size: 18px;">
                <tr>
                    <th>Image</th>
                    <th>ProductId</th>
                    <th>Name</th>
                    <th>Type</th>
                    <th>Price</th>
                    <th>Sold Qty</th>
                    <th>Stock Qty</th>
                    <th colspan="2" style="text-align: center">Actions</th>
                </tr>
            </thead>
            <tbody style="font-size: 16px;">
            <%
                ProductServiceImpl productDao = new ProductServiceImpl();
                List<ProductBean> products = new ArrayList<ProductBean>();
                products = productDao.getAllProducts();
                String style1;
                for (ProductBean product : products) {
                	style1 = "";
                    if (product.getProdQuantity() <= 3) {
                    	style1 = "\"background-color: red;\"";
                    } %> 
                <tr style=<%= style1 %>>
                    <td><img src="./ShowImage?pid=<%=product.getProdId()%>" style="width: 50px; height: 50px;"></td>
                    <td><a href="./updateProduct.jsp?prodid=<%=product.getProdId()%>"><%=product.getProdId()%></a></td>
                    <%
                    String name = product.getProdName();
                    name = name.length() > 25 ? name.substring(0, 25) + ".." : name;
                    %>
                    <td><%=name%></td>
                    <td><%=product.getProdType().toUpperCase()%></td>
                    <td><%=product.getProdPrice()%></td>
                    <td><%=new OrderServiceImpl().countSoldItem(product.getProdId())%></td>
                    <td><%=product.getProdQuantity()%></td>
                    <td>
                        <form method="post">
                            <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>"
                                class="btn btn-primary">Update</button>
                        </form>
                    </td>
                    <td>
                        <form method="post">
                            <button type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>"
                                class="btn btn-danger">Remove</button>
                        </form>
                    </td>
                </tr>
                <%
                }
                if (products.isEmpty()) {
                %>
                <tr style="background-color: grey; color: white;">
                    <td colspan="7" style="text-align: center;">No Items Available</td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="footer.html"%>
</body>
</html>
