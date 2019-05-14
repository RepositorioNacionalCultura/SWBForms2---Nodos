<%-- 
    Document   : idsGenerator
    Created on : 01-nov-2018, 19:03:59
    Author     : juan.fernandez
--%><%@page import="java.util.Iterator"%><%@page import="java.io.PrintWriter"%><%@page import="java.util.HashMap"%><%@page import="org.json.JSONObject"%><%@page import="mx.gob.cultura.commons.Util"%><%@page import="java.text.NumberFormat"%><%@page import="org.semanticwb.datamanager.DataObject"%><%@page import="org.semanticwb.datamanager.DataObjectIterator"%><%@page import="org.semanticwb.datamanager.DataMgr"%><%@page import="org.semanticwb.datamanager.SWBScriptEngine"%><%@page import="org.semanticwb.datamanager.SWBDataSource"%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
// Ejemplo OAI Identifier :  oai:mx.gob.cultura.mexicana:0010723/0000001
    String oaiPattern = "oai:mexicana.cultura.gob.mx:{@idHolder}/";
    String folioPattern = "#######";
//NumberFormat nf = new NumberFormat();

    String act = "selHolder";
if(request.getParameter("act")!=null){
    act = request.getParameter("act");
//    if("selHolder".equals(act)){
//        act = "getCount";
//    } 
}
//    System.out.println("ACTION:" + act);
    String extractor = request.getParameter("extractor");
    String holder = request.getParameter("holder");
    SWBScriptEngine engine = DataMgr.initPlatform("/work/cultura/jsp/datasources.js", session);
    SWBDataSource dsex = engine.getDataSource("Extractor");
    SWBDataSource dshldr = engine.getDataSource("Nombres-de-Instituciones-custodias-y-funciones");
    SWBDataSource dscount = engine.getDataSource("Serial");

    DataObjectIterator itdo = dshldr.find();
    DataObjectIterator itex = dsex.find();
    DataObject noId = new DataObject();

//{ b: { $exists: false } } 
    DataObject sub = noId.addSubObject("data").addSubObject("culturaoaiid");
    sub.addParam("$exists", false);

//    System.out.println(noId.toString(true));

    HashMap<String, DataObject> hmerror = null;
    int num = 0;
    if(act.equals("reporte")){
        response.setContentType("text/plain");
        response.setHeader("Content-Disposition","attachment;filename=reporte.txt");
        try {
                out.println("Reporte de Registros que no se pudo Generar CULTURAOAIID");
                HashMap<String,DataObject> hm = (HashMap)request.getSession().getAttribute("_oaiid_error_list");
                request.getSession().removeAttribute("_oaiid_error_list");
                if(null!=hm&&!hm.isEmpty()){
                    out.println("_id,OAIID");
                    Iterator<DataObject> it = hm.values().iterator();
                    while(it.hasNext()){
                        DataObject dobj = it.next();
                        out.println(dobj.getId()+","+dobj.getString("oaiid","--"));
                    }
                    
                }
                
            } catch (Exception e) {
            }
        return; 
    }
//    System.out.println("paso 1");
%>


<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="../../templates/metas.jsp" flush="true"></jsp:include>
            <title>Repositorio Digital del Patrimonio Nacional de Cultura - Generador de ID's</title>
        </head>
        <body class="animated fadeIn">
        <jsp:include page="../../templates/topnav.jsp" flush="true">
            <jsp:param name="activeItem" value="idsGenerator" />
        </jsp:include>
        <div class="container-fluid">
            <div class="row">
                <jsp:include page="../../templates/sidenav.jsp" flush="true">
                    <jsp:param name="activeItem" value="idsGenerator" />
                </jsp:include>
                <main role="main" class="col-sm-9 ml-sm-auto col-md-10 pt-3">

                    <h1>Generador de URI</h1>
                    <div>
                        <form action="" method="post">
                            <input type="hidden" name="act" value="<%=act%>"/>
                            <label>Institución - Modelo</label>
                            <select  name="extractor" _onchange="this.form.submit()">
                                <option>Selecciona Institución/Modelo</option>
                                <%
