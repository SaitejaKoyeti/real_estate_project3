import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_project/const.dart';
import 'package:real_estate_project/executive/navigator.dart';
import 'package:real_estate_project/inside/pages/Amount.dart';
import 'package:real_estate_project/inside/pages/chat.dart';
import 'package:real_estate_project/inside/pages/salary.dart';
import 'package:real_estate_project/inside/pages/welcome.dart';
import 'package:real_estate_project/sales_screen.dart';
import 'package:real_estate_project/widgets/employees/employee_screen.dart';
import 'package:real_estate_project/widgets/employees/employeedetailspage.dart';
import 'package:real_estate_project/widgets/employees/recordings/AudioRecorderProvider.dart';
import 'customers/cus.dart';
import 'dashboards/Admindashboard.dart';
import 'firebase_options.dart';
import 'dashboards/Inside dashboard.dart';
import 'login/loginform.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AudioRecorderProvider>(
          create: (context) => AudioRecorderProvider(),
        ),
        ChangeNotifierProvider<NavigationProvider>(
          create: (context) => NavigationProvider(),
        ),

        // Add other providers if needed
      ],
      child: MaterialApp(
        routes: {
          '/login': (context) => LoginPage(),
        },
        title: 'Flutter Responsive Dashboard',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          // Your existing theme configuration
          primaryColor: MaterialColor(
            primaryColorCode,
            <int, Color>{
              50: const Color(primaryColorCode).withOpacity(0.1),
              100: const Color(primaryColorCode).withOpacity(0.2),
              200: const Color(primaryColorCode).withOpacity(0.3),
              300: const Color(primaryColorCode).withOpacity(0.4),
              400: const Color(primaryColorCode).withOpacity(0.5),
              500: const Color(primaryColorCode).withOpacity(0.6),
              600: const Color(primaryColorCode).withOpacity(0.7),
              700: const Color(primaryColorCode).withOpacity(0.8),
              800: const Color(primaryColorCode).withOpacity(0.9),
              900: const Color(primaryColorCode).withOpacity(1.0),

            },
          ),
          scaffoldBackgroundColor: Color(0xFF171821),
          fontFamily: 'IBMPlexSans',
          brightness: Brightness.dark,
        ),

        home: LoginPage()
      ),
    );
  }
}
