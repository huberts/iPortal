package models;

import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;
import java.util.List;
import java.util.Set;

@Entity
public class MapLocation extends Model {

    @Required
    public String name;

    @Required
    public String displayName;

    @OneToOne
    public MapLocation parent;

    @Required
    public Long xCoordinate;

    @Required
    public Long yCoordinate;

    @Required
    public Long zoomLevel;

    public List<MapLocation> children() {
        return find("parent = " + this.id).fetch();
    }
}
