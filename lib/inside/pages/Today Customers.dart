import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodayCustomer extends StatefulWidget {
  @override
  _TodayCustomerState createState() => _TodayCustomerState();
}

class _TodayCustomerState extends State<TodayCustomer> {
  late List<Map<String, dynamic>> allCustomers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      QuerySnapshot customerSnapshot =
      await FirebaseFirestore.instance.collection('customers').get();

      setState(() {
        allCustomers = customerSnapshot.docs
            .map((doc) => {'id': doc.id, 'name': doc['name']})
            .toList();
      });
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Customers'),
      ),
      body: allCustomers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: allCustomers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('ID: ${allCustomers[index]['id']}'),
            subtitle: Text('Name: ${allCustomers[index]['name']}'),
          );
        },
      ),
    );
  }
}