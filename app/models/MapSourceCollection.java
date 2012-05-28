package models;

import java.util.List;

public class MapSourceCollection {

    public static MapSourceCollection getInstance() {
        return new MapSourceCollection();
    }

    public List<MapSource> allSortedBy(String column) {
        return MapSource.find("order by " + column).fetch();
    }

    public Boolean canBeUsed(MapSource source) {
        for (MapService service : source.webMapServices) {
            if (MapServiceCollection.getInstance().canBeUsed(service)) {
                return true;
            }
        }
        return false;
    }

}
