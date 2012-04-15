package controllers;

import models.MapLayer;
import models.MapSource;
import models.MapWMS;
import play.Logger;
import play.mvc.Controller;
import play.mvc.Result;
import views.html.index;

import java.util.List;

public class Application extends Controller {

    public static Result index() {

        List<MapSource> all = MapSource.find.all();
        for (MapSource source : all) {
            Logger.info(source.name);
            for (MapWMS wms : source.webMapServices) {
                Logger.info(wms.name);
                for (MapLayer layer : wms.layers) {
                    Logger.info(layer.name);
                }
            }
        }


    return ok(index.render(all));
  }
  
}