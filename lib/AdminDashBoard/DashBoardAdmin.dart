import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:real_estate_project/inside/pages/salary.dart';
import 'package:real_estate_project/pages/home/home_page.dart';
import 'package:real_estate_project/widgets/employees/employee_screen.dart';
import '../customers/cus.dart';
import '../executive/navigator.dart';
import '../login/loginform.dart';
import '../sales_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      // Desktop view with sidebar
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          title: Text(
            'Admin Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50),
          ),
          backgroundColor: Colors.black,
        ),
        body: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
              child: Container(
                width: 250,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    _buildNavigationButton('DashBoard', 0, context, Icons.dashboard),
                    _buildNavigationButton('Employees', 1, context, Icons.people_alt_outlined),
                    _buildNavigationButton('Sales', 2, context, Icons.real_estate_agent_outlined),
                    _buildNavigationButton('Customers', 3, context, Icons.business_center_sharp),
                    _buildNavigationButton('Attendance', 4, context, Icons.mark_email_unread_rounded),
                    _buildNavigationButton('Settings', 5, context, Icons.settings),
                    _buildNavigationButton('Logout', 6, context, Icons.exit_to_app),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _buildPageView(context),
            ),
          ],
        ),
      );
    } else {
      // Mobile view with drawer
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 100,
          title: Text(
            ' Executive Dashboard',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          backgroundColor: Colors.black54,
        ),
        body: _buildPageView(context),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerHeader(),
              _buildDrawerItem('DashBoard', 0, context, Icons.dashboard),
              _buildDrawerItem('Employees', 1, context, Icons.people_alt_outlined),
              _buildDrawerItem('Sales', 2, context, Icons.real_estate_agent_outlined),
              _buildDrawerItem('Customers', 3, context, Icons.business_center_sharp),
              _buildDrawerItem('Attendance', 4, context, Icons.mark_email_unread_rounded),
              _buildDrawerItem('Settings', 5, context, Icons.settings),
              _buildDrawerItem('Logout', 6, context, Icons.exit_to_app),
            ],
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Disable screenshot functionality
    _disableScreenshots();
  }

  void _disableScreenshots() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Widget _buildPageView(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: PageView(
          controller: context.read<NavigationProvider>().pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomePage(scaffoldKey: _scaffoldKey),
            EmployeesScreen(),
            SalesScreen(),
            CustomersScreen(),
            ViewDataPagess(),
            SettingsScreen()
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(String label, int index, BuildContext context, IconData iconData) {
    return InkWell(
      onTap: () {
        if (label == 'Logout') {
          _showLogoutConfirmationDialog(context);
        } else {
          context.read<NavigationProvider>().currentIndex = index;
          context.read<NavigationProvider>().pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: context.watch<NavigationProvider>().currentIndex == index ? Colors.orange.withOpacity(0.5) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(iconData, color: Colors.white), // Changed icon color to white
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.black87,
      ),
      child: Center(
        child: Text(
          'Real Estate Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String label, int index, BuildContext context, IconData iconData) {
    return ListTile(
      title: Row(
        children: [
          Icon(iconData, color: Colors.orange), // Changed icon color to orange
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: Colors.orange),
          ),
        ],
      ),
      onTap: () {
        if (label == 'Logout') {
          _showLogoutConfirmationDialog(context);
        } else {
          context.read<NavigationProvider>().currentIndex = index;
          context.read<NavigationProvider>().pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          Navigator.pop(context); // Close the drawer
        }
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Handle Logout here
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSettingItem('Account Settings', Icons.account_circle, () {
              // Navigate to Account Settings screen
            }),
            _buildSettingItem('Notification Settings', Icons.notifications, () {
              // Navigate to Notification Settings screen
            }),
            _buildSettingItem('Privacy Settings', Icons.lock, () {
              // Navigate to Privacy Settings screen
            }),
            _buildSettingItem('About Us', Icons.info, () {
              // Navigate to About Us screen
            }),
            // Add more setting items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}