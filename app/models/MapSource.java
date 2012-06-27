package models;

import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;
import java.util.Set;

@Entity
public class MapSource extends Model {

    @Required
    public String name;

    @Required
    public String displayName;

    @OneToMany( cascade=CascadeType.ALL, mappedBy="mapSource" )
    @OrderBy( "id" )
    public Set<MapService> webMapServices;

    public MapSource(String name, String displayName) {
        this.name = name;
        this.displayName = displayName;
        this.save();
    }
}
