package controllers;

import models.*;
import play.Logger;
import play.mvc.Controller;
import play.mvc.With;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: umberto
 * Date: 15.07.12
 * Time: 12:22
 * To change this template use File | Settings | File Templates.
 */

@With(CommonData.class)
public class SysthermInstallation extends Controller {

    public static void index(String installation) {
        MapService service = MapServiceCollection.getInstance().findByName(installation);
        if (service==null) {
            notFound(installation);
        }

        List<MapSource> sources = MapSourceCollection.getInstance().allSortedBy("sort, id");
        List<MapLocation> locations = MapLocationCollection.getInstance().topLevel();
        sendArgumentsToView(service);
        renderArgs.put("mapInitialX", service.yCoordinate);
        renderArgs.put("mapInitialY", service.xCoordinate);
        renderArgs.put("mapInitialZ", service.zoomLevel);
        renderTemplate("Application/index.html", sources, locations);



//        renderTemplate("Application/index.html")
//        Application.index(service.xCoordinate, service.yCoordinate, service.zoomLevel);

//        getInstallationWms();
//        getInstallationLayers();
//        activateLayers();
//        zoomToWms();
//        showWmsTree();

    }

    private static void sendArgumentsToView(MapService service) {
        renderArgs.put("systhermSourceId", service.mapSource.id);
        renderArgs.put("systhermServiceId", service.id);
    }
}
