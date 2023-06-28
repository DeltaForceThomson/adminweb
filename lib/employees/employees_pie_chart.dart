import 'dart:math';
import 'package:d_chart/d_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_appbar.dart';



class EmployeesPieChartScreen extends StatefulWidget
{

  @override
  State<EmployeesPieChartScreen> createState() => _EmployeesPieChartScreenState();
}



class _EmployeesPieChartScreenState extends State<EmployeesPieChartScreen>
{
  int totalNumberOfVerifiedEmployees = 0;
  int totalNumberOfBlockedEmployees = 0;


  getTotalNumberOfVerifiedEmployees() async
  {
    FirebaseFirestore.instance
        .collection("employee")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedEmployees)
    {
      setState(() {
        totalNumberOfVerifiedEmployees= allVerifiedEmployees.docs.length;
      });
    });
  }

  getTotalNumberOfBlockedEmployees() async
  {
    FirebaseFirestore.instance
        .collection("employee")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedEmployees)
    {
      setState(() {
        totalNumberOfBlockedEmployees = allBlockedEmployees.docs.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getTotalNumberOfVerifiedEmployees();
    getTotalNumberOfBlockedEmployees();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(title: "Ente Gramam",),
      body: DChartPie(
        data: [
          {'domain': 'Blocked Employees', 'measure': totalNumberOfBlockedEmployees},
          {'domain': 'Verified Employees', 'measure': totalNumberOfVerifiedEmployees},
        ],
        fillColor: (pieData, index)
        {
          switch (pieData['domain'])
          {
            case 'Blocked Employees':
              return Colors.green;
            case 'Verified Employees':
              return Colors.white;
            default:
              return Colors.grey;
          }
        },
        labelFontSize: 20,
        animate: false,
        pieLabel: (pieData, index)
        {
          return "${pieData['domain']}";
        },
        labelColor: Colors.white,
        strokeWidth: 6,
      ),
    );
  }
}
