package controllers;

import models.MapLayer;
import play.Logger;
import play.mvc.Controller;
import play.mvc.Result;
import views.html.index;

import java.util.List;

public class Application extends Controller {
  
  public static Result index() {
    List<MapLayer> all = MapLayer.find.all();
    for (MapLayer layer : all) {
      Logger.info("Following layer:");
      Logger.info(layer.name);
    }
    return ok(index.render());
  }
  
}