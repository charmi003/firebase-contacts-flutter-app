import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Contact.dart';
import 'package:flutter/material.dart';


final FirebaseFirestore fireStore=FirebaseFirestore.instance;
final CollectionReference mainCollection= fireStore.collection('contacts');

Future showSuccess(BuildContext context,String title,String message){
    return showDialog(context: context, builder: (BuildContext context){
      Future.delayed(Duration(milliseconds:800),()=>Navigator.of(context).pop());
      return AlertDialog(
        title: Text(title),
        content: Text(message,style:TextStyle(color: Colors.green.shade700)),
        shape: RoundedRectangleBorder(),
        backgroundColor: Colors.blueGrey.shade200,
      );
    });
}

Future showError(BuildContext context,String title,String message){
    return showDialog(context: context, builder: (BuildContext context){
      Future.delayed(Duration(milliseconds:800),()=>Navigator.of(context).pop());
      return AlertDialog(
        title: Text(title),
        content: Text(message,style:TextStyle(color: Colors.red.shade700)),
        shape: RoundedRectangleBorder(),
        backgroundColor: Colors.blueGrey.shade200,
      );
    });
} 

Future createContact(BuildContext context,Contact contact) async{
  var docRef= mainCollection.doc();
  var data=contact.toJson();

  await docRef
  .set(data)
  .then((value)=>showSuccess(context, 'Status', 'Contact Saved'))
  .catchError((e)=>showError(context, 'Status', e.message));
}

Future deleteContact(BuildContext context,String docId) async {
  DocumentReference docRef =mainCollection.doc(docId);

  await docRef
  .delete()
  .then((value) => showSuccess(context, 'Status', 'Contact Deleted'))
  .catchError((e) => showError(context, 'Status', e.message));
}


Future<Contact> getContactById(String docId) async{
  var snapShot=await mainCollection.doc(docId).get();
  var json=snapShot.data() as Map<String,dynamic>;
  return Contact.fromJson(json);
}



Future updateContact(BuildContext context,Contact contact) async{
  DocumentReference docRef =mainCollection.doc(contact.id);

  Map<String, dynamic> data =contact.toJson();

  await docRef
  .update(data)
  .then((value) => showSuccess(context, 'Status', 'Contact Updated'))
  .catchError((e) => showError(context, 'Status', e.message));
}

