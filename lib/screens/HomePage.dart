import '../model/Contact.dart';
import 'package:flutter/material.dart';
import 'AddContact.dart';
import 'ViewContact.dart';
import '../db/CRUD_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/ContactCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts=[];
  bool isLoading=true;

  final Stream<QuerySnapshot> _contactsStream = FirebaseFirestore.instance.collection('contacts').snapshots();


  void navigateToAddPage() async{
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>AddContact())
    );
  }

  void navigateToViewPage(String contactId) async{
     await Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>ViewContact(contactId: contactId,))
    );
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
    stream: _contactsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      
      if (snapshot.hasError) {
        return Scaffold(
          appBar: AppBar(
            title:Text('Contacts')
          ),
          body:Center(child:Text('Something went wrong!')),
          floatingActionButton: FloatingActionButton(
            child:Icon(Icons.add),
            onPressed: (){
              navigateToAddPage();
            },
          ),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(
          appBar: AppBar(
            title:Text('Contacts')
          ),
          body:Center(child:CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
            child:Icon(Icons.add),
            onPressed: (){
              navigateToAddPage();
            },
          ),
        );
      }

      contacts=snapshot.data!.docs.map((DocumentSnapshot document){
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        data['id']=document.id;
        Contact contact=Contact.fromJson(data);
        return contact;
      }).toList();

      contacts.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

      return Scaffold(
        appBar: AppBar(
          title:Text('Contacts')
        ),
        body: ListView(
          children: contacts.map((Contact contact) {
            return GestureDetector(
             onTap:(){navigateToViewPage(contact.id!);},
             child: ContactCard(contact: contact)
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add),
          onPressed: (){
            navigateToAddPage();
          },
        ),
      );
    },
    );
  }
}