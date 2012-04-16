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
        return ok(index.render(MapSource.allWithServicesAndLayers()));
  }
  
}