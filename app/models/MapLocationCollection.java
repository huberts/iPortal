package models;

import java.util.List;

public class MapLocationCollection {

    public static MapLocationCollection getInstance() {
        return new MapLocationCollection();
    }

    public List<MapLocation> topLevel() {
        return MapLocation.find("parent is null").fetch();
    }

}
