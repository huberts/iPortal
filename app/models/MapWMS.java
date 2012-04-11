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
    public String url;

    @OneToMany( cascade=CascadeType.ALL )
    @OrderBy("id")
    Set<MapLayer> layers;
}
