import com.avaje.ebean.Ebean;
import models.MapLayer;
import models.MapSource;
import play.*;
import play.libs.Yaml;

import java.util.List;
import java.util.Map;

public class Global extends GlobalSettings {

    @Override
    public void onStart(Application app) {
        InitialData.insert(app);
    }

    static class InitialData {

        public static void insert(Application app) {
            if (Ebean.find(MapLayer.class).findRowCount()>0) {
                return;
            }
            Map<String, List<Object>> all = (Map<String, List<Object>>) Yaml.load("initial-layers.yml");
            Ebean.save(all.get("sources"));
            Ebean.save(all.get("wms"));
            Ebean.save(all.get("layers"));
        }
    }
}
