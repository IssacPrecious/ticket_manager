import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_manager/features/view_ticket/data/get_tickets_service.dart';

final tickets = GetTickets();

final ticketsProvider = StreamProvider((ref) {
  tickets.init();

  return tickets.stream();
});

final ticketsCount = Provider((ref) {
  return tickets.count;
});