//                                    System.out.println("paso 2");
                                    DataObject thisExt = null;
                                    String hldrId = null;
                                    String hldrIdDO = null;
                                    String hldrOrig = null;
                                    while (itex.hasNext()) {

                                        DataObject dobj = itex.next();
                                        String selected = "";
                                        if (null != extractor && extractor.equals(dobj.getId() + "|" + dobj.getString("name"))) {
                                            selected = "selected=\"selected\"";
                                            thisExt = dobj;
                                        }
                                %>
                                <option value="<%=dobj.getId() + "|" + dobj.getString("name")%>" <%=selected%>><%=dobj.getString("fullHolderName") + "/" + dobj.getString("name")%></option>
                                <%
                                    }
                                %>
                            </select>
                            <button type="submit" >Enviar</button>
                            <%if (null != act || holder != null) {
//                                System.out.println("paso 3");
                                    if (thisExt != null) {
                                        hldrId = thisExt.getString("holderid");
                                        if (null != hldrId && hldrId.startsWith("NI")) {
                                            hldrId = hldrId.substring(2);
                                        }


                            %>
                            <br><label>Generación de IDs Cultura <%=oaiPattern%></label>

                            <%
                                    String culturaId = null;

                                    SWBDataSource transobjs = engine.getDataSource("TransObject", thisExt.getString("name").toUpperCase());
                                    DataObjectIterator itcount = transobjs.find(noId);
                                    out.println("<br>Encontrados sin ID:" + itcount.size() + "<br>");
                                    hmerror = new HashMap<>();
                                    
                                    while (itcount.hasNext()) {

                                        DataObject dobj = itcount.next();
                                        if (null != dobj && dobj.getString("culturaoaiid", null) != null) {
                                            continue; 
                                        }
                                        culturaId = oaiPattern;
                                        hldrIdDO = null;
                                        if (dobj.getString("holderid") != null && dobj.getString("holderid").trim().length() > 0) {
                                            hldrIdDO = dobj.getString("holderid").trim();
                                            if (hldrIdDO.toUpperCase().startsWith("NI")) {
                                                hldrIdDO = hldrIdDO.substring(2);
                                            }
                                        }
                                        if (null != hldrIdDO) {
                                            culturaId = oaiPattern.replace("{@idHolder}", hldrIdDO);
                                            hldrOrig = "NI" + hldrIdDO;
                                        } else if (hldrId != null) {
                                            culturaId = oaiPattern.replace("{@idHolder}", hldrId);
                                            hldrOrig = "NI" + hldrId;
                                        } else {
                                            
                                            hmerror.put(dobj.getId(), dobj);
                                            continue;
                                        }
                                        String culturaoaiid = culturaId + String.format("%07d", Util.nextHolderId(hldrOrig, engine));
                                        dobj.put("culturaoaiid", culturaoaiid);
                                        transobjs.updateObj(dobj);
                                        num++;
                                        //out.println(culturaoaiid + "<br>");

                                    }
                                }
                            %>
                            <p>Se generaron <%=num%> nuevos IDs</p>
                            
                            <%  if(null!=hmerror && !hmerror.isEmpty()){
                              
                                // Se podría generar un reporte de los registros que no se pudieron generar
                                request.getSession().setAttribute("_oaiid_error_list", hmerror);
                                out.println("<h4>No se pudieron generar IDs, no se encontró el identificador de la Institución.</h4>");
                                %>
                                <button onclick="this.form.act.value='reporte';this.form.submit();">Ver reporte de registros que no se pudieron generr OAIID</button>
                                <%
                                
                                
                                } 
                            }
                            
                            %>

                        </form>

                    </div>
                </main>
            </div>
        </div>
        <jsp:include page="../../templates/bodyscripts.jsp" flush="true"></jsp:include>
    </body>
</html>
