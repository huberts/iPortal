package models;

import com.avaje.ebean.Ebean;
import com.avaje.ebean.FetchConfig;
import com.avaje.ebean.bean.EntityBean;
import play.data.validation.Constraints.Required;
import play.db.ebean.Model;

import javax.persistence.*;
import java.util.List;
import java.util.Set;

@Entity
public class MapSource extends Model {

    @Id
    public Long id;

    @Required
    public String name;

    @Required
    public String displayName;

    @OneToMany( cascade=CascadeType.ALL )
    @OrderBy("id")
    public Set<MapWMS> webMapServices;

    public static Model.Finder<Long,MapSource> find = new Model.Finder(Long.class, MapSource.class);

    static public List<MapSource> allWithServicesAndLayers() {
        return Ebean.find(MapSource.class)
                .fetch("webMapServices", new FetchConfig().query())
                .fetch("webMapServices.layers", new FetchConfig().query())
                .findList();
    }
}
