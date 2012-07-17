package models;

import play.db.jpa.Model;
import play.data.validation.Unique;
import play.data.validation.Required;

import javax.persistence.Column;
import javax.persistence.Entity;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

@Entity
public class MapSetting extends Model{
    @Required
    @Unique
    @Column(name = "_key")
    public String key;

    @Required
    @Column(name = "_value")
    public String value;

    public static final String ADMIN_PASSWORD = "admin.password";
    private static final String ADMIN_PASSWORD_SALT = "admin.password_salt";
    public static final String MAP_BOUNDINGBOX_LEFT = "map.bounding_box.left";
    public static final String MAP_BOUNDINGBOX_BOTTOM = "map.bounding_box.bottom";
    public static final String MAP_BOUNDINGBOX_RIGHT = "map.bounding_box.right";
    public static final String MAP_BOUNDINGBOX_TOP = "map.bounding_box.top";
    public static final String MAP_RESOLUTIONS = "map.resolutions";
    public static final String MAP_INITIAL_X_COORDINATE = "map.initial.cartographer_x_coordinate";
    public static final String MAP_INITIAL_Y_COORDINATE = "map.initial.cartographer_y_coordinate";
    public static final String MAP_INITIAL_Z = "map.initial.z";
    public static final String APPLICATION_ARMS = "app.use_arms";

    public static MapSetting findByKey(String key)
    {
        return MapSetting.find("byKey", key).first();
    }

    public static String encryptPassword(String password)
    {
        MessageDigest md = null;
        try {
            MapSetting salt = MapSetting.findByKey(ADMIN_PASSWORD_SALT);
            String saltedPassword = (salt != null ? salt.value : "") + password;
            md = MessageDigest.getInstance("MD5");
            return new BigInteger(1, md.digest(saltedPassword.getBytes("UTF-8"))).toString(16);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return "";
    }

    public static void createNewSalt()
    {
        SecureRandom random = new SecureRandom();
        byte bytes[] = new byte[64];
        random.nextBytes(bytes);
        MapSetting salt = MapSetting.findByKey(ADMIN_PASSWORD_SALT);
        if (salt == null)
            salt = new MapSetting();
        salt.key = MapSetting.ADMIN_PASSWORD_SALT;
        salt.value = new BigInteger(1, bytes).toString(16);
        salt.save();
    }
}
