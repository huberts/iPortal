package models;

import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;
import java.util.Set;

@Entity
public class MapWMS extends Model {

    @Required
    public String name;

    @Required
    public String displayName;

    @Required
    public String url;

    @ManyToOne
    public MapSource mapSource;

    @OneToMany( cascade=CascadeType.ALL, mappedBy="mapWMS" )
    public Set<MapLayer> layers;

}
