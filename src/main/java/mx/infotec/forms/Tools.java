/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mx.infotec.forms;


import com.sun.mail.util.MailSSLSocketFactory;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.function.Consumer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.activation.DataHandler;
import javax.imageio.ImageIO;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.semanticwb.datamanager.DataList;
import org.semanticwb.datamanager.DataMgr;
import org.semanticwb.datamanager.DataObject;
import org.semanticwb.datamanager.SWBDataSource;
import org.semanticwb.datamanager.SWBScriptEngine;
import org.semanticwb.datamanager.script.ScriptObject;

/**
 *
 * @author juan.fernandez
 */
public class Tools {

    private static SWBDataSource datasource = null;
    public static SWBScriptEngine engine = null;
    public static final String CANCEL_COURSE_MESSAGE = "cancel_msg";
    public static final String DEFAULT_DATASOURCE_PATH = "/APP/jsp/datasource.js";

    static final String DEFAULT_CANCEL_MESSAGE = "AVISO IMPORTANTE\n"
            + "Estimado usuario:\n"
            + "Le informamos que {#cname}, el día {#cdate}, ha sido {#caction}.\n"
            + "Estamos para servirle.";
    public static final String CONVOCATORIA_PROPERTY_ID = "convocatorias";
    static final String DEFAULT_CONVOCATORIA_SUBJECT = "Convocatoria {#cname} - {#cdate} de {#ncliente}";
    static final String DEFAULT_CONVOCATORIA_MESSAGE = "Convocatoria {#cname}\n\n"
            + "Se publicó el {#cdate}\n\n\n"
            + "Convocante: {#ncliente}\n\n\n"
            + "Objetivo: {#cobjetivo}\n\n"
            + "Fecha inicio convocatoria:: {#cfechaini} - {#choraini}\n"
            + "Fecha final convocatoria:: {#cfechafin} - {#chorafin}\n"
            + "Entrega de resultados el {#cfecharesultados}\n\n"
            + "Para más detalles de la convocatoria en http://207.248.177.63:8888/APP/convocatoria?_id={#convid}\n\n"
            + "Procesos FORMS INFOTEC";

    public static final String BUZON_PROPERTY_ID = "buzon_oportunidades";
    static final String DEFAULT_BUZON_SUBJECT = "Buzón de Oportunidad - {#cdate} de {#ncliente}";
    static final String DEFAULT_BUZON_MESSAGE = "Nueva Oportunidad \n\n"
            + "Se publicó el {#cdate}\n\n\n"
            + "Cliente a prospectar: {#ncliente}\n\n\n"
            + "Temas de interés: {#btemas}\n\n"
            + "Ejecutivo: {#kam}\n\n"
            + "Para más detalles de la oportunidad en http://207.248.177.63:8888/\n\n"
            + "Procesos FORMS INFOTEC";

    public static final String KAM_BUZON_PROPERTY_ID = "buzon_oportunidades";
    static final String DEFAULT_KAM_BUZON_SUBJECT = "Buzón de Oportunidad Asignada - {#cdate} de {#ncliente}";
    static final String DEFAULT_KAM_BUZON_MESSAGE = "Se te a asignado la Oportunidad \n\n"
            + "Se publicó el {#cdate}\n\n\n"
            + "Cliente a prospectar: {#ncliente}\n\n\n"
            + "Temas de interés: {#btemas}\n\n"
            + "Ejecutivo: {#kam}\n\n"
            + "Para más detalles de la oportunidad en http://207.248.177.63:8888/\n\n"
            + "Procesos FORMS INFOTEC";

    static final String DEFAULT_CREATOR_BUZON_MESSAGE = "Se ha asignado la Oportunidad Registrada en el Buzón de Oportunidades...\n\n"
            + "Se publicó el {#cdate}\n\n\n"
            + "Cliente a prospectar: {#ncliente}\n\n\n"
            + "Temas de interés: {#btemas}\n\n"
            + "Ejecutivo: {#kam}\n\n"
            + "Para más detalles de la oportunidad en http://207.248.177.63:8888/\n\n"
            + "Procesos FORMS INFOTEC";

    public static boolean startEngine(String path) {
        boolean loaded = false;
        if (null != path) {
            try {
                engine = DataMgr.getUserScriptEngine(path, (DataObject) null, false);
                loaded = true;
            } catch (Exception e) {
                loaded = false;
                System.out.println("Error al cargar el datasource engine. " + path);
                e.printStackTrace(System.out);
            }
        }
        return loaded;
    }

