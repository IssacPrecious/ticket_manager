import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_manager/features/view_ticket/data/view_tickets_service.dart';

final ticketsProvider = StreamProvider((ref) {
  final tickets = ViewTicketsService();
  tickets.init();

  return tickets.stream();
});
