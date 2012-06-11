package models;

import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;

@Entity
public class MapLayer extends Model {

    @Required
    public String name;

    @Required
    public String displayName;

    @Required
    public Boolean defaultVisible = false;

    @Required
    public Boolean canBeUsed = true;

    public String additionalOptions;

    @ManyToOne
    public MapService mapService;

}
