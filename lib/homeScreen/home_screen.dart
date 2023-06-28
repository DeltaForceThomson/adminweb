import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../employees/blocked_employees_screen.dart';
import '../employees/verified_employees_screen.dart';
import '../users/blocked_users_screen.dart';
import '../users/verified_users_screen.dart';
import '../widgets/nav_appbar.dart';


class HomeScreen extends StatefulWidget
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}




class _HomeScreenState extends State<HomeScreen>
{
  String liveTime = "";
  String liveDate = "";

  String formatCurrentLiveTime(DateTime time)
  {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentLiveDate(DateTime time)
  {
    return DateFormat("dd MMMM, yyyy").format(time);
  }

  getCurrentLiveTimeDate()
  {
    liveTime = formatCurrentLiveTime(DateTime.now());
    liveDate = formatCurrentLiveDate(DateTime.now());

    setState(() {
      liveTime;
      liveDate;
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer)
    {
      getCurrentLiveTimeDate();
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(title: "        Ente Gramam",),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                liveTime + "\n" + liveDate,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //users activate and block accounts button ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //active
                GestureDetector(
                  onTap: ()
                  {
                          Navigator.push(context,MaterialPageRoute(builder: (c)=> VerifiedUsersScreen()));
                  },
                  child: Image.asset(
                    "images/verified_users.png",
                    width: 200,
                  ),
                ),

                const SizedBox(width: 200,),

                //block
                GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>BlockedUsersScreen()));
                  },
                  child: Image.asset(
                    "images/blocked_users.png",
                    width: 200,
                  ),
                ),

              ],
            ),

            const SizedBox(
              height: 20,
            ),

            //sellers activate and block accounts button ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //active
                GestureDetector(
                  onTap: ()
                  {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> VerifiedEmployeesScreen()));
                  },
                  child: Image.asset(
                    "images/verified_employee.png",
                    width: 200,
                  ),
                ),

                const SizedBox(width: 200,),

                //block
                GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> BlockedEmployeesScreen()));
                  },
                  child: Image.asset(
                    "images/blocked_employee.png",
                    width: 200,
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}
