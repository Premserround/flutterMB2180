import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/response/trip_get_res.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/trip.dart';
import 'package:http/http.dart' as http;

class ShowtripPage extends StatefulWidget {
  int cid = 0;
  ShowtripPage({super.key, required this.cid});

  @override
  State<ShowtripPage> createState() => _ShowtripPageState();
}

class _ShowtripPageState extends State<ShowtripPage> {
  String url = '';

  List<TripGetResponse> tripGetResponses = [];

  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Showtrip'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.popUntil(context, (route) => route.isFirst);
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
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ปลายทาง', style: TextStyle(fontSize: 16)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilledButton(
                        onPressed: () async {
                          await getTrips();
                          setState(() {});
                        },
                        child: Text('ทั้งหมด'),
                      ),
                      FilledButton(
                        onPressed: () async {
                          await getTrips();
                          List<TripGetResponse> asiaTrips = [];
                          for (var trip in tripGetResponses) {
                            if (trip.destinationZone == 'เอเชีย') {
                              asiaTrips.add(trip);
                            }
                          }
                          setState(() {
                            tripGetResponses = asiaTrips;
                          });
                        },
                        child: Text('เอเชีย'),
                      ),
                      FilledButton(
                        onPressed: () async {
                          await getTrips();
                          List<TripGetResponse> euroTrips = [];
                          for (var trip in tripGetResponses) {
                            if (trip.destinationZone == 'ยุโรป') {
                              euroTrips.add(trip);
                            }
                          }
                          setState(() {
                            tripGetResponses = euroTrips;
                          });
                        },
                        child: Text('ยุโรป'),
                      ),
                      FilledButton(
                        onPressed: () async {
                          await getTrips();
                          List<TripGetResponse> aseanTrips = [];
                          for (var trip in tripGetResponses) {
                            if (trip.destinationZone ==
                                'เอเชียตะวันออกเฉียงใต้') {
                              aseanTrips.add(trip);
                            }
                          }
                          setState(() {
                            tripGetResponses = aseanTrips;
                          });
                        },
                        child: Text('อาเซียน'),
                      ),
                      FilledButton(
                        onPressed: () async {
                          await getTrips();
                          List<TripGetResponse> thaiTrips = [];
                          for (var trip in tripGetResponses) {
                            if (trip.destinationZone == 'ประเทศไทย') {
                              thaiTrips.add(trip);
                            }
                          }
                          setState(() {
                            tripGetResponses = thaiTrips;
                          });
                        },
                        child: Text('ไทย'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: tripGetResponses.map((e) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${e.name}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    bottom: 10,
                                  ),
                                  child: Image.network(
                                    e.coverimage,
                                    errorBuilder: (context, error, stackTrace) {
                                      return SizedBox(width: 100, height: 100);
                                    },
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${e.country}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text('ระยะเวลา${e.duration} วัน'),
                                    Text('ราคา${e.price}'),

                                    FilledButton(
                                      onPressed: () => gotoTrip(e.idx),
                                      child: Text('รายละเอียดเพิ่มเติม'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void gotoTrip(int idex) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idex)),
    );
  }

  Future<void> getTrips() async {
    // http.get(Uri.parse('$url/trips')).then((value) {
    //   log(value.body);
    //   setState(() {
    //     tripGetResponses = tripGetResponseFromJson(value.body);
    //   });
    //   log(tripGetResponses.length.toString());
    // });

    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    tripGetResponses = tripGetResponseFromJson(res.body);
    log(tripGetResponses.length.toString());
  }
}
