import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createSate() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> allTasks = [];
  String filterStatus = 'All';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
