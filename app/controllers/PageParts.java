package controllers;

import com.typesafe.config.ConfigFactory;
import play.api.templates.Html;
import play.mvc.Controller;
import views.html.global.header;
import views.html.global.stylesheetsAndScripts;

public class PageParts extends Controller {

    public static Html stylesheetsAndScripts() {
        return stylesheetsAndScripts.render(
                ConfigFactory.load().getStringList("views.stylesheets"),
                ConfigFactory.load().getStringList("views.scripts")
        );
    }

    public static Html header() {
        return header.render(ConfigFactory.load().getBoolean("views.use_application_arms"));
    }
}
