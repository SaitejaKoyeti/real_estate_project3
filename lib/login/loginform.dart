
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:real_estate_project/AdminDashBoard/DashBoardAdmin.dart';
import 'package:real_estate_project/dashboards/Admindashboard.dart';
import 'package:real_estate_project/dashboards/Inside%20dashboard.dart';
import 'package:real_estate_project/dashboards/outside_dashboard.dart';
import 'package:real_estate_project/executive/RealEstateDashboard.dart';
import 'package:real_estate_project/inside/pages/salary.dart';

import '../AdminDashBoard/admin board.dart';
import '../inside/pages/TargetScreen.dart';

class Employee {
  late String id;
  late String email;

  Employee({required this.id, required this.email});
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              "assets/images/img.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 32.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    obscureText: _obscureText,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      _signInWithEmailAndPassword(context);
                    },
                    child: Text('Login', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.blue[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _signInWithEmailAndPassword(BuildContext context) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //     );
  //
  //     User? user = userCredential.user;
  //     if (user != null) {
  //       // Proceed with your logic...
  //       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
  //           'employees').doc(user.uid).get();
  //       bool isInsideSalesEmployee = userDoc.exists &&
  //           userDoc['sales'] == 'Inside Sales';
  //
  //       if (isInsideSalesEmployee) {
  //         await _checkLocation(context, user.uid);
  //       } else {
  //         if (userDoc.exists && userDoc['sales'] == 'Outside Sales') {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => OutsideSales(),
  //             ),
  //           );
  //         } else {
  //           bool isAdmin = await _checkIfAdmin(
  //               _emailController.text, _passwordController.text);
  //           if (isAdmin) {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => DashBoard(),
  //               ),
  //             );
  //           } else {
  //             bool checkIfExecutive = await _checkIfExecutive(
  //                 _emailController.text, _passwordController.text);
  //             if (checkIfExecutive) {
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => RealEstateDashboard(),
  //                 ),
  //               );
  //             } else {
  //               // Show error message if neither admin nor executive
  //               showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) {
  //                   return AlertDialog(
  //                     title: Text("Login Failed"),
  //                     content: Text("Incorrect email or password."),
  //                     actions: <Widget>[
  //                       TextButton(
  //                         child: Text("OK"),
  //                         onPressed: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               );
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Login failed: $e');
  //     String errorMessage = '';
  //     if (e is FirebaseAuthException) {
  //       if (e.code == 'user-not-found') {
  //         errorMessage = 'No user found with this email.';
  //       } else if (e.code == 'wrong-password') {
  //         errorMessage = 'Incorrect password provided for this user.';
  //       } else {
  //         errorMessage = 'check email or password onces';
  //       }
  //     } else {
  //       errorMessage = 'An error occurred during login. Please try again later.';
  //     }
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Login Failed"),
  //           content: Text(errorMessage),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text("OK"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
            'employees').doc(user.uid).get();
        bool isInsideSalesEmployee = userDoc.exists &&
            userDoc['sales'] == 'Inside Sales';

        if (isInsideSalesEmployee) {
          await _checkLocation(context, user.uid);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Inside sales employee logged in successfully!'),
            backgroundColor: Colors.green[100],
          ));
        } else {
          if (userDoc.exists && userDoc['sales'] == 'Outside Sales') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OutsideSales(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Outside sales employee logged in successfully!'),
              backgroundColor: Colors.blueAccent[100],
            ));
          } else {
            bool isAdmin = await _checkIfAdmin(
                _emailController.text, _passwordController.text);
            if (isAdmin) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDashboard()
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Admin logged in successfully!',),
                backgroundColor: Colors.red[100],
              ));
            } else {
              bool checkIfExecutive = await _checkIfExecutive(
                  _emailController.text, _passwordController.text);
              if (checkIfExecutive) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RealEstateDashboard(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Executive logged in successfully!'),
                  backgroundColor: Colors.yellow[100],
                ));
              } else {
                // Show error message if neither admin nor executive
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Login Failed"),
                      content: Text("Incorrect email or password."),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
          }
        }
      }
    } catch (e) {
      print('Login failed: $e');
      String errorMessage = '';
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password provided for this user.';
        } else {
          errorMessage = 'check email or password onces';
        }
      } else {
        errorMessage = 'An error occurred during login. Please try again later.';
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _checkIfAdmin(String email, String password) async {
    try {
      QuerySnapshot adminSnapshot = await FirebaseFirestore.instance.collection(
          'Admin').where('email', isEqualTo: email).get();

      if (adminSnapshot.docs.isNotEmpty) {
        if (adminSnapshot.docs.first['password'] == password) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Error fetching admin document: $e');
      return false;
    }
  }

  Future<bool> _checkIfExecutive(String email, String password) async {
    try {
      QuerySnapshot adminSnapshot = await FirebaseFirestore.instance.collection(
          'executive').where('email', isEqualTo: email).get();

      if (adminSnapshot.docs.isNotEmpty) {
        if (adminSnapshot.docs.first['password'] == password) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Error fetching executive document: $e');
      return false;
    }
  }

  Future<void> _checkLocation(BuildContext context, String userId) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location Services Disabled"),
            content: Text("Please enable location services to use this app."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    var status = await Permission.location.request();
    if (status.isDenied) {
      return;
    }

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double desiredLatitude = 12.9120906;
      double desiredLongitude = 77.5209867;

      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        desiredLatitude,
        desiredLongitude,
      );

      if (distanceInMeters > 1000000) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(),
          ),
        );
        return;
      }
      await FirebaseFirestore.instance.collection('employees')
          .doc(userId)
          .collection('loginTimes')
          .add({
        'time': DateTime.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InsideSales(),
        ),
      );
    }
  }

  Future<void> _logout(BuildContext context, String userId) async {
    await FirebaseFirestore.instance.collection('employees')
        .doc(userId)
        .collection('logoutTimes')
        .add({
      'time': DateTime.now(),
    });

    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Future<void> _clearSecureFlag(BuildContext context) async {
    if (!kIsWeb) {
      try {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
        await Future.delayed(Duration(milliseconds: 500));
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

        final overlayEntry = OverlayEntry(
          builder: (context) =>
              Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
        );

        Overlay.of(context)?.insert(overlayEntry);

        await Future.delayed(Duration(seconds: 5));
        overlayEntry.remove();
      } catch (e) {
        print("Error during clearFlags or addFlags: $e");
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}