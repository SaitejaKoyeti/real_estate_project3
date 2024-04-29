import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCustomerForm extends StatefulWidget {
  @override
  _AddCustomerFormState createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_nameController, 'Name'),
                SizedBox(height: 16),
                _buildTextField(_emailController, 'Email', isEmail: true),
                SizedBox(height: 16),
                _buildTextField(_phoneController, 'Phone', isPhone: true),
                SizedBox(height: 24),
                _buildSubmitButton(),
                SizedBox(height: 16), // Add spacing between buttons
                _buildExcelUploadButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isEmail = false, bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (isEmail) {
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
        }
        if (isPhone) {
          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
            return 'Please enter a valid 10-digit phone number';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _submitForm();
      },
      child: Text('Submit'),
    );
  }

  Widget _buildExcelUploadButton() {
    return ElevatedButton(
      onPressed: () {
        _uploadExcel();
      },
      child: Text('Upload Excel'),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _registerCustomer();
    }
  }

  Future<void> _registerCustomer() async {
    try {
      Customer newCustomer = Customer(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      // Distribute customers among inside sales employees
      String assignedEmployeeId = await distributeCustomerToEmployee();

      // Add the assignedEmployeeId to the customer data
      await FirebaseFirestore.instance.collection('customers').add({
        'name': newCustomer.name,
        'email': newCustomer.email,
        'phone': newCustomer.phone,
        'assignedEmployeeId': assignedEmployeeId,
      });

      // Clear form fields
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Customer registration successful!'),
      ));
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Customer registration failed. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<String> distributeCustomerToEmployee() async {
    // Retrieve all inside sales employees
    QuerySnapshot employeeSnapshot = await FirebaseFirestore.instance
        .collection('employees')
        .where('sales', isEqualTo: 'Inside Sales')
        .get();

    // Map employee IDs to their respective customer counts
    Map<String, int> customersCountByEmployee = {};

    // Iterate over each inside sales employee
    for (QueryDocumentSnapshot employeeDoc in employeeSnapshot.docs) {
      String employeeId = employeeDoc.id;

      // Retrieve the count of customers assigned to the employee
      QuerySnapshot assignedCustomersSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .where('assignedEmployeeId', isEqualTo: employeeId)
          .get();

      // Store the count in the map
      customersCountByEmployee[employeeId] = assignedCustomersSnapshot.size;
    }

    // Find the employee with the minimum number of assigned customers
    String assignedEmployeeId = customersCountByEmployee.entries.reduce(
          (entry1, entry2) => entry1.value < entry2.value ? entry1 : entry2,
    ).key;

    return assignedEmployeeId;
  }

  Future<void> _uploadExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      PlatformFile file = result.files.single;
      Uint8List bytes = file.bytes!;
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows.skip(
            1)) { // Skip the first row (header)
          if (row != null && row.isNotEmpty) {
            String? name = row[0]?.value.toString();
            String? email = row[1]?.value.toString();
            String? phone = row[2]?.value.toString();

            if (name != null && email != null && phone!= null) {
              await firestore.collection('customers').add({
                'name': name,
                'email': email,
                'phone': phone,
              });
            }
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Name, email, and phone  data uploaded to Firestore'),
        ),
      );

      // Call submit form function after uploading excel
      _submitFormFromExcel();
    }
  }

  void _submitFormFromExcel() {
    _submitForm();
  }
}

class Customer {
  String name;
  String email;
  String phone;

  Customer({required this.name, required this.email, required this.phone});
}

void main() {
  runApp(MaterialApp(
    home: AddCustomerForm(),
  ));
}