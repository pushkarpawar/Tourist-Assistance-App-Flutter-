import 'dart:convert';

import 'package:http/http.dart' as http;

// ignore: camel_case_types
class apiClient {
  final Uri currecyURL = Uri.https("free.currconv.com", "/api/v7/currencies", {"apiKey": "180de5661d1ceae7c024"});

  // ignore: missing_return
  Future <List<String>> getcurrencies() async {
    http.Response res = await http.get(currecyURL);
    if(res.statusCode==200){
      var body = jsonDecode(res.body);
      var list = body["results"];
      List<String> currencies = (list.keys).toList();
      return currencies;
      
    }
    else {
      print("Nothing Happen");
    }
  }
  // ignore: missing_return
  Future<double> getRate(String from, String to) async {
    final Uri convertUrl = Uri.https("free.currconv.com", "/api/v7/convert", 
    // ignore: unnecessary_brace_in_string_interps
    {"apiKey": "180de5661d1ceae7c024", "q": "${from}_${to}",
    "compact": "ultra"
    });
    http.Response res = await http.get(convertUrl);
    if(res.statusCode==200){
      var body = jsonDecode(res.body);
      // ignore: unnecessary_brace_in_string_interps
      return body[ "${from}_${to}"];
      
    }
  }
}