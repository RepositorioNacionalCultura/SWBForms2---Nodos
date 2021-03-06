<%-- 
    Document   : propassignds
    Created on : 28-ene-2019, 18:53:55
    Author     : juan.fernandez
--%>

<%@page import="org.semanticwb.datamanager.DataObject"%>
<%@page import="org.semanticwb.datamanager.DataMgr"%>
<%@page import="org.semanticwb.datamanager.SWBScriptEngine"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    SWBScriptEngine eng = DataMgr.initPlatform("/admin/ds/admin.js", session);
    String dsName = request.getParameter("ds");
    String id = "_suri:SWBForms:DataSource:Record"; //request.getParameter("_id");

    DataObject dods = eng.getDataSource("DataSource").fetchObjById(id);

    //System.out.println("dods...\n" + dods.toString(true));


%>
<!DOCTYPE html>
<html>
    <head>
        <title>DataSources</title>
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

            var grid=eng.createGrid({
                //gridType: "TreeGrid",
                autoResize: true,
                resizeHeightMargin: 20,
                resizeWidthMargin: 15,
                canEdit: <%=eng.hasUserAnyRole(dods.getDataList("roles_update"))%>,
                canAdd: <%=eng.hasUserAnyRole(dods.getDataList("roles_add"))%>,
                canRemove: <%=eng.hasUserAnyRole(dods.getDataList("roles_remove"))%>,
                canReorderRecords: true,
                canAcceptDroppedRecords: true,
                
                expansionFieldImageShowSelected:true,
                canExpandRecords: true,
                
                canSort: false, // Disable user sorting because we rely on records being sorted by userOrder.
                sortField: "order",
                
                initialCriteria: {"ds":"_suri:SWBForms:DataSource:Record","type":"select"},
                fields: [
                    //{name: "ds"},
                    {name: "name"},
                    {name: "title"},
                    {name: "type"},        
                    {name: "required"},
                    {name: "order", width:70},
                ],
                        
                getExpansionComponent : function (record) 
                {
                    var grd=eng.createGrid({
                        height:200,       
                        canEdit: true,
                        canAdd: true,
                        canRemove: true,
                        showFilter: false,
                        editByCell: true,
                        initialCriteria: {"dsfield":record._id},
                        fields: [
                            //{name: "dsfield"},
                            {name: "att"},
                            {name: "value"},
                            {name: "type"},
                        ],
                        getEditorProperties:function(editField, editedRecord, rowNum) {
                            if (editField.name == "value")
                            {
                                if(editedRecord!=null) {
                                    var item=ds_field_atts_vals[editedRecord.att];
                                    editField._lastItem=item;
                                    //console.log(item);                                    
                                    return item;
                                }else
                                {
                                    return editField._lastItem;
                                }
                            } 
                            return null;
                        },                        
                    }, "DataSourceFieldsExt");  
                    return grd;
                }                        
                
            }, "DataSourceFields");    
            
            
            function createWidow(grid)
            {
                var totalsLabel = isc.Label.create({
                    padding: 5,
                    autoDraw:false,
                });

                var mem=[
                    totalsLabel,
                    isc.LayoutSpacer.create({
                        width: "*"
                    })
                ];

                var toolStrip = isc.ToolStrip.create({
                    width: "100%",
                    height: 24,
                    members: mem,
                    autoDraw:false
                });            


                var list=isc.ListGrid.create({
                    width: parent.innerWidth-600, height: parent.innerHeight-300,
                    dataSource: eng.createDataSource("DataSourceFields"),
                    alternateRecordStyles: true,
                    autoFetchData: true,
                    showFilterEditor: true,      
                    canEdit:false,
                    //initialCriteria:{estatus:'ACTIVO'},
                    fields: [
                        {name: "ds"},
                        {name: "name"},
                        {name: "title"},
                        {name: "type"},        
                        {name: "order"},        
                        {name: "required"},                     
                    ]
                });

                list.gridComponents = ["filterEditor","header", "body","summaryRow", toolStrip];

                list.dataChanged = function()
                {
                    this.Super("dataChanged", arguments);
                    var totalRows = this.data.getLength();
                    if (totalRows > 0 && this.data.lengthIsKnown()) {
                        totalsLabel.setContents(totalRows + " Registros");
                    } else {
                        totalsLabel.setContents(" ");
                    }
                };                        

                var addWindow=isc.Window.create({
                    title: "Copiar Propiedad",
                    autoSize:true,
                    autoCenter: true,
                    isModal: true,
                    showModalMask: true,
                    autoDraw: false,
                    closeClick : function () { this.Super("closeClick", arguments)},
                    items: [
                        list, 
                        isc.IButton.create(
                        {
                            title: "Agregar",
                            padding: "10px",
                            click: function(p1) {            
                                
                                var sel=list.getSelectedRecords();   
                                var i=0,r=0;
                                for(var x=0;x<sel.length;x++)
                                {
                                    var oid=sel[x]._id;
                                    console.log(sel[x]);                                    
                                    var obj={ds:"_suri:SWBForms:DataSource:Record", name:sel[x].name, title:sel[x].title, type:sel[x].type, order:sel[x].order};
                                    if(sel[x].required)obj.required=sel[x].required;
                                    console.log(obj);
                                    
                                    if(eng.getDataSource("DataSourceFields").fetch({data:{ds:obj.ds, name: obj.name}}).totalRows===0)
                                    {
                                        eng.getDataSource("DataSourceFields").addObj(obj);
                                        i++;
                                        var ext=eng.getDataSource("DataSourceFieldsExt").fetch({data:{dsfield:oid}}).data;
                                        console.log(ext);
                                        for(var y=0;y<ext.length;y++)
                                        {
                                            var next={dsfield: obj._id, att: ext[y].att, value: ext[y].value, type: ext[y].type};
                                            eng.getDataSource("DataSourceFieldsExt").addObj(next);      
                                            console.log(next);
                                        }                                        
                                    }else
                                    {
                                        r++;
                                    }
                                }
                                addWindow.hide();
                                list.invalidateCache();
                                grid.invalidateCache();                           
                                isc.confirm(i+" Registros Agregados y "+r+" Registros Repetidos"); 
                                return true;                                    
                            }
                        })
                    ]
                });     
                return addWindow;

            }
            
            var addWindow=createWidow(grid);
            
            var _copyProp = isc.ToolStripButton.create({
                icon: "[SKIN]/actions/configure.png",
                prompt: "Copiar Propiedad",
                autoDraw:false,
                click:function(){
                    addWindow.show();
                    return true;
                }
            });      
            var _toolStrip=grid.getGridMembers()[2];
            _toolStrip.addMember(_copyProp,3);            


        </script>         
    </body>
</html>
