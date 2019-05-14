<%-- 
    Document   : evidencia
    Created on : 28-mar-2019, 13:08:12
    Author     : juan.fernandez
--%><%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Collections"%><%@page import="java.util.ArrayList"%><%@page import="java.util.List"%><%@page import="java.io.File"%><%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
        <div class="row">
            <div class="col-md-12" id="main_content">    
                <div class="row" style="margin:15px;">            
                    <div style="background-color: white;">
                        <div>                         
                            <!-- /.box-header -->
                            <div class="box-body">
                                <table id="evidenceTable" class="table table-bordered table-striped">
                                    <thead>
                                        <tr>
                                            <th>Evidencia</th>
                                            <th style="width: 120px;">Fecha</th>
                                            <th>&nbsp;&nbsp;&nbsp;&nbsp;</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <%  
                                            String acuseID=request.getParameter("ID");
                                            String server=request.getScheme()+"://"+request.getServerName()+(request.getServerPort()!=80?":"+request.getServerPort():"");
                                            String dir = DataMgr.getApplicationPath() + "/work/acuse_upload/";
                                            HashMap<String,File> hmFiles = new HashMap();
                                            File d = new File(dir);
                                            File[] files = d.listFiles();
                                            List<String> fileNames = new ArrayList<>();
                                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                            for (int x = 0; x < files.length; x++) {
                                                if (files[x].isDirectory()) {
                                                    continue;
                                                }
                                                hmFiles.put(files[x].getName(),files[x]);
                                                if (files[x].getName().startsWith(acuseID)) {
                                                    fileNames.add(files[x].getName());
                                                }
                                            }

                                            Collections.sort(fileNames);

                                            for (String nombre : fileNames) {
                                                String tmp_name = nombre.replace(acuseID, "Evidencia");
                                                tmp_name = tmp_name.substring(0, tmp_name.lastIndexOf("."));

                                                String tmpdate = sdf.format(new Date(hmFiles.get(nombre).lastModified()));
                                            
                                        %>
                                        <tr>
                                            <td><%=tmp_name%></td>
                                            <td><%=tmpdate%></td>
                                            <td><a style="" class="btn bg-green btn-flat" href="<%=server%>/work/acuse_upload/<%=nombre%>" data-target="#content" data-load="ajax">Ver</a></td>
                                        </tr>

                                        <%
                                            }
                                        %>
                                    </tbody>  
                                </table>
                                <script type="text/javascript">
                                    $('.box').boxWidget({
                                        animationSpeed: 500,
                                    });

                                    $(function () {
                                        $('#evidenceTable').DataTable({
                                            'paging': false,
                                            'lengthChange': false,
                                            'searching': true,
                                            'ordering': true,
                                            'info': true,
                                            'autoWidth': true
                                        });
                                    })
                                </script>


                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

