import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_care/screens/home_screen.dart';
import 'package:plant_care/screens/profile_screen.dart';
import 'package:plant_care/screens/welcome_screen.dart';
import 'package:plant_care/screens/plant_detail_screen.dart';
import 'package:plant_care/screens/add_plant_screen.dart';
import 'package:plant_care/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Firebase başlatılıyor
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF5F4),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // ✅ Giriş kontrolü yapılır
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return const HomeScreen(); // Kullanıcı zaten giriş yapmışsa
          } else {
            return const WelcomeScreen(); // Giriş yapılmamışsa
          }
        },
      ),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/add': (context) => const AddPlantScreen(),
      },
    );
  }
}
