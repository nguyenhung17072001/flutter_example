import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Firebase_Utils {
  static final Firebase_Utils instance = Firebase_Utils._getInstance();
  Firebase_Utils._getInstance();
  final _firebaseApp = Firebase.app();



  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Future setData (String urlRef, Map data)async {
    Completer completer = Completer();
    DatabaseReference ref = _database.ref(urlRef);
    try {
      await ref.set(data);
      
    } catch (e) {
      print(e);
      completer.completeError(e);
    }


  }


  Future readData(String urlRef)async {
    Completer completer = Completer();
    
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child(urlRef).get();
      //print(snapshot.value);
      completer.complete(snapshot.value);
          
     
      
    } catch(e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}