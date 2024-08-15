import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/response/trip_get_res.dart';
import 'package:flutter_application_1/model/response/trip_idx_get_res.dart';
import 'package:http/http.dart' as http;

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late TripsIdxGetRespones trips;
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    log(widget.idx.toString());
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trips.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(trips.country),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(trips.coverimage),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ราคา ${trips.price} บาท',style:const TextStyle(fontSize: 11),), 
                          Text('โซน${trips.destinationZone}',style: const TextStyle(fontSize: 11))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(trips.detail),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: FilledButton(
                          onPressed: () {},
                          child: const Text('จองเลย!!!!')),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> loadDataAsync() async {
    //Get url endpoint from config
    var value = await Configuration.getConfig();
    var url = value['apiEndpoint'];
    //Call api /trips
    var data = await http.get(Uri.parse("$url/trips/${widget.idx}"));
    trips = tripsIdxGetResponesFromJson(data.body);
  }
}
