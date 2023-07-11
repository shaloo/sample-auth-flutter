import 'dart:convert';
import 'dart:math';

import 'package:arcana_auth_flutter/common.dart';
import 'package:arcana_sdk_example/strings.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:arcana_auth_flutter/arcana_sdk.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final auth = AuthProvider(
      clientId: "xar_dev_2cbfe3fc82840d8f4191935e1811b0c2e33619f8");
  TextEditingController heightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  String logs = '';
  String action = '';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    setState(() {
      logs = '';
    });
    auth.init(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Row(children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(
                      bottom: 13.0, top: 13.0, left: 13.0, right: 13.0),
                  child: Text(
                    "result: $logs",
                    // overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'Roboto',
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
            Row(children: [
              Container(
                  padding: const EdgeInsets.only(
                      bottom: 13.0, top: 13.0, left: 13.0, right: 13.0),
                  width: MediaQuery.of(context).size.width*0.8,
                child: Row(children: [Flexible(
                  child: Text(
                    "action: $action",
                    // overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'Roboto',
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )],
                ),
              ),
            ]),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        auth.loginWithSocial("google").then((_) {
                          action = "login_complete";
                          setState(() {});
                        });
                        logs = '';
                        action = 'login_google';
                        setState(() {});
                      },
                      child: Text("Login with google")),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          auth.showWallet();
                          logs = '';
                          action = 'show_wallet';
                          setState(() {});
                        },
                        child: Text(show))),
                SizedBox(width: 50),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          auth.hideWallet();
                          action = 'hide_wallet';
                        },
                        child: Text(hide))),
              ],
            ),
            Row(children: [
              // Expanded(
              //   child: ElevatedButton(
              //       onPressed: () async {
              //         // _arcanaSdkPlugin.request((Object? response) {
              //         //   logs=response;
              //         // });
              //       },
              //       child: Text('sendRequest')),
              // ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      auth.getUserInfo().then((info) {
                        debugPrint(info.address);
                        logs = info.toJSONString();
                        action = 'get_user_info';
                        setState(() {});
                      });
                    },
                    child: Text('Get User Info')),
              ),
              SizedBox(width: 50),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      auth.sendTransaction(params: {
                        "to": "0xE28F01Cf69f27Ee17e552bFDFB7ff301ca07e780",
                        "value": "0x9184e72a"
                      }).then((hash) {
                        debugPrint("hash: $hash");
                        logs = hash;
                        action = 'send_transaction';
                        setState(() {});
                      });
                    },
                    child: Text('Send Transaction')),
              )
            ]),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        auth.getAccount().then((account) {
                          debugPrint("account: $account");
                          logs = account;
                          action = 'get_account';
                          setState(() {});
                        });
                      },
                      child: Text('Get Account')),
                ),
                SizedBox(width: 50),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        auth.logout();
                        action = 'logout';
                      },
                      child: Text('Logout')),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: heightController,
                )),
                Expanded(
                    child: TextField(
                  controller: widthController,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
