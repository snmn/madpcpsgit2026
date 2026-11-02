import 'package:demopcpsseca/controller/apicall.dart';
import 'package:demopcpsseca/model/news.dart';
import 'package:flutter/material.dart';
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
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"

                )
                ),
                Container(
                    height: size.height/4,
                    width: size.width,
                    color: Colors.black54,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back,color: Colors.white,size: 40,),
                ),
                Positioned(
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.share,color: Colors.white,size: 40,),
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
                  Text("Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone"
                  ,style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold),maxLines: 2,
                  overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Author Name"),
                      Text("02 02 2026 ")
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text("Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone Happy Dashain Everyone")
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
                                    return  dashboardState.verticallistitem(size,
                                        data.articles![index].title!.toUpperCase(),
                                        data.articles![index].urlToImage,
                                        data.articles![index].publishedAt!.split("T")[0],
                                        data.articles![index].source!.name);
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
