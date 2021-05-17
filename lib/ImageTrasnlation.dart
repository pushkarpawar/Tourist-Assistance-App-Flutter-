import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

import 'package:touristasst/ImageTranslation2.dart';

class ImageTranslate extends StatefulWidget {
  ImageTranslate({Key key}) : super(key: key);

  @override
  _ImageTranslateState createState() => _ImageTranslateState();
}

class _ImageTranslateState extends State<ImageTranslate> {
  var labels = "";
  var texts = "";
  var selectedImagePath;
   bool translatetext = false;
  bool translatelabel = false;
  File _image;
  bool check = false;
  bool state = false;

  void getGallaryImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        check = true;
      });
    } else {
      print("No image found");
    }
  }

  void getCameraImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        check = true;
      });
    } else {
      // ignore: deprecated_member_use
      _scaffoldkey.currentState.showSnackBar(new SnackBar(
          duration: Duration(milliseconds: 500),
          content: new Text("Please Choose Image")));
    }
  }

  var extractedText;
  Future<void> recognizeText(File pickedImage) async {
    setState(() {
      translatelabel = false;
    });
    if (pickedImage == null) {
      // ignore: deprecated_member_use
      _scaffoldkey.currentState.showSnackBar(new SnackBar(
          duration: Duration(milliseconds: 500),
          content: new Text("Please Choose Image")));
    } else {
      extractedText = "";
      var firebaseVisionImage = FirebaseVisionImage.fromFile(pickedImage);
      var textrecognizer = FirebaseVision.instance.textRecognizer();

      try {
        var visionText = await textrecognizer.processImage(firebaseVisionImage);
        for (TextBlock textBlock in visionText.blocks) {
          for (TextLine textLine in textBlock.lines) {
            for (TextElement textElement in textLine.elements) {
              extractedText = extractedText + textElement.text + " ";
            }
            extractedText = extractedText + "\n";
          }
        }
        if (extractedText.toString().length == 0) {
          setState(() {
            texts = "There are no words in image ! ! !";
            state = true;
          });
        } else {
          setState(() {
            texts = extractedText;
            state = true;
          });
        }
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      translatetext = true;
    });
  }

  Future<void> imageLabel(File pickedImage) async {
    setState(() {
      translatetext = false;
    });
    var mylabel = '';
    if (pickedImage == null) {
      // ignore: deprecated_member_use
      _scaffoldkey.currentState.showSnackBar(new SnackBar(
          duration: Duration(milliseconds: 500),
          content: new Text("Please Choose Image")));
    } else {
      try {
        var firebaseVisionImage = FirebaseVisionImage.fromFile(pickedImage);
        ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
        var imageLabels = await labeler.processImage(firebaseVisionImage);
        for (ImageLabel imageLabel in imageLabels) {
          if (imageLabel.confidence > 0.75) {
            mylabel = mylabel +
                imageLabel.text +
                " : " +
                ((imageLabel.confidence) * 100).toStringAsFixed(2) +
                "%" +
                "\n";
          }
        }
        setState(() {
          labels = mylabel;
          state = false;
        });
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      translatelabel = true;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
          backgroundColor: Colors.amber,
          brightness: Brightness.light,
          title: Text(
            "Image Translate",
            style: TextStyle(
                fontFamily: "junegull", fontSize: 23, color: Colors.black),
          )),
      body: ListView(
        children: [
          Container(
            height: 350,
            width: 200,
            decoration: BoxDecoration(
                border: Border.all(width: 5.0, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(0))),
            child: SingleChildScrollView(
                child: check
                    ? Image.file(_image)
                    : Center(
                        child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 150, 0, 0),
                            child: Icon(Icons.photo_size_select_actual_rounded),
                          ),
                          Text("Please Select An Image",
                              style: TextStyle(
                                fontFamily: "junegull",
                                fontSize: 18,
                              ))
                        ],
                      ))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.all(5.0),
                  height: 50,
                  width: 135,
                  color: Colors.amber,
                  child: Builder(
                      builder: (ctx) =>
                          // ignore: deprecated_member_use
                          OutlineButton(
                            child: check
                                ? Text("CHANGE IMAGE",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                                : Text("PICK IMAGE",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: ctx,
                                  builder: (builder) {
                                    return new Container(
                                      child: new Wrap(
                                        children: <Widget>[
                                          new ListTile(
                                            leading: Icon(Icons.camera,
                                                color: Colors.black, size: 30),
                                            title: Text("Camera",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                            onTap: () {
                                              getCameraImage();
                                              Navigator.pop(ctx);
                                            },
                                          ),
                                          new ListTile(
                                            leading: Icon(
                                                Icons.drive_file_move_outline,
                                                color: Colors.black,
                                                size: 30),
                                            title: Text("Gallery",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                            onTap: () {
                                              getGallaryImage();
                                              Navigator.pop(ctx);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ))),
              Container(
                height: 50,
                width: 121,
                margin: EdgeInsets.all(5.0),
                color: Colors.amber,
                // ignore: deprecated_member_use
                child: OutlineButton(
                    onPressed: () {
                      imageLabel(File(_image.path));
                    },
                    child: Text("LABEL IMAGE",
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ),
              Container(
                color: Colors.amber,
                height: 50,
                width: 96,
                margin: EdgeInsets.all(5.0),
                // ignore: deprecated_member_use
                child: OutlineButton(
                    onPressed: () {
                      recognizeText(_image);
                    },
                    child: Text("GET TEXT",
                        style: TextStyle(fontWeight: FontWeight.bold))),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  Center(
                      child: state
                          ? Text(texts,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "AlexandriaFLF",
                                  fontWeight: FontWeight.bold))
                          : Text(labels,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "AlexandriaFLF",
                                  fontWeight: FontWeight.bold))),
                  Center(
                    child: Container(
                        height: 50,
                        width: 121,
                        margin: EdgeInsets.all(5.0),
                        color: Colors.amber,
                        // ignore: deprecated_member_use
                        child: Builder(
                          // ignore: deprecated_member_use
                          builder: (ctx) => OutlineButton(
                              onPressed: () {
                                if(translatetext == true){
                                  Navigator.push(
                                  ctx,
                                  MaterialPageRoute(
                                      builder: (context) => ImageTranslate2(
                                            ImageText: texts,
                                          )),
                                );
                                }
                                else if(translatelabel==true){
                                  Navigator.push(
                                  ctx,
                                  MaterialPageRoute(
                                      builder: (context) => ImageTranslate2(
                                            ImageText: labels,
                                          )),
                                );
                                }
                              },
                              child: Text("TRANSLATE",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        )),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
