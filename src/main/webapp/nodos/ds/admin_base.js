eng.require("/admin/ds/base.js",false);

//******* Contants ************
var type_pages = {
    "head": "Head",
    "group_menu": "Group Menu",
    "url_content": "URL Content",
    "ajax_content": "Ajax Content",
    "iframe_content": "IFrame Content",
    "sc_grid": "SC Grid",
    "sc_grid_detail": "SC Grid Detail",
    "sc_form": "SC Form",
    //"subt_ajax_content": "Subtab Ajax Content",
    //"subt_iframe_content": "Subtab IFrame Content",
    //"subt_sc_grid": "Subtab SC Grid",
    //"subt_sc_form": "Subtab SC Form"
};

//Tipos de propiedades o Fields
//type: string, int, date, float, double, long, text      //primitivos
//stype: grid, gridSelect, select, time, file             //extendidos
//Tipos de links, objetos vinculados a formas
//stype: subForm, tab

var ds_dataSources=[];

var ds_field_types = ["boolean","date","double","float","int","long","password","select","string","time"];

var ds_field_atts_types = ["boolean","date","double","float","int","long","password","select","string","object","time"];

var ds_view_atts=[];

var ds_field_atts = [];

var ds_field_atts_vals={    
    canEdit:{type:"boolean"},
    canEditRoles:{type:"object", editorType:"SelectOtherItem", multiple:true, valueMap:roles},    
    canFilter:{type:"boolean"},
    canViewRoles:{type:"object", editorType:"SelectOtherItem", multiple:true, valueMap:roles},    
    dataSource:{type:"string", editorType:"SelectOtherItem", valueMap:[]},                            //se llena al final
    editorType:{type:"string", editorType:"SelectOtherItem", valueMap:{"StaticTextItem":"StaticTextItem"}},
    format:{type:"string"},
    formatCellValue:{type:"object"},    
    mask:{type:"string"},
    multiple:{type:"boolean"},                                                                              //select
    redrawOnChange:{type:"boolean"},                                                                        //select
    required:{type:"boolean", viewAtt:true},
    showFilter:{type:"boolean"},
    selectFields:{type:"object"},
    selectWidth:{type:"int"},
    showIf:{type:"string"},
    stype:{type:"string", editorType:"SelectOtherItem", valueMap:{"select":"select","gridSelect":"gridSelect","grid":"grid","time":"time","file":"file","text":"text","html":"html","autogen":"autogen","sequence":"sequence","id":"id"}},
    title:{type:"string", viewAtt:true},
    type:{type:"string", viewAtt:true, editorType:"SelectOtherItem", valueMap:ds_field_types},
    validators:{type:"string", editorType:"SelectItem", multiple:true, valueMap:{}},
    valueMap:{type:"object"},                                                                               //select
    width:{type:"string", viewAtt:true},
};



eng.dataSources["Record"] = {
    scls: "Record",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "id",
    fields: [
        {name: "id", title: "Identificador", type: "string", validators: [{stype: "unique"},{stype: "id"}]},
        {name: "description", title: "Descripción", type: "string"},
        {name: "scls", title: "Nombre de Collección", type: "string"},
        {name: "modelid", title: "Nombre del Modelo", type: "string"},
        {name: "dataStore", title: "Data Store", type: "string"},
        {name: "displayField", title: "Campo de Despliegue", type: "string"},
        {name: "backend", title: "Backend", type: "boolean"},
        {name: "frontend", title: "Frontend", type: "boolean"},
        
        {name: "roles_fetch", title: "Roles de Consulta", type: "selectOther", multiple:true, valueMap:roles},
        {name: "roles_add", title: "Roles de Creación", type: "selectOther", multiple:true, valueMap:roles},
        {name: "roles_update", title: "Roles de Edición", type: "selectOther", multiple:true, valueMap:roles},
        {name: "roles_remove", title: "Roles de Eliminación", type: "selectOther", multiple:true, valueMap:roles},
        
        {name: "created", title: "Fecha de Registro", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "creator", title: "Usuario Creador", type: "string", editorType: "StaticTextItem", canEdit: false},
        {name: "updated", title: "Ultima Actualización", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "updater", title: "Usuario Ultima Actualización", type: "string", editorType: "StaticTextItem", canEdit: false},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};

eng.dataServices["RecordService"] = {
    dataSources: ["Record"],
    actions:["add", "update","remove"],
    service: function(request, response, dataSource, action)
    {
        //print("DataSourceService:"+request.data["_id"]+"->"+action);
        if(action=="remove")
        {
            var it=this.getDataSource("DataSourceFields").find({data:{ds:request.data["_id"]}});
            while(it.hasNext())
            {
                this.getDataSource("DataSourceFields").removeObj(it.next());
            }
        }
    }
};



