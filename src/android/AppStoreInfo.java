package cordova.plugin.appstoreinfo;

import android.content.Context;
import android.content.IntentSender;

import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import com.google.android.play.core.appupdate.AppUpdateInfo;
import com.google.android.play.core.appupdate.AppUpdateManager;
import com.google.android.play.core.appupdate.AppUpdateManagerFactory;
import com.google.android.play.core.install.model.AppUpdateType;
import com.google.android.play.core.install.model.UpdateAvailability;
import com.google.android.play.core.tasks.Task;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class AppStoreInfo extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        if (action.equals("appInfo")) {

            try {
                
                Context currentContext = (cordova.getActivity()).getBaseContext();
                AppUpdateManager appUpdateManager = AppUpdateManagerFactory.create(currentContext);

                Task<AppUpdateInfo> appUpdateInfoTask = appUpdateManager.getAppUpdateInfo();


                appUpdateInfoTask.addOnSuccessListener(
                        appUpdateInfo -> {
                            PackageInfo pInfo = null;
                            try {
                                pInfo = this.getPackageInfo();
                            } catch (PackageManager.NameNotFoundException e) {
                                callbackContext.success("Unable to get App Info");
                                return;
                            }
                            try {
                                JSONObject response = new JSONObject();
                                response.put("localVersion", String.valueOf(pInfo.versionCode));
                                response.put("storeVersion", String.valueOf(appUpdateInfo.availableVersionCode()));
                                
                                callbackContext.success(response);
                            } catch (JSONException e) {
                                callbackContext.success("JSON Unable to get App Info");
                            }

                            return;
                        }
                );

                appUpdateInfoTask.addOnFailureListener( e -> {
                    callbackContext.success("appUpdateInfoTask expected one non-empty string argument.");
                });

                return true;
            } catch (Exception e) {
                callbackContext.success("Unable to get App Info");
            }
        }

        return false;
    }


    private PackageInfo getPackageInfo() throws PackageManager.NameNotFoundException {
        String packageName = this.getContext().getPackageName();
        return this.getContext().getPackageManager().getPackageInfo(packageName, 0);
    }

    private Context getContext() throws PackageManager.NameNotFoundException {
        Context currentContext = (cordova.getActivity()).getBaseContext();
        return currentContext;
    }
}