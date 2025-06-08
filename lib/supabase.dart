import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://mligcolwhmyfnihtcsva.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1saWdjb2x3aG15Zm5paHRjc3ZhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwNTMxNTcsImV4cCI6MjA2NDYyOTE1N30.1JBDRMY-vr5XV6NWu1OzGVMUEI47EBYfRIHPx7yiQNQ';

  static Future<void> init() async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}