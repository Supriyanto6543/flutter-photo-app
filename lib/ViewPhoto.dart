import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewPhoto extends StatefulWidget {
  @override
  _ViewPhotoState createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {

  Future viewPhoto() async{
    var url = "http://192.168.43.183/flutter_app/view.php";
    var response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewPhoto();
  }

  @override
  Widget build(BuildContext context) {

    List list;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Photo'),
      ),
      body: FutureBuilder(
        future: viewPhoto(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasError){
            print("error in here");
          }
          return snapshot.hasData ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data.length,
              itemBuilder: (_, index){
                list = snapshot.data;
                return Container(
                  margin: EdgeInsets.only(top: 7, bottom: 7, right: 9, left: 9),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                        'http://192.168.43.183/flutter_app/upload/${list[index]['image']}',
                      fit: BoxFit.cover,),
                  ),
                );
              }) : Container();
        },
      ),
    );
  }
}
