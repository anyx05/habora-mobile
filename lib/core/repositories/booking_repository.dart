import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/booking.dart';
import '../supabase/supabase_client.dart';
import 'booking_exception.dart';
import 'port_repository.dart';

class CreateBookingRequest {
  final String berthId;
  final String customerName;
  final String customerEmail;
  final String vesselName;
  final double vesselLengthM;
  final double? vesselDraftM;
  final DateTime arrivalDate;
  final DateTime departureDate;
  final String? notes;
  final double berthPricePerNight;

  const CreateBookingRequest({
    required this.berthId,
    required this.customerName,
    required this.customerEmail,
    required this.vesselName,
    required this.vesselLengthM,
    this.vesselDraftM,
    required this.arrivalDate,
    required this.departureDate,
    this.notes,
    this.berthPricePerNight = 0,
  });

  Map<String, dynamic> toJson() => {
        'berth_id': berthId,
        'customer_name': customerName,
        'customer_email': customerEmail,
        'vessel_name': vesselName,
        'vessel_length_m': vesselLengthM,
        if (vesselDraftM != null) 'vessel_draft_m': vesselDraftM,
        'arrival_date': arrivalDate.toIso8601String().substring(0, 10),
        'departure_date': departureDate.toIso8601String().substring(0, 10),
        if (notes != null) 'notes': notes,
      };
}

/// Rich booking record with resolved berth and port names used by detail UI.
class BookingWithRelated {
  final Booking booking;
  final String berthName;
  final double berthPricePerNight;
  final String portName;
  final double portLatitude;
  final double portLongitude;

  const BookingWithRelated({
    required this.booking,
    required this.berthName,
    required this.berthPricePerNight,
    required this.portName,
    required this.portLatitude,
    required this.portLongitude,
  });
}

abstract class BookingRepository {
  Future<List<Booking>> getUserBookings(String userEmail);
  Future<Booking> createBooking(CreateBookingRequest request);
  Future<Booking> getBookingByCode(String confirmationCode);
  Future<void> cancelBooking(String bookingId);
  Future<BookingWithRelated> getBookingWithRelated(String bookingId);
}

class SupabaseBookingRepository implements BookingRepository {
  @override
  Future<List<Booking>> getUserBookings(String userEmail) async {
    try {
      final data = await supabase
          .from('bookings')
          .select()
          .eq('customer_email', userEmail)
          .order('arrival_date', ascending: false);
      return (data as List).map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }

  @override
  Future<Booking> createBooking(CreateBookingRequest request) async {
    try {
      final response = await supabase.rpc(
        'create_booking_safely',
        params: {
          'p_berth_id':        request.berthId,
          'p_customer_name':   request.customerName,
          'p_customer_email':  request.customerEmail,
          'p_vessel_name':     request.vesselName,
          'p_vessel_length_m': request.vesselLengthM,
          'p_vessel_draft_m':  request.vesselDraftM,
          'p_arrival_date':    request.arrivalDate.toIso8601String().substring(0, 10),
          'p_departure_date':  request.departureDate.toIso8601String().substring(0, 10),
          'p_notes':           request.notes,
        },
      );

      // RPC returns a single row (the inserted booking).
      final raw = response is List ? response.first : response;
      final map = Map<String, dynamic>.from(raw as Map);

      // Defensive total_price fallback if the DB trigger hasn't run yet.
      if (map['total_price'] == null) {
        final nights = request.departureDate
            .difference(request.arrivalDate)
            .inDays
            .clamp(1, 365);
        map['total_price'] = request.berthPricePerNight * nights;
      }

      return Booking.fromJson(map);
    } on PostgrestException catch (e) {
      throw BookingException.fromCode(e.code, e.message);
    } catch (e) {
      throw RepositoryException('Unexpected error creating booking: $e');
    }
  }

  @override
  Future<Booking> getBookingByCode(String confirmationCode) async {
    try {
      final data = await supabase
          .from('bookings')
          .select()
          .eq('confirmation_code', confirmationCode)
          .single();
      return Booking.fromJson(data);
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await supabase
          .from('bookings')
          .update({'status': 'cancelled'})
          .eq('id', bookingId);
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }

  @override
  Future<BookingWithRelated> getBookingWithRelated(String bookingId) async {
    try {
      final data = await supabase
          .from('bookings')
          .select('*, berths!inner(name, price_per_night, ports!inner(name, latitude, longitude))')
          .eq('id', bookingId)
          .single();

      final berthMap = data['berths'] as Map<String, dynamic>;
      final portMap  = berthMap['ports'] as Map<String, dynamic>;

      return BookingWithRelated(
        booking:            Booking.fromJson(data),
        berthName:          berthMap['name'] as String,
        berthPricePerNight: (berthMap['price_per_night'] as num).toDouble(),
        portName:           portMap['name'] as String,
        portLatitude:       (portMap['latitude'] as num).toDouble(),
        portLongitude:      (portMap['longitude'] as num).toDouble(),
      );
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }
}
