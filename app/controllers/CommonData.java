package controllers;

import models.MapSetting;
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
        renderArgs.put("useArms", Boolean.parseBoolean(MapSetting.findByKey(MapSetting.APPLICATION_ARMS).value));
        renderArgs.put("mapBoundingBoxLeft", Play.configuration.getProperty("map.bounding_box.left"));
        renderArgs.put("mapBoundingBoxBottom", Play.configuration.getProperty("map.bounding_box.bottom"));
        renderArgs.put("mapBoundingBoxRight", Play.configuration.getProperty("map.bounding_box.right"));
        renderArgs.put("mapBoundingBoxTop", Play.configuration.getProperty("map.bounding_box.top"));
        renderArgs.put("mapResolutions", MapSetting.findByKey(MapSetting.MAP_RESOLUTIONS).value);
        renderArgs.put("mapInitialX", MapSetting.findByKey(MapSetting.MAP_INITIAL_Y_COORDINATE).value);
        renderArgs.put("mapInitialY", MapSetting.findByKey(MapSetting.MAP_INITIAL_X_COORDINATE).value);
        renderArgs.put("mapInitialZ", MapSetting.findByKey(MapSetting.MAP_INITIAL_Z).value);
        renderArgs.put("urlSlashReplacement", Play.configuration.getProperty("url.slash_replacement"));
    }
}
