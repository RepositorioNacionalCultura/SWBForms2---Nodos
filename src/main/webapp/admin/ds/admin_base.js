eng.require("/admin/ds/base.js",eng.config.dsCache);

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

var ds_field_types = ["boolean","date","double","float","header","int","long","password","section","select","string","time"];

var ds_field_atts_types = ["boolean","date","double","float","int","long","password","select","string","object","time"];

var ds_view_atts=[];

var ds_field_atts = [];

var ds_field_atts_vals={    
    canEdit:{type:"boolean"},
    canEditRoles:{type:"object", editorType:"SelectOtherItem", multiple:true, valueMap:roles},    
    canFilter:{type:"boolean"},
    canViewRoles:{type:"object", editorType:"SelectOtherItem", multiple:true, valueMap:roles},    
    dataSource:{type:"string", editorType:"SelectOtherItem", valueMap:[]},                            //se llena al final
    defaultValue:{type:"string"},
    displayFormat:{type:"string", hint:"value+' '+record.name", showHintInField:"true"},
    editorType:{type:"string", editorType:"SelectOtherItem", valueMap:{"StaticTextItem":"StaticTextItem"}},
    format:{type:"string"},
    formatCellValue:{type:"object", hint:"value+' '+record.name", showHintInField:"true"},   
    helpText:{type:"string"},
    hint:{type:"string"},    
    hoverWidth:{type:"string"},
    icons:{type:"object"},    
    mask:{type:"string"},
    multiple:{type:"boolean"},                                                                              //select
    prompt:{type:"string"},
    redrawOnChange:{type:"boolean"},                                                                        //select
    required:{type:"boolean", viewAtt:true},
    showFilter:{type:"boolean"},
    selectFields:{type:"object"},
    selectWidth:{type:"int"},
    showHintInField:{type:"boolean"},
    showIf:{type:"string"},
    stype:{type:"string", editorType:"SelectOtherItem", valueMap:{"select":"select","gridSelect":"gridSelect","listGridSelect":"listGridSelect","grid":"grid","time":"time","file":"file","text":"text","html":"html","autogen":"autogen","sequence":"sequence","id":"id"}},
    title:{type:"string", viewAtt:true},
    type:{type:"string", viewAtt:true, editorType:"SelectOtherItem", valueMap:ds_field_types},
    validators:{type:"string", editorType:"SelectItem", multiple:true, valueMap:{}},
    valueMap:{type:"object"},                                                                               //select
    width:{type:"string", viewAtt:true},
};

var ds_validator_atts = [];

var ds_validator_types = ["isBoolean","isString","isInteger","isFloat","isFunction",
    "requiredIf", //expression which takes four parameters:
        //item - the DynamicForm item on which the error occurred (may be null)
        //validator - a pointer to the validator object
        //value - the value of the field in question
        //record - the "record" object - the set of values being edited by the widget
    "matchesField", //otherField (should be set to a field name).
    "isOneOf",  //list which should be set to an array of values.
    "regexp",   //expresion
    "integerRange", //min, max, exclusive:true
    "lengthRange",  //min, max
    "mask",     //transformTo
    "custom",   //condition
    "serverCustom", // serverCondition
    "dateRange",    //min max
    "floatRange",   //min max
    
];
var ds_validator_atts_vals={
    expression:{type:"string"},
    list:{type:"object", hint:"['val1','val2']", showHintInField:"true"},
    mask:{type:"string"},    
    max:{type:"int"},
    min:{type:"int"},    
    otherField:{type:"string"},
    transformTo:{type:"string"},
    exclusive:{type:"boolean"},
    condition:{type:"object"},
    serverCondition:{type:"object", hint:"function(name,value,request){return true;}", showHintInField:"true"},
};
var ds_validator_atts_types = ["boolean","double","int","string","object"];

