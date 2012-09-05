package com.mmontuori.atrix_mrom;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.telephony.TelephonyManager;
import android.util.Log;

public class CheckIn extends Service {

	@Override
	public IBinder onBind(Intent arg0) {
		return null;
	}

	@Override
	public void onCreate() {
		super.onCreate();
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		try {
			// Thread.sleep(10000);
			final TelephonyManager tm = (TelephonyManager) getBaseContext()
					.getSystemService(Context.TELEPHONY_SERVICE);
			String deviceId = tm.getDeviceId();
			String myIP = null;
			for (;;) {
				myIP = getLocalIpAddress();
				if (myIP != null) {
					// return Service.START_FLAG_RETRY;
					break;
				}
				Thread.sleep(2000);
			}
			StringBuffer sb = new StringBuffer();
			sb.append(Build.DEVICE);
			sb.append(":");
			sb.append(Build.DISPLAY);
			sb.append(":");
			sb.append(Build.VERSION.INCREMENTAL);
			sb.append(":");
			sb.append(Build.ID);
			sb.append(":");
			sb.append(Build.MODEL);
			sb.append(":");
			sb.append(Build.VERSION.RELEASE);
			sb.append(":");
			sb.append(Build.VERSION.SDK);
			String buildToCheck = Build.DEVICE + "-" + Build.DISPLAY + "-"
					+ Build.VERSION.INCREMENTAL;
			StringBuffer postString = new StringBuffer();
			postString
					.append("http://www.montuori.net/mrom/checkin.php?ip=");
			postString.append(URLEncoder.encode(myIP));
			postString.append("&&build=");
			postString.append(URLEncoder.encode(sb.toString()));
			postString.append("&&device_id=");
			postString.append(URLEncoder.encode(deviceId));
			Log.i("MROM", "Checking in: " + postString.toString());
			/*
			 * PrintWriter pw = new PrintWriter(new
			 * File("/mnt/sdcard/testfile.txt")); pw.println("device id:" +
			 * deviceId); pw.println("ip address:" + myIP); pw.println("build: "
			 * + sb.toString()); pw.println("post string: " +
			 * postString.toString()); pw.flush(); pw.close(); pw = null;
			 */
			URL url = new URL(postString.toString());
			URLConnection urlConnection = url.openConnection();
			BufferedInputStream in = new BufferedInputStream(
					urlConnection.getInputStream());
			byte bt[] = new byte[2048];
			try {
				in.read(bt);
			} finally {
				in.close();
			}

			String jsonString = new String(bt);
			JSONArray jsonArray = new JSONArray(jsonString);
			String current_version = null;

			for (int i = 0; i < jsonArray.length(); ++i) {
				JSONObject jsonObj = jsonArray.getJSONObject(i);
				if (jsonObj.has("name")) {
					String name = jsonObj
							.getString("name");
					//Log.i("MROM", "name:" + name);
					if ( name.equals("current_version") ) {
						String tmpVersion = jsonObj.getString("value");
						if ( tmpVersion.startsWith(Build.DEVICE + "-")) {
							current_version = tmpVersion;
						}
						Log.i("MROM", "latest version:" + current_version);
					}
				}

			}
			
			Log.i("MROM","running version:" + buildToCheck);
			
			if ( current_version != null && ! current_version.equals(buildToCheck)) {
				Log.i("MROM", "New Version is Available!!!");
				NotificationManager notifManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
				Notification note = new Notification(R.drawable.ic_launcher, "MROM Alert",
						System.currentTimeMillis());
				PendingIntent pendingIntent = PendingIntent.getActivity(this, 0,
						new Intent(this, CheckIn.class), 0);
				note.setLatestEventInfo(this, "MROM Alert",
						"New MROM version available, visit montuori.net", pendingIntent);
				notifManager.notify(2456, note);
				return Service.START_NOT_STICKY;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return Service.START_NOT_STICKY;
	}

	public String getLocalIpAddress() {
		try {
			for (Enumeration<NetworkInterface> en = NetworkInterface
					.getNetworkInterfaces(); en.hasMoreElements();) {
				NetworkInterface intf = en.nextElement();
				for (Enumeration<InetAddress> enumIpAddr = intf
						.getInetAddresses(); enumIpAddr.hasMoreElements();) {
					InetAddress inetAddress = enumIpAddr.nextElement();
					if (!inetAddress.isLoopbackAddress()) {
						return inetAddress.getHostAddress().toString();
					}
				}
			}
		} catch (SocketException ex) {
			Log.e("Checkin", ex.toString());
		}
		return null;
	}

}
