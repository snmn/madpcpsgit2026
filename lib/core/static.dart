import 'package:demopcpsseca/model/news.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

class Static {
  //static datas
  //https://newsapi.org/
  // v2/everything
  // ?q=apple
  // &sortBy=popularity
  // &apiKey=a25a0c0b883c4f389ff5c23da0f9dfea
  static String baseurl = "newsapi.org";
  static String path = "v2/everything";
  static String apikey = "a25a0c0b883c4f389ff5c23da0f9dfea";
  static String mapsapikey = "AIzaSyDmMzGmGbjESph5OSbXVTktwB3OkVd6W18";

  static Articles? article;

  //datetime formatter
  static datetimeconverter (String value){
    if(value.isEmpty || value == "" || value == " " ){
      return "";
    }
    try {
      //datetime format //parse //return string
      DateTime formatt = DateTime.parse(value);
      var formateddate = formatt.toReadable;
      return formateddate.toString();
    }catch(e){
      return "";
    }
  }
  }



