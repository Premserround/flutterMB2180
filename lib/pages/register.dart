import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/request/customer_regis_post_req.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var fullnameCt = TextEditingController();
  var phoneNoCt = TextEditingController();
  var emailCt = TextEditingController();
  var passwordCt = TextEditingController();
  var confirmpasswordCt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: Text('ชื่อ-นามสกุล', style: TextStyle(fontSize: 18)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: TextField(
                  controller: fullnameCt,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: 18)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: TextField(
                  controller: phoneNoCt,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('อีเมล', style: TextStyle(fontSize: 18)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: TextField(
                  controller: emailCt,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('รหัสผ่าน', style: TextStyle(fontSize: 18)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: TextField(
                  controller: passwordCt,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('ยืนยันรหัสผ่าน', style: TextStyle(fontSize: 18)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: TextField(
                  controller: confirmpasswordCt,
                  obscureText: true,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: FilledButton(
                      onPressed: () {
                        register(
                          fullnameCt.text,
                          phoneNoCt.text,
                          emailCt.text,
                          passwordCt.text,
                          confirmpasswordCt.text,
                        );
                      },
                      child: const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'หากมีบัญชีอยู่แล้ว',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register(
    String fullname,
    String phone,
    String email,
    String password,
    String confirmPassword,
  ) {
    CustomerRegisterPostRequest req = CustomerRegisterPostRequest(
      fullname: fullnameCt.text,
      phone: phoneNoCt.text,
      email: emailCt.text,
      image:
          'https://www.bangkokframe.com/image/cache/data/products/photos/FPAN/FPAN197-800x800.jpg',
      password: passwordCt.text,
      confirmPassword: confirmpasswordCt.text,
    );
    http
        .post(
          Uri.parse("http://192.168.0.247:3000/customers"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerRegisterPostRequestToJson(req),
        )
        .then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
