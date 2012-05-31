package controllers;

import play.Logger;
import play.libs.WS;
import play.mvc.Controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

public class CapabilitiesGetter extends Controller{

    public static void getCapabilities(String serviceUrl) {
        renderXml(WS.url(buildQueryString(serviceUrl)).get().getString());
    }

    private static String buildQueryString(String serviceUrl) {
        String queryUrl = tryToDecode(serviceUrl);
        if (queryUrl.endsWith("?")) {
            queryUrl = queryUrl.substring(0, queryUrl.length()-1);
        }
        return queryUrl + "?service=WMS&request=getCapabilities";
    }

    private static String tryToDecode(String utf8Encoded) {
        try {
            utf8Encoded = URLDecoder.decode(utf8Encoded, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return utf8Encoded;
    }
}
