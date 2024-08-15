import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/response/trip_get_res.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/trippage.dart';
import 'package:http/http.dart' as http;

class ShowtripPage extends StatefulWidget {
  int idx = 0;
  ShowtripPage({super.key, required this.idx});

  @override
  State<ShowtripPage> createState() => _ShowtripPageState();
}

class _ShowtripPageState extends State<ShowtripPage> {
  List<TripsGetRespones> trips = [];

  // 3. Use loadDataAsync()
  late Future<void> loadData;

  String url = '';
  @override
  void initState() {
    // super.initState();
    // Configuration.getConfig().then((value) {
    //   log(value['apiEndpoint']);
    //   url = value['apiEndpoint'];
    // }).catchError((err) {
    //   log(err.toString());
    // });
    super.initState();
    // 4. Asssing loadData
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(idx: widget.idx),
                    ));
              } else if (value == 'logout') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('ปลายทาง'),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FilledButton(
                            onPressed: () => getTrips,
                            child: const Text('ทั้งหมด')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FilledButton(
                            onPressed: () => getTrips('เอเชียตะวันออกเฉียงใต้'),
                            child: const Text('เอเชียตะวันออกเฉียงใต้')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FilledButton(
                            onPressed: () => getTrips('ยุโรป'),
                            child: const Text('ยุโรป')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FilledButton(
                            onPressed: () => getTrips('ประเทศไทย'),
                            child: const Text('ประเทศไทย')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FilledButton(
                            onPressed: () => getTrips('เอเชีย'),
                            child: const Text('เอเชีย')),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      // 1. create FutureBuilder
                      FutureBuilder(
                          future: loadData,
                          builder: (context, snapshot) {
                            // ถ้ายังไม่เจอข้อมูลให้แสดงหมุนๆ รอการโหลด
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return Column(
                              children: trips
                                  .map((trip) => Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(trip.name,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Row(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8.0, 3.0, 8.0, 3.0),
                                                  child: SizedBox(
                                                    width: 150,
                                                    height: 150,
                                                    child: Image.network(
                                                        trip.coverimage),
                                                  )),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('ประเทศ${trip.country}', style: const TextStyle(fontSize: 12),),
                                                  Text(
                                                      'ระยะเวลา ${trip.duration} วัน', style: const TextStyle(fontSize: 12)),
                                                  Text(
                                                      'ราคา ${trip.price} บาท', style: const TextStyle(fontSize: 12)),
                                                  SizedBox(
                                                    width: 160,
                                                    height: 30,
                                                    child: FilledButton(
                                                        onPressed: () =>
                                                            goToTripPage(
                                                                trip.idx),
                                                        child: const Text(
                                                            'รายละเอียดเพิ่มเติม',
                                                            style: TextStyle(
                                                              fontSize: 11
                                                            ),)),
                                                  )
                                                ],
                                              )
                                            ])
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              // children: [
                              //   Card(
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         const Padding(
                              //           padding: EdgeInsets.all(8.0),
                              //           child: Text('อันซีนสวิตเซอร์แลนด์',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontSize: 16,
                              //                   fontWeight: FontWeight.bold)),
                              //         ),
                              //         Row(children: [
                              //           Padding(
                              //             padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                              //             child: SizedBox(
                              //                 width: 150,
                              //                 height: 150,
                              //                 child: Image.asset('assets/image/switzerland.jpg')),
                              //           ),
                              //           Column(
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               const Text('ประเทศสวิตเซอร์แลนด์'),
                              //               const Text('ระยะเวลา 10 วัน'),
                              //               const Text('ราคา 119900 บาท'),
                              //               FilledButton(onPressed: () {}, child: const Text('รายละเอียดเพิ่มเติม'))
                              //             ],
                              //           )
                              //         ])
                              //       ],
                              //     ),
                              //   ),
                              //   Card(
                              //     child: Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           const Padding(
                              //             padding: EdgeInsets.all(8.0),
                              //             child: Text('ชิบุยะ',
                              //                 style: TextStyle(
                              //                     color: Colors.black,
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.bold)),
                              //           ),
                              //           Row(children: [
                              //             Padding(
                              //               padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                              //               child: SizedBox(
                              //                   width: 150,
                              //                   height: 150,
                              //                   child: Image.asset('assets/image/md.jpg')),
                              //             ),
                              //             Column(
                              //               crossAxisAlignment: CrossAxisAlignment.start,
                              //               children: [
                              //                 const Text('ประเทศญี่ปุ่น'),
                              //                 const Text('ระยะเวลา 12 วัน'),
                              //                 const Text('ราคา 155200 บาท'),
                              //                 FilledButton(onPressed: () {}, child: const Text('รายละเอียดเพิ่มเติม'))
                              //               ],
                              //             )
                              //           ])
                              //         ],
                              //       ),
                              //   ),
                              //   Card(
                              //     child: Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           const Padding(
                              //             padding: EdgeInsets.all(8.0),
                              //             child: Text('ตลาดพลู (กรุงเทพมหานคร)',
                              //                 style: TextStyle(
                              //                     color: Colors.black,
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.bold)),
                              //           ),
                              //           Row(children: [
                              //             Padding(
                              //               padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                              //               child: SizedBox(
                              //                   width: 150,
                              //                   height: 150,
                              //                   child: Image.asset('assets/image/ky.jpg')),
                              //             ),
                              //             Column(
                              //               crossAxisAlignment: CrossAxisAlignment.start,
                              //               children: [
                              //                 const Text('ประเทศไทย'),
                              //                 const Text('ระยะเวลา 5 วัน'),
                              //                 const Text('ราคา 11200 บาท'),
                              //                 FilledButton(onPressed: () {}, child: const Text('รายละเอียดเพิ่มเติม'))
                              //               ],
                              //             )
                              //           ])
                              //         ],
                              //       ),
                              //   ),
                              //   Card(
                              //     child: Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           const Padding(
                              //             padding: EdgeInsets.all(8.0),
                              //             child: Text('ทะเลสาบสีชมพู Hiller Lake',
                              //                 style: TextStyle(
                              //                     color: Colors.black,
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.bold)),
                              //           ),
                              //           Row(children: [
                              //             Padding(
                              //               padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                              //               child: SizedBox(
                              //                   width: 150,
                              //                   height: 150,
                              //                   child: Image.asset('assets/image/md.jpg')),
                              //             ),
                              //             Column(
                              //               crossAxisAlignment: CrossAxisAlignment.start,
                              //               children: [
                              //                 const Text('ประเทศออสเตรเลีย'),
                              //                 const Text('ระยะเวลา 8 วัน'),
                              //                 const Text('ราคา 245200 บาท'),
                              //                 FilledButton(onPressed: () {}, child: const Text('รายละเอียดเพิ่มเติม'))
                              //               ],
                              //             )
                              //           ])
                              //         ],
                              //       ),
                              //   ),
                              //   Card(
                              //     child: Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           const Padding(
                              //             padding: EdgeInsets.all(8.0),
                              //             child: Text('Cinque Terre',
                              //                 style: TextStyle(
                              //                     color: Colors.black,
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.bold)),
                              //           ),
                              //           Row(children: [
                              //             Padding(
                              //               padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
                              //               child: SizedBox(
                              //                   width: 150,
                              //                   height: 150,
                              //                   child: Image.asset('assets/image/qvb.jpg')),
                              //             ),
                              //             Column(
                              //               crossAxisAlignment: CrossAxisAlignment.start,
                              //               children: [
                              //                 const Text('ประเทศอิตาลี'),
                              //                 const Text('ระยะเวลา 15 วัน'),
                              //                 const Text('ราคา 1074500 บาท'),
                              //                 FilledButton(onPressed: () {}, child: const Text('รายละเอียดเพิ่มเติม'))
                              //               ],
                              //             )
                              //           ])
                              //         ],
                              //       ),
                              //   )
                              // ],
                            );
                          }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // (async) Function for load data from api
  // 2.
  Future<void> loadDataAsync() async {
    //Get url endpoint from config
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    //Call api /trips
    var data = await http.get(Uri.parse("$url/trips"));
    trips = tripsGetResponesFromJson(data.body);
  }

  void getTrips(String? zone) {
    http.get(Uri.parse("$url/trips")).then((value) {
      log(value.body);
      trips = tripsGetResponesFromJson(value.body);
      List<TripsGetRespones> filteredTrips = [];
      if (zone != null) {
        for (var trip in trips) {
          if (trip.destinationZone == zone) {
            filteredTrips.add(trip);
          }
        }
        trips = filteredTrips;
      }
      setState(() {});
    }).catchError((err) {
      log(err.toString());
    });
  }

  goToTripPage(int idx) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripPage(idx: idx),
        ));
  }
}
