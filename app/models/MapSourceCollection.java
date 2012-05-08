package models;

import java.util.List;

public class MapSourceCollection {

    public static MapSourceCollection getInstance() {
        return new MapSourceCollection();
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
