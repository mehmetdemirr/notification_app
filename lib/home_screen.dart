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
              NotificationService().showSheduleDailyNotification(
                id: 1,
                body: 'mesaj',
                payLoad: 'payload',
                sheduleTime: const Time(21, 33),
                title: 'başlık',
                finishTime: const Time(23, 10),
              );
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
                print(await NotificationService().activeNotifications());
                print(await NotificationService().pendingNotifications());
              }
            },
            icon: const Icon(Icons.abc),
          ),
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
