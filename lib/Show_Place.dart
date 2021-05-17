import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ignore: camel_case_types
class Show_Place extends StatefulWidget {
  final String img;
  final String data;
  final String loc;
  final String name;
  Show_Place({Key key, 
  @required this.img,
  @required this.data, 
  @required this.loc,
  @required this.name
  }) : super(key: key);

  @override
  _Show_PlaceState createState() => _Show_PlaceState();
}

// ignore: camel_case_types
class _Show_PlaceState extends State<Show_Place> {
  final FlutterTts flutterTts =FlutterTts();
  bool listen = true;
   Future _speak(String _newVoiceText) async {
     await flutterTts.setLanguage("en-IN");
     await flutterTts.speak(_newVoiceText);
     setState(() {
       listen = false;
     });
  }
  Future _stop() async {
        await flutterTts.stop();
        setState(() {
          listen = true;
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          backgroundColor: Colors.amber,
          brightness: Brightness.light,
          title: Text(
            "Explore In "+ widget.name,
            style: TextStyle(
                fontFamily: "junegull", fontSize: 23, color: Colors.black),
          )),
        body: SingleChildScrollView(
          child: Column(
          children: [
            Container(
              height: 300,
              width: 390,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.img)
                )
              ),
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
            Container(
              child: listen ? OutlinedButton(
                onPressed: (){
                  _speak(widget.data);
                },
              child: Row(
                children: [
                  Icon(CupertinoIcons.speaker),
                  Text("Listen Information")
                ],
              )
              ) : OutlinedButton(
                onPressed: (){
                  _stop();
                },
              child: Row(
                children: [
                  Icon(CupertinoIcons.speaker_slash),
                  Text("Stop Listening")
                ],
              )
              )
            )
             ],
           ),
            Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(widget.data, style: TextStyle(fontSize: 18.0),)
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  launch(widget.loc);
                },
                child: Row(
                  children: [
                    Icon(CupertinoIcons.location, color: Colors.red, size: 20,),
                    SizedBox(width: 10,),
                    Text(widget.loc, style: TextStyle(color:Colors.blue,fontSize: 17.0),)
                  ],
                ),
              )
            )
          ],
        ),
        )
    );
  }
}