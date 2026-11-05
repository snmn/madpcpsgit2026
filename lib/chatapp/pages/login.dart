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
            ),
            
            Container(
              width: size.width/1.1,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 20,right: 10,top: 5,bottom: 5),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                children: [
                  Text("Email: "),
                  Container(
                    width: size.width/1.8,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hint: Text("Enter your email here")
                      ),
              
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: size.width/1.1,
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.only(left: 20,right: 10,top: 5,bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                children: [
                  Text("Password: "),
                  Container(
                    width: size.width/1.8,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hint: Text("Enter your Password here")
                      ),

                    ),
                  )
                ],
              ),
            ),

            GestureDetector(
              onTap: (){
                // check firebase with email and password

                // if yes route to dashboard
                // if no show error msg
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => dashboard(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 20,
                right: 20,top: 15,bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Text("Login".toUpperCase(),
                  style: TextStyle(color: Colors.white),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Forget password? | "),
                Text("Register here")
              ],
            )

          ],
        ),
      ),
    );
  }
}
