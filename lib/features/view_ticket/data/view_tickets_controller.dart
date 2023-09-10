import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewTicketsRepository {
  late Stream<dynamic> ticketsStream;

  Future<void> init() async {
    final firestore = FirebaseFirestore.instance;
    final Query query = firestore.collection('tickets');
    final Stream<QuerySnapshot> snapshot = query.snapshots();

    ticketsStream = snapshot.map((snapshot) {
      final result = snapshot.docs;
      debugPrint("Snapshot Data :: $result");

      return result;
    });
  }

  Stream<dynamic> stream() {
    return ticketsStream;
  }
}
