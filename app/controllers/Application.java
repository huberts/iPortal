package controllers;

import models.MapSourceCollection;
import play.mvc.Controller;
import play.mvc.Result;
import views.html.index;

public class Application extends Controller {

    public static Result index() {
        return ok(index.render(MapSourceCollection.getInstance().allWithServicesAndLayers()));
  }
  
}