import 'package:demopcpsseca/core/static.dart';
import 'package:demopcpsseca/model/news.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class Apicall {
  // function
 Future<news?>? getapicall() async {
    //exception handling
    try{
      // ?q=apple
      // &sortBy=popularity
    var url = Uri.https(Static.baseUrl,
    Static.path,{
      'q': "apple",
       'sortBy': "popularity",
       'apiKey': Static.apikey
        });
    var response = await http.get(url);
    if(response.statusCode.toString().contains("20")){
      var jsonresponse = convert.jsonDecode(response.body);
      var data = news.fromJson(jsonresponse);
      return data;
    }else{
      return null;
    }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}