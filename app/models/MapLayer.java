package models;

import play.db.ebean.*;
import play.data.validation.Constraints.*;
import javax.persistence.*;

@Entity
public class MapLayer extends Model {

    @Id
    public Long id;

    @Required
    public String name;

    @Required
    public Boolean defaultVisible = true;

    @Required
    public Boolean canBeUsed = true;

}
