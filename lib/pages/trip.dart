import 'dart:developer';

import 'package:flutter/material.dart';

class TripPage extends StatefulWidget {
  //รับค่าใส่เข้ามา
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  @override
  void initState() {
    super.initState();
    log(widget.idx.toString());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
