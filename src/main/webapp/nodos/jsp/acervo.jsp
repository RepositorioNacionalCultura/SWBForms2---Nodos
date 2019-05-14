<%-- 
    Document   : acervo
    Created on : 09-ene-2019, 16:49:26
    Author     : juan.fernandez
--%><%@page import="org.semanticwb.datamanager.SWBDataSource"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.io.IOException"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page import="org.semanticwb.datamanager.DataList"%>
<%!
    public String parseScript(String txt, HttpServletRequest request) {
        if (txt == null) {
            return "";
        }
        if (request.getParameter("ID") != null) {
            txt = txt.replace("{request.ID}", request.getParameter("ID"));
        } else if (request.getParameter("id") != null) {
            txt = txt.replace("{request.id}", request.getParameter("id"));
        }
        return txt;
    }

    public DataList getExtProps(DataObject obj, String extPropsField, SWBScriptEngine eng) throws IOException {
        DataList extProps = new DataList();
        DataList data = obj.getDataList(extPropsField);
        if (data != null) {
            DataObject query = new DataObject();
            query.addSubObject("data").addParam("_id", data);
            extProps = eng.getDataSource("PageProps").fetch(query).getDataObject("response").getDataList("data");
        }
        return extProps;
    }

    public StringBuilder getProps(DataList extProps) {
        StringBuilder fields = new StringBuilder();
        DataList empty = new DataList();
        for (int i = 0; i < extProps.size(); i++) {
            DataObject ext = extProps.getDataObject(i);
            if (ext.getDataList("prop", empty).isEmpty()) {
                String att = ext.getString("att");
                String value = ext.getString("value");
                String type = ext.getString("type");
                fields.append(att + ":");
                if ("string".equals(type) || "date".equals(type)) {
                    fields.append("\"" + value + "\"");
                } else {
                    fields.append(value);
                }
                fields.append(",\n");
            }
        }
        return fields;
    }

    public StringBuilder getFields(DataObject obj, String propsField, DataList extProps) {
        StringBuilder fields = new StringBuilder();
        DataList gridProps = obj.getDataList(propsField);
        DataList empty = new DataList();
        if (gridProps != null) {
            Iterator<String> it = gridProps.iterator();
            while (it.hasNext()) {
                String _id = it.next();
                String name = _id.substring(_id.indexOf(".") + 1);
                //System.out.println(_id);
                fields.append("{");
                fields.append("name:" + "\"" + name + "\"");
                for (int i = 0; i < extProps.size(); i++) {
                    DataObject ext = extProps.getDataObject(i);
                    if (ext.getDataList("prop", empty).contains(_id)) {
                        String att = ext.getString("att");
                        String value = ext.getString("value");
                        String type = ext.getString("type");
                        fields.append(", " + att + ":");
                        if ("string".equals(type) || "date".equals(type)) {
                            fields.append("\"" + value + "\"");
                        } else {
                            fields.append(value);
                        }
                    }
                }
                fields.append("}");
                if (it.hasNext()) {
                    fields.append(",");
                }
                fields.append("\n");
            }
        }
        return fields;
    }

    String getParentPath(DataObject page, SWBScriptEngine eng) throws IOException {
        StringBuilder ret = new StringBuilder();
        String parentId = page.getString("parentId");
        if (parentId != null) {
            DataObject obj = eng.getDataSource("Page").getObjectById(parentId);
            String title = obj.getString("name", "");
            //String smallName=obj.getString("smallName","");
            String path = obj.getString("path");
            String iconClass = obj.getString("iconClass");
            if (iconClass == null) {
                iconClass = "fa fa-circle-o";
            }
            String type = obj.getString("type");

            if ("sc_grid".equals(type)) {
                path = "admin_content?pid=" + obj.getNumId();
            }
            if ("sc_grid_detail".equals(type)) {
                path = "admin_content?pid=" + obj.getNumId();
            }
            if ("sc_form".equals(type)) {
                path = "admin_content?pid=" + obj.getNumId();
            }
            if ("iframe_content".equals(type)) {
                path = "admin_content?pid=" + obj.getNumId();
            }
            if ("ajax_content".equals(type)) {
                path = "admin_content?pid=" + obj.getNumId();
            }

            if (type != null && !type.equals("head")) {
                ret.append(getParentPath(obj, eng));
                ret.append("<li>");
                if (path != null) {
                    ret.append("<a href=\"" + path + "\">");
                }
                //if(iconClass!=null)ret.append("<i class=\""+iconClass+"\"></i> ");
                ret.append(title);
                if (path != null) {
                    ret.append("</a>");
                }
                ret.append("</li>");
            }
        }
        return ret.toString();
    }

%>
<%
    SWBScriptEngine eng = DataMgr.initPlatform("/admin/ds/admin.js", session);
    String dsName = request.getParameter("ds");
    String id = request.getParameter("_id");

    DataObject dods = eng.getDataSource("DataSource").fetchObjById(id);

//    System.out.println("dods...\n" + dods.toString(true));

//    DataObject query = new DataObject();
//    query.addSubList("sortBy").add("order");
//    DataObject data = new DataObject();
//
//    query.addParam("data", data);
//    data.addParam("ds", id);
//    data.addParam("type", "section");
//
//    DataObject rs;
//    rs = eng.getDataSource("DataSourceFields").fetch(query);
//
//    DataList dlprops = rs.getDataObject("response").getDataList("data");
//    StringBuilder sb = new StringBuilder();
//    for (int i = 0; i < dlprops.size(); i++) {
//        DataObject dobj = dlprops.getDataObject(i);
//        
//        System.out.println("name:" + dobj.getString("name") + ",title:" + dobj.getString("title") + ",type:" + dobj.getString("type", "N/A") +",order:"+dobj.getInt("order")+ "\n");
//    }
//
//    //DataObject dodf = eng.getDataSource("DataSourceField").fetch(query);
//    System.out.println("fields....\n" + rs.toString(true));

%>
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
            eng.initPlatform("/admin/ds/admin.js", false);
        </script>
        <script type="text/javascript">

            var grid = eng.createGrid({
                autoResize: true,
                resizeHeightMargin: 20,
                resizeWidthMargin: 15,
                canEdit: <%=eng.hasUserAnyRole(dods.getDataList("roles_update"))%>,
                canAdd: <%=eng.hasUserAnyRole(dods.getDataList("roles_add"))%>,
                canRemove: false<%//=eng.hasUserAnyRole(dods.getDataList("roles_remove"))%>,
                showFilter: true,
                initialCriteria: {'deleted': false},

                recordDoubleClick: function(grid, record)
                {
                    //loadContent("bicdetail.jsp?ds=<%=dsName%>&id="+ record["_id"],".content-wrapper");
                    window.location = "bicdetail.jsp?ds=<%=dsName%>&dsid=<%=id%>&id="+ record["_id"];
                    return false;
                },
                
                addButtonClick: function(event)
                {
                    //parent.loadContent("admin_content?pid=acervo&id=",".content-wrapper");
                    window.location = "bicdetail.jsp?ds=<%=dsName%>&dsid=<%=id%>&id=";
                    return false;
                },                                 

                fields: [
                    {name:"oaiid"},
                    {name:"culturaoaiid"},
                    {name:"recordtitle"},
                    {name:"holder"},
//                    {name:"modelid"},
                    {name:"deleted"},
                    {name:"forIndex"},
                    {name:"created"},
                    {name:"updated"}
                    ]           
            }, "<%=dsName%>");



        </script>         
    </body>
</html>