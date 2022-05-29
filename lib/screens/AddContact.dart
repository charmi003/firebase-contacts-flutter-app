import '../db/CRUD_helper.dart';
import 'package:flutter/material.dart';
import '../model/Contact.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:path/path.dart';



class AddContact extends StatefulWidget {
  const AddContact({ Key? key }) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final _formKey= GlobalKey<FormState>();
  String firstName='';
  String lastName='';
  String phone='';
  String email='';
  String address='';
  String photoUrl='empty';

  File? tempImgFile;
  String? tempFileName;

  bool isLoading=false;

  onChangedFirstName(input) { setState(()=>firstName=input); }
  onChangedLastName(input) { setState(()=>lastName=input);  }
  onChangedPhone(input) { setState(()=>phone=input); }
  onChangedEmail(input) { setState(()=>email=input); }
  onChangedAddress(input) { setState(()=>address=input); }

  saveContact(BuildContext context) async{
    final isValid=_formKey.currentState!.validate();
    if(isValid){
      setState(() {
        isLoading=true;
      });

      //upload photo to firebase storage
      if(tempImgFile!=null) {
        await uploadImage(tempImgFile!, tempFileName!);
      }

      //insert new contact to firestore
      Contact contact=Contact(firstName: firstName, lastName: lastName, phone: phone, email: email, address: address, photoUrl: photoUrl);
      await createContact(context, contact);
      Navigator.of(context).pop();
    }
  }

  Future pickImage() async{
    var image=await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    File imgFile=File(image!.path);
    String fileName=basename(imgFile.path);

    setState(() {
      tempImgFile=imgFile;
      tempFileName=fileName;
    });
  }


  uploadImage(File imgFile,String fileName) async{
    final storageRef=FirebaseStorage.instance.ref().child(fileName);
    UploadTask? uploadTask=storageRef.putFile(imgFile);

    final snapShot=await uploadTask.whenComplete(() => null);

    final urlDownload=await snapShot.ref.getDownloadURL();
    print(urlDownload);

    setState(() {
      photoUrl=urlDownload;
    });
  }


  @override
  Widget build(BuildContext context) {

    final img;
    if(tempImgFile==null){
      img=AssetImage('assets/dummy_person.jpg');
    }
    else{
      img=FileImage(tempImgFile!);
    }

    return Scaffold(
      appBar: AppBar(
        title:Text('Add Contact'),
      ),
      body:isLoading
      ? Center(child:CircularProgressIndicator())
      : SingleChildScrollView(
        child: Center(
          child:Column(
            children:[
              SizedBox(height:10),
              Container(
                height:120,
                width:120,
                decoration: BoxDecoration(
                  shape:BoxShape.circle,
                  image: DecorationImage(
                    image:img,
                    fit: BoxFit.contain
                  )
                )
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Change Photo')
              ),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          )
                        ),
                        validator: (input){
                          if(input!=null && input.isEmpty)
                            return 'This field is required';
                        },
                        onChanged:onChangedFirstName
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          )
                        ),
                        validator: (input){
                          if(input!=null && input.isEmpty)
                            return 'This field is required';
                        },
                        onChanged:onChangedLastName
                      ),
                      SizedBox(height:10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          )
                        ),
                        validator: (input){
                          if(input!=null && input.isEmpty)
                            return 'This field is required';
                        },
                        keyboardType: TextInputType.phone,
                        onChanged:onChangedPhone
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          )
                        ),
                        validator: (input){
                          if(input!=null && input.isEmpty)
                            return 'This field is required';
                        },
                        onChanged:onChangedEmail
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                          )
                        ),
                        validator: (input){
                          if(input!=null && input.isEmpty)
                            return 'This field is required';
                        },
                        onChanged:onChangedAddress
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: (){
                          saveContact(context);
                        },
                        child: Text('Save Contact', style:TextStyle(fontSize:20)),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30,vertical: 12)),
                          backgroundColor: MaterialStateProperty.all(Colors.pink),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
          )
        ),
      )

      
    );
  }
}