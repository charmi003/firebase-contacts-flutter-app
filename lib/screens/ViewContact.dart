import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/Contact.dart';
import 'EditContact.dart';
import '../db/CRUD_helper.dart';

class ViewContact extends StatefulWidget {
  final String contactId;
  const ViewContact({ Key? key, required this.contactId }) : super(key: key);

  @override
  State<ViewContact> createState() => _ViewContactState(contactId: contactId);
}

class _ViewContactState extends State<ViewContact> {
  final String contactId;
  _ViewContactState({required this.contactId});

  late Contact contact;
  bool isLoading=false;

  callAction(String number) async{
    String url='tel://$number';
    await launchUrl(Uri.parse(url));
  }

  smsAction(String number) async{
    String url='sms://$number';
    await launchUrl(Uri.parse(url));
  }

  mailAction(String mailId) async{
    String url='mailto:<$mailId>';
    await launchUrl(Uri.parse(url));
  }

  fetchContact() async{
    setState(() {
      isLoading=true;
    });
    var tempContact=await getContactById(contactId);
    setState(() {
      contact=tempContact;
      isLoading=false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchContact();
  }

  getPreviewImage(){
    final img;
    if(contact.photoUrl=='empty')
      img=AssetImage('assets/dummy_person.jpg');
    else
      img=NetworkImage(contact.photoUrl);
    return img;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text('Contact Details'),
        actions: [editButton(),deleteButton()], 
      ),
      body:isLoading
      ? Center(child:CircularProgressIndicator())
      : bodyWidget()
    );
  }


  Widget bodyWidget() => ListView(
    children: <Widget>[
      // header text container
      Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: 120.0,
        width:120.0,
        decoration: BoxDecoration(
          shape:BoxShape.circle,
          image:DecorationImage(
            image: getPreviewImage(),
            fit: BoxFit.contain
          )
        ),
      ),
      Card(
        elevation: 2.0,
        child: Container(
          margin: EdgeInsets.all(20.0),
          width: double.maxFinite,
          child: Row(
            children: <Widget>[
              Icon(Icons.person),
              Container(
                width: 10.0,
              ),
              Text(
                "${contact.firstName} ${contact.lastName}",
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          )
        ),
      ),
      Card(
        elevation: 2.0,
        child: Container(
          margin: EdgeInsets.all(20.0),
          width: double.maxFinite,
          child: Row(
            children: <Widget>[
              Icon(Icons.phone),
              Container(
                width: 10.0,
              ),
              Text(
                contact.phone,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          )
        ),
      ),
      Card(
        elevation: 2.0,
        child: Container(
          margin: EdgeInsets.all(20.0),
          width: double.maxFinite,
          child: Row(
            children: <Widget>[
              Icon(Icons.email),
              Container(
                width: 10.0,
              ),
              Text(
                contact.email,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          )
        ),
      ),
      Card(
        elevation: 2.0,
        child: Container(
          margin: EdgeInsets.all(20.0),
          width: double.maxFinite,
          child: Row(
            children: <Widget>[
              Icon(Icons.home),
              Container(
                width: 10.0,
              ),
              Text(
                contact.address,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          )
        ),
      ),
      Card(
        elevation: 2.0,
        child: Container(
          margin: EdgeInsets.all(20.0),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                iconSize: 30.0,
                icon: Icon(Icons.phone),
                color: Colors.pink,
                onPressed: () {
                  callAction(contact.phone);
                },
              ),
              IconButton(
                iconSize: 30.0,
                icon: Icon(Icons.message),
                color: Colors.pink,
                onPressed: () {
                  smsAction(contact.phone);
                },
              ),
              IconButton(
                iconSize: 30.0,
                icon: Icon(Icons.email),
                color: Colors.pink,
                onPressed: () {
                  mailAction(contact.email);
                },
              )
            ],
          )
        ),
      )
    ],
  );


  Widget editButton() => IconButton(
    onPressed: () async{ 
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>EditContact(contactId: contactId))
      );
      await fetchContact();
    },
    icon:Icon(Icons.edit)
  );


  Widget deleteButton() => IconButton(
    onPressed: () async{ 
      await deleteContact(context, contactId);
      Navigator.of(context).pop();
    },
    icon:Icon(Icons.delete)
  );

}



  