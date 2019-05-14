<%-- 
    Document   : extractores
    Created on : 08-dic-2017, 10:19:49
    Author     : juan.fernandez
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Acervo</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="/platform/js/eng.js" type="text/javascript"></script>
        <link href="/admin/css/sc_admin.css" rel="stylesheet" type="text/css" />
        <script src="/admin/js/admin_utils.js"></script>
    </head>
    <body>
        <script type="text/javascript">
            eng.initPlatform("/cultura/jsp/datasources.js", false);
        </script>
        <div class="container-fluid">
            <div class="row">

                <main role="main" class="col-sm-9 ml-sm-auto col-md-10 pt-3">
                    <%
                        String id = request.getParameter("_id");
                        String pid = id;
                        if (id != null) {
                            id = "\"" + id + "\"";
                        }
                    %>
                    <script type="text/javascript">

                        var extractor = eng.createGrid({
                            left: "0",
                            margin: "10px",
                            width: "80%",
                            height: 600,
                            canEdit: false,
                            canRemove: true,
                            canAdd: true,
                            fields: [
                                //{name:"endpoint",title:"EndPoint",stype:"select", dataSource:"EndPoint", required:true},
                                {name: "name", title: "Nombre/Modelo", type: "string"},
                                {name: "class", title: "Tipo"},
        //        {name:"verbs",title:"Verbos",type:"select",
        //        valueMap:vals_verbs, defaultValue:"Identify", required:true},
        //        {name:"prefix",title:"MetaData PREFIX",type:"select",
        //        valueMap:vals_meta, defaultValue:"mods"},
        //        {name:"resumptionToken",title:"Soporta Resumption Token",type:"boolean"},
        //        {name:"tokenValue",title:"Token",type:"string"},
                                {name: "periodicity", title: "Periodicidad", type: "boolean"},
                                {name: "interval", title: "Intervalo de tiempo (días)", type: "int"},
        //        {name:"mapeo",title:"Tabla de mapeo", stype:"select",  dataSource:"MapDefinition"},
                                {name: "created", title: "Fecha creación", type: "string", canEdit: false},
                                {name: "lastExecution", title: "Última ejecución", type: "string", canEdit: false},
                                {name: "status", title: "Estatus"}, //STARTED | EXTRACTING | STOPPED
                                {name: "rows2harvest", title: "Registros por cosechar", type: "int"},
                                {name: "harvestered", title: "Registros cosechados", type: "int"},
                                {name: "rows2Processed", title: "Registros por procesar", type: "int"},
                                {name: "processed", title: "Registros procesados", type: "int"}
                            ],
        //                recordClick: function (grid, record) {
        //                    var o = record._id;
        //                    isc.say(JSON.stringify(o, null, "\t"));
        //                    return false;
        //                }
                            recordDoubleClick: function (grid, record)
                            {
                                window.location = "/cultura/jsp/extractor.jsp?_id=" + record._id;
                                return false;
                            }
                            ,
                            addButtonClick: function (event)
                            {
                                window.location = "/cultura/jsp/extractor.jsp";
                                return false;
                            }
                        }, "Extractor");
                        
                        
                    </script>
                </main>
            </div>
        </div>
    </body>
</html>