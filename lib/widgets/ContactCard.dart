import 'package:flutter/material.dart';
import '../model/Contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  const ContactCard({ Key? key, required this.contact }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var img;
    if(contact.photoUrl=='empty')
      img=AssetImage('assets/dummy_person.jpg');
    else
      img=NetworkImage(contact.photoUrl);

    return Card(
      color:Colors.white,
      elevation: 2.0,
      child:Container(
        margin:EdgeInsets.all(10),
        child:Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape:BoxShape.circle,
                image:DecorationImage(
                  image: img,
                  fit: BoxFit.contain
                )
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${contact.firstName} ${contact.lastName}', style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                  SizedBox(height:5),
                  Text(contact.phone, style:TextStyle(color:Colors.grey.shade600))
                ],
              ),
            )
          ],
        )
      )
    );
  }
}