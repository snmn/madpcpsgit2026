import 'package:demopcpsseca/model/news.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

class StaticFile {
  // newsapi.org
  // /v2/everything
  // ?q=apple
  // &sortBy=popularity
  // &apiKey=a25a0c0b883c4f389ff5c23da0f9dfea
  static String baseurl = "newsapi.org";
  static String path = "v2/everything";
  static String apikey = "a25a0c0b883c4f389ff5c23da0f9dfea";

  static Articles? article;

  static String dateconverter(String date){
    if(date.isEmpty || date == "" || date == " "){
      return "";
    }
    try {
      DateTime formatt = DateTime.parse(date);
      var formatted = formatt.toReadable;
      return formatted.toString();
    }catch(e){
      return "";
    }
  }

}
