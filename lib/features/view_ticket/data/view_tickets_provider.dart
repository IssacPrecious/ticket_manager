import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_manager/features/view_ticket/data/view_tickets_controller.dart';

final ticketsProvider = StreamProvider((ref) {
  final tickets = ViewTicketsRepository();
  tickets.init();

  return tickets.stream();
});
