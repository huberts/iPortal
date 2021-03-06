package models;

import org.hibernate.annotations.Cascade;
import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;
import java.util.List;

@Entity
public class MapLocation extends Model {

    @Required
    public String name;

    @Required
    public String displayName;

    @ManyToOne
    public MapLocation parent;

    @Required
    public Long xCoordinate;

    @Required
    public Long yCoordinate;

    @Required
    public Long zoomLevel;

    @OneToMany(cascade = {CascadeType.REMOVE}, mappedBy = "parent")
    public List<MapLocation> children;
}
