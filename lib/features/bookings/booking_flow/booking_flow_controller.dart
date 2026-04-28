import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/models/booking.dart';
import 'package:myapp/core/models/vessel.dart';
import 'package:myapp/core/providers/bookings_provider.dart';
import 'package:myapp/core/repositories/booking_exception.dart';
import 'package:myapp/core/repositories/booking_repository.dart';

class BookingFlowState {
  static const _absent = Object();

  final int currentStep;
  final String? berthId;
  final String? portId;
  final String? berthName;
  final String? portName;
  final double? berthPricePerNight;
  final Vessel? selectedVessel;
  final String? vesselName;
  final double? vesselLengthM;
  final double? vesselDraftM;
  final String? customerName;
  final String? customerEmail;
  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final String? notes;
  final bool isLoading;
  final String? error;

  const BookingFlowState({
    this.currentStep = 1,
    this.berthId,
    this.portId,
    this.berthName,
    this.portName,
    this.berthPricePerNight,
    this.selectedVessel,
    this.vesselName,
    this.vesselLengthM,
    this.vesselDraftM,
    this.customerName,
    this.customerEmail,
    this.arrivalDate,
    this.departureDate,
    this.notes,
    this.isLoading = false,
    this.error,
  });

  int get nights =>
      (arrivalDate != null && departureDate != null)
          ? departureDate!.difference(arrivalDate!).inDays.clamp(1, 365)
          : 1;

  double get totalPrice => (berthPricePerNight ?? 0) * nights;

  BookingFlowState copyWith({
    int? currentStep,
    String? berthId,
    String? portId,
    String? berthName,
    String? portName,
    double? berthPricePerNight,
    Object? selectedVessel = _absent,
    String? vesselName,
    double? vesselLengthM,
    double? vesselDraftM,
    String? customerName,
    String? customerEmail,
    DateTime? arrivalDate,
    DateTime? departureDate,
    String? notes,
    bool? isLoading,
    Object? error = _absent,
  }) =>
      BookingFlowState(
        currentStep:        currentStep        ?? this.currentStep,
        berthId:            berthId            ?? this.berthId,
        portId:             portId             ?? this.portId,
        berthName:          berthName          ?? this.berthName,
        portName:           portName           ?? this.portName,
        berthPricePerNight: berthPricePerNight ?? this.berthPricePerNight,
        selectedVessel:     identical(selectedVessel, _absent)
            ? this.selectedVessel
            : selectedVessel as Vessel?,
        vesselName:         vesselName         ?? this.vesselName,
        vesselLengthM:      vesselLengthM      ?? this.vesselLengthM,
        vesselDraftM:       vesselDraftM       ?? this.vesselDraftM,
        customerName:       customerName       ?? this.customerName,
        customerEmail:      customerEmail      ?? this.customerEmail,
        arrivalDate:        arrivalDate        ?? this.arrivalDate,
        departureDate:      departureDate      ?? this.departureDate,
        notes:              notes              ?? this.notes,
        isLoading:          isLoading          ?? this.isLoading,
        error:              identical(error, _absent) ? this.error : error as String?,
      );
}

class BookingFlowNotifier extends StateNotifier<BookingFlowState> {
  final BookingRepository _repo;
  final Ref _ref;

  BookingFlowNotifier(this._repo, this._ref) : super(const BookingFlowState());

  void init({
    required String berthId,
    required String portId,
    String berthName = '',
    String portName = '',
    double berthPricePerNight = 0,
    DateTime? arrivalDate,
    DateTime? departureDate,
  }) {
    state = BookingFlowState(
      berthId:            berthId,
      portId:             portId,
      berthName:          berthName,
      portName:           portName,
      berthPricePerNight: berthPricePerNight,
      arrivalDate:        arrivalDate,
      departureDate:      departureDate,
    );
  }

  void selectVessel(Vessel vessel) {
    state = state.copyWith(
      selectedVessel: vessel,
      vesselName:     vessel.name,
      vesselLengthM:  vessel.lengthM,
      vesselDraftM:   vessel.draftM,
      currentStep:    2,
    );
  }

  void setManualVessel({
    required String name,
    required double lengthM,
    double? draftM,
  }) {
    state = BookingFlowState(
      currentStep:        2,
      berthId:            state.berthId,
      portId:             state.portId,
      berthName:          state.berthName,
      portName:           state.portName,
      berthPricePerNight: state.berthPricePerNight,
      vesselName:         name,
      vesselLengthM:      lengthM,
      vesselDraftM:       draftM,
      arrivalDate:        state.arrivalDate,
      departureDate:      state.departureDate,
    );
  }

  void setContactInfo({
    required String name,
    required String email,
    String? notes,
  }) {
    state = state.copyWith(
      customerName:  name,
      customerEmail: email,
      notes:         notes,
      currentStep:   3,
    );
  }

  void goBack() {
    if (state.currentStep > 1) {
      state = state.copyWith(
        currentStep: state.currentStep - 1,
        error: null,
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);

  /// Submits the booking. Returns the created [Booking] on success, null on failure.
  Future<Booking?> submitBooking() async {
    final s = state;
    if (s.berthId == null ||
        s.vesselName == null ||
        s.vesselLengthM == null ||
        s.customerName == null ||
        s.customerEmail == null ||
        s.arrivalDate == null ||
        s.departureDate == null) {
      return null;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final booking = await _repo.createBooking(
        CreateBookingRequest(
          berthId:            s.berthId!,
          customerName:       s.customerName!,
          customerEmail:      s.customerEmail!,
          vesselName:         s.vesselName!,
          vesselLengthM:      s.vesselLengthM!,
          vesselDraftM:       s.vesselDraftM,
          arrivalDate:        s.arrivalDate!,
          departureDate:      s.departureDate!,
          notes:              s.notes,
          berthPricePerNight: s.berthPricePerNight ?? 0,
        ),
      );
      _ref.invalidate(userBookingsProvider);
      state = state.copyWith(isLoading: false);
      return booking;
    } on BookingException {
      // Typed booking errors propagate to the UI for code-based dispatch.
      state = state.copyWith(isLoading: false, error: null);
      rethrow;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  void reset() => state = const BookingFlowState();
}

final activeBookingFlowProvider =
    StateNotifierProvider<BookingFlowNotifier, BookingFlowState>((ref) {
  return BookingFlowNotifier(
    ref.watch(bookingRepositoryProvider),
    ref,
  );
});
