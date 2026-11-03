import 'package:demopcpsseca/controller/apicall.dart';
import 'package:demopcpsseca/model/news.dart';
import 'package:demopcpsseca/pages/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:demopcpsseca/core/staticfile.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => dashboardState();
}

class dashboardState extends State<dashboard> {

  Future<news?>? futurenewsdata;
  @override
  void initState() {
    super.initState();
    futurenewsdata = Apicall().getnewsdata();
  }

  horizontallistitem(size, String title,url, date,Articles art ){

    var formatted =  Staticfile.dateconverter(date);
    date = formatted;

    return GestureDetector(
      onTap: (){
        //yah katai static ma save garnu paryo
        Staticfile.article = art;

        //route
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => detailpage(),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: size.height/4.5,
            width: size.width/1.4,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(20)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(fit: BoxFit.cover,
                  url),
            ),
          ),
          Container(
            height: size.height/4.5,
            width: size.width/1.4,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20)
            ),
          ),
          Positioned(
            bottom: 45,
            left: 30,
            child: Container(
              width: size.width/2,
              child: Text(title,
                overflow: TextOverflow.ellipsis,maxLines: 2,
                style: TextStyle(color: Colors.white,fontSize: 16),),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 30,
            child: Text(date,
              style: TextStyle(color: Colors.white,fontSize: 16),),
          ),
          Positioned(
              bottom: 30,right: 30,
              child: Icon(Icons.play_circle_fill_rounded,color:
              Colors.white,size: 40,))
        ],
      ),
    );
  }

  static verticallistitem(context,size, String title, url,
      date, source, Articles art){
    var formatted =  Staticfile.dateconverter(date);
    date = formatted.split(",")[1];
    return GestureDetector(
      onTap: (){
        //yah katai static ma save garnu paryo
        Staticfile.article = art;
        //route
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => detailpage(),
          ),
        );
      },
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                width: 120,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(fit: BoxFit.cover,
                      url),
                ),
              ),
              Container(
                height: 120,
                width: 120,
                margin: EdgeInsets.all(15),
                child: Center(
                  child: Icon(Icons.play_circle_fill_rounded,
                    size: 50,color: Colors.white,),
                ),
              )
            ],
          ),
          Container(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width/2,
                  child: Text(title
                    ,maxLines: 2,overflow: TextOverflow.ellipsis,),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10,
                          top: 8,bottom: 8),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(source,style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(width: 15,),
                    Text(date,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
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
                            height: size.height/4,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: data!.articles!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return  horizontallistitem(size,
                                      data.articles![index].title!,
                                      data.articles![index].urlToImage,
                                      data.articles![index].publishedAt,
                                      data.articles![index]
                                  );
                                }
                            ),
                          ),
                          Container(
                            height: size.height/1.6,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: data!.articles!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return  verticallistitem(context,size,
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
    );
  }
}
