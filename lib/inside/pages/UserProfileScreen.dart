import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../login/loginform.dart';
import '../../dashboards/Inside dashboard.dart';

class UserProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  UserProfileScreen({required this.userProfile});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Uint8List? _image;
  String? _profilePicUrl;
  bool isObscurePassword = false;

  @override
  void initState() {
    super.initState();
    fetchProfilePic();
  }

  void fetchProfilePic() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.userProfile.userId)
          .get();
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _profilePicUrl = userData['profilePic'];
      });
    } catch (error) {
      print("Error fetching profile picture: $error");
    }
  }

  Future<void> selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    if (_image != null) {
      // Upload image to Firebase Storage
      String imagePath =
          'profile_pictures/${widget.userProfile.userId}.jpg'; // Define a path for the image
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      UploadTask uploadTask = ref.putData(_image!);

      // Get the download URL and save it to Firestore
      uploadTask.then((res) {
        res.ref.getDownloadURL().then((downloadURL) {
          FirebaseFirestore.instance
              .collection('employees')
              .doc(widget.userProfile.userId)
              .update({
            'profilePic': downloadURL,
          });
          setState(() {
            _profilePicUrl = downloadURL;
          });
        });
      });
    }
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Save logout time in the employee's document
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.userProfile.userId)
          .update({
        'status': 'loggedOut',
      });

      // Add logout time to the logout times sub-collection
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.userProfile.userId)
          .collection('logoutTimes')
          .add({
        'time': DateTime.now(),
      });

      // Perform logout logic (e.g., sign out from FirebaseAuth)
      await FirebaseAuth.instance.signOut();

      // Navigate to login page after logout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Logout failed: $e');
      // Handle logout failure (e.g., show error message to user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('User Profile'),
          elevation: 2,
          backgroundColor: Colors.blue
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                                : _profilePicUrl != null
                                ? CircleAvatar(
                              radius: 64,
                              backgroundImage:
                              NetworkImage(_profilePicUrl!),
                            )
                                : CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2018/01/15/08/34/woman-3083453_1280.jpg'),
                            ),
                            Positioned(
                              bottom: -2,
                              left: 80,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Username: ${widget.userProfile.name}',
                          style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        if (widget.userProfile.dob != null)
                          Text('Date of Birth: ${widget.userProfile.dob}'),
                        SizedBox(height: 10),
                        if (widget.userProfile.email != null)
                          Text('Email: ${widget.userProfile.email}'),
                        SizedBox(height: 10),
                        if (widget.userProfile.gender != null)
                          Text('Gender: ${widget.userProfile.gender}'),
                        SizedBox(height: 10),
                        if (widget.userProfile.phone != null)
                          Text('Phone: ${widget.userProfile.phone}'),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            _logout(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            // primary: Colors.deepPurpleAccent,
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Logout', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                          ),

                        ),])
              ),
            ),
          ),
        ),
      ),
    );
  }
}