package models;

import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;
import java.util.Set;

@Entity
public class MapService extends Model {

    @Required
    public String name;

    @Required
    public String displayName;

    @Required
    public String url;

    public Long xCoordinate;

    public Long yCoordinate;

    public Long zoomLevel;

    public  Long sort;

    public String coatOfArms;

    @Required
    @OneToOne
    public MapServiceType serviceType;

    @ManyToOne
    public MapSource mapSource;

    @OneToMany( cascade=CascadeType.ALL, mappedBy="mapService" )
    @OrderBy( "sort, id" )
    public Set<MapLayer> layers;

    public MapService(String name, String displayName, String url, MapServiceType serviceType, MapSource mapSource) {
        this.name = name;
        this.displayName = displayName;
        this.url = url;
        this.serviceType = serviceType;
        this.mapSource = mapSource;
        this.save();
    }
}
