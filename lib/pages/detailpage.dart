import 'package:flutter/material.dart';
import 'dashboard.dart';
class detailpage extends StatefulWidget {
  const detailpage({super.key});

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
                     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"),
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
             child: Text("Happy Dashain Everyone "
                 .toUpperCase(),
             style: TextStyle(fontSize: 18),),
           ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Author Name"),
                Text("02 02 2026")
              ],
            ),
          ),
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: Text("Happy Dashain Everyone Happy Dashain EveryoneHappy Dashain EveryoneHappy Dashain Everyone ",
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

           dashboardState.verticallistitem(size,
               "pcps dashain fest"
               , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
               , "02 02 2026"
               , "PCPS"),
           dashboardState.verticallistitem(size,
               "pcps dashain fest"
               , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
               , "02 02 2026"
               , "PCPS"),
           dashboardState.verticallistitem(size,
               "pcps dashain fest"
               , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
               , "02 02 2026"
               , "PCPS"),
           dashboardState.verticallistitem(size,
               "pcps dashain fest"
               , "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYNBJaFUb3pMu0XkkBdNkmsaBuZoYsR78LNMLGEdLPig&s=10"
               , "02 02 2026"
               , "PCPS"),
         ],
       ),
     ),
    );
  }
}
