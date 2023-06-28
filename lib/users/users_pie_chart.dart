import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_appbar.dart';



class UsersPieChartScreen extends StatefulWidget
{

  @override
  State<UsersPieChartScreen> createState() => _UsersPieChartScreenState();
}



class _UsersPieChartScreenState extends State<UsersPieChartScreen>
{
  int totalNumberOfVerifiedUsers = 0;
  int totalNumberOfBlockedUsers = 0;


  getTotalNumberOfVerifiedUsers() async
  {
    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedUsers)
    {
      setState(() {
        totalNumberOfVerifiedUsers = allVerifiedUsers.docs.length;
      });
    });
  }

  getTotalNumberOfBlockedUsers() async
  {
    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedUsers)
    {
      setState(() {
        totalNumberOfBlockedUsers = allBlockedUsers.docs.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getTotalNumberOfVerifiedUsers();
    getTotalNumberOfBlockedUsers();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(title: "Ente Gramam",),
      body: DChartPie(
        data: [
          {'domain': 'Blocked Users', 'measure': totalNumberOfBlockedUsers},
          {'domain': 'Verified Users', 'measure': totalNumberOfVerifiedUsers},
        ],
        fillColor: (pieData, index)
        {
          switch (pieData['domain'])
          {
            case 'Blocked Users':
              return Colors.green;
            case 'Verified Users':
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
