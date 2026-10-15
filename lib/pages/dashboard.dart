import 'package:demopcpsseca/controller/apicall.dart';
import 'package:demopcpsseca/pages/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:demopcpsseca/controller/apicall.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => dashboardState();
}

class dashboardState extends State<dashboard> {

  horizontalitem(size, String title, url, date){
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
            margin: EdgeInsets.only(left: 10,right: 10,top: 8),
            height: size.height/4.5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            width: size.width/1.3,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 8),
            height: size.height/4.5,
            width: size.width/1.3,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Positioned( bottom: 40,left: 30,
              child: Container(width: size.width/2,
                  child: Text(title,
                    overflow: TextOverflow.ellipsis,maxLines: 2,
                    style: TextStyle(color: Colors.white),)
              )),
          Positioned( bottom: 20,left: 30,
              child: Container(width: size.width/2,
                  child: Text(date,
                    overflow: TextOverflow.ellipsis,maxLines: 1,
                    style: TextStyle(color: Colors.white),)
              )),
          Positioned( bottom: 20,right: 30,
              child: Container(
                  child: Icon(Icons.play_circle,color: Colors.white,size: 30,)
              ))
        ],
      ),
    );
  }

  static verticalllistitem(size,String title, url,date,source){
    return  Container(
      margin: EdgeInsets.all(15),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                      fit: BoxFit.cover,
                      url),
                ),
              ),
              Container(
                height: 150,
                width: 150,
                child: Center(
                  child: Icon(Icons.play_circle_fill_rounded,size: 50,
                    color: Colors.white,),
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                width: size.width/2,
                child: Text(title, maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ),
              Container(
                margin: EdgeInsets.all(15),
                width: size.width/2.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15,
                          right: 15,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                          color:Colors.red ),
                      child: Text(source,style: TextStyle(color: Colors.white),),
                    ),
                    Text(date,style: TextStyle(color: Colors.black),),
                  ],
                ),
              )
            ],
          )

        ],
      ),
    );
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Apicall.getnewsapidata();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
            children: [

              //horizontal list data
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                  // horizontalitem(size, String title, url, date){
                    horizontalitem(size,
                        "Happy Dashain",
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                        "05, FEB 2026"),
                    horizontalitem(size,
                        "Happy tihar",
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                        "02, FEB 2026"),
                    horizontalitem(size,
                        "Happy chatt",
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                        "09, FEB 2026"),
                  ],
                ),
              ),

              //vertical list data
              Container(
                height: size.height/1.65,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                    verticalllistitem(size,
                        "PCPS DASHAIN FEST",
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                        "02 FEB 2026", "PCPS NEWS"),
                      verticalllistitem(size,
                          "PCPS DASHAIN FEST",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                          "02 FEB 2026", "PCPS NEWS"),
                      verticalllistitem(size,
                          "PCPS DASHAIN FEST",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                          "02 FEB 2026", "PCPS NEWS"),
                      verticalllistitem(size,
                          "PCPS DASHAIN FEST",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                          "02 FEB 2026", "PCPS NEWS")

                    ],
                  ),
                ),
              )

            ],
          ),
      ),
    );
  }
}
