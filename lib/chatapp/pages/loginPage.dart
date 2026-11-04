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

          Stack(
            children: [
              Container(
                height: size.height/1.6,
                  width: size.width,
                  child: Image.network(
                    fit: BoxFit.cover,
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7TWU1OpSO_J38hCm2Zp1duR-khopG3-wyLqOHCaN92Q&s=10")),
              Positioned(
                bottom: -20,
                child: Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Kurafy",style: TextStyle(
                        color: Color(0xff03518D),fontSize: 80,
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
