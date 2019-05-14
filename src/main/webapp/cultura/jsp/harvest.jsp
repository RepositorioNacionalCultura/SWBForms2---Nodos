<%-- 
    Document   : harvest
    Created on : 23-nov-2017, 12:37:52
    Author     : juan.fernandez
--%>
<%@page import="mx.gob.cultura.commons.Util"%>
<%@page import="mx.gob.cultura.extractor.nodos.ExtractorManager"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Extractor action</title>

        <!-- Bootstrap 3.3.4 -->
        <link href="/static/admin/bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css" />    
        <link href="/static/admin/bower_components/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css" />

        <!-- FontAwesome 4.5.0 -->
        <link href="/static/admin/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="/static/plugins/fontawesome-iconpicker-1.3.1/css/fontawesome-iconpicker.min.css">
        <!-- Ionicons 2.0.0 -->
        <link href="/static/admin/bower_components/Ionicons/css/ionicons.min.css" rel="stylesheet" type="text/css" />   
        <!-- DataTables -->
        <link rel="stylesheet" href="/static/admin/bower_components/datatables.net-bs/css/dataTables.bootstrap.min.css">        
              <!-- Theme style -->
        <link href="/static/admin/dist/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
        <!-- AdminLTE Skins. Choose a skin from the css/skins 
             folder instead of downloading all of them to reduce the load. -->
        <link href="/static/admin/dist/css/skins/_all-skins.min.css" rel="stylesheet" type="text/css" />
        <!-- Pace style -->
        <link href="/static/admin/plugins/pace/pace.min.css" rel="stylesheet" type="text/css" >        
        <!-- iCheck -->
        <link href="/static/admin/plugins/iCheck/flat/blue.css" rel="stylesheet" type="text/css" />
        <!-- Morris chart -->
        <!--        
                <link href="/static/plugins/morris/morris.css" rel="stylesheet" type="text/css" />
        -->
        <!-- jvectormap -->
        <link href="/static/admin/plugins/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
        <!-- Date Picker -->
        <link href="/static/admin/bower_components/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css" rel="stylesheet" type="text/css" />
        <!-- Daterange picker -->
        <link href="/static/admin/bower_components/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css" />
        <!-- bootstrap wysihtml5 - text editor -->
        <link href="/static/admin/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css" rel="stylesheet" type="text/css" />

        <link href="/static/plugins/bootstrap-switch/bootstrap-switch.min.css" rel="stylesheet" type="text/css" />
        
        <link href="/static/admin/plugins/iCheck/square/blue.css" rel="stylesheet" type="text/css" />

        <link rel="stylesheet" href="/static/plugins/bootstrap-select/css/bootstrap-select.min.css">

        <style type="text/css">
            .CodeMirror {border: 1px solid black; font-size:13px}

            @media (min-width: 768px) {
                .main-header .sidebar-toggle {
                    display: none;
                }
                .main_alert
                {
                    padding-left: 250px
                }
                .nicheButtons{
                    position:absolute;
                }
            }
            
            .sidebar a {
                color: #b8c7ce;
            }
            
            .ifram_content{
                overflow:hidden;
                border:none;    
            }   
            
            @media (max-width: 767px)
            {
                .small-box {
                    text-align:unset !important;
                }         
                
                .small-box .icon {
                    display:unset !important;
                }

                .small-box p {
                    font-size:unset !important;
                }                
            }
        </style>   
        <!-- Cloudino Styles-->
        <style>
            .cdino_console{
                background-color: #00c0ef;
                min-height: 20px;
                margin-bottom: 10px;
                color: white;
                padding: 10px;
                font-family: courier;
                font-size: 13px;                            
            }
            .tab-pane{
                margin: 10px;
            }
            
            .cdino_buttons{
                padding-top: 10px;
            }
            
            .cdino_control {
                height: 90px;   
                display: inline-block;
            }
            
            .cdino_control_image {
                display: table;
            }    
            
            .cdino_text_menu{
                overflow:hidden;
                text-overflow:ellipsis;
            }
            
            dd{
                padding: 0px 0px 10px 0px;
            }
            
            .cdino_control_image, .cdino_control{
                padding: 10px 5px;
                margin: 0 0 10px 10px;
                min-width: 90px;
                font-size: 14px;
                border-radius: 3px;
                position: relative;
                padding: 15px 5px;
                text-align: center;
                color: #666;
                border: 1px solid #ddd;
                background-color: #f4f4f4;
                -webkit-box-shadow: none;
                box-shadow: none;                
                font-weight: 400;
                line-height: 1.42857143;
                white-space: nowrap;
                vertical-align: middle;
                -ms-touch-action: manipulation;
                touch-action: manipulation;
                cursor: pointer;
                -webkit-user-select: none;
                -moz-user-select: none;
                -ms-user-select: none;
                user-select: none;
            }        
        </style>    
        <link rel="stylesheet" href="/cultura/jsp/harvester.css">
        <script type="text/javascript">
            function updateInfo(listSize, extracted) {
                var ele = document.getElementById("res");
                ele.innerHTML("<strong>Records to extract:" + listSize + "</strong><br>" +
                        "<strong>Records extracted:" + (extracted) + "</strong><br>" +
                        "<strong>Records to go:" + (listSize - (extracted)) + "</strong><br>");
            }

        </script>

    </head>
    <body>


        <%
            String id = request.getParameter("_id");
            String pid = id;
            String status = "";
            String action = request.getParameter("act");
            long numItems = 0;

            if (null == action) {
                action = "";
            }
            String dspath = "/cultura/jsp/datasources.js";
            SWBScriptEngine engine = DataMgr.initPlatform(dspath, session);
            SWBDataSource datasource = engine.getDataSource("Extractor", "SWBForms");
            System.out.println("DS Extractor:"+(datasource!=null?"Ok":"NULL"));
            DataObject dobj = datasource.fetchObjById(id);

            System.out.println("DO:\n"+dobj);

        %>

        <section class="content-header">
            <h1>
                JSON Extractor 
                <small>(<%=dobj.getString("name")%>)</small>
            </h1>
        </section>

        <!-- Main content -->
        <section class="content">            



            <div id="res">
                <%  SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm:ss");
                    long startTime = System.currentTimeMillis();

                    long endTime = 0;
                    if (action.equals("EXTRACT")) {
                        if (null != pid) {

                            ExtractorManager extMgr = ExtractorManager.getInstance(dspath);
                            extMgr.loadExtractor(dobj);
    //                        status = extMgr.getStatus(id);
                            extMgr.startExtractor(id);
                            dobj = datasource.fetchObjById(id);
                            endTime = System.currentTimeMillis();

                            //System.out.println("Tiempo de extracción de datos:"+sdfTime.format(new Date(endTime.getTime()-startTime.getTime())));
                            status = dobj.getString("status");
                            numItems = dobj.getInt("harvestered");
                %>
                <strong>Status: <%=status%></strong><br>
                <strong>Extracted Records: <%=numItems%></strong><br>
                <strong>Extraction time: <%=Util.TEXT.getElapsedTime((endTime - startTime))%></strong><br>
                <%
                    }
                } else if (action.equals("STOP")) {
                    if (null != pid) {
                        ExtractorManager extMgr = ExtractorManager.getInstance(dspath);
                        //extMgr.loadExtractor(dobj);
                        extMgr.stopExtractor(id);
                        status = extMgr.getStatus(id);
                        endTime = System.currentTimeMillis();
                %>
                <strong>Status:<%=status%></strong><br>
                <strong>Se detuvo el extractor.</strong><br>
                <strong>Stopping time: <%=Util.TEXT.getElapsedTime((endTime - startTime))%></strong><br>

                <%
                    }
                } else if (action.equals("REPLACE")) {
                    if (null != pid) {
                        ExtractorManager extMgr = ExtractorManager.getInstance(dspath);
                        extMgr.loadExtractor(dobj);
                        extMgr.replaceExtractor(id);
    //                    status = extMgr.getStatus(id);
                        dobj = datasource.fetchObjById(id);
                        status = dobj.getString("status");
                        numItems = dobj.getInt("harvestered");
                        endTime = System.currentTimeMillis();
                %>
                <strong>Status:<%=status%></strong><br>
                <strong>Se limpió la base de datos</strong><br>
                <strong>Se reinició la extracción de datos.</strong><br>
                <strong>Extracted Records: <%=numItems%></strong><br>
                <strong>Extraction time: <%=Util.TEXT.getElapsedTime((endTime - startTime))%></strong><br>
                <%

                    }
                } else if (action.equals("PROCESS")) {
                    if (null != pid) {
                        ExtractorManager extMgr = ExtractorManager.getInstance(dspath);
                        extMgr.loadExtractor(dobj);
    //System.out.println("dobj: \n"+dobj.toString());
                        extMgr.processExtractor(id);
                        endTime = System.currentTimeMillis();
    //                    status = extMgr.getStatus(id);
                        dobj = datasource.fetchObjById(id);
                        status = dobj.getString("status");
                        numItems = dobj.getInt("processed");
                %>
                <strong>Status:<%=status%></strong><br>
                <strong>Se procesaron los metadatos.</strong><br>
                <strong>Processed Records: <%=numItems%></strong><br>
                <strong>Processing time: <%=Util.TEXT.getElapsedTime((endTime - startTime))%></strong><br>
                <%
                    }
                } else if (action.equals("INDEX")) {
                    if (null != pid) {
                        ExtractorManager extMgr = ExtractorManager.getInstance(dspath);
                        extMgr.loadExtractor(dobj);
    //System.out.println("dobj: \n"+dobj.toString());
                        extMgr.indexExtractor(id);
    //System.out.println("End Indexing...");
                        endTime = System.currentTimeMillis();
    //                    status = extMgr.getStatus(id);
                        dobj = datasource.fetchObjById(id);
                        status = dobj.getString("status");
                        numItems = dobj.getInt("indexed", 0);
                %>
                <strong>Status:<%=status%></strong><br>
                <strong>Se indexaron los metadatos.</strong><br>
                <strong>Se concluyó la indexación.</strong><br>
                <strong>Indexed Records: <%=numItems%></strong><br>
                <strong>Indexing time: <%=Util.TEXT.getElapsedTime((endTime - startTime))%></strong><br>
                <%
                    }
                } else if (action.equals("UPDATE")) {
                    if (null != pid) {
                        ExtractorManager extMgr = ExtractorManager.getInstance(dspath);
                        extMgr.loadExtractor(dobj);
                        extMgr.updateExtractor(pid);
                        endTime = System.currentTimeMillis();
    //                    status = extMgr.getStatus(id);
                        dobj = datasource.fetchObjById(id);
                        status = dobj.getString("status");
                        numItems = dobj.getInt("processed");
                %>
                <strong>Status:<%=status%></strong><br>
                <strong>Se actualizaron los datos.</strong><br>
                <strong>Updated Records: <%=numItems%></strong><br>
                <strong>Updating time: <%=Util.TEXT.getElapsedTime((endTime - startTime))%></strong><br>
                <%
                        }
                    }
                %>



            </div>
        </section>

    </body>


</html>