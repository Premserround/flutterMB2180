import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/config/internal.dart';
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
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Login Page')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(child: Image.asset('assets/image/ssss.jpg')),

              Padding(
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: Text('หมายเลขโทศัพท์', style: TextStyle(fontSize: 18)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: TextField(
                  controller: phoneNoCtl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('รหัสผ่าน', style: TextStyle(fontSize: 18)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: TextField(
                  controller: passwordCtl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: register,
                          child: const Text(
                            'ลงทะเบียนใหม่',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            login(phoneNoCtl.text, passwordCtl.text);
                          },
                          child: const Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 20, color: Colors.amber),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void login(String phone, String password) {
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );
    http
        .post(
          Uri.parse("$API_ENDPOINT/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          log(value.body);
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShowtripPage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
