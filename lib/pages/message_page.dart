import 'package:she/theme.dart';
import 'package:she/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../utils/utils.dart';

class MessagePage extends StatefulWidget {
  final String? user;
  const MessagePage({Key? key, this.user}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget chatInput() {
      return Container(
        width: MediaQuery.of(context).size.width - 30,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(75),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'enter your message...',
                ),
                style: subtitleTextStyle,
              ),
            ),
            Expanded(child: Icon(Icons.send))
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      floatingActionButton: chatInput(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(30))),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/group1.png',
                      height: 55,
                      width: 55,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      children: [
                        Text(
                          'Moba Analog',
                          style: titleTextStyle,
                        ),
                        Text(
                          '14,209 members',
                          style: subtitleTextStyle,
                        )
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.phone),
                      color: greenColor,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView(
              children: [
                recieverBubble("message"),
                senderBubble('hai, hello.. how are you'),
              ],
            ))
          ],
        ),
      ),
    );
  }

  recieverBubble(String message) => ChatBubble(
      imageUrl: 'assets/images/friend1.png', text: message, time: '11.22');
  senderBubble(String message) => Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 11,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(fontSize: 16, color: primaryColor),
                    ),
                    Text(
                      '22:08',
                      style: subtitleTextStyle.copyWith(color: primaryColor),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            // Image.asset(
            //   'assets/images/my.png',
            //   width: 40,
            //   height: 40,
            // ),
          ],
        ),
      );
}
