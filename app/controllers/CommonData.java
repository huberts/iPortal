package controllers;

import play.Play;
import play.mvc.Before;
import play.mvc.Controller;

/**
 * Created with IntelliJ IDEA.
 * User: wstasiak
 * Date: 14.06.12
 * Time: 10:50
 * Common code used among other controllers
 */
public class CommonData extends Controller {
    @Before
    private static void commonData() {
        renderArgs.put("useArms", Boolean.parseBoolean(Play.configuration.getProperty("views.use_application_arms")));
        renderArgs.put("mapBoundingBoxLeft", Play.configuration.getProperty("map.bounding_box.left"));
        renderArgs.put("mapBoundingBoxBottom", Play.configuration.getProperty("map.bounding_box.bottom"));
        renderArgs.put("mapBoundingBoxRight", Play.configuration.getProperty("map.bounding_box.right"));
        renderArgs.put("mapBoundingBoxTop", Play.configuration.getProperty("map.bounding_box.top"));
        renderArgs.put("mapResolutions", Play.configuration.getProperty("map.resolutions"));
        renderArgs.put("mapInitialX", Play.configuration.getProperty("map.initial.cartographer_y_coordinate"));
        renderArgs.put("mapInitialY", Play.configuration.getProperty("map.initial.cartographer_x_coordinate"));
        renderArgs.put("mapInitialZ", Play.configuration.getProperty("map.initial.z"));
        renderArgs.put("urlSlashReplacement", Play.configuration.getProperty("url.slash_replacement"));
        renderArgs.put("systhermSourceId", 0);
        renderArgs.put("systhermServiceId", 0);
    }
}
