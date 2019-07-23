import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> _getUsers() async {

  var data = await http.get("https://next.json-generator.com/api/json/get/EJThB3CWP");
  var jsonData = json.decode(data.body);
  List<User> users = [];
  for (var u in jsonData){
    User user = User (u["index"], u["about"], u["email"], u["company"], u["picture"]);

    users.add(user);
  }
  print(users.length);
  return users;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
          body: Container(
            child: FutureBuilder(
            future: _getUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot){

              if (snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("Loading...")
                  )
                );
              }else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data[index].picture
                        ),
                      ),
                      title: Text(snapshot.data[index].company),
                      subtitle: Text(snapshot.data[index].email),
                    );
                  },
                );
              }
              },
            ),
    ),
    );
  }
}

class User {
  final int index;
  final String about;
  final String email;
  final String company;
  final String picture;

  User (this.index, this.about , this.email, this.company, this.picture);

}
