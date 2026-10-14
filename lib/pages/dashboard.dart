import 'package:flutter/material.dart';
import 'detailpage.dart';
class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => dashboardState();
}

class dashboardState extends State<dashboard> {


  horizontallistitem(size, String title,url, date){
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
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20)
          ),
          height: size.height/4.5,
          width: size.width/1.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(fit: BoxFit.cover,
                url),
          ),
        ),
        Container(
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(20)
          ),
          height: size.height/4.5,
          width: size.width/1.5,
        ),
        Positioned(
          bottom: 45,
          left: 30,
          child: Container(
            width: size.width/2,
            child: Text(title,
              style: TextStyle(color: Colors.white,
                  fontSize: 14),maxLines: 2,overflow: TextOverflow.ellipsis,),
          ),
        ),
        Positioned(
          bottom: 25,
          left: 30,
          child: Container(
            width: size.width/2,
            child: Text(date,
              style: TextStyle(color: Colors.white,
                  fontSize: 14),maxLines: 1,overflow: TextOverflow.ellipsis,),
          ),
        ),
        Positioned(
          bottom: 25,
          right: 30,
          child: Container(
              child: Icon(Icons.play_circle_fill,
                color: Colors.white,size: 45,) ),
        )
      ],
    ),
  );
  }

  static verticallistitem(size, String title, url, date, source){
    return  Row(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20)
              ),
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(fit: BoxFit.cover,
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"),
              ),
            ),
            Positioned(top: 45,left: 45,child: Icon(Icons.play_circle_fill_rounded,
              color: Colors.white,size: 40,))
          ],
        ),
        Container(
          height: 85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width/1.6,
                child: Text(maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    "Happy Dashain 2026 PCPS Happy Dashain 2026 PCPS Happy Dashain 2026 PCPS Happy Dashain 2026 PCPS"),
              ),
              Row(
                children: [
                  Container(

                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    padding: EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                    child: Text("PCPS NEWS",
                      style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text("02 feb 2026"),

                ],
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
    return  Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //horizontal list
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
              horizontallistitem(
              size,
              "pcps dashain fest",
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10",
                  "02 02 2026"
              ),

                horizontallistitem(
                    size,
                    " dashain fest",
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10",
                    "02 02 2026"
                ),
                horizontallistitem(
                    size,
                    "pcps  fest",
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10",
                    "02 02 2026"
                ),
                horizontallistitem(
                    size,
                    "pcps dashain ",
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10",
                    "02 02 2026"
                ),
              ],
            ),
          ),

          //vertical list
          Container(
            height: size.height/1.6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                 verticallistitem(size,
                     "pcps dashain fest"
                     , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
                     , "02 02 2026"
                     , "PCPS"),
                  verticallistitem(size,
                      "pcps dashain fest"
                      , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
                      , "02 02 2026"
                      , "PCPS"),
                  verticallistitem(size,
                      "pcps dashain fest"
                      , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
                      , "02 02 2026"
                      , "PCPS"),
                  verticallistitem(size,
                      "pcps dashain fest"
                      , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
                      , "02 02 2026"
                      , "PCPS"),
                  verticallistitem(size,
                      "pcps dashain fest"
                      , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
                      , "02 02 2026"
                      , "PCPS"),
                  verticallistitem(size,
                      "pcps dashain fest"
                      , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
                      , "02 02 2026"
                      , "PCPS"),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
