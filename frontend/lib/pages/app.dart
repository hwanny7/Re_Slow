// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:reslow/pages/frame.dart';
// import 'package:reslow/pages/home/home.dart';

// class App extends StatelessWidget {
//   const App({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text("firebase load fail"),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           return MainPage();
//         }
//         return CircularProgressIndicator();
//       },
//     );
//   }
// }
