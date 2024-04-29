import 'package:flutter/material.dart';
import 'package:real_estate_project/inside/pages/attendance_sheet.dart';
import 'package:real_estate_project/pages/home/home_page.dart';
import 'package:real_estate_project/widgets/menu.dart';
import 'package:real_estate_project/Responsive.dart';
import 'package:real_estate_project/widgets/profile/profile.dart';

import '../services/FirebaseService.dart';

class DashBoard extends StatelessWidget {
  DashBoard({Key? key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _signOut() async {
    try {
      await _firebaseService.signOut();
      // Handle successful sign-out, for example, navigate to the login page
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      // Handle sign-out errors
      print("Error during sign-out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: !Responsive.isDesktop(context)
          ? SizedBox(
        width: 250,
        child: Drawer(
          child: Menu(
            scaffoldKey: _scaffoldKey,
            onSignOut: _signOut,
          ),
        ),
      )
          : null,
      endDrawer: Responsive.isMobile(context)
          ? SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: const Profile(),
      )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Drawer(
                    child: Menu(
                      scaffoldKey: _scaffoldKey,
                      onSignOut: _signOut,
                    ),
                  ),
                ),
              ),
            Expanded(
              flex: 8,
              child: HomePage(scaffoldKey: _scaffoldKey,),
            ),
            if (!Responsive.isMobile(context))
              const Expanded(
                flex: 4,
                child: Profile(),
              ),
          ],
        ),
      ),
    );
  }
}
