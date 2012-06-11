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

    @Required
    @OneToOne
    public MapServiceType serviceType;

    @ManyToOne
    public MapSource mapSource;

    @OneToMany( cascade=CascadeType.ALL, mappedBy="mapService" )
    @OrderBy( "id" )
    public Set<MapLayer> layers;

}