    public static int getAge(String CURP) {
        //System.out.println("Calculo de fecha...." + CURP);
        int age = -1;
        if (null != CURP) {
            String birthday = CURP.substring(4, 10);
            try {
                int cumple = Integer.parseInt(birthday);
//                System.out.println("CURP Pasó validación de fecha");
                //calculo de la edad
                String syear = CURP.substring(4, 6);
                String smonth = CURP.substring(6, 8);
                String sday = CURP.substring(8, 10);

                Calendar cal = Calendar.getInstance();
                cal.set(Integer.parseInt(syear), Integer.parseInt(smonth) - 1, Integer.parseInt(sday));

                Calendar ctoday = Calendar.getInstance();
                ctoday.add(Calendar.YEAR, -cal.get(Calendar.YEAR));

                SimpleDateFormat sdfYY = new SimpleDateFormat("yy");
                age = Integer.parseInt(sdfYY.format(ctoday.getTime()));

                if (ctoday.get(Calendar.MONTH) < cal.get(Calendar.MONTH)) {
                    age--;
                } else if ((ctoday.get(Calendar.MONTH) == cal.get(Calendar.MONTH)) && (ctoday.get(Calendar.DATE) < cal.get(Calendar.DATE))) {
                    age--;
                }
            } catch (Exception e) {
                System.out.println("Error al procesar el CURP para calcular la Edad.");
            }
        }
        return age;
    }

    /**
     *
     * @param convDO
     * @return
     */
    public static boolean sendConvocatoriaEmailNotification(Object convDO) {
        boolean ret = false;
        if (null == engine) {
            startEngine(DEFAULT_DATASOURCE_PATH);
        }
        if (null != engine) {

            String message = DEFAULT_CONVOCATORIA_MESSAGE;
            String asunto = DEFAULT_CONVOCATORIA_SUBJECT;
            try {
                //System.out.println("...................sendConvocatoriaEmailNotification...............");
                SWBDataSource dslist = engine.getDataSource("Lista_distribucion");
                DataObject rlist = new DataObject();
                DataObject datalist = new DataObject();
                rlist.put("data", datalist);
                datalist.put("nombre", CONVOCATORIA_PROPERTY_ID);

                DataObject retPT = dslist.fetch(rlist);

                DataList rdatalist = retPT.getDataObject("response").getDataList("data");
                if (null != rdatalist && rdatalist.size() > 0) {
                    //System.out.println("Se encontro lista de distribución....");
                    DataObject dobj = (DataObject) convDO;

                    SWBDataSource ds = engine.getDataSource("ModelProperties");

                    DataObject r = new DataObject();
                    DataObject data = new DataObject();

                    r = new DataObject();
                    data = new DataObject();
                    r.put("data", data);
                    data.put("propertyName", CONVOCATORIA_PROPERTY_ID);

                    DataObject retmsg = ds.fetch(r);
                    DataList rdatamsg = retmsg.getDataObject("response").getDataList("data");
                    DataObject doMsg = null;
                    if (!rdatamsg.isEmpty()) {
                        doMsg = rdatamsg.getDataObject(0);
                    }

                    if (null != doMsg) {
                        message = doMsg.getString("propertyValue");
                        // System.out.println("Mensaje encontrado...\n\n" + message);
                    }
                    //Obteniendo datos de la convocatoria
                    String nombre = dobj.getString("nombre");
                    String fecha = dobj.getString("fechaConvocatoria");
                    String institucionId = dobj.getString("institucion");
                    String clienteNombre = institucionId;

                    SWBDataSource dsc = engine.getDataSource("Clientes");
                    DataObject clienteDO = dsc.fetchObjById(institucionId);
                    if (null != clienteDO) {
                        clienteNombre = clienteDO.getString("nombre");
                        //System.out.println("Nombre del cliente: " + clienteNombre);
                    }

                    String objetivo = dobj.getString("objetivo");
                    String fechaini = dobj.getString("fechaIni");
                    String horaini = dobj.getString("horaIni");
                    String fechafin = dobj.getString("fechaFin");
                    String horafin = dobj.getString("horafin");
                    String fecharesultados = dobj.getString("fechaResultados");
                    String convid = dobj.getString("_id");

                    if (null != horaini && horaini.length() == 3) {
                        horaini = horaini.substring(0, 1) + ":" + horaini.substring(1);
                    } else if (null != horaini && horaini.length() > 3) {
                        horaini = horaini.substring(0, 2) + ":" + horaini.substring(2);
                    }
                    if (null != horafin && horafin.length() == 3) {
                        horafin = horafin.substring(0, 1) + ":" + horafin.substring(1);
                    } else if (null != horafin && horafin.length() > 3) {
                        horafin = horafin.substring(0, 2) + ":" + horafin.substring(2);
                    }

                    //System.out.println("hora inicial..." + horaini + " - " + horafin);
                    message = message.replace("{#cname}", nombre);
                    message = message.replace("{#cdate}", fecha);
                    message = message.replace("{#ncliente}", clienteNombre);
                    message = message.replace("{#cobjetivo}", objetivo);
                    message = message.replace("{#cfechaini}", fechaini);
                    message = message.replace("{#choraini}", horaini);
                    message = message.replace("{#cfechafin}", fechafin);
                    message = message.replace("{#chorafin}", horafin);
                    message = message.replace("{#cfecharesultados}", fecharesultados);
                    message = message.replace("{#convid}", convid);

                    asunto = asunto.replace("{#cname}", nombre);
                    asunto = asunto.replace("{#ncliente}", clienteNombre);
                    asunto = asunto.replace("{#cdate}", fecha);

                    SWBDataSource dsusr = engine.getDataSource("User");
                    DataObject usrDO = null;

                    DataObject listaDist = rdatalist.getDataObject(0);
                    DataList listUsrs = listaDist.getDataList("users");
                    int errors = 0;
                    for (int i = 0; i < listUsrs.size(); i++) {
                        String usrId = listUsrs.getString(i);
                        //System.out.println("\n\nRevisando lista de usuarios...." + usrId);
                        usrDO = dsusr.fetchObjById(usrId);
                        if (null != usrDO) {
                            //System.out.println(usrId + " ==> " + usrDO.getString("email") + "\n");
                            String email = usrDO.getString("email");
                            if (null != email && isValidEmailAddress(email)) {
                                try {
                                    //engine.getUtils().sendHtmlMail(email, asunto, message);
                                    sendHtmlMail(email, asunto, message);
                                } catch (Exception e) {
                                    System.out.println("Error al enviar notificacion convocatoria a " + email + " . " + e.getMessage());
                                }
                            }
                        }
                    }
                } else {
                    System.out.println("No se encontró lista de distribución 'convocatorias' definida.");
                }
            } catch (Exception e) {
                System.out.println("Error..." + e.getMessage());
            }
        } else {
            System.out.println("Error al cargar el DataSource al HashMap, falta inicializar el engine.");
        }
        return ret;
    }

