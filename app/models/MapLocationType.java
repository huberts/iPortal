package models;

import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;
import java.util.Set;

@Entity
public class MapLocationType extends Model {

    @Required
    public String name;

}
