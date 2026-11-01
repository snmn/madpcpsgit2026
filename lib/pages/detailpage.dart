import 'package:demopcpsseca/controller/apicall.dart';
import 'package:demopcpsseca/core/static.dart';
import 'package:demopcpsseca/model/news.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:smart_date_formatter/smart_date_formatter.dart';

class detailpage extends StatefulWidget {
  const detailpage({super.key});

  @override
  State<detailpage> createState() => _detailpageState();
}

class _detailpageState extends State<detailpage> {


  Future<news?>? futurenewsdata;
  @override
  void initState() {
    super.initState();
    futurenewsdata = Apicall().getapicall();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
     body: SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           SizedBox(height: 55,),
           Stack(
             children: [
               Container(
                 height: size.height/4.5,
                 width: size.width,
                 child: Image.network(
                   fit: BoxFit.cover,
                     Static.article!.urlToImage!),
               ),
               Container(
                 height: size.height/4.5,
                 width: size.width,
                 color: Colors.black45,
               ),
               GestureDetector(
                 onTap: (){
                   Navigator.of(context).pop();
                 },
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Icon(Icons.arrow_back,
                     color: Colors.white,size: 30,),
                 ),
               ),
               Positioned(
                 right: 0,
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Icon(Icons.share,
                     color: Colors.white,size: 30,),
                 ),
               ),
               Container(
                 height: size.height/4.5,
                 width: size.width,
                 child: Center(
                   child: Icon(Icons.play_circle_fill,
                     size: 60,color: Colors.white,),
                 ),
               )
             ],
           ),
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: Text(Static.article!.title!
                 .toUpperCase(),
             style: TextStyle(fontSize: 18),),
           ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Static.article!.author!),
                Text( Static.datetimeformatter(Static.article!.publishedAt!))
              ],
            ),
          ),
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: Text(Static.article!.description!,
               style: TextStyle(fontSize: 15),),
           ),
          Padding(
            padding: const EdgeInsets.only(left:15.0,right: 15),
            child: Divider(),
          ),
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: Text("Related Videos",
             style: TextStyle(fontSize: 18),),
           ),

           //apicall
           FutureBuilder(
               future: futurenewsdata,
               builder: (context,
                   AsyncSnapshot<news?> snapshot){
                 switch (snapshot.connectionState){
                   case ConnectionState.none:
                   case ConnectionState.waiting:
                     return CircularProgressIndicator();
                   case ConnectionState.active:
                   case ConnectionState.done:
                     if(snapshot.hasData){
                       var data = snapshot.data;
                       return Column(
                         children: [
                           Container(
                             height: size.height/1.6,
                             child: ListView.builder(
                                 padding: EdgeInsets.zero,
                                 scrollDirection: Axis.vertical,
                                 itemCount: data!.articles!.length,
                                 itemBuilder: (BuildContext context, int index) {
                                   return dashboardState.verticallistitem(
                                     context,
                                       size,
                                       data.articles![index].title!,
                                       data.articles![index].urlToImage,
                                       data.articles![index].publishedAt,
                                       data.articles![index].source!.name,
                                     data.articles![index]
                                   );
                                 }
                             ),
                           ),
                         ],
                       );
                     }else{
                       return Text("No Data");
                     }
                 }
               }),

         ],
       ),
     ),
    );
  }
}
