package models;

import play.db.jpa.Model;
import play.data.validation.Required;
import javax.persistence.*;

@Entity
public class MapServiceType extends Model {

    @Required
    public String name;

}
