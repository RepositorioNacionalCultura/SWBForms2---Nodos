<%-- 
    Document   : register
    Created on : 26-ago-2015, 17:54:48
    Author     : javiersolis
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.datamanager.*"%><%
    SWBScriptEngine eng=DataMgr.initPlatform("/admin/ds/base.js",session);
    String fullname=request.getParameter("fullname");
    String email=request.getParameter("email");
    String password=request.getParameter("password");
    String password2=request.getParameter("password2");
    if(email!=null && password!=null)
    {
        if(password.equals(password2))
        {
            SWBDataSource ds=eng.getDataSource("User");   
            DataObject obj=new DataObject();
            obj.put("fullname", fullname);
            obj.put("email", email);
            obj.put("password", password);
            ds.addObj(obj);
            //engine.close();
            response.sendRedirect("/login");
            return;
        }
    }
%><!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title><%=eng.getAppName()%> | Registration Page</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <!-- Bootstrap 3.3.4 -->
    <link href="/static/admin/bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css" />    
    <!-- Font Awesome Icons -->
    <link href="/static/admin/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <!-- Theme style -->
    <link href="/static/admin/dist/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <!-- iCheck -->
    <link href="/static/admin/plugins/iCheck/flat/blue.css" rel="stylesheet" type="text/css" />
  </head>
  <body class="register-page">
    <div class="register-box">
      <div class="register-logo">
        <a href="/"><b><%=eng.getAppName()%></b></a>
      </div>

      <div class="register-box-body">
        <p class="login-box-msg">Register a new membership</p>
        <form action="" method="post">
          <div class="form-group has-feedback">
            <input type="text" name="fullname" class="form-control" placeholder="Full name"/>
            <span class="glyphicon glyphicons-user form-control-feedback"></span>
          </div>
          <div class="form-group has-feedback">
            <input type="email" name="email" class="form-control" placeholder="Email"/>
            <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
          </div>
          <div class="form-group has-feedback">
            <input type="password" name="password" class="form-control" placeholder="Password"/>
            <span class="glyphicon glyphicon-lock form-control-feedback"></span>
          </div>
          <div class="form-group has-feedback">
            <input type="password" name="password2" class="form-control" placeholder="Retype password"/>
            <span class="glyphicon glyphicon-log-in form-control-feedback"></span>
          </div>
          <div class="row">
            <div class="col-xs-8">    
              <div class="checkbox icheck">
                <label>
                  <input type="checkbox"> I agree to the <a href="#">terms</a>
                </label>
              </div>                        
            </div><!-- /.col -->
            <div class="col-xs-4">
              <button type="submit" class="btn btn-primary btn-block btn-flat">Register</button>
            </div><!-- /.col -->
          </div>
        </form>        
<!--
        <div class="social-auth-links text-center">
          <p>- OR -</p>
          <a href="#" class="btn btn-block btn-social btn-facebook btn-flat"><i class="fa fa-facebook"></i> Sign up using Facebook</a>
          <a href="#" class="btn btn-block btn-social btn-google-plus btn-flat"><i class="fa fa-google-plus"></i> Sign up using Google+</a>
        </div>
-->
        <a href="/login" class="text-center">I already have a membership</a>
      </div><!-- /.form-box -->
    </div><!-- /.register-box -->

    <!-- jQuery 2.1.4 -->
    <script src="/static/admin/bower_components/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap 3.3.2 JS -->
    <script src="/static/admin/bower_components/bootstrap/dist/js/bootstrap.min.js" type="text/javascript"></script>  
    <!-- iCheck -->
    <script src="/static/admin/plugins/iCheck/icheck.min.js" type="text/javascript"></script>
    <script>
      $(function () {
        $('input').iCheck({
          checkboxClass: 'icheckbox_square-blue',
          radioClass: 'iradio_square-blue',
          increaseArea: '20%' // optional
        });
      });
    </script>
  </body>
</html>