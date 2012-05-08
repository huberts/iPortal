package controllers;

import play.Logger;
import play.Play;
import play.mvc.*;

import java.util.*;

import models.*;

public class Application extends Controller {

    @Before
    private static void commonData() {
        renderArgs.put("useArms", Boolean.parseBoolean(Play.configuration.getProperty("views.use_application_arms")));
    }

    public static void index() {
        List<MapSource> sources = MapSource.findAll();
        render(sources);
    }

}
