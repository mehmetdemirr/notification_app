import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_deneme/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: Column(
        children: [
          const Text(""),
          // Bildirim denemeleri
          IconButton(
            onPressed: () async {
              // NotificationService().showNotification(
              //   id: 1,
              //   title: "mehmet",
              //   body: "body",
              //   payLoad: "payload",
              // );
              // NotificationService().showSheduleNotification(
              //   id: 1,
              //   title: "mehmet",
              //   body: "body",
              //   payLoad: "payload",
              //   sheduleTime: DateTime.now().add(
              //     const Duration(seconds: 4),
              //   ),
              // );

              //başlangıç saati ve bitiş saati arası alınır
              for (int i = 18; i <= 18; i++) {
                for (int j = 0; j < 60; j = j + 2) {
                  await NotificationService().showSheduleDailyNotification(
                    id: int.parse("$i$j"),
                    body: 'mesaj',
                    payLoad: 'payload',
                    sheduleTime: Time(i, j),
                    title: 'başlık',
                    finishTime: DateTime(2024),
                  );
                }
              }

              // Bildirim gönderme kodunu buraya yazın
              // await NotificationService().showSheduleMinuteNotification(
              //   id: 1,
              //   body: 'mesaj',
              //   payLoad: 'payload',
              //   title: 'başlık',
              //   finishTime: DateTime(2030),
              //   sheduleTime: const Time(3, 3),
              // );

              // NotificationService().showSheduleWeeklyNotification(
              //   id: 2,
              //   body: 'mesaj',
              //   payLoad: 'payload',
              //   sheduleTime: const Time(00, 00),
              //   title: 'başlık',
              //   days: [7, 6, 5, 1],
              //   finishTime: const Time(00, 00),
              // );
              if (kDebugMode) {
                //print(await NotificationService().activeNotifications());
                var list = await NotificationService().pendingNotifications();
                print("Toplam bildirim:${list.length}");
              }
            },
            icon: const Icon(Icons.abc),
          ),
          IconButton(
              onPressed: () async {
                if (kDebugMode) {
                  //print(await NotificationService().activeNotifications());
                  var list = await NotificationService().pendingNotifications();
                  print("Toplam bildirim:${list.length}");
                }
              },
              icon: const Icon(Icons.shower)),
          IconButton(
            onPressed: () async {
              await NotificationService().allDeleteNotification();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
