import 'package:flutter/material.dart';
import 'package:flutter_notification/screens/second_screen.dart';
import 'package:flutter_notification/services/local_notification_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final LocalNotificationService notificationService;

  @override
  void initState() {
    notificationService = LocalNotificationService();
    notificationService.init();
    onNotifClick();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  await notificationService.showNotification(
                      id: 0, title: "title", body: "body");
                },
                child: const Text("Local")),
            ElevatedButton(
                onPressed: () async {
                  await notificationService.showSchedoualNotification(
                      id: 0, title: "title", body: "body", second: 4);
                },
                child: const Text("Schedule")),
            ElevatedButton(
                onPressed: () async {
                  await notificationService.showNotificationWithPayload(
                      id: 0,
                      title: "title",
                      body: "body",
                      payload: 'payload navigation');
                },
                child: const Text("payload")),
          ],
        ),
      )),
    );
  }

  void onNotifClick() => notificationService.onNotificationClick.stream
      .listen(onNotificationListener);

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return SecondScreen(payload: payload);
      }));
    }
  }
}
