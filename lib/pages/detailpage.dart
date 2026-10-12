import 'package:demopcpsseca/pages/dashboard.dart';
import 'package:flutter/material.dart';

class detailpage extends StatefulWidget {
   detailpage({super.key});

  @override
  State<detailpage> createState() => _detailpageState();
}

class _detailpageState extends State<detailpage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10"),
                    ),
                    Container(
                      height: size.height/4,
                      width: size.width,
                      color: Colors.black26,
                      ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back,
                        size: 40,
                      color: Colors.white,),
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
                  child: Text("Happy dashain Everyone "
                      "sasdasdasddasdad gdgfd".toUpperCase()
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
                      Text("Author Name",style: TextStyle(fontSize: 18),),
                      Text("Date 2026 ",style: TextStyle(fontSize: 18),)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Happy dashain Everyone "
                      "sasdasdasddasdad gdgfd"
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
            dashboardState.verticallistcard(size,
                "PCPS DASHAIN FEST",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                "02 FEB 2026",
                "PCPS"),
            dashboardState.verticallistcard(size,
                "Happy Dashain",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                "date ", "pcps"),
            dashboardState.verticallistcard(size,
                "Happy Dashain",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                "date ", "pcps"),
            dashboardState.verticallistcard(size,
                "Happy Dashain",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjZEcP2NkJQgEzAbBaG49jkD5TOG9hI9VALB1a_-vXlQ&s=10",
                "date ", "pcps"),
          ],
        ),
      ),
    );
  }
}
