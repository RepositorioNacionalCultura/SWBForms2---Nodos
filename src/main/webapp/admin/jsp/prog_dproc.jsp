<%-- 
    Document   : prog_menu
    Created on : 10-feb-2018, 19:57:02
    Author     : javiersolis
--%><%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%><%
    String _title="DataProcessor";
    String _ds="DataProcessor";
    String _fileName="prog_dproc";
    SWBScriptEngine eng=DataMgr.initPlatform("/admin/ds/admin.js", session);
    //if(!eng.hasUserPermission(_permision))response.sendError(403,"Acceso Restringido...");

    String id=request.getParameter("id"); 
    boolean iframe=request.getParameter("iframe")!=null; 
    boolean detail=request.getParameter("detail")!=null; 
    boolean add=(id!=null && id.length()==0);
       
    if(!iframe)
    {
%>
<!-- Content Header (Page header) -->
<section class="content-header">
    <h1>
        <%=_title%>
        <small></small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="/admin"><i class="fa fa-home"></i>Home</a></li>
        <li>Programación</li>
        <li <%=detail?"":"class=\"active\""%>><a href="<%=_fileName%>" data-history="#<%=_fileName%>" data-target=".content-wrapper" data-load="ajax"><%=_title%></a></li>
<%
        if(detail)
        {            
%>
        <li class="active"><%=add?"Alta":"Detalle"%></li>
<%
        }
%>        
    </ol>
</section>
<!-- Main content -->
<%
        if(detail)
        {
%>            
<section id="content" class="content">  
    <div class="row">
        <div class="col-md-12" id="main_content">
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#info" data-toggle="tab" aria-expanded="true"><%=add?"Agregar Menu":"Información"%></a></li>
                    <!--<li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">Fields</a></li>-->
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="info">
                        <iframe class="ifram_content" src="<%=_fileName%>?iframe=true&detail=true&id=<%=id%>" frameborder="0" width="100%">Cargando...</iframe>
                    </div><!-- /.tab-pane -->
                </div><!-- /.tab-content -->
                <script type="text/javascript">
                    $(window).resize();
                </script>                                                
            </div><!-- nav-tabs-custom -->
        </div><!-- /.col -->
    </div>
</section><!-- /.content -->
<%
        }else
        {
%>
<section id="content" style="padding: 7px">  
    <iframe class="ifram_content" src="<%=_fileName%>?iframe=true" frameborder="0" width="100%">Cargando...</iframe>
    <script type="text/javascript">
        $(window).resize();
    </script>                        
</section><!-- /.content -->
<%
        }
    }else 
    {
%>
<!DOCTYPE html>
<html>
    <head>
        <title><%=_title%></title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="/platform/js/eng.js?id=<%=eng.getId()%>" type="text/javascript"></script>
        <link href="/admin/css/sc_admin.css" rel="stylesheet" type="text/css" />
        
        <link rel="stylesheet" href="/platform/codemirror/lib/codemirror.css">
        <link rel="stylesheet" href="/platform/codemirror/addon/hint/show-hint.css">
        <link rel="stylesheet" href="/platform/codemirror/theme/eclipse.css">   
        <link rel="stylesheet" href="/platform/codemirror/addon/dialog/dialog.css">
        <link rel="stylesheet" href="/platform/codemirror/addon/lint/lint.css">  
        

        <script src="/platform/codemirror/lib/codemirror.js"></script>  
        <script src="/platform/codemirror/addon/hint/show-hint.js"></script>
        <script src="/platform/codemirror/addon/selection/active-line.js"></script> 
        <script src="/platform/codemirror/addon/lint/lint.js"></script>       
        <script src="/platform/codemirror/addon/search/search.js"></script> 
        <script src="/platform/codemirror/addon/search/searchcursor.js"></script>
        <script src="/platform/codemirror/addon/dialog/dialog.js"></script>
        
                
        <script src="/platform/codemirror/mode/javascript/javascript.js"></script>
        <script src="/platform/codemirror/addon/hint/javascript-hint.js"></script>
        <script src="/platform/codemirror/addon/lint/javascript-lint.js"></script>
        <script src="//ajax.aspnetcdn.com/ajax/jshint/r07/jshint.js"></script>
                
        <script src="/platform/codemirror/addon/edit/matchbrackets.js"></script>
        <script src="/platform/codemirror/addon/edit/closebrackets.js"></script>
        <script src="/platform/codemirror/addon/comment/continuecomment.js"></script>
        <script src="/platform/codemirror/addon/comment/comment.js"></script>
                
        <script src="/platform/codemirror/mode/clike/clike.js"></script>
                
    </head>
    <body>
        <script type="text/javascript">
            eng.initPlatform("/admin/ds/admin.js", <%=eng.getDSCache()%>);
        </script>
        <script type="text/javascript">            
<%            
        if(id==null)
        {
%>
            eng.createGrid({
                autoResize: true,
                resizeHeightMargin: 20,
                resizeWidthMargin: 15,
                canEdit: true,
                canAdd: true,
                canRemove: true,
                //showFilter: true,
                
                showRecordComponents: true,
                showRecordComponentsByCell: true,
                //recordComponentPoolingMode: "recycle",
                fields: [
                    {name: "id"},
                    {name: "dataSources"},
                    {name: "actions"},
                    //{name: "request"},
                    //{name: "response"},
                    //{name: "created"},
                    //{name: "creator"},
                    //{name: "updated"},
                    //{name: "updater"},
                    {name: "edit", title: " ", width:32, canEdit:false, formatCellValue: function (value) {return " ";}}
                ],
                
                createRecordComponent: function (record, colNum) {
                    var fieldName = this.getFieldName(colNum);

                    if (fieldName == "edit") {
                        var content=isc.HTMLFlow.create({
                            width:16,
                            //height:16,
                            contents:"<img style=\"cursor: pointer;\" width=\"16\" height=\"16\" src=\"/platform/isomorphic/skins/Tahoe/images/actions/edit.png\">", 
                            dynamicContents:true,
                            click: function () {
                                //isc.say(record["_id"] + " info button clicked.");
                                parent.loadContent("<%=_fileName%>?detail=true&id=" + record["_id"],".content-wrapper");
                                return false;
                            }
                        });
                        return content;
                    } else {
                        return null;
                    }
                },     
/*         
                addButtonClick: function(event)
                {
                    parent.loadContent("<%=_fileName%>?detail=true&id=",".content-wrapper");
                    return false;
                },
*/                
            }, "<%=_ds%>");
<%
        }else
        {
            String sid = add?"null":"\"" + id + "\"";
%>
            
    
            var form = eng.createForm({
                width: "100%",
                left: "-8px",
                title: "Información",
                showTabs: false,
                canPrint: false,
                numCols: 2,
                colWidths: [250, "*"],
                redrawOnResize:false,
                
                hasType:function(type)
                {                    
                    var val=this.getValue('type')
                    if(typeof type === "string")
                    {
                        return val && val.startsWith(type);
                    }else if(typeof type === "object")
                    {                        
                        if(val)
                        {
                            //console.log(type);
                            for(var i=0;i<type.length;i++)
                            {                                
                                if(val.startsWith(type[i]))return true;
                            }
                            return false;
                        }                        
                    }
                    return true;
                },
                
                fields: [
                    {name: "id"},
                    {name: "dataSources"},
                    {name: "actions"},
                    {name: "request", height:300},
                    {name: "response", height:300},
<%if(!add){%>                    
                    {name: "created"},
                    {name: "creator"},
                    {name: "updated"},
                    {name: "updater"},
<%}%>   
                ],
                                
                onLoad:function()
                {
                    var req="request";
                    var res="response";
                    var reqele=document.getElementsByName(req)[0];
                    var resele=document.getElementsByName(res)[0];
                                                            
                    var reqCM = CodeMirror.fromTextArea(reqele, {
                        mode: "text/javascript",                            
                        smartIndent: true,
                        lineNumbers: true,
                        styleActiveLine: true,
                        matchBrackets: true,
                        autoCloseBrackets: true,
                        theme: "eclipse",
                        continueComments: "Enter",
                        extraKeys: {"Ctrl-Space": "autocomplete","Ctrl-Q": "toggleComment","Ctrl-J": "toMatchingTag"},
                        matchTags: {bothTags: true},                  
                        gutters: ["CodeMirror-lint-markers"],
                        lint: true,
                    }); 
                    
                    var resCM = CodeMirror.fromTextArea(resele, {
                        mode: "text/javascript",                            
                        smartIndent: true,
                        lineNumbers: true,
                        styleActiveLine: true,
                        matchBrackets: true,
                        autoCloseBrackets: true,
                        theme: "eclipse",
                        continueComments: "Enter",
                        extraKeys: {"Ctrl-Space": "autocomplete","Ctrl-Q": "toggleComment","Ctrl-J": "toMatchingTag"},
                        matchTags: {bothTags: true},                  
                        gutters: ["CodeMirror-lint-markers"],
                        lint: true,
                    }); 
                    
                    reqCM.on('change',function(cm){
                        // get value right from instance
                        form.setValue(req,cm.getValue());
                    });
                    
                    resCM.on('change',function(cm){
                        // get value right from instance
                        form.setValue(res,cm.getValue());
                    });
                    
                    var repaint=function(name,cm){
                        setTimeout(function(){ 
                            var ele=document.getElementsByName(name)[0];
                            ele.style.display = "none";
                            ele.parentNode.insertBefore(cm.getWrapperElement(), ele.nextSibling);
                        },0);
                    };
                    
                    repaint(req,reqCM);
                    repaint(res,resCM);
                                                                
                    window.addEventListener("resize", function(){
                        repaint(req,reqCM);
                        repaint(res,resCM);
                    });                   
                }
                
            }, <%=sid%>, "<%=_ds%>");
            
            form.submitButton.setTitle("Guardar");

            form.submitButton.click = function (p1)
            {
                eng.submit(form, this, function ()
                {
                    isc.say("Datos enviados correctamente...", function () {
                        <%if(add){%>parent.loadContent("<%=_fileName%>?detail=true&id=" + form.values._id,".content-wrapper");<%}%>
                    });
                });
            };

            form.buttons.addMember(isc.IButton.create({
                title: "Regresar",
                padding: "10px",
                click: function (p1) {
                    parent.loadContent("<%=_fileName%>",".content-wrapper");
                    return false;
                }
            }));
            form.buttons.members.unshift(form.buttons.members.pop());
<%
        }
%>
        </script>         
    </body>
</html>
<%
    }
%>
