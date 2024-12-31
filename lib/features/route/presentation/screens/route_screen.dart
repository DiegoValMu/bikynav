import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Screen'),
      ),
      body: Center(
        child: Text('This is the Route Screen'),
      ),
    );
  }
}