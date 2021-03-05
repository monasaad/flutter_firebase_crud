import 'package:flutter/material.dart';
// Step A1: import the package and of course in yml file
import 'package:firebase_core/firebase_core.dart';

// Step B1: import the package and of course in yml file
import 'package:cloud_firestore/cloud_firestore.dart';

// Step B2: add this line of code
FirebaseFirestore firestore = FirebaseFirestore.instance;

// Step A2: add keyword async after the main()
Future<void> main() async {
  //Step A3: add this line of code to ru the main app even thought the main is async
  WidgetsFlutterBinding.ensureInitialized();

  //Step A4: add this line pf code
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
    home: Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('FireBase CRUD'),
        // backgroundColor: Colors.white,
      ),
      body: UserInformation(),
      //AddUser('Mona', 'eme', 20),
      // GetUserName('6ODvWvmOSTGWDMwJQ8NE'),
     ),
    ),
  );
}

CollectionReference users = FirebaseFirestore.instance.collection('users');

//Step A5: run the app to make sure everything works good
class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId, {String title});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Directionality(
              textDirection: TextDirection.ltr,
              child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Directionality(
              textDirection: TextDirection.ltr,
              child: Text("Name: ${data['fullName']} , Age: ${data['age']}"));
        }

        return Directionality(
            textDirection: TextDirection.ltr,
            child: Text("loading"));
      },
    );
  }
}

class UserInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // AddUser('nV0I8Yu8r3zDgYWaa9Br', 'emme', 10),
        AddUser(),
        StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return ListTile(
                      title: Text(document.data()['fullName']),
                      subtitle: Text(document.data()['company']),

                    );
                  }).toList(),
                );
          },
        ),
      ],
    );
  }
}

class AddUser extends StatelessWidget {
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

   String docId ;

  @override
  Widget build(BuildContext context) {

     addUser() {
      return users
          .add({
            'fullName': myController.text,
            'company': myController2.text,
            'age': myController3.text
          })
          .then((value) => docId = value.id)
          // ignore: return_of_invalid_type_from_catch_error
          .catchError((error) => print("Failed to add user: $error"));
    }
    // WriteBatch batch = FirebaseFirestore.instance.batch();
    // DocumentReference maryRef = FirebaseFirestore.instance.collection("users").doc("Mary");
    // batch.update(maryRef, "Anna", 20); //Update name and age
    updateUser() {
      return users
          .doc(docId)
          .update({'fullName': myController.text})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    deleteUser() {
      return users
          .doc(docId)
          .delete()
          .then((value) => print("User Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: addUser,
              child: Text("Add User",
              ),
            ),
            ElevatedButton(
              onPressed: updateUser,
              child: Text("Update User",
              ),
            ),
            ElevatedButton(
              onPressed: deleteUser,
              child: Text("Delete User",
              ),
            ),
          ],
        ),
        TextField(
          controller: myController,
          decoration: InputDecoration(
            labelText: 'name',
          )
        ),
        TextField(
            controller: myController2,
            decoration: InputDecoration(
              labelText: 'company',
            )
        ),
        TextField(
            controller: myController3,
            decoration: InputDecoration(
              labelText: 'age',
            )
        ),
        TextField(
            decoration: InputDecoration(
              labelText: docId,
            )
        ),
      ],
    );
  }
}



// To add text with variable to this:
// 1. wrap all the text with double quote " "
// 2. before the var add $ then wrap it with {}
// e.g: "hi ${document.data()['fullName']}"