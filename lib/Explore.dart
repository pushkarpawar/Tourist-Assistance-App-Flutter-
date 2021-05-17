import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:touristasst/Explore_Place.dart';


// ignore: camel_case_types
class Explore_States extends StatefulWidget {
  Explore_States({Key key}) : super(key: key);

  @override
  _Explore_StatesState createState() => _Explore_StatesState();
}

// ignore: camel_case_types
class _Explore_StatesState extends State<Explore_States> {
 
  bool showstates = false;
  List<dynamic> states = [];
  List<dynamic> stateimg = [];

  Map <String, String> stateandimg = {};

  Future<void> readstates() async {
  // ignore: await_only_futures
    final dbref = await FirebaseDatabase.instance.reference();
    dbref.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> myval = snapshot.value;
       myval.forEach((key, value) {
         setState(() {
           states.add(key);
            stateimg.add(value["stateimg"]);
           showstates = true;
         });
       }
       );
       if(showstates){
         for(int i=0;i<states.length;i++)
         {
           setState(() {
             stateandimg[states[i]] = stateimg[i];
           });
         }
       }       
    }
    
    );
  }

  @override
  void initState() {
    super.initState();
    readstates(); 
  }

  @override
  Widget build(BuildContext mycontext) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.amber,
            brightness: Brightness.light,
            title: Text(
              "Explore States",
              style: TextStyle(
                  fontFamily: "junegull", fontSize: 23, color: Colors.black),
            )),
        body: showstates
            ? GridView.count(
                crossAxisCount: 2,
                children: stateandimg.keys.map((e) => new GestureDetector(
                      onTap: () {
                        Navigator.push(
                            mycontext,
                            MaterialPageRoute(
                                builder: (_) => Explore_Places(statename: e,)));
                      },
                      child: Card(
                        elevation: 15,
                        margin: EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 4),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    stateandimg[e],
                                  ),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.55),
                                      BlendMode.dstATop))),
                          alignment: Alignment.center,
                          child: Text(e,
                              style: TextStyle(
                                  fontFamily: "junegull",
                                  fontSize: 27.5,
                                  color: Colors.black)),
                        ),
                      ),
                    )).toList())
            : Center(
                child: Text(
                "Please Wait ...",
                style: TextStyle(
                    fontFamily: "junegull", fontSize: 23, color: Colors.black),
              ))
              );
  }
}
