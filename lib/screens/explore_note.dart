import 'package:flutter/material.dart';

class ExploreNote extends StatelessWidget{
  //note data
  var data;
  ExploreNote({required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_rounded)),
      ),
      body: Padding(
        padding:  EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['title'],style: TextStyle(fontSize: 30),),
            SizedBox(height: 10,),
            Text(data['desc'],style: TextStyle(fontSize: 17),)
          ],
        ),
      ),
    );
  }
}