package com.mmontuori.atrix_mrom;

import java.util.Calendar;

import android.os.Bundle;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.widget.Button;
import android.util.Log;
import android.view.Menu;
import android.view.View;

public class TestCheckin extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test_checkin);
        final Button button = (Button) findViewById(R.id.button1);
        button.setOnClickListener(new Button.OnClickListener() {
            public void onClick(View v) {
              Log.i("MROM", "Clicked");
              Intent serviceIntent = new Intent(button.getContext(), CheckIn.class);
              startService(serviceIntent);
              
            }
          });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_test_checkin, menu);
        return true;
    }

	
}
