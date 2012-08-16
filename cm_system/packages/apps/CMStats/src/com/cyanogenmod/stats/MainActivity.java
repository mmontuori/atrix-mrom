package com.cyanogenmod.stats;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.TextView;
import android.widget.CompoundButton.OnCheckedChangeListener;

public class MainActivity extends Activity {
    private static final String PREF_NAME = "CMStats";

    private CheckBox mCheckbox;
    private Button mPreviewButton;
    private Button mSaveButton;
    private Button mStatsButton;
    private TextView mLink;

    @Override
    public void onCreate(Bundle savedInstanceState) {
    }

    private void startReportingService(){
    }
}
