package models;

import play.db.ebean.*;
import play.data.validation.Constraints.*;
import javax.persistence.*;
import java.util.Set;

@Entity
public class MapWMS extends Model {

    @Id
    public Long id;

    @Required
    public String name;

    @Required
    public String displayName;

    @Required
    public String url;

    @ManyToOne
    public MapSource mapSource;

    @OneToMany( cascade=CascadeType.ALL )
    @OrderBy("id")
    public Set<MapLayer> layers;

    public static Model.Finder<Long,MapWMS> find = new Model.Finder(Long.class, MapWMS.class);
}
