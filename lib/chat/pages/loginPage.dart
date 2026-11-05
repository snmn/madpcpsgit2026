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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
            children: [
                Container(
                height: size.height/1.5,
                width: size.width,
                child: Image.network(
                  fit: BoxFit.fitWidth,
                  "https://img.magnific.com/free-vector/messaging-application-abstract-concept-illustration_335657-3870.jpg?semt=ais_hybrid&w=740&q=80"
                ),
              ),
                Positioned(
                  bottom: -5,
                  child: Container(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("eGUFF",
                        style: TextStyle(
                          color: Color(0xffCD86E4),
                          fontSize: 70,fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ),
                ),
            ],
          ),
            Container(
            width: size.width/1.1,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color(0xffEAEDF6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(" Email: "),
                Container(
                  width: size.width/1.8,
                  child: TextField(

                    decoration: InputDecoration(
                      hint: Text("abc@gmail.com"),
                      border: InputBorder.none
                    ),
                  ),
                )
              ],
            ),
          ),
            Container(
              width: size.width/1.1,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0xffEAEDF6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(" Password: "),
                  Container(
                    width: size.width/1.8,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          hint: Text("keep it a secret"),
                          border: InputBorder.none
                      ),
                    ),
                  ),

                ],
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
                padding: EdgeInsets.only(
                    left: 20,right: 20,
                    top: 12,bottom: 12
                ),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Text("Login".toUpperCase(),
                style: TextStyle(color: Colors.white,
                fontSize: 14,fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("forget password? "),
                Text("Register Now")
              ],
            )
          ],
        ),
      ),
    );
  }
}
