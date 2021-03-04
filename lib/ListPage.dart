import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:todoapp/data/fetch.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/profile.dart';

class ListPage extends StatefulWidget {

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {


  TextEditingController ListController= new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    getTodoList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Todo Screen"),
        actions: [
          GestureDetector(
              child: Icon(Icons.account_circle),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 50.0),

          )
        ],
      ),
      body:

      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple,Colors.blue,Colors.red]
          )
        ),
        child: FutureBuilder(builder: (context, snapshot) {
          if (snapshot.data != null) {
            List<Todo> todoList = snapshot.data;
            print("lenght");
            print(todoList.length);

            return ListView.builder(itemBuilder: (_, position) {
              return ListTile(
                title: Text(todoList[position].name, style: TextStyle(color: Colors.white),),
                subtitle: Text(todoList[position].date,style: TextStyle(color: Colors.white),),

                trailing: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.edit), onPressed: () {
                          showUpdateDialog(todoList[position]);
                        }),
                        IconButton(icon: Icon(Icons.delete, color: Colors.green,), onPressed: () {
                          deleteTodo(todoList[position].id);
                        }),

                      ],
                    ),

                  ],
                ),
              );
            },
              itemCount: todoList.length,
            );

          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
          future: getTodoList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        AddingDialogShow();
      },
        child: Icon(Icons.add),
      ),
    );
  }
  Future <List<Todo>> getTodoList() async{

    List<Todo> todoList = [];

    Response response = await FetchingData.getTodoList();
    print("Code is ${response.statusCode}");
    print("Response is ${response.body}");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var results = body["body"];

      for (var todo in results) {
        todoList.add(Todo.fromJson(todo));
      }

    } else {
      print("harun");
    }

    return todoList;
  }

  void AddingDialogShow(){
    showDialog(context: context, builder: (_)=> AlertDialog(
      content: Container(
        width: double.maxFinite,
        child: TextField(
          controller: ListController,
          decoration: InputDecoration(
            labelText: "Enter a Todo task",
          ),
        ),
      ),
      actions: [
        FlatButton(onPressed: (){
          Navigator.pop(context);
          addTodo();
          setState(() {

          });
        },
        child: Text("Add")),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        },
        child: Text("Cancel")),
      ],
    )
    );
  }
  void addTodo(){
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      children: <Widget>[
        Text("Adding task"),
        CircularProgressIndicator(),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ),
      duration: Duration(minutes: 1),
    ));
    String date= DateTime.now().toIso8601String();
    Todo task =Todo(name: ListController.text, date: date);
    FetchingData.addTodo(task).then((res){
      _scaffoldKey.currentState.hideCurrentSnackBar();
      Response response =res;
      if(response.statusCode==201){
        ListController.text ="";
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Your Task is added"),
          duration: Duration(seconds: 2),
        ));
        setState(() {

        });
      }

    }
    );
  }
  void showUpdateDialog(Todo todo) {

    ListController.text = todo.name;

    showDialog(context: context,
        builder: (_) => AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: TextField(
              controller: ListController,
              decoration: InputDecoration(
                labelText: "Enter updated new task",
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(onPressed: () {
              Navigator.pop(context);
              todo.name = ListController.text;
              updateTodo(todo);
            }, child: Text("Update")),
            FlatButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("Cancel")),
          ],
        )
    );


  }
  void updateTodo(Todo todo) {

    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Updating todo"),
        CircularProgressIndicator(),
      ],
    ),
      duration: Duration(minutes: 1),
    ),);


    FetchingData.updateTodo(todo)
        .then((res) {

      _scaffoldKey.currentState.hideCurrentSnackBar();

      Response response = res;
      if (response.statusCode == 200) {
        //Successfully Deleted
        ListController.text = "";
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: (Text("Updated!"))));
        setState(() {

        });
      } else {
        //Handle error
        print("hata update de");
      }
    });


  }
  void deleteTodo(int objectId) {

    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Deleting todo"),
        CircularProgressIndicator(),
      ],
    ),
      duration: Duration(minutes: 1),
    ),);


    FetchingData.deleteTodo(objectId)
        .then((res) {

      _scaffoldKey.currentState.hideCurrentSnackBar();

      Response response = res;
      if (response.statusCode == 200) {
        //Successfully Deleted
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: (Text("Deleted!")),duration: Duration(seconds: 1),));
        setState(() {

        });
      } else {
        //Handle error
        print("hata delete de");
      }
    });

  }




}




