import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:touristasst/Show_Place.dart';

 
// ignore: camel_case_types
class Explore_Places extends StatefulWidget {
  final String statename ;
  Explore_Places({Key key, @required this.statename}) : super(key: key);

  @override
  _Explore_PlacesState createState() => _Explore_PlacesState();
}

// ignore: camel_case_types
class _Explore_PlacesState extends State<Explore_Places> {
   List<dynamic> places = [];
   List<dynamic> loc = [];
   List<dynamic> data = [];
   List<dynamic> img = [];
   bool showplace = false;
   String temp;
   Map <String, String> placeandimg = {};
   Map <String, String> placeandloc = {};
   Map <String, String> placeanddata = {};
   

  void readplaces(){
    final dbref =  FirebaseDatabase.instance.reference().child(widget.statename);
    dbref.once().then((DataSnapshot snapshot) {
       Map<dynamic, dynamic> myval = snapshot.value;
       myval.forEach((key, value) {
         if(key!='stateimg')
         {
           temp = key;
          setState(() {
            places.add(temp);
          });
         }
         final childdb = FirebaseDatabase.instance.reference().child(widget.statename).child(key);
         childdb.once().then((DataSnapshot snapshot) {
            Map<dynamic, dynamic> childval = snapshot.value;
            childval.forEach((key, value) {
              if(key=='LocUrl'){
                setState(() {
                  loc.add(childval['LocUrl']);
                });
              }
              else if(key=='Data'){
                setState(() {
                  data.add(childval['Data']);
                });
              }
              else if(key=='ImgUrl'){
                setState(() {
                  img.add(childval['ImgUrl']);
                });
              }
            });
            for(int i=0;i<places.length;i++)
            {
              setState(() {
                placeandimg[places[i]] = img[i];
                placeandloc[places[i]] = loc[i];
                placeanddata[places[i]] = data[i];
                showplace = true;
              });
            }
         });
       });
    });
  }
  
  
  void initState() {
    super.initState();
    readplaces();
  }
  @override
  Widget build(BuildContext mycontext) {
   return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber,
          brightness: Brightness.light,
          title: Text(
            "Explore In "+ widget.statename,
            style: TextStyle(
                fontFamily: "junegull", fontSize: 23, color: Colors.black),
          )),
          body: showplace ? GridView.count(
                crossAxisCount: 2,
                children: placeanddata.keys.map((e) => new GestureDetector(
                      onTap: () {
                       Navigator.push(mycontext, 
                       MaterialPageRoute(builder: (_)=> Show_Place(img: placeandimg[e],
                        data: placeanddata[e], loc: placeandloc[e], 
                        name: e))
                       );
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
                                    placeandimg[e]
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
                    )).toList()) : Center(
            child: Text(
                "Please Wait ...",
                style: TextStyle(
                    fontFamily: "junegull", fontSize: 23, color: Colors.black),
              )
          )
    );
  }
}