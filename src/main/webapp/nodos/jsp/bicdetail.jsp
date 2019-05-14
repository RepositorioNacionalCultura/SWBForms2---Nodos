<%-- 
    Document   : bicdetail
    Created on : 18-ene-2019, 18:13:18
    Author     : juan.fernandez
--%>

<%@page import="java.util.HashSet"%>
<%@page import="org.semanticwb.datamanager.DataList"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%><%
    SWBScriptEngine eng = DataMgr.initPlatform("/admin/ds/admin.js", session);
    String dsName = request.getParameter("ds");
    String id = request.getParameter("id");
    String origID =id;
    String dsid = request.getParameter("dsid");
    if (id != null && id.trim().isEmpty()) {
        id = null;
    } else {
        id = "\"" + id + "\"";
    }

//    System.out.println("====================================================\n\n" + dsName + "/" + id);
    String properties = getProps(eng, dsName);
//    System.out.println("fields....\n" + properties);

    boolean iscatalog = false;
    if (request.getParameter("iscatalog") != null && request.getParameter("iscatalog").equalsIgnoreCase("true")) {
        iscatalog = true;
    }
    String bckurl = "/nodos/jsp/acervo.jsp";
    if (iscatalog) {
        bckurl = "/nodos/jsp/catalogo.jsp";
    }

%>


<!DOCTYPE html>
<html>
    <head>
        <title>Acervo</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="/platform/js/eng.js" type="text/javascript"></script>
        <link href="/admin/css/sc_admin.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <script type="text/javascript">
            eng.initPlatform("/admin/ds/admin.js", false);
        </script>
        <script type="text/javascript">

            var form = eng.createForm({
                width: "100%",
                left: "-8px",
                title: "Información",
                showTabs: false,
                canPrint: false,
                canEdit: true,
                numCols: 2,
                colWidths: [300, "*"],
            <%=properties%>

                onLoad: function ()
                {
                    setTimeout(function () {
                        parent.$(".acervo").attr("height", (document.body.offsetHeight + 16) + "px");
                    }, 0);
                }
            }, <%=id%>, "<%=dsName%>");
            
            
//            form.buttons.addMember(isc.IButton.create(
//            {
//                title: "Indexar",
//                padding: "10px",
//                click: function (p1) {
//                    isc.say("Se manda a Indexar....",function(){});
//                    //window.location = "/cultura/jsp/harvest.jsp?_id=<%//=pid%>&act=INDEX";
//                    return false;
//                }
//            }));

            form.submitButton.setTitle("Guardar");

            form.submitButton.click = function (p1)
            {
                eng.submit(form, this, function ()
                {
                    isc.say("Datos enviados correctamente...", function () {
                        <% if(!iscatalog) { 
                        %>
                        window.location = "/nodos/jsp/bicdetail.jsp?ds=<%=dsName%>&dsid=<%=dsid%>&id=<%=origID%>";
                        <% 
                        }
                        %>
                    });
                });
            };

            form.buttons.addMember(isc.IButton.create({
                title: "Regresar",
                padding: "10px",
                click: function (p1) {
                
                    window.location.href = "<%=bckurl%>?ds=<%=dsName%>&_id=<%=dsid%>";
                                //parent.loadContent("admin_content?pid=acervo", ".content-wrapper");
                                return false;
                            }
                        }));
                        form.buttons.members.unshift(form.buttons.members.pop());



        </script>         
    </body>
