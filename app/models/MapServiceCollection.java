package models;

public class MapServiceCollection {

    public static MapServiceCollection getInstance() {
        return new MapServiceCollection();
    }

    public Boolean canBeUsed(MapService service) {
        for (MapLayer layer : service.layers) {
            if (layer.canBeUsed) {
                return true;
            }
        }
        return false;
    }

    public MapService findByName(String name) {
        return MapService.find("lower(name) = ?", name.toLowerCase()).first();
    }

}
