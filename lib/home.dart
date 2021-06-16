import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:photo_app/ViewPhoto.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController nameController = TextEditingController();
  File? _pickerImage = File("");
  final picker = ImagePicker();

  Future uploadImage() async{
    final url = Uri.parse("http://192.168.43.183/flutter_app/upload.php");
    var request = http.MultipartRequest('POST', url);
    request.fields['name'] = nameController.text;
    request.fields['id'] = 21.toString();
    var photo = await http.MultipartFile.fromPath("image", _pickerImage!.path);
    request.files.add(photo);
    var response = await request.send();
    if(response.statusCode == 200){
      print("the photo store to database");
      setState(() {
        nameController.text = "";
        _pickerImage = File("");
      });
    }else{
      print("any error");
    }
  }

  Future chooseImage() async{
    final imgSoruce = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Choose photo"),
          actions: [
            MaterialButton(
              child: Text("Camera"),
              onPressed: (){
                Navigator.pop(context, ImageSource.camera);
              },
            ),
            MaterialButton(
              child: Text('Gallery'),
              onPressed: (){
                Navigator.pop(context, ImageSource.gallery);
              })
          ],
        )
    );
    if(imgSoruce != null){
      final files = await ImagePicker.platform.pickImage(source: imgSoruce);
      if(files != null){
        setState(() {
          _pickerImage = File(files.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Photo App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: _pickerImage!.path == "" ? Text('Nothing image ') : CircleAvatar(
                radius: 112,
                backgroundColor: Colors.green,
                child: CircleAvatar(
                  radius: 110,
                  backgroundImage: FileImage(_pickerImage!),
                ),
              ),
            ),
            Center(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name', border: InputBorder.none),
              ),
            ),
            Center(
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue
                  ),
                  child: Text('Upload Image', style: TextStyle(color: Colors.white),)),
                onTap: (){
                  if(_pickerImage != null){
                    uploadImage();
                  }else{
                    print("Any error");
                  }
                },
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue
                  ),
                  child: Text("See all photo", style: TextStyle(color: Colors.white),)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPhoto()));
                },
              ),
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: chooseImage,
        child: Icon(Icons.add),
      ),
    );
  }
}
