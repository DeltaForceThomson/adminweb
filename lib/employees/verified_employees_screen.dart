
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../functions/functions.dart';
import '../homeScreen/home_screen.dart';
import '../widgets/nav_appbar.dart';


class VerifiedEmployeesScreen extends StatefulWidget
{

  @override
  State<VerifiedEmployeesScreen> createState() => _VerifiedEmployeesScreenState();
}



class _VerifiedEmployeesScreenState extends State<VerifiedEmployeesScreen>
{
  QuerySnapshot? allApprovedEmployees;


  showDialogBox(employeeDocumentId)
  {
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text(
              "Block Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to block this account ?",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                child: const Text(
                    "No"
                ),
              ),
              ElevatedButton(
                onPressed: ()
                {
                  Map<String, dynamic> employeeDataMap =
                  {
                    "status": "not approved",
                  };

                  FirebaseFirestore.instance
                      .collection("employee")
                      .doc(employeeDocumentId)
                      .update(employeeDataMap)
                      .whenComplete(()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

                    showReusableSnackBar(context, "Blocked Successfully.");
                  });
                },
                child: const Text(
                    "Yes"
                ),
              )
            ],
          );
        }
    );
  }

  getAllVerifiedSellers() async
  {
    FirebaseFirestore.instance
        .collection("employee")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedEmployees)
    {
      setState(() {
        allApprovedEmployees = allVerifiedEmployees;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getAllVerifiedSellers();
  }

  @override
  Widget build(BuildContext context)
  {
    Widget verifiedSellersDesign()
    {
      if(allApprovedEmployees == null)
      {
        return const Center(
          child: Text(
            "No Record Found.",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      }
      else
      {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: allApprovedEmployees!.docs.length,
          itemBuilder: (context, index)
          {
            return Card(
              elevation: 10,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 180,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            allApprovedEmployees!.docs[index].get("photoUrl"),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Text(
                    allApprovedEmployees!.docs[index].get("name"),
                  ),

                  Text(
                    allApprovedEmployees!.docs[index].get("email"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //block now
                      GestureDetector(
                        onTap: ()
                        {
                          showDialogBox(allApprovedEmployees!.docs[index].id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/block.png",
                                width: 56,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Block Now",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //earnings
                    ],
                  ),

                ],
              ),
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: NavAppBar(title: "Verified Employee Accounts",),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: verifiedSellersDesign(),
        ),
      ),
    );
  }
}