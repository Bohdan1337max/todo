import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.orange),
      home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  String input = "";

  createTodos() {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTodos").doc(input);

    Map<String, String> todos = {
      "todoTitle":input
    };

    documentReference.set(todos).whenComplete( (){
      print("$input created");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTodos").doc(item);
    

    documentReference.delete()
.whenComplete(() {
  print("$item deleted");
    });
  }



  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my todos"),
      ),

      floatingActionButton: FloatingActionButton(onPressed:
          () {
        showDialog(context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: 
                BorderRadius.circular(8)),
                title: Text("Add TodoList"),
                content: TextField(
                  onChanged: (String value) {
                    input = value;
                  },
                ),
                actions: <Widget>[
                  TextButton(onPressed: () {
                   createTodos();
                    Navigator.of(context).pop();
                  }, child: Text("Add"))
                ],
              );
            });
      } ,
        child: Icon(Icons.add, color: Colors.white,),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
      builder: (context,snapshots){
        return
          ListView.builder(
          shrinkWrap: true,
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (context,index) {
              DocumentSnapshot documentSnapshot = snapshots.data!.docs[index];
              return Dismissible(
                  key: Key(index.toString()),
                  child: Card(
                      elevation: 4 ,
                      margin: EdgeInsets.all(4),
                      shape: RoundedRectangleBorder(borderRadius:
                      BorderRadius.circular(8)),
                      child: ListTile(
                        title: Text(documentSnapshot["todoTitle"]),
                        trailing: IconButton(icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            deleteTodos(documentSnapshot["todoTitle"]);
                          },
                        ),
                      )
                  )
              );
            }
        );
      }

      )
    );
  }
}
