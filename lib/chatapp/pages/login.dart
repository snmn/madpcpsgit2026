import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40,),
          Stack(
            children: [
              Container(
                height: size.height/1.5,
                  width: size.width,
                  child: Image.network(
                      fit: BoxFit.cover,
                  "https://i.pinimg.com/1200x/b7/ee/20/b7ee20b6778a5603d57c7153646d2809.jpg")),
              Positioned(
                bottom: 0,
                child: Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("CONVO",style: TextStyle(
                        color: Colors.white,
                        fontSize: 70,
                        fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}
