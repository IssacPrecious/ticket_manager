import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:ticket_manager/features/create_ticket/presentation/add_ticket_screen.dart';
import 'package:ticket_manager/features/view_ticket/data/view_tickets_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

final firestore = FirebaseFirestore.instance;

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final FirebaseMessaging messaging;
  late Stream<dynamic> ticketsStream;
  int ticketsLength = 0;

  @override
  void initState() {
    registerNotification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ticketsStream = ref.read(ticketsProvider.stream);

    return Scaffold(
        backgroundColor: Colors.indigo[100],
        appBar: AppBar(title: const Text("Ticket Manager")),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add_rounded, size: 40, color: Colors.indigo),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const AddTaskScreen();
                },
              ));
            }),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: StreamBuilder(
            stream: ticketsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint("Snapshot Data :: ${snapshot.data!.length}");
                ticketsLength = snapshot.data!.length;

                if (ticketsLength == 0) {
                  return const Center(
                    child: Text("No Tickets found"),
                  );
                }

                // snapshot.data!.first();
                // showSimpleNotification(Text("data"));

                return ListView(
                  children: snapshot.data!.map<Widget>((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    debugPrint("Data:: ${document.data()}");

                    return TicketCard(
                        title: data['title'],
                        description: data['description'],
                        location: data['location'],
                        dateTime: data['dateTime'],
                        attachment: data['fileName'] ?? "");
                  }).toList(),
                );
              }

              return const Center(
                child: CircularProgressIndicator(color: Colors.indigo),
              );
            },
          ),
        ));
  }

  void showNotification() {}

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    messaging = FirebaseMessaging.instance;

    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint(e.toString());
    }

    // On iOS, this helps to take the user permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint("Message Received :: ${message.notification!.title!}");

        // For displaying the notification as an overlay
        showSimpleNotification(
          Text(
            message.notification!.title!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(message.notification!.body!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                  )),
          background: Colors.indigo,
          duration: const Duration(seconds: 2),
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint("Message Opened :: ${message.notification!.title!}");
      });
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }
}

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.dateTime,
    required this.attachment,
  });

  final String title;
  final String description;
  final String location;
  final String dateTime;
  final String attachment;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double availableWidth = screenWidth - (16 * 4);
    return Card(
        color: const Color(0xFFf1f3ff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // if you need this
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: availableWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                            if (attachment.isNotEmpty) const Icon(Icons.attachment)
                          ],
                        ),
                      ),
                      SizedBox(
                        width: availableWidth,
                        child: Text(description, style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.pin_drop, color: Colors.grey, size: 16),
                      Text(
                        location,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                  Text(
                    dateTime.toString(),
                    style: Theme.of(context).textTheme.labelLarge,
                  )
                ],
              )
            ],
          ),
        ));
  }
}
