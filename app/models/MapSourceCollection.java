package models;

import com.avaje.ebean.Ebean;
import com.avaje.ebean.FetchConfig;
import play.Logger;

import java.util.ArrayList;
import java.util.List;

public class MapSourceCollection {

    public static MapSourceCollection getInstance() {
        return new MapSourceCollection();
    }

    public List<MapSource> allWithServicesAndLayers() {
        return Ebean.find(MapSource.class)
                .fetch("webMapServices", new FetchConfig().query())
                .fetch("webMapServices.layers", new FetchConfig().query())
                .orderBy("id")
                .findList();
    }

    public Boolean canBeUsed(MapSource source) {
        for (MapWMS service : source.webMapServices) {
            if (MapWMSCollection.getInstance().canBeUsed(service)) {
                return true;
            }
        }
        return false;
    }
}
