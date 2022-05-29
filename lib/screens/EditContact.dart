import 'package:flutter/material.dart';
import '../model/Contact.dart';
import '../db/CRUD_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditContact extends StatefulWidget {
  final String contactId;
  const EditContact({ Key? key, required this.contactId }) : super(key: key);

  @override
  State<EditContact> createState() => _EditContactState(contactId: contactId);
}

class _EditContactState extends State<EditContact> {
  final String contactId;
  _EditContactState({required this.contactId});
  late Contact contactFetched;

  final _formKey= GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String phone;
  late String email;
  late String address;
  late String photoUrl;

  File? tempImgFile;
  String? tempFileName;

  bool isLoading=false;

  onChangedFirstName(input) { setState(()=>firstName=input); }
  onChangedLastName(input) { setState(()=>lastName=input);  }
  onChangedPhone(input) { setState(()=>phone=input); }
  onChangedEmail(input) { setState(()=>email=input); }
  onChangedAddress(input) { setState(()=>address=input); }

  fetchContact() async{
    setState(() {
      isLoading=true;
    });
    var res=await getContactById(contactId);
    setState(() {
      contactFetched=res;
      firstName=contactFetched.firstName;
      lastName=contactFetched.lastName;
      phone=contactFetched.phone;
      email=contactFetched.email;
      address=contactFetched.address;
      photoUrl=contactFetched.photoUrl;
      isLoading=false;
    });
  }

  @override
  void initState(){
    super.initState();
    fetchContact();
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

  
  update(BuildContext context) async{
    final isValid=_formKey.currentState!.validate();
    if(isValid){
      setState(() {
        isLoading=true;
      });

      //upload photo to firebase storage
      //upload only if a new photo is choosen
      if(tempImgFile!=null) {
        await uploadImage(tempImgFile!, tempFileName!);
      }

      //update contact
      final contact=Contact(id: contactId, firstName: firstName, lastName: lastName, phone: phone, email: email, address: address, photoUrl: photoUrl);
      await updateContact(context, contact);
      Navigator.of(context).pop();
    }
  }


  getPreviewImage(){
    final img;

    if(tempImgFile==null){
      //no new image choosen, therefore show the previous one
      if(contactFetched.photoUrl=='empty')
        img=AssetImage('assets/dummy_person.jpg');
      else
        img=NetworkImage(contactFetched.photoUrl);
    }
    else{
      img=FileImage(tempImgFile!);
    }

    return img;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text('Edit Contact'),
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
                    image:getPreviewImage(),
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
                        initialValue: firstName,
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
                        initialValue: lastName,
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
                        initialValue: phone,
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
                        initialValue: email,
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
                        initialValue: address,
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
                          update(context);
                        },
                        child: Text('Update Contact', style:TextStyle(fontSize:20)),
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