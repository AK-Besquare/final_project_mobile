// ignore_for_file: file_names
import 'package:flutter/material.dart';

class Avoji extends StatelessWidget {
  const Avoji({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Column(
        
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Image.network('https://somaliupdate.com/wp-content/uploads/2021/08/vadivelu-4.png'),
        SizedBox(height: 30,),
        Text('Vanakam, Vanthanam, Namaste, Namoshkar!!!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        SizedBox(height: 30,),Text('Avoji! Avoji!! Avoji!!!', style: TextStyle(fontSize: 22)), 
        SizedBox(height: 30,),Text('Apediyea Pongoji! Pongoji!! Pongoji!!!', style: TextStyle(fontSize: 22),), 
        SizedBox(height: 126.5,),
        Image.network('https://i2.wp.com/www.ritzmagazine.in/wp-content/uploads/2019/10/Vadivelu.jpg?fit=624%2C351&ssl=1'),
        
      ],
      
      
      ),
      
    );
  }
}