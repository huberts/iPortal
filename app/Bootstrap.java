import models.MapLayer;
import play.jobs.Job;
import play.jobs.OnApplicationStart;
import play.test.Fixtures;

@OnApplicationStart
public class Bootstrap extends Job {

    @Override
    public void doJob() {
        if (MapLayer.count()==0) {
            Fixtures.loadModels("initial-layers.yml");
            Fixtures.loadModels("initial-locations.yml");
        }
    }

}
