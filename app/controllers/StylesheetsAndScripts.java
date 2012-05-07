package controllers;

import com.typesafe.config.ConfigFactory;
import play.api.templates.Html;
import play.mvc.Controller;
import views.html.global.stylesheetsAndScripts;

public class StylesheetsAndScripts extends Controller {
    public static Html all() {
        return stylesheetsAndScripts.render(
                ConfigFactory.load().getStringList("views.stylesheets"),
                ConfigFactory.load().getStringList("views.scripts")
        );
    }
}