    /**
     *
     * @param convDO
     * @return
     */
    public static boolean sendBuzonOportunidadEmailNotification(Object buzDO) {
        boolean ret = false;
        if (null == engine) {
            startEngine(DEFAULT_DATASOURCE_PATH);
        }
        if (null != engine) {

            String message = DEFAULT_BUZON_MESSAGE;
            String asunto = DEFAULT_BUZON_SUBJECT;
            try {
//                System.out.println("...................sendBuzonOportunidadEmailNotification...............");
                SWBDataSource dslist = engine.getDataSource("Lista_distribucion");
                DataObject rlist = new DataObject();
                DataObject datalist = new DataObject();
                rlist.put("data", datalist);
                datalist.put("nombre", BUZON_PROPERTY_ID);

                DataObject retPT = dslist.fetch(rlist);

                DataList rdatalist = retPT.getDataObject("response").getDataList("data");
                if (null != rdatalist && rdatalist.size() > 0) {
//                    System.out.println("Se encontro lista de distribución 1....");
                    DataObject dobj = (DataObject) buzDO;

                    SWBDataSource ds = engine.getDataSource("ModelProperties");

                    DataObject r = new DataObject();
                    DataObject data = new DataObject();

                    r = new DataObject();
                    data = new DataObject();
                    r.put("data", data);
                    data.put("propertyName", BUZON_PROPERTY_ID);

                    DataObject retmsg = ds.fetch(r);
                    DataList rdatamsg = retmsg.getDataObject("response").getDataList("data");
                    DataObject doMsg = null;
                    if (!rdatamsg.isEmpty()) {
                        doMsg = rdatamsg.getDataObject(0);
                    }

                    if (null != doMsg) {
                        message = doMsg.getString("propertyValue");
//                        System.out.println("Mensaje encontrado...\n\n" + message);
                    }
                    //Obteniendo datos de la oportunidad
                    //String kamId = dobj.getString("ejecutivoCta");
                    String kamNombre = "Por asignar";
                    String fecha = dobj.getString("created");
                    String temas = dobj.getString("temasInteres");
                    String clienteNombre = dobj.getString("nuevoCliente");

                    String buzid = dobj.getString("_id");

                    //System.out.println("hora inicial..." + horaini + " - " + horafin);
                    message = message.replace("{#cdate}", fecha);
                    message = message.replace("{#ncliente}", clienteNombre);
                    message = message.replace("{#btemas}", temas);
                    message = message.replace("{#kam}", kamNombre);
                    message = message.replace("{#bid}", buzid);

                    asunto = asunto.replace("{#ncliente}", clienteNombre);
                    asunto = asunto.replace("{#cdate}", fecha);

                    SWBDataSource dsusr = engine.getDataSource("User");
                    DataObject usrDO = null;

                    DataObject listaDist = rdatalist.getDataObject(0);
                    DataList listUsrs = listaDist.getDataList("users");
                    int errors = 0;
                    for (int i = 0; i < listUsrs.size(); i++) {
                        String usrId = listUsrs.getString(i);
//                        System.out.println("\n\nRevisando lista de usuarios...." + usrId);
                        usrDO = dsusr.fetchObjById(usrId);
                        if (null != usrDO) {
//                            System.out.println(usrId + " ==> " + usrDO.getString("email") + "\n");
                            String email = usrDO.getString("email");
                            if (null != email && isValidEmailAddress(email)) {
                                try {
                                    //engine.getUtils().sendHtmlMail(email, asunto, message);
                                    sendHtmlMail(email, asunto, message);
                                } catch (Exception e) {
                                    System.out.println("Error al enviar notificacion del Buzón de oportunidades a " + email + " . " + e.getMessage());
                                }
                            }
                        }
                    }
                } else {
                    System.out.println("No se encontró lista de distribución 'buzon_oportunidades' definida.");
                }
            } catch (Exception e) {
                System.out.println("Error..." + e.toString());

            }
        } else {
            System.out.println("Error al cargar el DataSource al HashMap, falta inicializar el engine.");
        }
        return ret;
    }

