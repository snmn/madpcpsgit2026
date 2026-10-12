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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //horizontal list
          Row(
            children: [
              Container(
                width: size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      horizontallistcard(
                          size,
                          "Hello PCPS news",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                          " 02 FEB 2026"),
                      horizontallistcard(
                          size,
                          "Happy Dashain Everyone",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                          " 04 FEB 2026"),
                      horizontallistcard(
                          size,
                          "Happy Dashain PCPS ",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                          " 04 FEB 2028"),
                    ],
                  ),
                ),
              )
            ],
          ),

          //vertical list
          Container(
            height: size.height/1.75,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  verticallistcard(
                      size,
                      "PCPS DASHAIN FEST",
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                      "02 FEB 2026",
                      "PCPS"
                  ),
                  verticallistcard(
                      size,
                      "PCPS DASHAIN FEST",
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                      "02 FEB 2026",
                      "PCPS"
                  ),
                  verticallistcard(
                      size,
                      "PCPS DASHAIN FEST",
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                      "02 FEB 2026",
                      "PCPS"
                  ),
                  verticallistcard(
                      size,
                      "PCPS DASHAIN FEST",
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                      "02 FEB 2026",
                      "PCPS"
                  ),
                  verticallistcard(
                      size,
                      "PCPS DASHAIN FEST",
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                      "02 FEB 2026",
                      "PCPS"
                  ),
                  verticallistcard(
                      size,
                      "PCPS DASHAIN FEST",
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                      "02 FEB 2026",
                      "PCPS"
                  ),verticallistcard(
                      size,
                      "PCPS DASHAIN FEST",
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                      "02 FEB 2026",
                      "PCPS"
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
