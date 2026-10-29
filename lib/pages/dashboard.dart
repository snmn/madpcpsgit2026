import 'package:demopcpsseca/controller/apicall.dart';
import 'package:demopcpsseca/model/news.dart';
import 'package:demopcpsseca/pages/detailpage.dart';
import 'package:flutter/material.dart';

class dashboard extends StatefulWidget {
  dashboard({super.key});

  @override
  State<dashboard> createState() => dashboardState();
}

class dashboardState extends State<dashboard> {

  horizontallistcard(size, String title, url, date ){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => detailpage(),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            height: size.height/4.5,
            width: size.width/1.2,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),

            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network( url
                ,fit: BoxFit.cover,),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            height: size.height/4.5,
            width: size.width/1.2,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(20),

            ),
          ),
          Positioned(
            bottom: 45,
            left: 30,
            child: Container(
              width: size.width/2,
              child: Text(title,
                style: TextStyle(color: Colors.white,fontSize: 14),
                maxLines: 2,overflow: TextOverflow.ellipsis,),
            ),
          ),
          Positioned(
            bottom: 25,
            left: 30,
            child: Container(
              width: size.width/2,
              child: Text(date,
                style: TextStyle(color: Colors.white,fontSize: 14),
                maxLines: 1,overflow: TextOverflow.ellipsis,),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 30,
            child: Icon(Icons.play_circle_fill,
              color: Colors.white,
              size: 40,
            ),
          )
        ],
      ),
    );
  }

  static verticallistcard(size, title, url, date, source){
    return  Row(
      children: [
        Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(borderRadius: BorderRadius.circular(20)
                      ,child: Image.network(url
                        ,fit: BoxFit.cover,)),
                ),
                Positioned(
                  top: 40,
                  left: 40,
                  child: Icon(Icons.play_circle_fill,
                    color: Colors.white,size: 40,),
                )
              ],
            )
          ],
        ),
        Container(
          height: size.height/10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: size.width/1.6,
                  child: Text(title,
                    maxLines: 2,overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),

              Container(
                width: size.width/1.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(3),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 8,bottom: 8),
                        child: Text(source,style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    Text(date),

                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
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
                          Container(
                            height: size.height/4,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                itemCount: data!.articles!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return  horizontallistcard(
                                      size,
                                      data.articles![index].title!,
                                      data.articles![index].urlToImage,
                                      data.articles![index].publishedAt);
                                }
                            ),
                          ),
                          //vertical list
                          Container(
                            height: size.height/1.75,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.zero,
                                itemCount: 15,
                                itemBuilder: (BuildContext context, int index) {
                                  return  verticallistcard(
                                      size,
                                      "PCPS DASHAIN FEST",
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                                      "02 FEB 2026",
                                      "PCPS"
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
    );
  }
}
