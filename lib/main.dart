import 'package:flutter/material.dart';
import 'package:nomad_wallet/auth.dart';
import 'package:nomad_wallet/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://mligcolwhmyfnihtcsva.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1saWdjb2x3aG15Zm5paHRjc3ZhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwNTMxNTcsImV4cCI6MjA2NDYyOTE1N30.1JBDRMY-vr5XV6NWu1OzGVMUEI47EBYfRIHPx7yiQNQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TourFriend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: Supabase.instance.client.auth.onAuthStateChange.map((authState) => authState.session?.user),
        builder: (context, snapshot) {
          // Tampilkan loading indicator saat mengecek status auth
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Redirect ke HomeScreen jika sudah login, AuthScreen jika belum
          return snapshot.hasData ? const HomeScreen() : const AuthScreen();
        },
      ),
    );
  }
}