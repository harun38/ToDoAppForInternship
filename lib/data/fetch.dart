

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/model/todo.dart';

class FetchingData{
  static final String _baseUrl = "https://aodapi.eralpsoftware.net/";



  static getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('token');
    return stringValue;
  }

  static Future<Response> addTodo(Todo todo) async{
    String token=await getStringValuesSF();
    String url =_baseUrl + "todo";
    final response = await http.post(
      url,
      body: {
        "name":todo.name,
        "date":todo.date
      },
      headers: {
        "content-type": "application/x-www-form-urlencoded",
        "token": token, // token = Login işleminden dönen token
      },
    );
    return response;

  }
  static Future getTodoList() async{
    String token=await getStringValuesSF();
    final response = await http.get(
      "https://aodapi.eralpsoftware.net/todo",

      headers: {
        "content-type": "application/x-www-form-urlencoded",
        "token": token
      },
    );
    return response;

  }
  static Future updateTodo(Todo todo) async{
    String token=await getStringValuesSF();
    String Url = _baseUrl + "todo/${todo.id}";

    Response response = await put(Url, headers: {

      'content-type' : 'application/x-www-form-urlencoded',
      "token": token,

    },
      body: {
      "name":todo.name
      }

    );

    return response;
  }




  static deleteTodo(int objectId) async {
    String token=await getStringValuesSF();
    String Url = _baseUrl + "todo/$objectId";
    Response response = await delete(Url, headers: {

    'Content-Type' : 'application/x-www-form-urlencoded',
    "token":token ,

    }

    );
    return response;
  }


}