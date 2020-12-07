//This is the home page.

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home Page')),
        backgroundColor: Colors.blueGrey[900],
      ),
    );
  }
}
