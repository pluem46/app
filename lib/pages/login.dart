// import 'dart:math';

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/model/request/customer_login_post_req.dart';
import 'package:flutter_application_1/model/response/customer_login_post_res.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int num = 0;
  String url = '';
  String phonenumber = '';
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  // initState ฟังก์ชัน ที่ทำงานเมื่อเปิดหน้านี้
  //1. initState จะทำงานครั้งเดียวเมื่อเปิดหน้านี้
  //2. จะไม่ทำงานเมื่อเราเรียก setstate
  //3. ไม่สามารถทำงานเป็น async ได้
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Configuration.getConfig().then((value) {
      log(value['apiEndpoint']);
      url = value['apiEndpoint'];
    }).catchError((err) {
      log(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    log("onDoubleTap is fired");
                  },
                  child: Image.asset('assets/image/logo.jpg')),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 50, 0),
                    child: Text(
                      'หมายเลขโทรศัพท์',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  // onChanged: (value) {
                  //   log(value);
                  //   phonenumber = value;
                  // },
                  controller: phoneCtl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1))),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 50, 0),
                    child: Text(
                      'รหัสผ่าน',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: passwordCtl,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: TextButton(
                        onPressed: register,
                        child: const Text('ลงทะเบียนใหม่')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 20),
                    child: FilledButton(
                        onPressed: login, child: const Text('เข้าสู่ระบบ')),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            ],
          ),
        ));
  }

  void login() {
    // log('This is Login');
    // setState(() {
    //   num = num + 1;
    //   text = 'Login time : $num';
    // });
    // log(phoneCtl.text);
    // log(passwordCtl.text);
    // if (phoneCtl.text == '0812345678' && passwordCtl.text == '1234') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => const ShowtripPage()),
    //   );
    // } else {
    //   setState(() {
    //     text = 'If phone no or password incorrect';
    //   });
    // }
    //var data = {"phone": phoneCtl.text, "password": passwordCtl.text};
    var data = {"phone": "0817399999", "password": "1111"};
    CustomerLoginPostRequest req =
        CustomerLoginPostRequest(phone: phoneCtl.text , password: passwordCtl.text );
    http
        .post(Uri.parse("$url/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerLoginPostRequestToJson(req))
        .then(
      (value) {
        log(value.body);
        CustomerLoginPostResponse customer = customerLoginPostResponseFromJson(value.body);
        log(customer.customer.fullname);
        log(customer.customer.email);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowtripPage(idx: customer.customer.idx),
            ));
      },
    ).catchError((error) {
      log('Error $error');
    });
  }

  void register() {
    // log('This is register');
    // setState(() {
    //   text = 'Hello World!!!';
    // });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}
