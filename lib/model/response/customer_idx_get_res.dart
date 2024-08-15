// To parse this JSON data, do
//
//     final customerOnegetRespone = customerOnegetResponeFromJson(jsonString);

import 'dart:convert';

CustomerOnegetRespone customerOnegetResponeFromJson(String str) => CustomerOnegetRespone.fromJson(json.decode(str));

String customerOnegetResponeToJson(CustomerOnegetRespone data) => json.encode(data.toJson());

class CustomerOnegetRespone {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    CustomerOnegetRespone({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory CustomerOnegetRespone.fromJson(Map<String, dynamic> json) => CustomerOnegetRespone(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}
