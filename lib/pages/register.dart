
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/request/customer_login_post_req.dart';
import 'package:flutter_application_1/model/request/customer_post_register_req.dart';
import 'package:flutter_application_1/model/request/customer_regis_post_req.dart';
import 'package:flutter_application_1/model/response/customer_login_post_res.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config/config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String text = '', url = '';
  int num = 0;
  TextEditingController nameNoCtl = TextEditingController();
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController emailNoCtl = TextEditingController();
  TextEditingController passNoCtl = TextEditingController();
  TextEditingController conpassNoctl = TextEditingController();


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
        appBar: AppBar(
          title: const Text('ลงทะเบียนสมาชิกใหม่'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  //ชื่อ-นามสกุล
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 240, 0),
                    child: Text(
                      'ชื่อ-นามสกุล',
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                          controller: nameNoCtl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))))),

                  // หมายเลขโทรศัพท์
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 170, 0),
                    child: Text(
                      'หมายเลขโทรศัพท์',
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                          controller: phoneNoCtl,
                          // onChanged: (value) {
                          //  phoneNo = value;
                          // },
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))))),

                  // อีเมล์
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 270, 0),
                    child: Text(
                      'อีเมล์',
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                          controller: emailNoCtl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))))),

                  // รหัสผ่าน
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 250, 0),
                    child: Text(
                      'รหัสผ่าน',
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                          controller: passNoCtl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))))),

                  // ยืนยันรหัสผ่าน
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 200, 0),
                    child: Text(
                      'ยืนยันรหัสผ่าน',
                    ),
                  ),
                   Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: conpassNoctl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1))))),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0), // Adjust the value to move the button down
                  child: FilledButton(
                    onPressed: login,
                    child: const Text('สมัครสมาชิก'),
                  ),
                ),
              ]),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        register();
                      },
                      child: const Text(
                        'หากมีบัญชีอยู่แล้ว?',
                        style: TextStyle(color: Colors.black),
                      )),
                  TextButton(
                      onPressed: () {
                        register();
                      },
                      child: const Text('ลงทะเบียนใหม่')),
                  // FilledButton(
                  //     onPressed: login, child: const Text('เข้าสู่ระบบ')),
                ],
              ),
              // Text(text),
              // Text(text1)
            ],
          ),
        ));
  }

  void register() {
    // log("This is Register button");
    // setState(() {
    //   text1 = 'Hello World!!!';
    // });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }

  void login() {
    // Call login api
    if( passNoCtl.text == conpassNoctl.text &&
    nameNoCtl.text.isNotEmpty &&
    phoneNoCtl.text.isNotEmpty &&
    emailNoCtl.text.isNotEmpty &&
    passNoCtl.text.isNotEmpty &&
    conpassNoctl.text.isNotEmpty){
      var req = CustomerPostRegisterReq(
        fullname: nameNoCtl.text,
        phone: phoneNoCtl.text,
        email: emailNoCtl.text,
        image: "http://202.28.34.197:8888/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png",
        password: passNoCtl.text);

    http
        .post(Uri.parse("$url/customers"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            // Send json string of object model
            body: customerPostRegisterReqToJson(req))
        .then(
      (value) {
        // Convert Json String to Object (Model)
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));

        CustomersRegisterPostRequest customer = customersRegisterPostRequestFromJson(value.body);

        log(customer.email);
        
        // Convert Json String to Map<String, String
        // var jsonRes = jsonDecode(value.body);
        // log(jsonRes['customer']['email']);
      },
    ).catchError((eee) {
      log(eee.toString());
    });
    }
    
    // setState(() {
    //   num++;
    //   text = 'Login time: $num';
    // });
    //   log(phoneNoCtl.text);
    //   // log(phoneNo);
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const ShowtripPage(),
    //       ));
  }

}




