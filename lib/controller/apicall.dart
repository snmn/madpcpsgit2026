import 'package:demopcpsseca/core/static.dart';
import 'package:demopcpsseca/model/news.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Apicall {
// ?q=apple
// &sortBy=popularity
  static Future<news?>? getnewsdata() async{
   try{
     var url = Uri.https(
       StaticFile.baseurl, StaticFile.path,
       {"q": "apple",
         "sortBy": "popularity",
         "apiKey": StaticFile.apikey,},
     );
     var response = await http.get(url);
     if(response.statusCode.toString().contains("20")){
       var responsedata = convert.jsonDecode(response.body);
       var data = news.fromJson(responsedata);
       return data;
     }else{
      return null;
     }
   }
   catch(e){
     return null;
   }
   }
  }

