

import 'dart:convert';

List<Todo> todoFromJson(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));
String todoToJson(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Todo {
  int id;
  String name;
  String date;
  int UserId;
  bool isActive;


  Todo({

    this.name,
    this.date,
    this.id,

});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id:json["id"] as int,
    name: json["name"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id":id,
    "name": name,
    "date": date,
  };

}
