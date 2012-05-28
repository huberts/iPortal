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

}
