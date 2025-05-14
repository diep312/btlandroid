import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chit_chat/src/app/constants/constants.dart';
import 'package:chit_chat/src/app/navigator/navigator.dart';
import 'package:chit_chat/src/app/pages/core/core_view.dart';
import 'package:chit_chat/src/app/widgets/k_dialog.dart';

class KAppBar extends StatelessWidget {
  final String header;
  final bool showNotification;
  final VoidCallback? onNotificationPressed;
  final bool showBack;
  final VoidCallback? onBack;
  const KAppBar({
    Key? key,
    required this.header,
    this.showNotification = true,
    this.onNotificationPressed,
    this.showBack = false,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;

    return Container(
      width: size.width,
      height: 70 + padding.top,
      color: Colors.white,
      padding: EdgeInsets.only(
        top: padding.top + 20,
        left: 20,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBack)
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF23272F)),
                onPressed: onBack,
              ),
            ),
          Expanded(
            child: Text(
              header,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Montserrat',
                letterSpacing: -1.5,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          if (showNotification)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF1F4FB),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.notifications_none_rounded,
                      color: Color(0xFF23272F)),
                  onPressed: onNotificationPressed,
                ),
              ),
            )
          else
            const SizedBox(width: 56), // For symmetry if no notification
        ],
      ),
    );
  }
}
