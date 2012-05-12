package models;

import java.util.List;
import java.util.Set;

public class MapSourceCollection {

    public static MapSourceCollection getInstance() {
        return new MapSourceCollection();
    }

    public List<MapSource> allSortedBy(String column) {
        return MapSource.find("order by " + column).fetch();
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
