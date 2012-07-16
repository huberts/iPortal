package models;

import play.Logger;

/**
 * Created with IntelliJ IDEA.
 * User: umberto
 * Date: 15.07.12
 * Time: 14:47
 * To change this template use File | Settings | File Templates.
 */
public class MapLayerCollection {

    public static MapLayerCollection getInstance() {
        return new MapLayerCollection();
    }

    public MapLayer getByNameFromMapService(MapService service, String name) {
        return MapLayer.find("mapService = ? and lower(name) = ?", service, name.toLowerCase()).first();
    }
}
