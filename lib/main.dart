import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:touristasst/CurrencyTranslate.dart';
import 'package:touristasst/Explore.dart';
import 'package:touristasst/ImageTrasnlation.dart';
import 'package:touristasst/TextTranslate.dart';
import 'package:touristasst/VoiceTranslate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          brightness: Brightness.light,
          leading: Image.asset('assets/images/traveler.png'),
          title: Text("Tourist Assistance", style: TextStyle(fontFamily: "junegull", fontSize: 28, color: Colors.black),),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Builder(builder: (mycontext)=> Column(
            children: [
              GestureDetector(
                onTap: (){
                   Navigator.push(
                            mycontext,
                            MaterialPageRoute(builder: (context) => TextTranslate()),
                          );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.amber
                  ),
                  margin: EdgeInsets.fromLTRB(10,100,10,10),
                  child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                      margin: EdgeInsets.all(10.0),
                      child: Image.asset('assets/images/translate.png', height: 40, width: 40,),),
                    Container(
                      child: Text("Text Translate", style: TextStyle(fontFamily: "junegull", fontSize: 23, color: Colors.black),))
                      ],
                    ),
                  ],
                ),
                )
              ),
              GestureDetector(
                onTap: (){
                   Navigator.push(
                            mycontext,
                            MaterialPageRoute(builder: (context) => VoiceTranslate()),
                          );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.amber
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                      margin: EdgeInsets.all(10.0),
                      child: Image.asset('assets/images/voice-recognition.png', height: 40, width: 40,),),
                    Container(
                      child: Text("Speak & Translate", style: TextStyle(fontFamily: "junegull", fontSize: 23, fontWeight: FontWeight.w400),))
                      ],
                    ),
                  ],
                ),
                )
              ),
               GestureDetector(
                 onTap: (){
                   Navigator.push(
                            mycontext,
                            MaterialPageRoute(builder: (context) => ImageTranslate()),
                          );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.amber
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                      margin: EdgeInsets.all(10.0),
                      child: Image.asset('assets/images/analytics.png', height: 40, width: 40,),),
                    Container(
                      child: Text("Image Translate", style: TextStyle(fontFamily: "junegull",fontSize: 23, fontWeight: FontWeight.w400),))
                      ],
                    ),
                  ],
                ),
                )
              ),
               GestureDetector(
              onTap: (){
                   Navigator.push(
                            mycontext,
                            MaterialPageRoute(builder: (context) => CurrencyTranslate()),
                          );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.amber
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                      margin: EdgeInsets.all(10.0),
                      child: Image.asset('assets/images/conversion.png', height: 40, width: 40,),),
                    Container(
                      child: Text("Currency Conversion", style: TextStyle(fontFamily: "junegull",fontSize: 23, fontWeight: FontWeight.w400),))
                      ],
                    ),
                  ],
                ),
                )
              ),
               GestureDetector(
                onTap: (){
                  Navigator.push(
                            mycontext,
                            MaterialPageRoute(builder: (context) => Explore_States()),
                          );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.amber
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                      margin: EdgeInsets.all(10.0),
                      child: Image.asset('assets/images/destination.png', height: 40, width: 40,),),
                    Container(
                      child: Text("Explore India", 
                      style: TextStyle(fontFamily: "junegull", fontSize: 23, fontWeight: FontWeight.w400),))
                      ],
                    ),
                  ],
                ),
                )
              ),
            ],)
          ),
        ),
      ),
    );
  }
}