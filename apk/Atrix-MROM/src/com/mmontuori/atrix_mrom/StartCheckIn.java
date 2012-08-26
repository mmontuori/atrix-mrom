package com.mmontuori.atrix_mrom;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class StartCheckIn extends BroadcastReceiver {

	@Override
	public void onReceive(Context ctx, Intent intent) {
		Intent service = new Intent(ctx, CheckIn.class);
		ctx.startService(service);
	}

}
