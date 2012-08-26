package com.mmontuori.atrix_mrom;

import android.app.Service;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Enumeration;
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
			Thread.sleep(10000);
			final TelephonyManager tm =(TelephonyManager)getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);
			String deviceId = tm.getDeviceId();	
			String myIP = getLocalIpAddress();
			if (myIP == null) {
				return Service.START_FLAG_RETRY;
			}
			StringBuffer sb = new StringBuffer();
			sb.append(Build.DEVICE);
			sb.append("-");
			sb.append(Build.DISPLAY);
			sb.append("-");
			sb.append(Build.VERSION.INCREMENTAL);
			sb.append("-");
			sb.append(Build.ID);
			sb.append("-");
			sb.append(Build.MODEL);
			sb.append("-");
			sb.append(Build.VERSION.RELEASE);
			sb.append("-");
			sb.append(Build.VERSION.SDK);
			StringBuffer postString = new StringBuffer();
			postString.append("http://www.montuori.net/mrom/checkin.php?ip=");
			postString.append(URLEncoder.encode(myIP));
			postString.append("&&build=");
			postString.append(URLEncoder.encode(sb.toString()));
			postString.append("&&device_id=");
			postString.append(URLEncoder.encode(deviceId));
	        /*PrintWriter pw = new PrintWriter(new File("/mnt/sdcard/testfile.txt"));
			pw.println("device id:" + deviceId);
			pw.println("ip address:" + myIP);
			pw.println("build: " + sb.toString());
			pw.println("post string: " + postString.toString());
			pw.flush();
			pw.close();
			pw = null;
			*/
			URL url = new URL(postString.toString());
			URLConnection urlConnection = url.openConnection();
			InputStream in = new BufferedInputStream(urlConnection.getInputStream());
			try {
				byte bt[] = new byte[1024];
				in.read(bt);
			} finally {
			    in.close();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return Service.START_NOT_STICKY;
	}
	
	public String getLocalIpAddress() {
	    try {
	        for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {
	            NetworkInterface intf = en.nextElement();
	            for (Enumeration<InetAddress> enumIpAddr = intf.getInetAddresses(); enumIpAddr.hasMoreElements();) {
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