</html>
<%!
    public String getProps(SWBScriptEngine eng, String dsName) {

        StringBuilder ret = new StringBuilder("fields: [");
        try {
            DataObject query1 = new DataObject();
            DataObject data1 = new DataObject();
            query1.addParam("data", data1);
            data1.addParam("id", dsName);

            DataObject rs1;
            rs1 = eng.getDataSource("DataSource").fetch(query1);

            DataObject dods = rs1.getDataObject("response").getDataList("data").getDataObject(0);
            String dsid = dods.getId();

//            System.out.println("dods...\n" + dods.toString(true));
            DataObject query = new DataObject();
            query.addSubList("sortBy").add("order");
            DataObject data = new DataObject();

            query.addParam("data", data);
            data.addParam("ds", dsid);
            //data.addParam("type", "section");

            DataObject rs;
            rs = eng.getDataSource("DataSourceFields").fetch(query);

            DataList dlprops = rs.getDataObject("response").getDataList("data");
            HashSet<String> hsproc = new HashSet();
            StringBuilder sb = null;
            StringBuilder sb2 = null;
            for (int i = 0; i < dlprops.size(); i++) {
                DataObject dobj = dlprops.getDataObject(i);
                if (hsproc.contains(dobj.getId())) {
                    continue;
                } else {
                    hsproc.add(dobj.getId());
                }
                // {name: "seguimiento", type: "section", defaultValue: "Seguimiento", canCollapse: true, sectionExpanded: true, itemIds: ["created", "creator", "updated", "updater"]},
                String objType = dobj.getString("type");
                if (!objType.isEmpty() && objType.equals("section")) {
                    //ret.append("{name:\"").append(dobj.getString("name")).append("\", type:\"").append(dobj.getString("type")).append("\",defaultValue:\"").append(dobj.getString("title")).append("\",canCollapse: true, sectionExpanded: true,");

                    if (dobj.getString("name", null).equals("seguimiento")) {
                        ret.append("{ type:\"section\",defaultValue:\"").append(dobj.getString("title")).append("\",canCollapse:true, sectionExpanded:false, ");
                    } else {
                        ret.append("{ type:\"section\",defaultValue:\"").append(dobj.getString("title")).append("\",canCollapse:true, sectionExpanded:true, ");
                    }

                    DataObject queryprops = new DataObject();
                    queryprops.addSubList("sortBy").add("order");
                    DataObject dataprops = new DataObject();

                    queryprops.addParam("data", dataprops);
                    dataprops.addParam("ds", dsid);
//                   System.out.println(dobj.getId());
                    dataprops.addParam("parentid", dobj.getId());

                    DataObject rsprops;
                    rsprops = eng.getDataSource("DataSourceFields").fetch(queryprops);

                    DataList dlprops2 = rsprops.getDataObject("response").getDataList("data");
                    if (dlprops2.size() > 0) {
                        sb = new StringBuilder("itemIds:[");
                        sb2 = new StringBuilder("");
                        for (int j = 0; j < dlprops2.size(); j++) {
                            DataObject dobj2 = dlprops2.getDataObject(j);
                            String propertyName = dobj2.getString("name");
                            sb.append("\"").append(propertyName).append("\"");
                            sb2.append("{name:\"").append(propertyName).append("\"");
                            if (null != propertyName && propertyName.toLowerCase().equals("deleted")) {
                                sb2.append(", defaultValue:false");
                            } else if (null != propertyName && propertyName.toLowerCase().equals("forIndex")) {
                                sb2.append(", defaultValue:true");
                            }
                            if (propertyName != null && !propertyName.equals("description")) {
                                sb2.append(", width:500},");
                            } else {
                                sb2.append("},");
                            }

                            if (j + 1 < dlprops2.size()) {
                                sb.append(",");

                            }
                            if (hsproc.contains(dobj2.getId())) {
                                continue;
                            } else {
                                hsproc.add(dobj2.getId());
                            }
                        }
                        sb.append("]");
//                        System.out.println("itemsIds:....." + sb.toString());
                        ret.append(sb.toString());
                    }
                    ret.append("},\n");
                    if (sb2.toString().length() > 0) {
                        ret.append(sb2.toString());
                    }
                } else {
                    ret.append("{name:\"").append(dobj.getString("name")).append("\", width:500},\n");
                }

                //System.out.println("name:" + dobj.getString("name") + ",title:" + dobj.getString("title") + ",type:" + dobj.getString("type", "N/A") + ",order:" + dobj.getInt("order") + "\n");
            }

            //DataObject dodf = eng.getDataSource("DataSourceField").fetch(query);
            //System.out.println("fields....\n" + rs.toString(true));
        } catch (Exception e) {
        }
        ret.append("],");

        return ret.toString();

    }

%>
