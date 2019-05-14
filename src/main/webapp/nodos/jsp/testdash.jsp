<%-- 
    Document   : testdash
    Created on : 12-mar-2019, 11:02:18
    Author     : juan.fernandez
--%>

<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page import="java.util.HashSet"%>
<%@page import="org.semanticwb.datamanager.DataList"%>
<%@page import="org.semanticwb.datamanager.DataObjectIterator"%>
<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    /**
     * 
     */
 public DataObject getDashBoardData(DataObjectIterator doit, DataList dl){
    DataObject doret = new DataObject();
    if(null==dl || null==doit) return doret;
    String propName = null;
    while (doit.hasNext()) {
        DataObject dobj = doit.next();
        for(int i=0; i<dl.size();i++){
            propName = dl.getString(i);
            //Se obtiene la propiedad a buscar
            String countValue = dobj.getString(propName);
            DataObject prop = doret.getDataObject(propName);
            //Revisando que la propiedad exista en el DataObject
            if(prop==null){
                prop = doret.addSubObject(propName);
            }
            if(prop.get(countValue)==null){
                prop.addParam(countValue, 1);
            } else {
                int val = prop.getInt(countValue);
                prop.addParam(countValue, val+1);
            }
        }  
    }
    return doret;
}




%>
<%
    SWBScriptEngine eng = DataMgr.initPlatform("/admin/ds/admin.js", session);

    DataObjectIterator doRecord = eng.getDataSource("Record").find();
    DataList dl = new DataList();
    dl.add("rightstitle");
    dl.add("important");
    dl.add("deleted");
    dl.add("datecreated");
   
    
    DataObject dashInfo =  getDashBoardData(doRecord,dl);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Test DashBoard data Information</h1>
        <p><%=dashInfo.toString()%></p>
    </body>
</html>
