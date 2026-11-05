import 'package:demopcpsseca/controller/apicall.dart';
import 'package:demopcpsseca/core/staticfile.dart';
import 'package:demopcpsseca/model/news.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dashboard.dart';

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
    futurenewsdata = Apicall().getnewsdata();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var data = Staticfile.article;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 55,),
            Stack(
              children: [
                Container(
                  height: size.height/4,
                  width: size.width,
                  child: Image.network(fit: BoxFit.cover,
                  data!.urlToImage!

                )
                ),
                Container(
                    height: size.height/4,
                    width: size.width,
                    color: Colors.black54,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back,color: Colors.white,size: 40,),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: GestureDetector(
                    onTap: (){
                      SharePlus.instance.share(
                          ShareParams(text: data.title! + " "
                              + data.url!)
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.share,color: Colors.white,size: 40,),
                    ),
                  ),
                ),
                Container(
                  height: size.height/4,
                  width: size.width,
                  child: Center(
                    child: Icon(Icons.play_circle_fill,size: 60,color: Colors.white,),
                  ),
                )

              ],
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title!
                  ,style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold),maxLines: 2,
                  overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.author!),
                      Text(Staticfile.dateconverter(data.publishedAt!))
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(data.description!)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15),
              child: Divider(),
            ),
            Row(
              children: [
                SizedBox(width: 15,),
                Text("Related Videos",style: TextStyle(fontSize: 18),),
              ],
            ),

            FutureBuilder(
                future: futurenewsdata,
                builder: (context, AsyncSnapshot<news?> snapshot ){
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    case ConnectionState.done:
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        //ui dekhaune
                        return Column(
                          children: [

                            Container(
                              height: size.height/1.6,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  itemCount: data!.articles!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return  dashboardState.verticallistitem(
                                        context,size,
                                        data.articles![index].title!.toUpperCase(),
                                        data.articles![index].urlToImage,
                                        data.articles![index].publishedAt!.split("T")[0],
                                        data.articles![index].source!.name,
                                        data.articles![index]);
                                  }
                              ),
                            ),
                          ],
                        );
                      }else{
                        return Center(child: Text("No Data"),);
                      }
                  }
                }),



          ],
        ),
      ),

    );
  }
}
