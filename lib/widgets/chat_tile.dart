import 'package:flutter/material.dart';
import 'package:she/theme.dart';

class ChatTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String text;
  final Function() click;
  final bool isRead;
  final IconData icon;

  const ChatTile(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.text,
      required this.click,
      this.icon = Icons.call,
      this.isRead = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(children: [
        CircleAvatar(
          backgroundImage: AssetImage(
            imageUrl,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: titleTextStyle),
          Text(text,
              style: isRead
                  ? subtitleTextStyle
                  : subtitleTextStyle.copyWith(
                      color: primaryColor, fontWeight: FontWeight.w500)),
        ]),
        const Spacer(),
        IconButton(onPressed: click, icon: Icon(icon))
      ]),
    );
  }
}
