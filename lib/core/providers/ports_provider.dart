import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/port.dart';
import '../repositories/port_repository.dart';

/// Search params passed to port search — null means "show all near Tallinn".
class PortSearchParams {
  final double lat;
  final double lng;
  final int radiusKm;
  final double? vesselLength;
  final double? vesselDraft;
  final DateTime? arrival;
  final DateTime? departure;

  const PortSearchParams({
    this.lat = 59.437,
    this.lng = 24.745,
    this.radiusKm = 200,
    this.vesselLength,
    this.vesselDraft,
    this.arrival,
    this.departure,
  });

  PortSearchParams copyWith({
    double? lat,
    double? lng,
    int? radiusKm,
    double? vesselLength,
    double? vesselDraft,
    DateTime? arrival,
    DateTime? departure,
  }) =>
      PortSearchParams(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        radiusKm: radiusKm ?? this.radiusKm,
        vesselLength: vesselLength ?? this.vesselLength,
        vesselDraft: vesselDraft ?? this.vesselDraft,
        arrival: arrival ?? this.arrival,
        departure: departure ?? this.departure,
      );
}

final portRepositoryProvider = Provider<PortRepository>(
  (_) => SupabasePortRepository(),
);

final portSearchParamsProvider = StateProvider<PortSearchParams>(
  (_) => const PortSearchParams(),
);

final portsResultsProvider = FutureProvider<List<Port>>((ref) async {
  final params = ref.watch(portSearchParamsProvider);
  final repo = ref.watch(portRepositoryProvider);
  return repo.searchPorts(
    lat: params.lat,
    lng: params.lng,
    radiusKm: params.radiusKm,
    vesselLength: params.vesselLength,
    vesselDraft: params.vesselDraft,
    arrival: params.arrival,
    departure: params.departure,
  );
});

final selectedPortProvider = StateProvider<Port?>((_) => null);

final portByIdProvider = FutureProvider.family<Port, String>((ref, id) async {
  final repo = ref.watch(portRepositoryProvider);
  return repo.getPortById(id);
});
