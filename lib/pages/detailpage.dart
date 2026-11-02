import 'package:demopcpsseca/controller/apicall.dart';
import 'package:demopcpsseca/core/static.dart';
import 'package:demopcpsseca/model/news.dart';
import 'package:demopcpsseca/pages/dashboard.dart';
import 'package:flutter/material.dart';

class detailpage extends StatefulWidget {
   detailpage({super.key});

  @override
  State<detailpage> createState() => _detailpageState();
}

class _detailpageState extends State<detailpage> {

  Future<news?>? futurenewsdata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurenewsdata = Apicall.getnewsdata();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var data = StaticFile.article;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60,),
            //1st row
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: size.height/4,
                      width: size.width,
                      child: Image.network(
                          fit: BoxFit.cover,
                          data!.urlToImage!),
                    ),
                    Container(
                      height: size.height/4,
                      width: size.width,
                      color: Colors.black26,
                      ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.arrow_back,
                          size: 40,
                        color: Colors.white,),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.share,
                          size: 40,
                          color: Colors.white,),
                      ),
                    ),
                    Container(
                      height: size.height/4,
                      width: size.width,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.play_circle_fill_rounded,
                            size: 70,
                            color: Colors.white,),
                        ),
                      ),
                    )

                  ],
                )
              ],
            ),

            //2nd Row
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text( data.title!.toUpperCase()
                  ,style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),maxLines: 2,),
                ),

                Container(
                  width: size.width/1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.author!,style: TextStyle(fontSize: 18),),
                      Text(data.publishedAt!,style: TextStyle(fontSize: 18),)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(data.description!
                    ,style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.visible,
                    )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15),
              child: Divider(),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Related Video",
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold),),
                ),
              ],
            ),

            FutureBuilder(
                future: futurenewsdata,
                builder: (context, AsyncSnapshot<news?> snapshot)
                {
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(snapshot.hasData){
                        //show ui
                        var data = snapshot.data;
                        return Column(
                          children: [

                            //vertical list
                            Container(
                              height: size.height/1.75,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.zero,
                                  itemCount: data!.articles!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return  dashboardState.verticallistcard(
                                        size,
                                        data.articles![index].title!,
                                        data.articles![index].urlToImage,
                                        data.articles![index].publishedAt!.split("T")[0],
                                        data.articles![index].source!.name!.toString()
                                    );
                                  }
                              ),
                            ),
                          ],
                        );
                      }else{
                        return Center(child:
                        Text("No Data Available"),);
                      }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
