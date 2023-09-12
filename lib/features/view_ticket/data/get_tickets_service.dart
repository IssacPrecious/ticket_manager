import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetTickets {
  late Stream<dynamic> ticketsStream;
  late int count;

  Future<void> init() async {
    final firestore = FirebaseFirestore.instance;
    final Query query = firestore.collection('tickets');
    final Stream<QuerySnapshot> snapshot = query.snapshots();

    ticketsStream = snapshot.map((snapshot) {
      final result = snapshot.docs;
      count = snapshot.docs.length;
      debugPrint("Snapshot Data :: $result");

      return result;
    });
  }

  int ticketsCount() {
    return count;
  }

  Stream<dynamic> stream() {
    return ticketsStream;
  }
}
