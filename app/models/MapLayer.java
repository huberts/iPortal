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
    public boolean defaultVisible = false;

    @Required
    public boolean canBeUsed = true;

    public String additionalOptions;

    @ManyToOne
    public MapService mapService;

    public MapLayer()
    {
    }

    public MapLayer(String name, String displayName, boolean defaultVisible, boolean canBeUsed, String additionalOptions, MapService mapService) {
        this.name = name;
        this.displayName = displayName;
        this.mapService = mapService;
        this.defaultVisible = defaultVisible;
        this.canBeUsed = canBeUsed;
        this.additionalOptions = additionalOptions;
        this.mapService = mapService;
        this.save();
    }
}
