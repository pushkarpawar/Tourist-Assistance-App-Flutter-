import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class ImageTranslate2 extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String ImageText;
  // ignore: non_constant_identifier_names
  ImageTranslate2({Key key, @required this.ImageText}) : super(key: key);

  @override
  _ImageTranslate2State createState() => _ImageTranslate2State();
}

class _ImageTranslate2State extends State<ImageTranslate2> {
  final List<String> langCode = ['af', 'sq', 'am', 'ar', 'hy', 'az', 'eu', 'be', 'bn', 'bs', 'bg', 'ca', 'ceb', 'ny', 'zh-cn', 'zh-tw', 'co', 'hr', 'cs', 'da', 'nl', 'en', 'eo', 'et', 'tl', 'fi', 'fr', 'fy', 'gl', 'ka', 'de', 'el', 'gu', 'ht', 'ha', 'haw', 'iw', 'he', 'hi', 'hmn', 'hu', 'is', 'ig', 'id', 'ga', 'it', 'ja', 'jw', 'kn', 'kk', 'km', 'ko', 'ku', 'ky', 'lo', 'la', 'lv', 'lt', 'lb', 'mk', 'mg', 'ms', 'ml', 'mt', 'mi', 'mr', 'mn', 'my', 'ne', 'no', 'or', 'ps', 'fa', 'pl', 'pt', 'pa', 'ro', 'ru', 'sm', 'gd', 'sr', 'st', 'sn', 'sd', 'si', 'sk', 'sl', 'so', 'es', 'su', 'sw', 'sv', 'tg', 'ta', 'te', 'th', 'tr', 'uk', 'ur', 'ug', 'uz', 'vi', 'cy', 'xh', 'yi', 'yo', 'zu'];
  final List<String> langName = ['afrikaans', 'albanian', 'amharic', 'arabic', 'armenian', 'azerbaijani', 'basque', 'belarusian', 'bengali', 'bosnian', 'bulgarian', 'catalan', 'cebuano', 'chichewa', 'chinese (simplified)', 'chinese (traditional)', 'corsican', 'croatian', 'czech', 'danish', 'dutch', 'english', 'esperanto', 'estonian', 'filipino', 'finnish', 'french', 'frisian', 'galician', 'georgian', 'german', 'greek', 'gujarati', 'haitian creole', 'hausa', 'hawaiian', 'hebrew', 'hebrew', 'hindi', 'hmong', 'hungarian', 'icelandic', 'igbo', 'indonesian', 'irish', 'italian', 'japanese', 'javanese', 'kannada', 'kazakh', 'khmer', 'korean', 'kurdish (kurmanji)', 'kyrgyz', 'lao', 'latin', 'latvian', 'lithuanian', 'luxembourgish', 'macedonian', 'malagasy', 'malay', 'malayalam', 'maltese', 'maori', 'marathi', 'mongolian', 'myanmar (burmese)', 'nepali', 'norwegian', 'odia', 'pashto', 'persian', 'polish', 'portuguese', 'punjabi', 'romanian', 'russian', 'samoan', 'scots gaelic', 'serbian', 'sesotho', 'shona', 'sindhi', 'sinhala', 'slovak', 'slovenian', 'somali', 'spanish', 'sundanese', 'swahili', 'swedish', 'tajik', 'tamil', 'telugu', 'thai', 'turkish', 'ukrainian', 'urdu', 'uyghur', 'uzbek', 'vietnamese', 'welsh', 'xhosa', 'yiddish', 'yoruba', 'zulu'];
  String _fromlang, _fromlangcode;
  var temp;
  String translatedText = '';
 
  int i;
  GoogleTranslator translator = GoogleTranslator();
  void langNametolangCode() {
    for (i = 0; i < langName.length; i++) {
      if (langName[i] == _fromlang) {
        _fromlangcode = langCode[i];
      }
    }
  }

  Future<void> translation(String processtext, String _from) async {
    try {
      await translator.translate(processtext, to: _from).then((value) {
        setState(() {
          temp = value;
          translatedText = temp.toString();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void translate() {
    langNametolangCode();
    translation(widget.ImageText, _fromlangcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.amber,
            brightness: Brightness.light,
            title: Text(
              "Image Translate",
              style: TextStyle(
                  fontFamily: "junegull", fontSize: 23, color: Colors.black),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(25.0),
                child: Text(widget.ImageText, style: TextStyle(fontSize: 15)),
              ),
              Container(
                  height: 50,
                  width: 350,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(color: Colors.black, width: 5.5),
                      borderRadius: BorderRadius.circular(50)),
                  child: DropdownSearch<String>(
                    maxHeight: 300,
                    hint: "Choose Language Of Translation",
                    items: langName,
                    showSearchBox: true,
                    searchBoxDecoration: InputDecoration(
                        prefixIcon: Icon(Icons.search), labelText: "Search"),
                    onChanged: (value) {
                      setState(() {
                        _fromlang = value;
                      });
                    },
                  )),
              Container(
                color: Colors.amber,
                margin: EdgeInsets.all(10.0),
                height: 50,
                // ignore: deprecated_member_use
                child: OutlineButton(
                  onPressed: () {
                    translate();
                  },
                  color: Colors.amber,
                  child: Text("Translate"),
                ),
              ),
              Container(
                
                margin: EdgeInsets.all(10.0),
                // ignore: deprecated_member_use
                child: Text("$translatedText", style: TextStyle(fontSize: 15)),
              )
            ],
          ),
        ));
  }
}
