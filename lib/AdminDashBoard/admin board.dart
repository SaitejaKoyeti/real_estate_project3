import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:real_estate_project/customers/cus.dart';
import 'package:real_estate_project/inside/pages/salary.dart';
import 'package:real_estate_project/pages/home/home_page.dart';
import 'package:real_estate_project/sales_screen.dart';
import 'package:real_estate_project/widgets/employees/employee_screen.dart';

class MenuModel {
  final String icon;
  final String title;

  MenuModel({required this.icon, required this.title});
}

class AdminDashboardScreen extends StatefulWidget {
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List<MenuModel> menu = [
    MenuModel(icon: 'assets/svg/home.svg', title: "DashBoard"),
    MenuModel(icon: 'assets/svg/profile.svg', title: "Employees"),
    MenuModel(icon: 'assets/svg/profile.svg', title: "Sales"),
    MenuModel(icon: 'assets/svg/exercise.svg', title: "Customers"),
    MenuModel(icon: 'assets/svg/Attendance.svg', title: "Attendance"),
    MenuModel(icon: 'assets/svg/setting.svg', title: "Settings"),
    MenuModel(icon: 'assets/svg/signout.svg', title: "Logout"),
  ];

  Widget getContentForIndex(int index) {
    switch (index) {
      case 0:
        return HomePage(scaffoldKey: _scaffoldKey);
      case 1:
        return EmployeesScreen();
      case 2:
        return SalesScreen();
      case 3:
        return CustomersScreen();
      case 4:
        return ViewDataPagess();
      case 5:
        // return Container();
      default:
        return Container(); // Return an empty container or default content
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
                radius: 40.0, // Set radius as per your requirement
              ),
            ),
            for (var item in menu)
              ListTile(
                leading: SvgPicture.asset(
                  item.icon,
                  width: 24,
                  height: 24,
                  color: _selectedIndex == menu.indexOf(item)
                      ? Colors.black
                      : Colors.grey,
                ),
                title: Text(
                  item.title,
                ),
                onTap: () {
                  setState(() {
                    _selectedIndex = menu.indexOf(item);
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          getContentForIndex(0),
          getContentForIndex(1),
          getContentForIndex(2),
          getContentForIndex(3),
          getContentForIndex(4),
          getContentForIndex(5),
        ],
      ),
    );
  }
}