import 'dart:js_interop';

import 'package:demopcpsseca/core/static.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Apicall {
  // ?q=apple
  // &sortBy=popularity
  // &apiKey=a25a0c0b883c4f389ff5c23da0f9dfea
  static getnewsapidata()async{
  try{
    var url = Uri.https(Static.baseurl, Static.path,{
          'q':'apple',
          'sortBy':'popularity',
          'apiKey':Static.apikey
        }
    );
    var response = await http.get(url);
    if (kDebugMode) {
      print(response.body);
    }
  }catch(e){
    if (kDebugMode) {
      print(e);
    }
  }
  }
}