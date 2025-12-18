import 'package:flutter/material.dart';
import 'package:uc_event_hubb/view/pages/pages.dart'; // Ensure CreateEventView is exported here
import 'firebase_options.dart';
import 'package:uc_event_hubb/view/widgets/bottom_bar.dart';
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

      home: const WelcomePageView(),
      
      // Register your routes here
      routes: {
        '/login': (context) => const LoginPageView(),
        '/explore': (context) => const MainNavigationScreen(),
        '/create_event': (context) => const CreateEventView(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 1; // Start with Explore tab (index 1)

  // Define your screens here
  final List<Widget> _screens = [
    const MyTicketScreen(), // Index 0 - My Ticket
    const HomeScreen(),      // Index 1 - Explore
    const ProfileScreen(),   // Index 2 - Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}