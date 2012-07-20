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
        renderArgs.put("appOwner", MapSetting.findByKey(MapSetting.APPLICATION_TITLE).value);
        renderArgs.put("mapBoundingBoxLeft", MapSetting.findByKey(MapSetting.MAP_BOUNDINGBOX_LEFT).value);
        renderArgs.put("mapBoundingBoxBottom", MapSetting.findByKey(MapSetting.MAP_BOUNDINGBOX_BOTTOM).value);
        renderArgs.put("mapBoundingBoxRight", MapSetting.findByKey(MapSetting.MAP_BOUNDINGBOX_RIGHT).value);
        renderArgs.put("mapBoundingBoxTop", MapSetting.findByKey(MapSetting.MAP_BOUNDINGBOX_TOP).value);
        renderArgs.put("mapResolutions", MapSetting.findByKey(MapSetting.MAP_RESOLUTIONS).value);
        renderArgs.put("mapInitialX", MapSetting.findByKey(MapSetting.MAP_INITIAL_Y_COORDINATE).value);
        renderArgs.put("mapInitialY", MapSetting.findByKey(MapSetting.MAP_INITIAL_X_COORDINATE).value);
        renderArgs.put("mapInitialZ", MapSetting.findByKey(MapSetting.MAP_INITIAL_Z).value);
        renderArgs.put("urlSlashReplacement", Play.configuration.getProperty("url.slash_replacement"));
        renderArgs.put("systhermSourceId", 0);
        renderArgs.put("systhermServiceId", 0);
        renderArgs.put("systhermLayerId", 0);
    }
}
