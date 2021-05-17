import 'dart:math';
import 'package:translator/translator.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
class VoiceTranslate extends StatefulWidget {
  VoiceTranslate({Key key}) : super(key: key);

  @override
  _VoiceTranslateState createState() => _VoiceTranslateState();
}

class _VoiceTranslateState extends State<VoiceTranslate> {

  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = 'Please Tap On Mic & Speak';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  String fcode;
  String fname;
  String tcode;
  String tname;
  
  final List<String> langCode = ['af', 'sq', 'am', 'ar', 'hy', 'az', 'eu', 'be', 'bn', 'bs', 'bg', 'ca', 'ceb', 'ny', 'zh-cn', 'zh-tw', 'co', 'hr', 'cs', 'da', 'nl', 'en', 'eo', 'et', 'tl', 'fi', 'fr', 'fy', 'gl', 'ka', 'de', 'el', 'gu', 'ht', 'ha', 'haw', 'iw', 'he', 'hi', 'hmn', 'hu', 'is', 'ig', 'id', 'ga', 'it', 'ja', 'jw', 'kn', 'kk', 'km', 'ko', 'ku', 'ky', 'lo', 'la', 'lv', 'lt', 'lb', 'mk', 'mg', 'ms', 'ml', 'mt', 'mi', 'mr', 'mn', 'my', 'ne', 'no', 'or', 'ps', 'fa', 'pl', 'pt', 'pa', 'ro', 'ru', 'sm', 'gd', 'sr', 'st', 'sn', 'sd', 'si', 'sk', 'sl', 'so', 'es', 'su', 'sw', 'sv', 'tg', 'ta', 'te', 'th', 'tr', 'uk', 'ur', 'ug', 'uz', 'vi', 'cy', 'xh', 'yi', 'yo', 'zu'];
  final List<String> langName = ['afrikaans', 'albanian', 'amharic', 'arabic', 'armenian', 'azerbaijani', 'basque', 'belarusian', 'bengali', 'bosnian', 'bulgarian', 'catalan', 'cebuano', 'chichewa', 'chinese (simplified)', 'chinese (traditional)', 'corsican', 'croatian', 'czech', 'danish', 'dutch', 'english', 'esperanto', 'estonian', 'filipino', 'finnish', 'french', 'frisian', 'galician', 'georgian', 'german', 'greek', 'gujarati', 'haitian creole', 'hausa', 'hawaiian', 'hebrew', 'hebrew', 'hindi', 'hmong', 'hungarian', 'icelandic', 'igbo', 'indonesian', 'irish', 'italian', 'japanese', 'javanese', 'kannada', 'kazakh', 'khmer', 'korean', 'kurdish (kurmanji)', 'kyrgyz', 'lao', 'latin', 'latvian', 'lithuanian', 'luxembourgish', 'macedonian', 'malagasy', 'malay', 'malayalam', 'maltese', 'maori', 'marathi', 'mongolian', 'myanmar (burmese)', 'nepali', 'norwegian', 'odia', 'pashto', 'persian', 'polish', 'portuguese', 'punjabi', 'romanian', 'russian', 'samoan', 'scots gaelic', 'serbian', 'sesotho', 'shona', 'sindhi', 'sinhala', 'slovak', 'slovenian', 'somali', 'spanish', 'sundanese', 'swahili', 'swedish', 'tajik', 'tamil', 'telugu', 'thai', 'turkish', 'ukrainian', 'urdu', 'uyghur', 'uzbek', 'vietnamese', 'welsh', 'xhosa', 'yiddish', 'yoruba', 'zulu'];
  List<String> speechLang  = [];
  List<String> speechCode = [];
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  GoogleTranslator translator = GoogleTranslator();
  String translatedText = "";
  bool show = true;

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
        finalTimeout: Duration(milliseconds: 0));
    if (hasSpeech) {
      _localeNames = await speech.locales();
      var systemLocale = await speech.systemLocale();
      for(int i=0;i<126;i++)
      {
        speechLang.add(_localeNames[i].name);
        speechCode.add(_localeNames[i].localeId);
      }
      _currentLocaleId = systemLocale.localeId;
    }
    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
    setState(() {
      show = false;
    });
  }
  void startListening() {
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {
    });
  } 

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }
 
  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    print('Result listener $resultListened');
    setState(() {
      lastWords = '${result.recognizedWords}';
      translation(lastWords.toString(), fcode, tcode);
    });    
    
    if(speech.isListening)
    {
      translation(lastWords.toString(), fcode, tcode);
    }
    
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  // ignore: unused_element
  void _switchLang(selectedVal) {
    int i;
      for(i=0;i<speechLang.length;i++)
    {
      if(selectedVal==speechLang[i])
      break;
    }
    String _currentID = speechCode[i];
    setState(() {
      _currentLocaleId = _currentID;
    });
    
  }
  
  void translation(String processText, String _from, String _to){
    try {
      translator.translate(processText, from: _from.toString(), to: _to.toString()).then((value) {
      setState(() {
        var temp = value;
      translatedText = temp.toString();
      });
    });
    
    } catch (e) {
      print(e);
    }
  }

  void fromnameTOcode()
  {
    int i;
    int start = 0;
    int end = fname.indexOf(" ");
    fname = fname.substring(start, end).toLowerCase();    
    for(i=0;i<langName.length;i++)
    {
      if(fname==langName[i])
      {
        break;
      }
    }
    fcode = langCode[i];
  }

  void tonameTOcode()
  {
    int i;
    int start = 0;
    int end = tname.indexOf(" ");
    tname = tname.substring(start, end).toLowerCase();
    for(i=0;i<langName.length;i++)
    {
      if(tname==langName[i])
      {
        break;
      }
    }
    tcode = langCode[i];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber,
          brightness: Brightness.light,
          title: Text(
            "Speak & Translate",
            style: TextStyle(
                fontFamily: "junegull", fontSize: 23, color: Colors.black),
          )),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AvatarGlow(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.amber,
                child: IconButton(icon: Icon(Icons.mic, color: Colors.black, size: 30),
                onPressed: (){
                   !_hasSpeech || speech.isListening
                          // ignore: unnecessary_statements
                          ? null
                          : startListening();
                },
                ),
              ),
            endRadius: 60,
            animate: speech.isListening,
            glowColor: Colors.blue,
            repeat: true,
          ),
          body: show ? Center(
          child: Text("Please Wait ..." , style: TextStyle(
                  fontFamily: "junegull", fontSize: 23, color: Colors.black),) 
        ) : SingleChildScrollView(
            child: 
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 350,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 5.0, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)) 
                        ),
                          child: SingleChildScrollView(
                            child: Text("$lastWords", style: TextStyle(
                               fontFamily: "AlexandriaFLF", fontSize: 23, color: Colors.black, fontWeight: FontWeight.w700)),
                          )
                      )
                    ],
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 150,
                        margin: EdgeInsets.fromLTRB(5,10,5,0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          border: Border.all(color: Colors.black, width: 5.5),
                          borderRadius: BorderRadius.circular(50)
                          ),
                        child: DropdownSearch<String>(
                          maxHeight: 300,
                          hint: "From",
                          items: speechLang,
                          showSearchBox: true,
                          searchBoxDecoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            labelText: "Search"
                          ),
                          onChanged: (value) {
                            setState(() {
                              _switchLang(value);
                              fname = value;
                              fromnameTOcode();
                            });
                          },
                        )
                      ),
                      Container(
                        height: 45,
                        margin: EdgeInsets.fromLTRB(5,10,5,0),
                        child: FloatingActionButton(
                          heroTag: "1",
                          onPressed: (){},
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.swap_horiz_sharp, color: Colors.black,size: 30.0,),
                        )
                      ),
                      Container(
                        height: 50,
                        width: 150,
                        margin: EdgeInsets.fromLTRB(5,10,5,0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.rectangle,
                          border: Border.all(width: 5.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(50)
                          ),
                        child: DropdownSearch<String>(
                          maxHeight: 300,
                          hint: "To",
                          items: speechLang,
                          showSearchBox: true,
                          searchBoxDecoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            labelText: "Search"
                          ),
                          onChanged: (value) {
                            setState(() {
                              tname = value;
                              tonameTOcode();
                            });
                          },
                        )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 350,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 5.0, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)) 
                        ),
                          child: SingleChildScrollView(
                            child: Text("$translatedText", style: TextStyle(
                                fontFamily: "AlexandriaFLF", fontSize: 23, color: Colors.black, fontWeight: FontWeight.w700)),
                          )
                      )
                    ],
                  ),
                ],
              )
          )

    );
  }
}