eng.dataSources["DataSourceFieldsExt"] = {
    scls: "DataSourceFieldsExt",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "prop",
    fields: [
        {name: "dsfield", title: "DataSourceField", stype: "select", dataSource:"DataSourceFields"},
        {name: "att", title: "Atributo", type: "selectOther", valueMap:ds_field_atts, 
            change:function(form,item,value){
                var att=ds_field_atts_vals[value];
                if(att)
                {
                    item.grid.setEditValue(item.rowNum,"type",att.type);
                    //form.setValue("type",att.type);
                }
            }
        },
        {name: "value", title: "Valor", type: "string"},
        {name: "type", title: "Tipo de Valor", type: "select", valueMap:ds_field_atts_types},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};

eng.dataSources["DataSourceFields"] = {
    scls: "DataSourceFields",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "title",
    fields: [
        {name: "ds", title: "DataSource", stype: "select", dataSource:"DataSource"},
        {name: "name", title: "Identificador", type: "string"},
        {name: "title", title: "Título", type: "string"},
        {name: "type", title: "Tipo", type: "selectOther", valueMap: ds_field_types},
        {name: "order", title: "Orden", type: "int"},
        {name: "visible", title: "Visible", type: "boolean", "defaultValue": true},
        {name: "facetado", title: "Facetado", type: "boolean", "defaultValue": false},
        {name: "parentid", title: "Padre", type: "string", "foreignKey": "Record._id", "stype": "select", "dataSource": "Record"},
        {name: "required", title: "Requerido", type: "boolean"},
        {name: "created", title: "Fecha de Registro", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "creator", title: "Usuario Creador", type: "string", editorType: "StaticTextItem", canEdit: false},
        {name: "updated", title: "Ultima Actualización", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "updater", title: "Usuario Ultima Actualización", type: "string", editorType: "StaticTextItem", canEdit: false},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};

eng.dataServices["DataSourceFieldsService"] = {
    dataSources: ["DataSourceFields"],
    actions:["add", "update","remove"],
    service: function(request, response, dataSource, action)
    {
        //print("DataSourceFieldsService:"+request.data["_id"]+"->"+action);
        if(action=="remove")
        {
            var it=this.getDataSource("DataSourceFieldsExt").find({data:{dsfield:request.data["_id"]}});
            while(it.hasNext())
            {
                this.getDataSource("DataSourceFieldsExt").removeObj(it.next());
            }
        }
    }
};

eng.dataSources["DataSource"] = {
    scls: "DataSource",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "id",
    fields: [
        {name: "id", title: "Identificador", type: "string", required: true, validators: [{stype: "unique"}, {stype: "id"}]},
        {name: "description", title: "Descripción", type: "string", required: true},
        {name: "scls", title: "Nombre de Collección", type: "string"},
        {name: "modelid", title: "Nombre del Modelo", type: "string"},
        {name: "isrecord", title: "Es ficha", type: "boolean", "defaultValue": false},
        {name: "iscatalog", title: "Es Catalogo", type: "boolean", "defaultValue": false},
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

eng.dataProcessors["DataSourceProcessor"] = {
    dataSources: ["DataSource"],
    actions: ["add"],
    request: function (request, dataSource, action)
    {

        if (request.data && request.data.iscatalog && request.data.iscatalog === true) {
            var info = request.data;
            var scls = request.data.id;
//            print("\n"+scls);
            if (scls && scls.startsWith("_suri:")) {
                scls = scls.substring(scls.lastIndexOf(":") + 1, scls.length);
            }
//            print("\nRES: "+scls);
            request.data.backend = true;
            request.data.frontend = true;
            request.data.scls = scls;
        }
//        print(request);

        return request;
    }
};
eng.dataServices["DataSourceService"] = {
    dataSources: ["DataSource"],
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

        if (action == "add" && request.data.iscatalog == true)
        {
//            print("ADD Catalog....");
            var dsf = this.getDataSource("DataSourceFields");
            var dsfext = this.getDataSource("DataSourceFieldsExt");
            var dobjid = {};
            dobjid.ds = response.data._id;
            dobjid.type = "string";
            dobjid.name = "id";
            dobjid.title = "Identificador";
            dobjid.order = 10;
            dobjid.visible = false;
            dobjid.facetado = false;
            var tmpOBJ = dsf.addObj(dobjid);

            var dobjstype = {
                dsfield: tmpOBJ.response.data._id,
                type: "string",
                att: "stype",
                value: "id"
            };
            
            var stypeobjid =  dsfext.addObj(dobjstype);
            
            var dobjvalidators = {
                dsfield: tmpOBJ.response.data._id,
                type: "string",
                att: "validators",
                value: "unique"
            };
            
            var validatorsobjid =  dsfext.addObj(dobjvalidators);
            
            
            var dsf = this.getDataSource("DataSourceFields");
            var dobjname = {};
            dobjname.ds = response.data._id;
            dobjname.type = "string";
            dobjname.name = "name";
            dobjname.title = "Nombre";
            dobjname.order = 15;
            dobjname.visible = false;
            dobjname.facetado = false;
            tmpOBJ = dsf.addObj(dobjname);

        }


//        if (action == "add" && request.data.isrecord == true)
//        {
//            var dsf = this.getDataSource("DataSourceFields");
//            var dsfext = this.getDataSource("DataSourceFieldsExt");
//            var dobjseg = {
//                type : "section",
//                ds : response.data._id,
//                name : "seguimiento",
//                defaultValue : "Seguimiento",
//                title : "Seguimiento",
//                order : 250
//            };
//
//            var secOBJ = dsf.addObj(dobjseg);
//            var secid = secOBJ.response.data._id;
//
//            var dobjcreator = {};
//            dobjcreator.ds = response.data._id;
//            dobjcreator.type = "string";
//            dobjcreator.name = "creator";
//            dobjcreator.title = "Usuario Creador";
//            dobjcreator.order = 260;
//            dobjcreator.parentid = secid;
//
//            var tmpOBJ = dsf.addObj(dobjcreator);
//            
//            var dobjreadonlyseg1 = {
//                dsfield: tmpOBJ.response.data._id,
//                type: "string",
//                att: "editorType",
//                value: "StaticTextItem"
//            };
//            
//            var readonlyseg1OBJ =  dsfext.addObj(dobjreadonlyseg1);
//
//            var dobjcreated = {};
//            dobjcreated.ds = response.data._id;
//            dobjcreated.type = "date";
//            dobjcreated.name = "created";
//            dobjcreated.title = "Fecha de registro";
//            dobjcreated.order = 255;
//            dobjcreated.parentid = secid;
//            tmpOBJ = dsf.addObj(dobjcreated);
//            
//            var dobjreadonlyseg2 = {
//                dsfield: tmpOBJ.response.data._id,
//                type: "string",
//                att: "editorType",
//                value: "StaticTextItem"
//            };
//            
//            var readonlyseg2OBJ =  dsfext.addObj(dobjreadonlyseg2);
//
//            var dobjupdater = {};
//            dobjupdater.ds = response.data._id;
//            dobjupdater.type = "string";
//            dobjupdater.name = "updater";
//            dobjupdater.title = "Usuario Última Actualización";
//            dobjupdater.order = 270;
//            dobjupdater.parentid = secid;
//            tmpOBJ = dsf.addObj(dobjupdater);
//            
//            var dobjreadonlyseg3 = {
//                dsfield: tmpOBJ.response.data._id,
//                type: "string",
//                att: "editorType",
//                value: "StaticTextItem"
//            };
//            
//            var readonlyseg3OBJ =  dsfext.addObj(dobjreadonlyseg3);
//
//            var dobjupdated = {};
//            dobjupdated.ds = response.data._id;
//            dobjupdated.type = "date";
//            dobjupdated.name = "updated";
//            dobjupdated.title = "Última Actualización";
//            dobjupdated.order = 265;
//            dobjupdated.parentid = secid;
//            tmpOBJ = dsf.addObj(dobjupdated);
//            
//            var dobjreadonlyseg4 = {
//                dsfield: tmpOBJ.response.data._id,
//                type: "string",
//                att: "editorType",
//                value: "StaticTextItem"
//            };
//            
//            var readonlyseg4OBJ =  dsfext.addObj(dobjreadonlyseg4);
//
//            var dobjcontrol = {
//                ds : response.data._id,
//                type : "section",
//                name : "control",
//                defaultValue : "Control",
//                title : "Control",
//                order: 200
//            };
//            
//            var ctrlOBJ = dsf.addObj(dobjcontrol);
//            var ctrlOBJid =  ctrlOBJ.response.data._id;
//            
//            var dobjdeleted = {};
//            dobjdeleted.ds = response.data._id;
//            dobjdeleted.type = "boolean";
//            dobjdeleted.name = "deleted";
//            dobjdeleted.title = "Borrado";
//            dobjdeleted.order = 210;
//            dobjdeleted.defaultValue = false;
//            dobjdeleted.parentid = ctrlOBJid;
//            tmpOBJ = dsf.addObj(dobjdeleted);
//            
//            var dobjindx = {};
//            dobjindx.ds = response.data._id;
//            dobjindx.type = "boolean";
//            dobjindx.name = "indexable";
//            dobjindx.title = "Indexar";
//            dobjindx.order = 215;
//            dobjindx.defaultValue = true;
//            dobjindx.parentid = ctrlOBJid;
//            tmpOBJ = dsf.addObj(dobjindx);
//            
//            var dobjgenerales = {
//                ds : response.data._id,
//                type : "section",
//                name : "generales",
//                defaultValue : "Generales",
//                title : "Generales",
//                order : 100
//            };
//            
//            var gralsOBJ = dsf.addObj(dobjgenerales);
//            var gralsOBJid =  gralsOBJ.response.data._id;
//            
//            var dobjholder = {};
//            dobjholder.ds = response.data._id;
//            dobjholder.type = "select";
//            dobjholder.name = "holder";
//            dobjholder.title = "Institución";
//            dobjholder.order = 115;
//            dobjholder.parentid = gralsOBJid;
//            dobjholder.visible = true;
//            dobjholder.facetado = true;
//            tmpOBJ = dsf.addObj(dobjholder);
//
//            var dobjselholder = {
//                dsfield: tmpOBJ.response.data._id,
//                type: "string",
//                att: "dataSource",
//                value: "Instituciones"
//            };
//            
//            var selHolderOBJ =  dsfext.addObj(dobjselholder);
//            
//            var dobjselSTYPEholder = {
//                dsfield: tmpOBJ.response.data._id,
//                type: "string",
//                att: "stype",
//                value: "select"
//            };
//            
//            var selHolderSTYPEOBJ =  dsfext.addObj(dobjselSTYPEholder);
//            
//            
//            var dobjdig = {};
//            dobjdig.ds = response.data._id;
//            //dobjdig.type = "string";
//            dobjdig.name = "digitalObject";
//            dobjdig.title = "Objeto Digital";
//            dobjdig.order = 120;
//            dobjdig.parentid = gralsOBJid;
//            dobjdig.visible = true;
//            dobjdig.facetado = false;
//            tmpOBJ = dsf.addObj(dobjdig);
//            
//            var dobjdigext = {
//                dsfield: tmpOBJ.response.data._id,
//                type: "string",
//                att: "stype",
//                value: "file"
//            };
//            
//            var digextOBJ =  dsfext.addObj(dobjdigext);
//            
//            
//            var dobjbasic = {
//                ds : response.data._id,
//                type : "section",
//                name : "basic",
//                defaultValue : "Información Básica",
//                title : "Información Básica",
//                order : 10
//            };
//            
//            var basicOBJ = dsf.addObj(dobjbasic);
//            var basicOBJid =  basicOBJ.response.data._id;
//            
//            var dobjtitle = {};
//            dobjtitle.ds = response.data._id;
//            dobjtitle.type = "string";
//            dobjtitle.name = "title";
//            dobjtitle.title = "Título";
//            dobjtitle.order = 15;
//            dobjtitle.parentid = basicOBJid;
//            dobjtitle.visible = true;
//            dobjtitle.facetado = false;
//            tmpOBJ = dsf.addObj(dobjtitle);
//            
//            var dobjdesc = {};
//            dobjdesc.ds = response.data._id;
//            dobjdesc.type = "string";
//            dobjdesc.name = "description";
//            dobjdesc.title = "Descripción";
//            dobjdesc.order = 20;
//            dobjdesc.parentid = basicOBJid;
//            dobjdesc.visible = true;
//            dobjdesc.facetado = false;
//            tmpOBJ = dsf.addObj(dobjdesc);
//            
//            var dobjkeys = {};
//            dobjkeys.ds = response.data._id;
//            //dobjkeys.type = "string";
//            dobjkeys.name = "keywords";
//            dobjkeys.title = "Palabras Clave";
//            dobjkeys.order = 25;
//            dobjkeys.parentid = basicOBJid;
//            dobjkeys.visible = true;
//            dobjkeys.facetado = false;
//            tmpOBJ = dsf.addObj(dobjkeys);
//            
//            
//            
//            
//            
////            var commonvals = {};
////            commonvals.put("type":"section");
////            commonvals.put("name":"seguimiento");
////            commonvals.put("defaultValue":"Seguimiento");
////            commonvals.put("ds":response.data._id);
////            
////            var commonvals = {};
////            commonvals.put("type":"section");
////            commonvals.put("name":"seguimiento");
////            commonvals.put("defaultValue":"Seguimiento");
////            commonvals.put("ds":response.data._id);
////            
////            var it = this.getDataSource("DataSourceFields").find({data: {ds: request.data["_id"]}});
////            while (it.hasNext())
////            {
////                this.getDataSource("DataSourceFields").removeObj(it.next());
////            }
//        }
    }
};

eng.dataSources["ValueMapValues"] = {
    scls: "ValueMapValues",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "id",
    fields: [
        {name: "id", title: "Identificador", validators: [{stype: "id"}], type: "string", required: true},
        {name: "value", title: "Valor", type: "string", required: true},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};

eng.dataSources["ValueMap"] = {
    scls: "ValueMap",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "id",
    fields: [
        {name: "id", title: "Identificador", type: "string", validators: [{stype: "unique"},{stype: "id"}]},
        {name: "values", title: "Valores", stype: "grid",  dataSource:"ValueMapValues"},        
        {name: "created", title: "Fecha de Registro", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "creator", title: "Usuario Creador", type: "string", editorType: "StaticTextItem", canEdit: false},
        {name: "updated", title: "Ultima Actualización", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "updater", title: "Usuario Ultima Actualización", type: "string", editorType: "StaticTextItem", canEdit: false},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};


eng.dataSources["ValidatorExt"] = {
    scls: "ValidatorExt",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "prop",
    fields: [
        {name: "validator", title: "Validator", stype: "select", dataSource:"Validator"},
        {name: "att", title: "Atributo", type: "selectOther", valueMap:ds_validator_atts, 
            change:function(form,item,value){
                var att=ds_validator_atts_vals[value];
                if(att)
                {
                    item.grid.setEditValue(item.rowNum,"type",att.type);
                    //form.setValue("type",att.type);
                }
            }
        },
        {name: "value", title: "Valor", type: "string"},
        {name: "type", title: "Tipo de Valor", type: "select", valueMap:ds_validator_atts_types},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};

eng.dataSources["Validator"] = {
    scls: "Validator",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "name",
    fields: [
        {name: "id", title: "Identificador", type: "string", validators: [{stype: "unique"},{stype: "id"}]},
        //{name: "name", title: "Nombre", type: "string"},
        {name: "type", title: "Tipo", type: "selectOther", valueMap:ds_validator_types},        
        {name: "errorMessage", title: "Mensaje de Error", type: "string"},        
        {name: "description", title: "Descripción", type: "string"},
        
        {name: "created", title: "Fecha de Registro", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "creator", title: "Usuario Creador", type: "string", editorType: "StaticTextItem", canEdit: false},
        {name: "updated", title: "Ultima Actualización", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "updater", title: "Usuario Ultima Actualización", type: "string", editorType: "StaticTextItem", canEdit: false},
    ]
};

eng.dataSources["DataService"] = {
    scls: "DataService",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "id",
    fields: [
        {name: "id", title: "Identificador", type: "string", validators: [{stype: "unique"},{stype: "id"}]},
        {name: "dataSources", title: "DataSources",  multiple:true, type: "selectOther", valueMap:ds_dataSources},        
        {name: "actions", title: "Actions", type: "select",  multiple:true, valueMap:["fetch","add","update","remove"]},        
        {name: "service", title: "Service", stype: "text"},
        {name: "created", title: "Fecha de Registro", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "creator", title: "Usuario Creador", type: "string", editorType: "StaticTextItem", canEdit: false},
        {name: "updated", title: "Ultima Actualización", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "updater", title: "Usuario Ultima Actualización", type: "string", editorType: "StaticTextItem", canEdit: false},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};

eng.dataProcessors["DataServiceProcessor"] = {
    dataSources: ["DataService"],
    actions: ["add"],
    request: function (request, dataSource, action)
    {
        if(!request.data.service)request.data.service="function(request, response, dataSource, action){\n    //your code\n}";
        return request;
    }
};
//eng.dataProcessors["DataSourceFieldsProcessor"] = {
//    dataSources: ["*"],
//    actions: ["add","update"],
//    request: function (request, dataSource, action)
//    {
//        var ndata = {};
//        print("DataSource:" + dataSource);
//        for (var att in request.data) {
//            if (att.startsWith("$") || (att.startsWith("_") && att != "_id") || att == "children" || att == "isFolder") {
//                //print("rebove att:"+att);
//            } else {
//                ndata[att] = request.data[att];
//            }
//        }
//        request.data = ndata;
//        return request;
//    }
//
//};

//eng.dataProcessors["UserProcessor"] = {
//    dataSources: ["User"],
//    actions: ["fetch", "add", "update"],
//    request: function (request, dataSource, action)
//    {
//        //print("UserProcessor\n\n"+request);
//        if (request.data && request.data.password && request.data.password !== null)
//        {
//            request.data.password = this.utils.encodeSHA(request.data.password);
//        }
//        if (request.data && request.data.email && request.data.email !== null) {
//            var dsper = this.getDataSource("Personal");
//
//            var rs = dsper.fetch({data: {email: request.data.email}});
//            if (rs !== null && rs.response.data && rs.response.data.length > 0) {
//                var personal = dsper.fetchObjById(rs.response.data[0]._id);
//                request.data.fullname = personal.fullname;
//            }
//
//        }
//        return request;
//    }
//};

eng.dataSources["DataProcessor"] = {
    scls: "DataProcessor",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "id",
    fields: [
        {name: "id", title: "Identificador", type: "string", validators: [{stype: "unique"},{stype: "id"}]},
        {name: "dataSources", title: "DataSources",  multiple:true, type: "selectOther", valueMap:ds_dataSources},        
        {name: "actions", title: "Actions", type: "select",  multiple:true, valueMap:["fetch","add","update","remove"]},        
        {name: "request", title: "Request", stype: "text"},
        {name: "response", title: "Response", stype: "text"},
        {name: "created", title: "Fecha de Registro", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "creator", title: "Usuario Creador", type: "string", editorType: "StaticTextItem", canEdit: false},
        {name: "updated", title: "Ultima Actualización", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "updater", title: "Usuario Ultima Actualización", type: "string", editorType: "StaticTextItem", canEdit: false},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};

eng.dataProcessors["DataProcessorProcessor"] = {
    dataSources: ["DataProcessor"],
    actions: ["add"],
    request: function (request, dataSource, action)
    {
        if (!request.data.request)
            request.data.request = "function(request, dataSource, action){\n    //your code\n    return request;\n}";
        if (!request.data.response)
            request.data.response = "function(response, dataSource, action){\n    //your code\n    return response;\n}";
        return request;
    },
};

eng.dataSources["PageProps"] = {
    scls: "PageProps",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "prop",
    fields: [
        {name: "prop", title: "Propiedad", stype: "select", multiple:true, dataSource:"ScriptDataSourceField", editorProperties:{sortField:null}, textMatchStyle:"exactCase", getFilterCriteria:function() {
            var ds = form.getValue("ds");
            console.log(ds);
            return {"ds":ds};
        }},
        {name: "att", title: "Atributo", type: "selectOther", valueMap:ds_view_atts, 
            change:function(form,item,value){
                var att=ds_field_atts_vals[value];
                if(att)
                {
                    item.grid.setEditValue(item.rowNum,"type",att.type);
                    //form.setValue("type",att.type);
                }
            }
        },
        {name: "type", title: "Tipo de Valor", type: "select", valueMap:ds_field_atts_types},        
        {name: "value", title: "Valor", type: "string"},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};

eng.dataSources["Page"] = {
    scls: "Page",
    modelid: _modelid,
    dataStore: _dataStore,
    displayField: "name",
    fields: [
        {name: "id", title: "Identificador", type: "string", validators: [{stype: "unique"},{stype: "id"}]},
        {name: "name", title: "Nombre", type: "string"},
        {name: "parentId", title: "Padre", stype: "select", dataSource:"Page", foreignKey:"Page._id",  rootValue_:"home"},
        {name: "smallName", title: "Sub Nombre", type: "string"},
        {name: "type", title: "Tipo", type: "select", valueMap:type_pages},
        {name: "iconClass", title: "Clase del Icono", type: "string"},
        {name: "order", title: "Orden", type:"integer", canEdit:"true", hidden:"false"},
        {name: "urlParams", title: "Extra URLParams", type:"string", canEdit:"true", hidden:"false"},
        {name: "roles_view", title: "Roles de Acceso", type: "select", multiple:true, valueMap:roles},
        {name: "path", title: "Ruta del Archivo", type: "string"},        
        //{name: "ds", title: "DataSource", type: "select", editorType: "ComboBoxItem", valueMap:dataSourcesMap},
        {name: "ds", title: "DataSource", type: "selectOther", valueMap:ds_dataSources, changed:"form.clearValue('gridProps');form.clearValue('formProps');"},        
        {name: "gd_conf", title: "Caracteristicas del Grid", type: "select", multiple:true, valueMap:{"inlineEdit":"Editar en Linea", "inlineAdd":"Agregar en linea"}},
        {name: "gridProps", title: "Propiedades del Grid", multiple:true, canReorder_:true, stype: "select", editorType_:"MultiComboBoxItem", layoutStyle_:"verticalReverse", dataSource:"ScriptDataSourceField", textMatchStyle:"exactCase", editorProperties:{sortField:null}, getFilterCriteria:function() {
            //canceled this for use MultiComboBoxItem, defined in onLoad Form
            var ds = this.form.getValue("ds");
            return {"ds":ds};
        }},
        {name: "gridExtProps", title: "Propiedades Extendidas del Grid", stype: "grid", canReorderRecords:true, dataSource:"PageProps"},
        {name: "gridAddiJS", title: "JScript Adicional al Grid", stype: "text"},
        {name: "formProps", title: "Propiedades de la Forma", multiple:true, canReorder_:true, stype: "select", editorType_:"MultiComboBoxItem", layoutStyle_:"verticalReverse", dataSource:"ScriptDataSourceField", textMatchStyle:"exactCase", editorProperties:{sortField:null}, getFilterCriteria:function() {
            //canceled this for use MultiComboBoxItem, defined in onLoad Form
            var ds = this.form.getValue("ds");
            return {"ds":ds};
        }},
        {name: "formExtProps", title: "Propiedades Extendidas de la Forma", stype: "grid", canReorderRecords:true, dataSource:"PageProps"},
        {name: "formAddiJS", title: "JScript Adicionales a la Forma", stype: "text"},
        {name: "roles_add", title: "Roles de Creación", type: "select", multiple:true, valueMap:roles},
        {name: "roles_update", title: "Roles de Edición", type: "select", multiple:true, valueMap:roles},
        {name: "roles_remove", title: "Roles de Eliminación", type: "select", multiple:true, valueMap:roles},
        {name: "created", title: "Fecha de Registro", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "creator", title: "Usuario Creador", type: "string", editorType: "StaticTextItem", canEdit: false},
        {name: "updated", title: "Ultima Actualización", type: "date", editorType: "StaticTextItem", canEdit: false},
        {name: "updater", title: "Usuario Ultima Actualización", type: "string", editorType: "StaticTextItem", canEdit: false},
    ],
    //security:{"fetch":{"roles":["prog"]}, "add":{"roles":["prog"]}, "update":{"roles":["prog"]}, "remove":{"roles":["prog"]}},
};

eng.dataProcessors["PageProcessor"] = {
    dataSources: ["Page"],
    actions: ["add", "update"],
    request: function (request, dataSource, action)
    {
        //print("PageProcessor ini:"+request.data);
        var ndata={};
        for(var att in request.data)
        {
            //print("att:"+att);
            if(att.startsWith("$") || (att.startsWith("_") && att!="_id") || att=="children" || att=="isFolder")
            {
                //print("remove att:"+att);                
            }else
            {
                ndata[att]=request.data[att];
            }
        }
        request.data=ndata;
        //print("PageProcessor end:"+request.data);
        return request;
    },
};

eng.dataSources["ScriptDataSourceField"]={
    displayField: "title",
    fields:[
        {name:"ds",title:"DataSource",type:"string"},
        {name:"title",title:"Nombre",type:"string"},
    ],
    clientOnly: true,
    cacheAllData:true,
    textMatchStyle:"exactCase",
    defaultTextMatchStyle:"exactCase"
    //cacheData: countryData
};

eng.dataServices["ReloadScriptEngineService"] = {
    dataSources: ["DataSource","DataSourceFields","DataSourceFieldsExt","ValueMap","ValueMapValues","Validator","ValidatorExt","DataProcessor", "DataService"],
    actions:["add", "update","remove"],
    service: function(request, response, dataSource, action)
    {
        //print("needsReloadAllScriptEngines");
        this.needsReloadAllScriptEngines();
    }
};

