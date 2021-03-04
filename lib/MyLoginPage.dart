import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/ListPage.dart';

class MyLoginpage extends StatefulWidget {

  @override
  _MyLoginpageState createState() => _MyLoginpageState();
}

class _MyLoginpageState extends State<MyLoginpage> {

  String token="";
  void ShowToast(username){
    Fluttertoast.showToast(msg: "Your Login is Successful, Welcome ${username}",
    toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white
    );
  }

LoggingFunction(username,password) async{
  var response = await http.post(
    "https://aodapi.eralpsoftware.net/login/apply",
    body: jsonEncode(
      {
        "username": username,
        "password": password,
      },
    ),
   headers: {
      "content-type": "application/json",
      'token':"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkhhcnVuIEhlc2FwY2kiLCJpZCI6MTIsImlhdCI6MTYxNDY4NTUxOSwiZXhwIjoxNjE0NzU3NTE5fQ.KAg12M5DCKD7GvQ1UjAQWgKRa4f03BFh73VyKnheRqE"
    },
  );

  print(response.body);
  print("TOKEN IS BELOW");
  token=jsonDecode(response.body)['token'];
  print(token);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);



  if(response.statusCode ==200){

   Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage()));
  }


}



  final TextEditingController UserNameController= new TextEditingController();
  final TextEditingController PasswordController= new TextEditingController();
  String MyUserName="harun11638@gmail.com";
  String MyPassword="123456";
  String MyToken="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkhhcnVuIEhlc2FwY2kiLCJpZCI6MTIsImlhdCI6MTYxNDY4NTUxOSwiZXhwIjoxNjE0NzU3NTE5fQ.KAg12M5DCKD7GvQ1UjAQWgKRa4f03BFh73VyKnheRqE";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
        centerTitle: true,

      ),
      body:

      Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    child: TextField(
                      controller: UserNameController,
                      decoration: InputDecoration(
                        labelText: 'Your Email'
                      ),

                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: PasswordController,
                      decoration: InputDecoration(
                        labelText: 'Your Password'
                      ),
                      obscureText: true,
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  RaisedButton(
                    padding: EdgeInsets.all(8),
                    textColor: Colors.white,
                    color: Colors.blue,
                    child:Text("Login"),
                    onPressed: () => LoggingFunction(UserNameController.text,PasswordController.text),

                  )


                ],
              ),
            )
          ],

        ),
      ),
    );
  }

}
