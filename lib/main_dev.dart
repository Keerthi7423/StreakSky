import 'package:flutter/material.dart';
import 'app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig(
    appTitle: 'StreakSky DEV',
    flavor: AppFlavor.dev,
    apiBaseUrl: 'http://localhost:3000',
    supabaseUrl: 'https://fwwcbiskdyunwtuzwstj.supabase.co',
    supabaseAnonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3d2NiaXNrZHl1bnd0dXp3c3RqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxMTU3MTksImV4cCI6MjA5MjY5MTcxOX0.bQCELUv6d5LvPM33jKrSRS6BsOwIUJkH6TSQj0gVATQ', // TODO: Paste your anon key from Supabase Settings -> API
  );
  
  app.main();
}
