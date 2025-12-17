import 'package:flutter/material.dart';
import 'package:uc_event_hubb/view/pages/pages.dart'; // Ensure CreateEventView is exported here
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'viewmodel/event_viewmodel.dart';
import 'viewmodel/user_viewmodel.dart';
import 'viewmodel/auth_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UC Event Hub',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // Start at WelcomePage
      home: const WelcomePageView(),
      
      // Register your routes here
      routes: {
        '/login': (context) => const LoginPageView(),
        '/explore': (context) => const EventScreen(),
        // Add the new route here:
        '/create_event': (context) => const CreateEventView(),
      },
    );
  }
}