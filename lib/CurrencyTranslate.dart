import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'api_Client/api_Client.dart';

class CurrencyTranslate extends StatefulWidget {
  CurrencyTranslate({Key key}) : super(key: key);

  @override
  _CurrencyTranslateState createState() => _CurrencyTranslateState();
}

class _CurrencyTranslateState extends State<CurrencyTranslate> {
  apiClient client = apiClient();
  String from;
  String to;
  double result = 0.0;
  double rate;
  List<String> currencies;
  List<String> mylist;
  String temp;
  bool show = true;
  String hint = "Enter Amount";
  TextEditingController amountController = TextEditingController();
  // ignore: missing_return
  Future<List<String>> getcurrencyList() async {
    mylist = await client.getcurrencies();
    setState(() {
      currencies = mylist;
      show = false;
    });
  }
  // ignore: missing_return

  @override
  void initState() {
    super.initState();
    getcurrencyList();
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    String temp;
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
            backgroundColor: Colors.amber,
            brightness: Brightness.light,
            title: Text(
              "Currency Translate",
              style: TextStyle(
                  fontFamily: "junegull", fontSize: 23, color: Colors.black),
            )),
        body: show
            ? Center(
                child: Text(
                "Please Wait ...",
                style: TextStyle(
                    fontFamily: "junegull", fontSize: 23, color: Colors.black),
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(40.0),
                          width: 250,
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber, width: 3),
                              borderRadius: BorderRadius.circular(30)
                              ),
                          padding: EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: amountController,
                            cursorHeight: 25.0,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "$hint",
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w200)),
                            onTap: () {
                              setState(() {
                                hint = "";
                              });
                            },
                            onChanged: (value) async {
                              if (from == null && to == null) {
                                // ignore: deprecated_member_use
                                _scaffoldkey.currentState.showSnackBar(new SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    content: new Text(
                                        "Please Choose Your Currency")));
                              } else {
                                rate = await client.getRate(from, to);
                                setState(() {
                                  result = rate * double.parse(value);
                                });
                              }
                            },
                            onEditingComplete: () {
                              if(amountController.text.length==0)
                              {
                                result = 00.00;
                              }
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                          height: 50,
                          width: 125,
                          color: Colors.amber,
                          child: DropdownSearch(
                            hint: "From",
                            items: currencies,
                            selectedItem: from,
                            onChanged: (value) {
                              setState(() {
                                amountController.clear();
                                from = value;
                              });
                            },
                          )),
                      Container(
                          height: 50,
                          margin: EdgeInsets.all(15),
                          child: FloatingActionButton(
                            onPressed: () {
                              temp = from;
                              setState(() {
                                from = to;
                                to = temp;
                              });
                              print(to);
                            },
                            backgroundColor: Colors.amber,
                            child: Icon(
                              Icons.swap_horiz_sharp,
                              color: Colors.black,
                              size: 35.0,
                            ),
                          )),
                      Container(
                          height: 50,
                          width: 125,
                          color: Colors.amber,
                          child: DropdownSearch(
                            hint: "To",
                            selectedItem: to,
                            items: currencies,
                            onChanged: (value) {
                              setState(() {
                                result = 00;
                                to = value;
                              });
                            },
                          ))
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber, width: 3),
                              borderRadius: BorderRadius.circular(30)),
                          width: 250,
                          height: 100,
                          margin: EdgeInsets.all(40.0),
                          alignment: Alignment.center,
                          child: Text(
                            result.toStringAsFixed(5),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ));
  }
}
