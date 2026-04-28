import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/berth.dart';
import '../models/booking.dart';
import '../repositories/berth_repository.dart';
import '../repositories/booking_repository.dart';
import 'auth_provider.dart';

class BerthQuery {
  final String portId;
  final DateTime arrival;
  final DateTime departure;

  const BerthQuery({
    required this.portId,
    required this.arrival,
    required this.departure,
  });

  @override
  bool operator ==(Object other) =>
      other is BerthQuery &&
      other.portId == portId &&
      other.arrival == arrival &&
      other.departure == departure;

  @override
  int get hashCode => Object.hash(portId, arrival, departure);
}

final berthRepositoryProvider = Provider<BerthRepository>(
  (_) => SupabaseBerthRepository(),
);

final bookingRepositoryProvider = Provider<BookingRepository>(
  (_) => SupabaseBookingRepository(),
);

final berthAvailabilityProvider =
    FutureProvider.family<List<Berth>, BerthQuery>((ref, query) async {
  final repo = ref.watch(berthRepositoryProvider);
  return repo.getAvailableBerths(
    portId: query.portId,
    arrival: query.arrival,
    departure: query.departure,
  );
});

final userBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.email == null) return [];
  final repo = ref.watch(bookingRepositoryProvider);
  return repo.getUserBookings(user.email!);
});

/// Filters bookings into semantic buckets.
///
/// Pass one of the three category keys:
/// * `'upcoming'`  — confirmed/pending with arrival today or later
/// * `'past'`      — confirmed with departure already in the past
/// * `'cancelled'` — cancelled bookings
final bookingsByStatusProvider =
    Provider.family<AsyncValue<List<Booking>>, String>((ref, category) {
  return ref.watch(userBookingsProvider).whenData(
        (bookings) => switch (category) {
          'upcoming'  => bookings.where((b) => b.isUpcoming).toList(),
          'past'      => bookings.where((b) => b.isPast).toList(),
          'cancelled' => bookings.where((b) => b.bookingStatus.isCancelled).toList(),
          _           => bookings,
        },
      );
});

final bookingDetailProvider =
    FutureProvider.family<BookingWithRelated, String>((ref, bookingId) async {
  final repo = ref.watch(bookingRepositoryProvider);
  return repo.getBookingWithRelated(bookingId);
});
