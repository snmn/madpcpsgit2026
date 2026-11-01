import 'package:demopcpsseca/model/news.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

class Static {
  //https://newsapi.org/
  // v2/everything
  // ?q=apple
  // &from=2026-10-29&to=2026-10-29
  // &sortBy=popularity
  // &apiKey=a25a0c0b883c4f389ff5c23da0f9dfea
  static String baseUrl = "newsapi.org";
  static String path = "v2/everything";
  static String apikey = "a25a0c0b883c4f389ff5c23da0f9dfea";

  static Articles? article;

  //datetimeformatter

  static datetimeformatter(String date){
    if(date == "" || date == " " || date.isEmpty){
      return "";
    }
    try {
      //string date lai format (parse)
      DateTime parsed = DateTime.parse(date);
      //desired format ma liyaunu paryo
      var desired = parsed.toReadable;
      //return
      return desired.toString();
    }catch(e){
      return "";
    }
  }


}