import 'dart:convert';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she/models/person.dart';
import 'package:she/pages/message_page.dart';
import 'package:she/theme.dart';
import 'package:she/utils/network_service.dart';
import 'package:she/utils/utils.dart';
import 'package:she/widgets/blue.dart';
import 'package:she/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import '../utils/constant.dart';
import '../widgets/my_camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BluetoothController bluetoothController = BluetoothController();

  var visible2 = false;
  var locationData = "";
  @override
  void initState() {
    getMyLocation().listen((event) {
      locationData =
          "https://www.google.com/maps/@${event.latitude},${event.longitude},12z";
    });
    super.initState();
  }

  List<Person> numbers = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: blueColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: greenColor,
          onPressed: () {
            setState(() {
              visible2 = !visible2;
            });
          },
          child: const Icon(
            Icons.bluetooth,
            size: 28,
          ),
        ),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 40,
              ),
              Visibility(
                visible: visible2,
                maintainState: true,
                child: BluetoothApp(
                    controller: bluetoothController,
                    onMessage: (message) {
                      sendSms(locationData, numbers);
                      show(message);
                      lockScreen();
                    }),
              ),
              Image.asset(
                'assets/images/female.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'She Secure',
                style: TextStyle(fontSize: 20, color: whiteColor),
              ),
              Text(
                'Always with you',
                style: TextStyle(fontSize: 16, color: mutedColor),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Friends',
                              style: titleTextStyle,
                            ),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        final name = TextEditingController(),
                                            mobile = TextEditingController();
                                        return AlertDialog(
                                          title: Text('Add new friend'),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: name,
                                                decoration: InputDecoration(
                                                    hintText: "Enter Name"),
                                              ),
                                              TextField(
                                                controller: mobile,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Enter phone number"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  addContact(
                                                      name.text, mobile.text);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("add"),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                icon: Icon(Icons.add)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            clearAll();
                          },
                          child: Text("clear"),
                        )
                      ],
                    ),
                    FutureBuilder(
                      future: getContacts(),
                      builder: (context, AsyncSnapshot<List<String>> snapshot) {
                        return Column(children: friends(snapshot.data!));
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Groups',
                      style: titleTextStyle,
                    ),
                    FutureBuilder(
                      future: getPolice(),
                      builder: (context,
                              AsyncSnapshot<Map<String, dynamic>> snapshot) =>
                          ChatTile(
                        imageUrl: 'assets/images/police.png',
                        name: 'police : ' +
                            (snapshot.hasData
                                ? snapshot.data!['name']
                                : "no data"),
                        text: snapshot.hasData
                            ? snapshot.data!['mobile']
                            : "no data",
                        click: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const MessagePage(),
                            ),
                          );
                        },
                        icon: Icons.rounded_corner,
                        isRead: true,
                      ),
                    ),
                    FutureBuilder(
                      future: getWomenCell(),
                      builder: (context,
                              AsyncSnapshot<Map<String, dynamic>> snapshot) =>
                          ChatTile(
                        imageUrl: 'assets/images/women.png',
                        name: 'women cell : ' +
                            (snapshot.hasData
                                ? snapshot.data!['name']
                                : "no data"),
                        text: snapshot.hasData
                            ? snapshot.data!['mobile']
                            : "no data",
                        click: () {
                          // Navigator.push<void>(
                          //   context,
                          //   MaterialPageRoute<void>(
                          //     builder: (BuildContext context) =>
                          //         const MessagePage(),
                          //   ),
                          // );
                        },
                        icon: Icons.rounded_corner,
                        isRead: true,
                      ),
                    ),
                    FloatingActionButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraPage()),
                      );
                    })
                  ],
                ),
              )
            ]),
          ),
        )),
      ),
    );
  }

  List<Widget> friends(List<String> snapshot) {
    if (snapshot.length == 0) {
      return [
        const Center(
          child: Text("empty"),
        )
      ];
    }
    final persons = snapshot.map((e) => Person.fromJson(jsonDecode(e)));
    numbers = persons.toList();
    final widgets = persons
        .map((person) => ChatTile(
              imageUrl: 'assets/images/frnd.png',
              name: person.name!,
              text: person.mobile!,
              click: () {
                call(person.mobile!);
              },
              isRead: true,
            ))
        .toList();
    return widgets;
  }

  Future<Map<String, dynamic>> getPolice() async {
    final result = await getData("view_police.php");
    return result;
  }

  Future<Map<String, dynamic>> getWomenCell() async {
    final result = await getData("view_womencell.php");
    return result;
  }

  Future<List<String>> getContacts() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList('items') ?? [];
    return items;
  }

  logoutUser() {
    Route route = MaterialPageRoute(builder: (context) => HomePage());

    Constants.logout()
        .then((value) => Navigator.pushReplacement(context, route));
  }

  void addContact(String name, String mobile) async {
    String contact = jsonEncode(Person(name: name, mobile: mobile).toJson());
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final List<String> items = prefs.getStringList('items') ?? [];
    await prefs.setStringList('items', [contact, ...items]);
    setState(() {});
  }

  clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove('items');
    setState(() {});
  }

  void call(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void lockScreen() {
    screenLock(
      context: context,
      correctString: '1234',
      canCancel: false,
    );
  }
}
