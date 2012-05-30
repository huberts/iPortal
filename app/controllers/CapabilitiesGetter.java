package controllers;

import play.Logger;
import play.libs.WS;
import play.mvc.Controller;

public class CapabilitiesGetter extends Controller{

    public static void getCapabilities(String serviceUrl) {
        serviceUrl = "http://212.244.173.51/cgi-bin/bierun";
        serviceUrl +="?service=WMS&request=getCapabilities";
        WS.HttpResponse xml = WS.url(serviceUrl).get();
        String frame = xml.getString();
        renderXml(frame);
        Logger.info(frame);
    }
}
