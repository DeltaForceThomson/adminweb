
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import '../functions/functions.dart';
import '../homeScreen/home_screen.dart';
import '../widgets/nav_appbar.dart';


class BlockedEmployeesScreen extends StatefulWidget
{

  @override
  State<BlockedEmployeesScreen> createState() => _BlockedEmployeesScreenState();
}



class _BlockedEmployeesScreenState extends State<BlockedEmployeesScreen>
{
  QuerySnapshot? allBlockedEmployees;


  showDialogBox(employeeDocumentId)
  {
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text(
              "Activate Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to activate this account ?",
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
                    "status": "approved",
                  };

                  FirebaseFirestore.instance
                      .collection("employee")
                      .doc(employeeDocumentId)
                      .update(employeeDataMap)
                      .whenComplete(()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

                    showReusableSnackBar(context, "Activated Successfully.");
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

  getAllBlockedEmployees() async
  {
    FirebaseFirestore.instance
        .collection("employee")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((getAllBlockedEmployees)
    {
      setState(() {
        allBlockedEmployees = getAllBlockedEmployees;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getAllBlockedEmployees();
  }

  @override
  Widget build(BuildContext context)
  {
    Widget blockedEmployeesDesign()
    {
      if(allBlockedEmployees == null)
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
          itemCount: allBlockedEmployees!.docs.length,
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
                            allBlockedEmployees!.docs[index].get("photoUrl"),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Text(
                    allBlockedEmployees!.docs[index].get("name"),
                  ),

                  Text(
                    allBlockedEmployees!.docs[index].get("email"),
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
                          showDialogBox(allBlockedEmployees!.docs[index].id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/activate.png",
                                width: 56,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Activate Now",
                                style: TextStyle(
                                  color: Colors.green,
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
      appBar: NavAppBar(title: "Blocked Employees Accounts",),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: blockedEmployeesDesign(),
        ),
      ),
    );
  }
}
