<%-- 
    Document   : catalogos
    Created on : 17-ene-2019, 13:08:30
    Author     : juan.fernandez
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
<%-- 
    Document   : fichas
    Created on : 17-ene-2019, 12:29:44
    Author     : juan.fernandez
--%><!DOCTYPE html>
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
                canEdit: true,
                canAdd: true,
                canRemove: true,
                //showFilter: true,
                canReorderRecords: true,
                canAcceptDroppedRecords: true,
                
                showRecordComponents: true,
                showRecordComponentsByCell: true,
                //recordComponentPoolingMode: "recycle",
                fields: [
                    {name: "id", canEdit:false},
                    {name: "description"},
                    {name: "backend"},
                    {name: "frontend"},        
                    {name: "roles_fetch"},
                    {name: "roles_add"},
                    {name: "roles_update"},
                    {name: "roles_remove"},   
                    
                    {name: "edit", title: " ", width:32, canEdit:false, formatCellValue: function (value) {return " ";}},
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
                                parent.loadContent("prog_ds?mode=detail&id=" + record["_id"],".content-wrapper");
                                return false;
                            }
                        });
                        return content;
                    } else {
                        return null;
                    }
                },     
 
                addButtonClick: function(event)
                {
                    parent.loadContent("prog_ds?mode=detail&id=",".content-wrapper");
                    return false;
                },

                
            }, "DataSource");

        </script>         
    </body>
</html>