    /**
     *
     * @param convDO
     * @return
     */
    public static boolean sendKAMBuzonOportunidadEmailNotification(Object buzDO) {
        boolean ret = false;
        if (null == engine) {
            startEngine(DEFAULT_DATASOURCE_PATH);
        }
        if (null != engine && null != buzDO) {

            String message = DEFAULT_KAM_BUZON_MESSAGE;
            String messagePerson = DEFAULT_CREATOR_BUZON_MESSAGE;
            String asunto = DEFAULT_KAM_BUZON_SUBJECT;
            try {
                DataObject dobj = (DataObject) buzDO;
                //KAM
                String kamId = dobj.getString("ejecutivoCta");
                //Solicitante
                String usrId = dobj.getString("creator");
//                System.out.println("...................sendKAMBuzonOportunidadEmailNotification...............");
                SWBDataSource dslist = engine.getDataSource("Personal");
                DataObject kam = dslist.fetchObjById(kamId);
                SWBDataSource dsusr = engine.getDataSource("User");
                DataObject person = dsusr.fetchObjById(usrId);
                if (null != kam && person != null) {

                    SWBDataSource ds = engine.getDataSource("ModelProperties");

                    DataObject r = new DataObject();
                    DataObject data = new DataObject();

                    r = new DataObject();
                    data = new DataObject();
                    r.put("data", data);
                    data.put("propertyName", KAM_BUZON_PROPERTY_ID);

                    DataObject retmsg = ds.fetch(r);
                    DataList rdatamsg = retmsg.getDataObject("response").getDataList("data");
                    DataObject doMsg = null;
                    if (!rdatamsg.isEmpty()) {
                        doMsg = rdatamsg.getDataObject(0);
                    }

                    if (null != doMsg) {
                        message = doMsg.getString("propertyValue");
//                        System.out.println("Mensaje encontrado...\n\n" + message);
                    }
                    //Obteniendo datos de la convocatoria
                    String kamNombre = null;
                    String fecha = dobj.getString("created");
                    String temas = dobj.getString("temasInteres");
                    String clienteNombre = dobj.getString("nuevoCliente");

                    kamNombre = kam.getString("fullname");

                    String buzid = dobj.getString("_id");

                    //System.out.println("hora inicial..." + horaini + " - " + horafin);
                    message = message.replace("{#cdate}", fecha);
                    message = message.replace("{#ncliente}", clienteNombre);
                    message = message.replace("{#btemas}", temas);
                    message = message.replace("{#kam}", kamNombre);
                    message = message.replace("{#bid}", buzid);

                    asunto = asunto.replace("{#ncliente}", clienteNombre);
                    asunto = asunto.replace("{#cdate}", fecha);

                    messagePerson = messagePerson.replace("{#cdate}", fecha);
                    messagePerson = messagePerson.replace("{#ncliente}", clienteNombre);
                    messagePerson = messagePerson.replace("{#btemas}", temas);
                    messagePerson = messagePerson.replace("{#kam}", kamNombre);
                    messagePerson = messagePerson.replace("{#bid}", buzid);

//                        System.out.println("\n\nRevisando  usuarios...." );
//                            System.out.println(kamId + " ==> " + kam.getString("email") + "\n");
                    String email = kam.getString("email");
                    if (null != email && isValidEmailAddress(email)) {
                        try {
                            //engine.getUtils().sendHtmlMail(email, asunto, message);
                            sendHtmlMail(email, asunto, message);
                        } catch (Exception e) {
                            System.out.println("Error al enviar notificacion del Buzón de oportunidades a " + email + " . " + e.getMessage());
                        }
                    }
//                            System.out.println(usrId + " ==> " + person.getString("email") + "\n");
                    email = person.getString("email");
                    if (null != email && isValidEmailAddress(email)) {
                        try {
                            //engine.getUtils().sendHtmlMail(email, asunto, messagePerson);
                            sendHtmlMail(email, asunto, messagePerson);
                        } catch (Exception e) {
                            System.out.println("Error al enviar notificacion del Buzón de oportunidades a " + email + " . " + e.getMessage());
                        }
                    }

                } else {
                    System.out.println("No se encontró lista de distribución 'buzon_oportunidades' definida.");
                }
            } catch (Exception e) {
                System.out.println("Error..." + e.getMessage());
                e.printStackTrace(System.out);
            }
        } else {
            System.out.println("Error al cargar el DataSource al HashMap, falta inicializar el engine.");
        }
        return ret;
    }

