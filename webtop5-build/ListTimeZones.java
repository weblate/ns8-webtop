import java.util.TimeZone;
import java.util.concurrent.TimeUnit;

public class ListTimeZones {
    public static void main(String[] args) {
        for (String id : TimeZone.getAvailableIDs()) {
            System.out.println(id);
        }
    }
}
