import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_estate_project/Responsive.dart';
import 'package:real_estate_project/model/health_model.dart';
import 'package:real_estate_project/widgets/custom_card.dart';
import '../../../inside/pages/Today Customers.dart';
import '../../../inside/pages/Total Employees.dart';
import '../../../inside/pages/intrested.dart';
import '../../../widgets/employees/addemployeeform.dart';
class HealthModel {
  final IconData icon; // Change the type to IconData
  final String value;
  final String title;

  HealthModel({
    required this.icon,
    required this.value,
    required this.title,
  });
}

class ActivityDetailsCard extends StatelessWidget {
  const ActivityDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('employees').snapshots(),
      builder: (context, employeeSnapshot) {
        if (employeeSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (employeeSnapshot.hasError) {
          return Text('Error: ${employeeSnapshot.error}');
        } else {
          int totalEmployees = employeeSnapshot.data!.size;

          return StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance.collection('customers').snapshots(),
            builder: (context, customerSnapshot) {
              if (customerSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (customerSnapshot.hasError) {
                return Text('Error: ${customerSnapshot.error}');
              } else {
                int totalCustomers = customerSnapshot.data!.size;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('interested_customers')
                      .snapshots(),
                  builder: (context, interestedCustomersSnapshot) {
                    if (interestedCustomersSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (interestedCustomersSnapshot.hasError) {
                      return Text(
                          'Error: ${interestedCustomersSnapshot.error}');
                    } else {
                      int interestedCustomers =
                          interestedCustomersSnapshot.data!.size;

                      final List<HealthModel> healthDetails = [
                        HealthModel(
                          icon: Icons.people_rounded,
                          value: totalEmployees.toString(),
                          title: "Total Employees",
                        ),
                        HealthModel(
                          icon: Icons.people_alt,
                          value: totalCustomers.toString(),
                          title: "Today Customers",
                        ),
                        HealthModel(
                          icon: Icons.interests,
                          value: interestedCustomers.toString(),
                          title: "Interested",
                        ),
                        HealthModel(
                          icon: Icons.add_box,
                          value: "",
                          title: "Add Employee",
                        ),
                      ];

                      return GridView.builder(
                        itemCount: healthDetails.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                          Responsive.isMobile(context) ? 2 : 4,
                          crossAxisSpacing:
                          !Responsive.isMobile(context) ? 15 : 12,
                          mainAxisSpacing: 12.0,
                        ),
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              if (i == healthDetails.length - 1) {
                                // Handle tapping on "Add Employee"
                                // For example, show AddEmployeeForm in a dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Add Employee'),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width * 0.8, // Set the width to 80% of the screen width
                                      child: AddEmployeeForm(), // Or any other widget you want to show
                                    ),
                                  ),
                                );
                              } else if (i == healthDetails.length - 2) {
                                // Handle tapping on "Interested"
                                // For example, show Interested in a dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Interested'),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width * 0.8, // Set the width to 80% of the screen width
                                      child: Intrested(), // Or any other widget you want to show
                                    ),
                                  ),
                                );
                              } else if (i == healthDetails.length - 3) {
                                // Handle tapping on "Today Customers"
                                // For example, show Today Customers in a dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Today Customers'),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width * 0.8, // Set the width to 80% of the screen width
                                      child: TodayCustomer(), // Or any other widget you want to show
                                    ),
                                  ),
                                );
                              } else if (i == healthDetails.length - 4) {
                                // Handle tapping on "Total Employees"
                                // For example, show Total Employees in a dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Total Employees'),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width * 0.8, // Set the width to 80% of the screen width
                                      child: AllEmployeesScreen(), // Or any other widget you want to show
                                    ),
                                  ),
                                );

                              } else {
                                // Handle other taps as needed
                              }
                            },
                            child: CustomCard(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Icon(
                                      healthDetails[i].icon,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 4),
                                      child: Text(
                                        healthDetails[i].value,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      healthDetails[i].title,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}