    //
    /**
     * Checks if is valid email address.
     *
     * @param emailAddress the email address
     * @return true, if is valid email address
     */
    public static boolean isValidEmailAddress(String emailAddress) {
        //String  expression="^[\\w\\-]([\\.\\w])+[\\w]+@([\\w\\-]+\\.)+[A-Z]{2,4}$";
        String expression = "^[\\w]([\\.\\w\\-])+[\\w]+@([\\w\\-]+\\.)+[A-Z]{2,4}$";

        CharSequence inputStr = emailAddress;
        Pattern pattern = Pattern.compile(expression, Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(inputStr);
        return matcher.matches();
    }

    /**
     * Revisa archivos a eliminar para no dejar en el servidor archivos que ya
     * no se utilizarán
     *
     * @param newValues arreglo con los nombres de archivos nuevos
     * @param oldValues arreglo con los nombres de archivos anteriores
     * @return true si no existe error al revisar y eliminar archivos anteriores
     */
    public static boolean checkFiles(String[] newValues, String[] oldValues) {
        boolean ret = false;
        HashMap<String, String> hmNew = new HashMap();
        try {
            if (newValues != null && oldValues != null) {
                for (int i = 0; i < newValues.length; i++) {
                    hmNew.put(newValues[i], newValues[i]);
                }
                //revisando si los archivos anteriores si siguen existiendo
                for (int i = 0; i < oldValues.length; i++) {
                    if (hmNew.get(oldValues[i]) == null) {
                        //si ya no aparece en los nuevos hay que eliminarlos
                        File f = new File(DataMgr.getApplicationPath() + "/uploadfile/" + oldValues[i]);
                        if (f.exists()) {
                            ret = f.delete();
                        }
                    }
                }
                ret = true;
            }
        } catch (Exception e) {
            ret = false;
            System.out.println("Error al tratar de eliminar archivos en el servidor TrainerService " + e.getMessage());
        }
        return ret;
    }

    /**
     * Carga la colección a un HashMap
     *
     * @param ds Nombre del DataSource a cargar en un HashMap
     * @return HashMap con DataSource cargado en memoria.
     */
    public static HashMap<String, DataObject> loadDataSource(String ds) {

        HashMap<String, DataObject> rethm = new HashMap<String, DataObject>();
        if (null != engine) {
            try {
                datasource = engine.getDataSource(ds);
                DataObject r = new DataObject();
                DataObject data = new DataObject();
                r.put("data", data);

                DataObject ret = datasource.fetch(r);
                String key = "";

                DataList rdata = ret.getDataObject("response").getDataList("data");
                DataObject dobj = null;
                if (!rdata.isEmpty()) {
                    for (int i = 0; i < rdata.size(); i++) {
                        dobj = rdata.getDataObject(i);  // DataObject de la Delegación
                        key = dobj.getString("_id");
                        // System.out.println("loaded rol:"+key);
                        rethm.put(key, dobj);
                    }
                }
            } catch (Exception e) {
                System.out.println("Error al cargar el DataSource. " + e.getMessage());
                e.printStackTrace(System.out);
            }
        } else {
            System.out.println("Error al cargar el DataSource al HashMap, falta inicializar el engine.");
            return null;
        }

        return rethm;
    }

    /**
     * Carga la colección de Roles de una determinada página a un HashMap
     *
     * @param page Página a revisar para cargar sus roles en un HashMap
     * @return HashMap con los roles asociados a la página cargado en memoria.
     */
    public static HashMap<String, DataObject> loadPageRoles(String page) {

        HashMap<String, DataObject> rethm = new HashMap<String, DataObject>();
        try {
            datasource = engine.getDataSource("Pages");
            DataObject r = new DataObject();
            DataObject data = new DataObject();
            r.put("data", data);
            data.put("rutaJSP", page);

            DataObject ret = datasource.fetch(r);
            String key = "";

            DataList rdata = ret.getDataObject("response").getDataList("data");
            //System.out.println("RDATA:"+rdata);
            DataObject dobj = null;
            if (!rdata.isEmpty()) {
                dobj = rdata.getDataObject(0);  // DataObject de la Delegación
                List<String> list = dobj.getDataList("roles");
                if (null != list) {
                    for (int i = 0; i < list.size(); i++) {
                        key = list.get(i);
                        rethm.put(key, dobj);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error al cargar los Roles de la Página. " + e.getMessage());
            e.printStackTrace(System.out);
        }
        return rethm;
    }

    

    /**
     * Carga la colección de Roles de un determinada seccion a un HashMap
     *
     * @param page Página a revisar para cargar sus roles en un HashMap
     * @return HashMap con los roles asociados a la página cargado en memoria.
     */
    public static HashMap<String, DataObject> loadSectionRoles(DataObject section) {

        HashMap<String, DataObject> rethm = new HashMap<String, DataObject>();
        HashMap<String, DataObject> hmroles = new HashMap<String, DataObject>();
        hmroles = loadDataSource("Roles");
        try {
            List<String> list = section.getDataList("roles");
            if (null != list) {
                for (int i = 0; i < list.size(); i++) {
                    String key = list.get(i);
                    if (hmroles.containsKey(key)) {
                        rethm.put(key, hmroles.get(key));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error al cargar los Roles de la Sección. " + e.getMessage());
            e.printStackTrace(System.out);
        }
        return rethm;
    }

    /**
     * Carga la colección de Roles de un determinada subseccion a un HashMap
     *
     * @param page Página a revisar para cargar sus roles en un HashMap
     * @return HashMap con los roles asociados a la página cargado en memoria.
     */
    public static HashMap<String, DataObject> loadSubsectionRoles(DataObject subsection) {

        HashMap<String, DataObject> rethm = new HashMap<String, DataObject>();
        HashMap<String, DataObject> hmroles = new HashMap<String, DataObject>();
        hmroles = loadDataSource("Roles");
        try {
            List<String> list = subsection.getDataList("roles");
            if (null != list) {
                for (int i = 0; i < list.size(); i++) {
                    String key = list.get(i);
                    if (hmroles.containsKey(key)) {
                        rethm.put(key, hmroles.get(key));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error al cargar los Roles de la Subsección. " + e.getMessage());
            e.printStackTrace(System.out);
        }
        return rethm;
    }

    /**
     * Carga la colección de Roles de un determinada página a un HashMap
     *
     * @param page Página a revisar para cargar sus roles en un HashMap
     * @return HashMap con los roles asociados a la página cargado en memoria.
     */
    public static HashMap<String, DataObject> loadSectionPageRoles(DataObject page) {

        HashMap<String, DataObject> rethm = new HashMap<String, DataObject>();
        HashMap<String, DataObject> hmroles = new HashMap<String, DataObject>();
        hmroles = loadDataSource("Roles");
        try {
            List<String> list = page.getDataList("roles");
            if (null != list) {
                for (int i = 0; i < list.size(); i++) {
                    String key = list.get(i);
                    if (hmroles.containsKey(key)) {
                        rethm.put(key, hmroles.get(key));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error al cargar los Roles de la Página. " + e.getMessage());
            e.printStackTrace(System.out);
        }
        return rethm;
    }

    /**
     * Carga la colección de Roles de un determinad0 usuario a un HashMap
     *
     * @param page Página a revisar para cargar sus roles en un HashMap
     * @return HashMap con los roles asociados a la página cargado en memoria.
     */
    public static HashMap<String, DataObject> loadUserRoles(DataObject user) {

        HashMap<String, DataObject> rethm = new HashMap<String, DataObject>();
        HashMap<String, DataObject> hmroles = new HashMap<String, DataObject>();
        hmroles = loadDataSource("Roles");
        try {
            List<String> list = user.getDataList("roles");
            for (int i = 0; i < list.size(); i++) {
                String key = list.get(i);
                if (hmroles.containsKey(key)) {
                    rethm.put(key, hmroles.get(key));
                }
            }
        } catch (Exception e) {
            System.out.println("Error al cargar los Roles del usuario. " + e.getMessage());
            e.printStackTrace(System.out);
        }
        return rethm;
    }

    /**
     * Replaces accented characters and blank spaces in the string given. Makes
     * the changes in a case sensitive manner, the following are some examples
     * of the changes this method makes: <br>
     *
     * @param txt a string in which the characters are going to be replaced
     * @param replaceSpaces a {@code boolean} indicating if blank spaces are
     * going to be replaced or not
     * @return a string similar to {@code txt} but with neither accented or
     * special characters nor symbols in it. un objeto string similar a
     * {@code txt} pero sin caracteres acentuados o especiales y sin
     * s&iacute;mbolos {@literal Á} is replaced by {@literal A} <br>
     * {@literal Ê} is replaced by {@literal E} <br> {@literal Ï} is replaced by
     * {@literal I} <br> {@literal â} is replaced by {@literal a} <br>
     * {@literal ç} is replaced by {@literal c} <br> {@literal ñ} is replaced by
     * {@literal n} <br>
     * and blank spaces are replaced by underscore characters, any symbol in
     * {@code txt} other than underscore is eliminated including the periods.
     * <p>
     * Reemplaza caracteres acentuados y espacios en blanco en {@code txt}.
     * Realiza los cambios respetando caracteres en may&uacute;sculas o
     * min&uacute;sculas los caracteres en blanco son reemplazados por guiones
     * bajos, cualquier s&iacute;mbolo diferente a gui&oacute;n bajo es
     * eliminado.</p>
     */
    public static String replaceSpecialCharacters(String txt, boolean replaceSpaces) {
        StringBuffer ret = new StringBuffer();
        String aux = txt;
        //aux = aux.toLowerCase();
        aux = aux.replace('Á', 'A');
        aux = aux.replace('Ä', 'A');
        aux = aux.replace('Å', 'A');
        aux = aux.replace('Â', 'A');
        aux = aux.replace('À', 'A');
        aux = aux.replace('Ã', 'A');

        aux = aux.replace('É', 'E');
        aux = aux.replace('Ê', 'E');
        aux = aux.replace('È', 'E');
        aux = aux.replace('Ë', 'E');

        aux = aux.replace('Í', 'I');
        aux = aux.replace('Î', 'I');
        aux = aux.replace('Ï', 'I');
        aux = aux.replace('Ì', 'I');

        aux = aux.replace('Ó', 'O');
        aux = aux.replace('Ö', 'O');
        aux = aux.replace('Ô', 'O');
        aux = aux.replace('Ò', 'O');
        aux = aux.replace('Õ', 'O');

        aux = aux.replace('Ú', 'U');
        aux = aux.replace('Ü', 'U');
        aux = aux.replace('Û', 'U');
        aux = aux.replace('Ù', 'U');

        aux = aux.replace('Ñ', 'N');

        aux = aux.replace('Ç', 'C');
        aux = aux.replace('Ý', 'Y');

        aux = aux.replace('á', 'a');
        aux = aux.replace('à', 'a');
        aux = aux.replace('ã', 'a');
        aux = aux.replace('â', 'a');
        aux = aux.replace('ä', 'a');
        aux = aux.replace('å', 'a');

        aux = aux.replace('é', 'e');
        aux = aux.replace('è', 'e');
        aux = aux.replace('ê', 'e');
        aux = aux.replace('ë', 'e');

        aux = aux.replace('í', 'i');
        aux = aux.replace('ì', 'i');
        aux = aux.replace('î', 'i');
        aux = aux.replace('ï', 'i');

        aux = aux.replace('ó', 'o');
        aux = aux.replace('ò', 'o');
        aux = aux.replace('ô', 'o');
        aux = aux.replace('ö', 'o');
        aux = aux.replace('õ', 'o');

        aux = aux.replace('ú', 'u');
        aux = aux.replace('ù', 'u');
        aux = aux.replace('ü', 'u');
        aux = aux.replace('û', 'u');

        aux = aux.replace('ñ', 'n');

        aux = aux.replace('ç', 'c');
        aux = aux.replace('ÿ', 'y');
        aux = aux.replace('ý', 'y');

        if (replaceSpaces) {
            aux = aux.replace(' ', '_');
        }
        int l = aux.length();
        for (int x = 0; x < l; x++) {
            char ch = aux.charAt(x);
            if ((ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'z')
                    || (ch >= 'A' && ch <= 'Z') || ch == '_' || ch == '-') {
                ret.append(ch);
            }
        }
        aux = ret.toString();
        return aux;
    }

    public static String getDate(int dateFormat) {
        return getDate(DateFormat.SHORT, "es", "MX");
    }

    public static String getDate(int dateFormat, String lang) {
        DateFormat df = DateFormat.getDateInstance(dateFormat, new Locale(lang));
        return df.format(new Date());
    }

    public static String getDate(int dateFormat, String lang, String country) {
        DateFormat df = DateFormat.getDateInstance(dateFormat, new Locale(lang, country));
        return df.format(new Date());
    }

    public static String getDate() {
        return getDate("dd/MM/yyyy hh:mm:ss", new Locale("es", "MX"));
    }

    public static String getDate(String datePattern) {
        return getDate(datePattern, new Locale("es", "MX"));
    }

    public static String getDate(String datePattern, Locale locale) {
        SimpleDateFormat formatter = new SimpleDateFormat(datePattern, locale);
        return formatter.format(new Date());
    }

    public static boolean sendHtmlMail(String to, String subject, String msg) {
        return sendMail(to, null, subject, "<html><body>" + msg + "</body></html>", "text/html", null);
    }

    public static boolean sendMail(String to, String toName, String subject, String message, String contentType, Consumer callback) {
        Properties props = new Properties();
        ScriptObject config = engine.getScriptObject().get("config");
        if (config != null) {
            ScriptObject smail = config.get("mail");
            if (smail != null) {
                String from = smail.getString("from");
                String fromName = smail.getString("fromName");
                String host = smail.getString("host");
                String user = smail.getString("user");
                String passwd = smail.getString("passwd");
                int port = 25;
                try {
                    port = (Integer) smail.get("port").getValue();
                } catch (Exception e) {
                }
                String transport = smail.getString("transport") == null ? "smtps" : smail.getString("transport");
                String ssltrust = smail.getString("ssltrust");
                String starttls = smail.getString("starttls");

                if (ssltrust == null) {
                    ssltrust = "*";
                }
                if (starttls == null) {
                    starttls = "true";
                }
                if (from == null) {
                    from = "procesos.forms@infotec.mx";
                }
                if (host == null) {
                    host = "mta1.infotec.com.mx";
                }
                if (user == null) {
                    user = "procesos.forms@infotec.mx";
                }
                if (passwd == null) {
                    passwd = "temporal.123!";
                }

                props.put("mail.smtp.host", host);
                props.put("mail.smtp.port", port);
                props.put("mail.smtps.ssl.trust", ssltrust);
                props.put("mail.smtp.starttls.enable", starttls);

                try {
                    MailSSLSocketFactory socketFactory = new MailSSLSocketFactory();
                    socketFactory.setTrustAllHosts(true);
                    Session session = Session.getInstance(props, null);
                    InternetAddress userAddr = toName == null ? new InternetAddress(to) : new InternetAddress(to, toName);
                    Message msg = new MimeMessage(session);
                    Address[] addrs = new Address[]{new InternetAddress(from, fromName)};
                    msg.addFrom(addrs);
                    msg.setRecipient(Message.RecipientType.TO, userAddr);
                    msg.setSubject(subject);
                    msg.setDataHandler(new DataHandler(message, contentType));
                    msg.setSentDate(new Date());

                    try {
                        Transport t = session.getTransport("smtp");
                        t.connect(host, port, user, passwd);
                        msg.saveChanges();
                        t.sendMessage(msg, (new Address[]{userAddr}));
                        t.close();
                        if (callback != null) {
                            callback.accept(null);
                        }
                    } catch (MessagingException uex) {
                        uex.printStackTrace();
                    }

                    return true;
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }

    
}
