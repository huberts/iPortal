package models;

import play.data.validation.Constraints.Required;
import play.db.ebean.Model;

import javax.persistence.*;
import java.util.Set;

@Entity
public class MapSource extends Model {

    @Id
    public Long id;

    @Required
    public String name;

    @OneToMany( cascade=CascadeType.ALL )
    @OrderBy("id")
    Set<MapWMS> layers;

    public static Model.Finder<Long,MapSource> find = new Model.Finder(Long.class, MapSource.class);
}
