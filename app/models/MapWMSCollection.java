package models;

public class MapWMSCollection {

    public static MapWMSCollection getInstance() {
        return new MapWMSCollection();
    }

    public Boolean canBeUsed(MapWMS service) {
        for (MapLayer layer : service.layers) {
            if (layer.canBeUsed) {
                return true;
            }
        }
        return false;
    }

}
