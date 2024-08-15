// To parse this JSON data, do
//
//     final tripsIdxGetRespones = tripsIdxGetResponesFromJson(jsonString);

import 'dart:convert';

TripsIdxGetRespones tripsIdxGetResponesFromJson(String str) => TripsIdxGetRespones.fromJson(json.decode(str));

String tripsIdxGetResponesToJson(TripsIdxGetRespones data) => json.encode(data.toJson());

class TripsIdxGetRespones {
    int idx;
    String name;
    String country;
    String coverimage;
    String detail;
    int price;
    int duration;
    String destinationZone;

    TripsIdxGetRespones({
        required this.idx,
        required this.name,
        required this.country,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
        required this.destinationZone,
    });

    factory TripsIdxGetRespones.fromJson(Map<String, dynamic> json) => TripsIdxGetRespones(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
    };
}
