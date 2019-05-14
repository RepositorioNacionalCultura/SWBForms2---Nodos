<%-- 
    Document   : suma
    Created on : 24-feb-2019, 14:41:29
    Author     : juan.fernandez
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String action = request.getParameter("action");
if(null==action) action = "";
String numero1 = request.getParameter("numero1");
String numero2 = request.getParameter("numero2");

String errMsg = "";
String suma = "";

if(action.equals("suma")){
    numero1 = request.getParameter("numero1");
    numero2 = request.getParameter("numero2");
    
    int num1 = 0;
    int num2 = 0;
    try {
            num1 = Integer.parseInt(numero1); 
            num2 = Integer.parseInt(numero2); 
            
            //llamas a tu calse de Java
            suma = Integer.toString((num1+num2));
            /////////////////////////////////////
            
        } catch (Exception e) {
            errMsg = "Solo números por favor";
        }
}
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Suma de dos números</h1>
        <form action="" method="post">
            <input type="hidden" name="action" value="suma">
            número 1: <input type="text" name="numero1" value="<%=numero1!=null?numero1:""%>"><br>
            número 2: <input type="text" name="numero2" value="<%=numero2!=null?numero2:""%>"><br>
            suma:     <input type="text" name="suma" value="<%=suma!=null?suma:""%>">
            <button type="submit">suma</button><br><%=errMsg%>
            
        </form>
    </body>
</html>
