import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:ticket_manager/features/view_ticket/presentation/list_tickets_screen.dart';
import 'package:ticket_manager/firebase_options.dart';
import 'package:ticket_manager/utils/device_info_helper.dart';
import 'package:ticket_manager/utils/init.dart';

/// To verify things are working, check out the native platform logs.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    log('Received a background message ${message.messageId}');
    log('Received a background message ${message.data}');
  } catch (e) {
    log(e.toString());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await Initializer.initializeFCM();
  } catch (e) {
    log(e.toString());
  }
  await Initializer.initializeApp();
  fcmTokenUpdate();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          textTheme: const TextTheme(
            labelSmall: TextStyle(fontSize: 11, letterSpacing: 0.50, fontWeight: FontWeight.w500, color: Colors.grey),
            labelMedium: TextStyle(fontSize: 12, letterSpacing: 0.50, fontWeight: FontWeight.w500, color: Colors.grey),
            labelLarge: TextStyle(fontSize: 14, letterSpacing: 0.10, fontWeight: FontWeight.w500, color: Colors.grey),
            bodySmall: TextStyle(fontSize: 12, letterSpacing: 0.40, fontWeight: FontWeight.w400, color: Colors.indigo),
            bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0.25, fontWeight: FontWeight.w400, color: Colors.indigo),
            bodyLarge: TextStyle(fontSize: 16, letterSpacing: 0.50, fontWeight: FontWeight.w400, color: Colors.indigo),
            titleSmall: TextStyle(fontSize: 14, letterSpacing: 0.10, fontWeight: FontWeight.bold, color: Colors.indigo),
            titleMedium:
                TextStyle(fontSize: 16, letterSpacing: 0.15, fontWeight: FontWeight.bold, color: Colors.indigo),
            titleLarge: TextStyle(fontSize: 22, letterSpacing: 0.00, fontWeight: FontWeight.bold, color: Colors.indigo),
            headlineSmall:
                TextStyle(fontSize: 24, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.indigo),
            headlineMedium:
                TextStyle(fontSize: 28, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.indigo),
            headlineLarge:
                TextStyle(fontSize: 32, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.indigo),
            displaySmall:
                TextStyle(fontSize: 36, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.indigo),
            displayMedium:
                TextStyle(fontSize: 45, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.indigo),
            displayLarge:
                TextStyle(fontSize: 57, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.indigo),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<void> fcmTokenUpdate() async {
  String? fcmToken = '';
  try {
    fcmToken = await FirebaseMessaging.instance.getToken();
    log("FCM :: ${fcmToken ?? "EMPTY"}");
    String deviceId = await AppDeviceInfo.getDeviceUUID();
    QuerySnapshot? userData =
        await FirebaseFirestore.instance.collection('users').where('device_id', isEqualTo: deviceId).limit(1).get();
    if (userData.docs.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(userData.docs[0].id).update({
        'fcmtoken': fcmToken,
      });
    } else {
      await FirebaseFirestore.instance.collection('users').add({
        'device_id': deviceId,
        'fcmtoken': fcmToken,
      });
    }
  } catch (e) {
    log(e.toString());
  }
}
