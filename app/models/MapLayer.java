package models;

import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;
import java.util.Set;

@Entity
public class MapLayer extends Model {

    @Required
    public String name;

    @Required
    public String displayName;

    @Required
    public Boolean defaultVisible = false;

    @Required
    public Boolean canBeUsed= true;

    @ManyToOne
    public MapWMS mapWMS;

}
