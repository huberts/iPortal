package controllers;

import play.Play;
import play.data.validation.Required;
import play.i18n.Messages;
import play.mvc.*;

import java.util.List;

import models.*;

/**
 * Created with IntelliJ IDEA.
 * User: wstasiak
 * Date: 12.06.12
 * Time: 08:09
 * Administration panel
 */
@With(CommonData.class)
public class Admin extends Controller {

    // Every call is checked for authentication, except those listed below
    @Before(unless={"login", "authenticate", "logout"})
    static void checkAccess() throws Throwable {
        // Is authenticated?
        if(!session.contains("username")) {
            login();
        }
    }

    public static void index() {
        renderArgs.put("user", session.get("username"));
        List<MapSource> sources = MapSourceCollection.getInstance().allSortedBy("id");
        List<MapLocation> locations = MapLocationCollection.getInstance().topLevel();
        render(sources, locations);
    }

    public static void login() {
        //Check if we are already logged in
        if(!session.contains("username")) {
            render();
        }
        else {
            index();
        }
    }

    public static void logout() throws Throwable {
        //Clear session data
        session.clear();
        Application.index(null, null, null);
    }

    public static void authenticate(@Required String username, String password) {
        //Check username & password
        if (username.equalsIgnoreCase(Play.configuration.getProperty("admin.user", "admin"))
            && password.equals(Play.configuration.getProperty("admin.password", "1234"))) {
            session.put("username", username);
            index();
        }
        //Opss... something is wrong
        flash.put("admin.error", Messages.get("app.admin.error"));
        login();
    }
}
