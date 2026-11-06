import 'package:demopcpsseca/pages/dashboard.dart';
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
      body: SingleChildScrollView(
        child: Column(
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
            ),

            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Colors.black12,
                borderRadius: BorderRadius.circular(20)
              ),
              width: size.width/1.2,
              child: TextField(
                decoration: InputDecoration(
                  hint: Text("Enter your email here"),
                  border: InputBorder.none
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20)
              ),
              width: size.width/1.2,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hint: Text("Enter your password here"),
                    border: InputBorder.none
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => dashboard(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.purple
                ),
                padding: EdgeInsets.only(left: 15,right: 15,top: 8,
                bottom: 8),
                child:
                Text(" Login ".toUpperCase(),
                style: TextStyle(color: Colors.white),),
              ),
            )

          ],
        ),
      ),
    );
  }
}
