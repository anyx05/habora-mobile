import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

/// The three status values the Supabase `bookings` table accepts.
enum BookingStatus {
  confirmed,
  cancelled,
  pending;

  static BookingStatus fromString(String value) {
    return switch (value) {
      'confirmed' => BookingStatus.confirmed,
      'cancelled' => BookingStatus.cancelled,
      'pending'   => BookingStatus.pending,
      _           => BookingStatus.pending,
    };
  }

  /// True when the booking is not yet cancelled and the trip has not ended.
  bool get isUpcoming => this == BookingStatus.confirmed || this == BookingStatus.pending;

  /// Always false on the enum itself — past determination requires date comparison.
  bool get isPast => false;

  bool get isCancelled => this == BookingStatus.cancelled;
}

@freezed
class Booking with _$Booking {
  const Booking._();

  const factory Booking({
    required String id,
    required String berthId,
    required String customerName,
    required String customerEmail,
    required String vesselName,
    required double vesselLengthM,
    double? vesselDraftM,
    required DateTime arrivalDate,
    required DateTime departureDate,
    required String status,
    String? confirmationCode,
    double? totalPrice,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id:               json['id'] as String,
        berthId:          json['berth_id'] as String,
        customerName:     json['customer_name'] as String,
        customerEmail:    json['customer_email'] as String,
        vesselName:       json['vessel_name'] as String,
        vesselLengthM:    (json['vessel_length_m'] as num).toDouble(),
        vesselDraftM:     (json['vessel_draft_m'] as num?)?.toDouble(),
        arrivalDate:      DateTime.parse(json['arrival_date'] as String),
        departureDate:    DateTime.parse(json['departure_date'] as String),
        status:           json['status'] as String,
        confirmationCode: json['confirmation_code'] as String?,
        totalPrice:       (json['total_price'] as num?)?.toDouble(),
      );

  // ── Computed getters ────────────────────────────────────────────────────────

  int get nights => departureDate.difference(arrivalDate).inDays;

  /// Typed status parsed from the raw [status] string.
  BookingStatus get bookingStatus => BookingStatus.fromString(status);

  /// True when the booking is active or pending and the arrival date is today
  /// or in the future (within a one-day grace window).
  bool get isUpcoming =>
      bookingStatus.isUpcoming &&
      arrivalDate.isAfter(DateTime.now().subtract(const Duration(days: 1)));

  /// True when the trip has ended — departure is in the past and the booking
  /// was confirmed (not cancelled).
  bool get isPast =>
      departureDate.isBefore(DateTime.now()) &&
      bookingStatus == BookingStatus.confirmed;
}
