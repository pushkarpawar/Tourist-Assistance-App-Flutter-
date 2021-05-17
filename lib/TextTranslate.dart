import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:translator/translator.dart';

class TextTranslate extends StatefulWidget {
  TextTranslate({Key key}) : super(key: key);

  @override
  _TextTranslateState createState() => _TextTranslateState();
}

class _TextTranslateState extends State<TextTranslate> {
  final List<String> langCode = ['af', 'sq', 'am', 'ar', 'hy', 'az', 'eu', 'be', 'bn', 'bs', 'bg', 'ca', 'ceb', 'ny', 'zh-cn', 'zh-tw', 'co', 'hr', 'cs', 'da', 'nl', 'en', 'eo', 'et', 'tl', 'fi', 'fr', 'fy', 'gl', 'ka', 'de', 'el', 'gu', 'ht', 'ha', 'haw', 'iw', 'he', 'hi', 'hmn', 'hu', 'is', 'ig', 'id', 'ga', 'it', 'ja', 'jw', 'kn', 'kk', 'km', 'ko', 'ku', 'ky', 'lo', 'la', 'lv', 'lt', 'lb', 'mk', 'mg', 'ms', 'ml', 'mt', 'mi', 'mr', 'mn', 'my', 'ne', 'no', 'or', 'ps', 'fa', 'pl', 'pt', 'pa', 'ro', 'ru', 'sm', 'gd', 'sr', 'st', 'sn', 'sd', 'si', 'sk', 'sl', 'so', 'es', 'su', 'sw', 'sv', 'tg', 'ta', 'te', 'th', 'tr', 'uk', 'ur', 'ug', 'uz', 'vi', 'cy', 'xh', 'yi', 'yo', 'zu'];
  final List<String> langName = ['afrikaans', 'albanian', 'amharic', 'arabic', 'armenian', 'azerbaijani', 'basque', 'belarusian', 'bengali', 'bosnian', 'bulgarian', 'catalan', 'cebuano', 'chichewa', 'chinese (simplified)', 'chinese (traditional)', 'corsican', 'croatian', 'czech', 'danish', 'dutch', 'english', 'esperanto', 'estonian', 'filipino', 'finnish', 'french', 'frisian', 'galician', 'georgian', 'german', 'greek', 'gujarati', 'haitian creole', 'hausa', 'hawaiian', 'hebrew', 'hebrew', 'hindi', 'hmong', 'hungarian', 'icelandic', 'igbo', 'indonesian', 'irish', 'italian', 'japanese', 'javanese', 'kannada', 'kazakh', 'khmer', 'korean', 'kurdish (kurmanji)', 'kyrgyz', 'lao', 'latin', 'latvian', 'lithuanian', 'luxembourgish', 'macedonian', 'malagasy', 'malay', 'malayalam', 'maltese', 'maori', 'marathi', 'mongolian', 'myanmar (burmese)', 'nepali', 'norwegian', 'odia', 'pashto', 'persian', 'polish', 'portuguese', 'punjabi', 'romanian', 'russian', 'samoan', 'scots gaelic', 'serbian', 'sesotho', 'shona', 'sindhi', 'sinhala', 'slovak', 'slovenian', 'somali', 'spanish', 'sundanese', 'swahili', 'swedish', 'tajik', 'tamil', 'telugu', 'thai', 'turkish', 'ukrainian', 'urdu', 'uyghur', 'uzbek', 'vietnamese', 'welsh', 'xhosa', 'yiddish', 'yoruba', 'zulu'];
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  GoogleTranslator translator = GoogleTranslator();
  var _fromlang, _tolang;
  var _fromlangcode, _tolangcode;
  String hint = "Enter Text Here...";
  var translatedText;
  int i;
  bool islanggiven = false;
  bool fromto = false;
  bool tofrom = false;
  var temp;

  void languageselected() {
    if (_fromlang != null && _tolang != null) {
      setState(() {
        islanggiven = true;
      });
    } else {
      setState(() {
        islanggiven = false;
      });
      // ignore: deprecated_member_use
      _scaffoldkey.currentState.showSnackBar(new SnackBar(
        duration: Duration(milliseconds: 500),
        content: new Text("Please Choose Languages For Translations")
    )
    );
    }
  }

