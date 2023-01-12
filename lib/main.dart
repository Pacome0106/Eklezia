// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:camera/camera.dart';
import 'package:eklezia/add_pages/add_note.dart';
import 'package:eklezia/add_pages/adds.dart';
import 'package:eklezia/auth/main_page.dart';
import 'package:eklezia/auth/pages_Auth/forgot_pw_page.dart';
import 'package:eklezia/auth/pages_Auth/login_screens.dart';
import 'package:eklezia/auth/pages_Auth/signup_page.dart';
import 'package:eklezia/camera_screen.dart';
import 'package:eklezia/pages/group_page.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/pages/screens/analystic_screen.dart';
import 'package:eklezia/pages/screens/bloc_note_screen.dart';
import 'package:eklezia/pages/screens/church_screen.dart';
import 'package:eklezia/pages/screens/evengil_screen.dart';
import 'package:eklezia/pages/screens/help_screen.dart';
import 'package:eklezia/pages/screens/members_screen.dart';
import 'package:eklezia/pages/screens/propos_screen.dart';
import 'package:eklezia/pages/screens/settings_screen.dart';
import 'package:eklezia/pages/user_page.dart';
import 'package:eklezia/provider/dark_theme_provider.dart';
import 'package:eklezia/widgets/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e.toString);
  }
  runApp(MyApp(
    cameras: cameras,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.cameras});
  final cameras;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChandeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChandeProvider.darkTheme =
        await themeChandeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChandeProvider;
        }),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles.themeData(themeChandeProvider.darkTheme, context),
            initialRoute: '/',
            routes: {
              '/': (context) => const MainPage(),
              '/home': (context) => HomePage(),
              '/group': (context) => const GroupPage(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignupPage(),
              '/forgot': (context) => const ForgotPasswordPage(),
              // '/identity_page': (context) => const IdentityPage(),
              '/screens/church_screen': (context) => const ChurchScreen(),
              '/screens/members_screnn': (context) => const MembersScrenn(
                    groupe: '',
                    type: '',
                    userData: '',
                  ),
              '/screens/bloc_note': (context) => const BlocNote(),
              '/screens/adds': (context) => const Adds(route: '', groupe: ''),
              '/screens/add_note': (context) => const AddNote(
                  titre: '', theme: '', notes: '', index: -1, id: 0),
              '/screens/evengil_screen': (context) => const EvengilScreen(),
              '/screens/setting_screen': (context) => const SettingsScreen(),
              '/screens/propos_screen': (context) => const ProposScreen(),
              '/screens/analystic_screen': (context) => const AnalysticScreen(),
              '/screens/help_screen': (context) => const HelpScreen(),
              '/screens/user_screen': (context) => const UserPage(image: ''),
              '/camera': (context) => CameraScreen('', widget.cameras),
            },
          );
        },
      ),
    );
  }
}
