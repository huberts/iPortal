package models;

import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;
import java.util.Set;

@Entity
public class MapLocation extends Model {

    @Required
    public String name;

    @Required
    public String displayName;

    @OneToOne
    public MapLocationType type;

    @OneToOne
    public MapLocation parent;

}