  void langNametolangCode() {
    for (i = 0; i < langName.length; i++) {
      if (langName[i] == _fromlang) {
        _fromlangcode = langCode[i];
      }
    }

    for (i = 0; i < langName.length; i++) {
      if (langName[i] == _tolang) {
        _tolangcode = langCode[i];
      }
    }
  }

  Future<void> translation(String processtext, String _from, String _to) async {
    try {
      await translator.translate(processtext, from: _from, to: _to).then((value) {
      temp = value;
      translatedText = temp.toString();
      if (fromto) {
        setState(() {
          _toController.text = translatedText;
        });
      }
      if (tofrom) {
        setState(() {
          _fromController.text = translatedText;
        });
      }
    });
    } catch (e) {
      print(e);
    }
  }

  void runthis1(String abc) {
    fromto = true;
    tofrom = false;
    languageselected();
    if (islanggiven) {
      langNametolangCode();
      translation(abc, _fromlangcode, _tolangcode);
    }
  }

  void runthis2(String abc) {
    fromto = false;
    tofrom = true;
    languageselected();
    if (islanggiven) {
      langNametolangCode();
      translation(abc, _tolangcode, _fromlangcode);
    }
    setState(() {
      _fromController.text = translatedText;
    });
  }

  void showhint() {
    if (_fromController.text.isNotEmpty || _toController.text.isNotEmpty) {
      setState(() {
        hint = '';
      });
    } else {
      setState(() {
        hint = "Enter Text Here";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
          backgroundColor: Colors.amber,
          brightness: Brightness.light,
          title: Text(
            "Text Translate",
            style: TextStyle(
                fontFamily: "junegull", fontSize: 23, color: Colors.black),
          )),
      body: ListView(children: [
        Column(
          children: [
            Card(
                color: Colors.white,
                elevation: 10,
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fromController,
                      autocorrect: true,
                      onTap: () {
                        showhint();
                      },
                      onChanged: (value) {
                        showhint();
                        runthis1(value);
                      },
                      maxLines: 9,
                      style: TextStyle(fontSize: 20),
                      cursorHeight: 20,
                      decoration: InputDecoration(
                          hintText: "$hint",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          contentPadding: EdgeInsets.all(10)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _fromController.clear();
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.clear_all),
                              ),
                              Container(
                                child: Text("Clear Text"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )),
            Row(
              children: [
                Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(color: Colors.black, width: 5.5),
                        borderRadius: BorderRadius.circular(50)),
                    child: DropdownSearch<String>(
                      maxHeight: 300,
                      hint: "From",
                      items: langName,
                      selectedItem: _fromlang,
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
                    height: 45,
                    margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                    child: FloatingActionButton(
                      onPressed: () {
                        temp = _fromlang;
                        setState(() {
                          _fromlang = _tolang;
                          _tolang = temp;
                        });
                      },
                      backgroundColor: Colors.amber,
                      child: Icon(
                        Icons.swap_horiz_sharp,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    )),
                Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 5.5, color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: DropdownSearch<String>(
                      maxHeight: 300,
                      hint: "To",
                      selectedItem: _tolang,
                      items: langName,
                      showSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                          prefixIcon: Icon(Icons.search), labelText: "Search"),
                      onChanged: (value) {
                        setState(() {
                          _tolang = value;
                        });
                      },
                    )),
              ],
            ),
            Card(
                color: Colors.white,
                elevation: 10,
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      autocorrect: true,
                      controller: _toController,
                      onTap: () {
                        showhint();
                      },
                      onChanged: (value) {
                        showhint();
                        runthis2(value);
                      },
                      maxLines: 9,
                      style: TextStyle(fontSize: 20),
                      cursorHeight: 20,
                      decoration: InputDecoration(
                          hintText: "$hint",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          contentPadding: EdgeInsets.all(10)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _toController.clear();
                          },
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.clear_all),
                              ),
                              Container(
                                child: Text("Clear Text"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ]),
    );
  }
}
