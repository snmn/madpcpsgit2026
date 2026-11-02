import 'package:demopcpsseca/model/news.dart';

class Staticfile {
  //https://newsapi.org/v2/everything
  // ?q=apple&
  // from=2026-10-13
  // &to=2026-10-13
  // &sortBy=popularity
  // &apiKey=a25a0c0b883c4f389ff5c23da0f9dfea
  static String apikey = "a25a0c0b883c4f389ff5c23da0f9dfea";
  static String baseUrl = 'newsapi.org';
  static Articles? article;
  static String path = 'v2/everything';



}