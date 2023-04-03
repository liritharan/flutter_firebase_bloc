import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_bloc/retrive_data/bloc.dart';
import 'package:flutter_firebase_bloc/retrive_data/view.dart';
import 'package:flutter_firebase_bloc/service/get_repository.dart';
import 'package:flutter_firebase_bloc/service/notification_service.dart';

import 'package:flutter_firebase_bloc/view/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey(debugLabel: "Main Navigator"); //
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  // This widget is the root of your application.
  @override
  void initState() {

    super.initState();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
  Future<dynamic> onSelectNotification(payload) async {
// navigate to booking screen if the payload equal BOOKING

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BlocProvider(
          create: (context) =>
              RetriveDataBloc(getApi: GetApiRepository()),
          child: RepositoryProvider(
            create: (_) => GetApiRepository(),
            child: GetList(),
          ),
        )),
            (Route<dynamic> route) => false,
      );
    }

}
