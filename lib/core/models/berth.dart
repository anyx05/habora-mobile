import 'package:freezed_annotation/freezed_annotation.dart';

part 'berth.freezed.dart';
part 'berth.g.dart';

@freezed
class Berth with _$Berth {
  const factory Berth({
    required String id,
    required String portId,
    required String name,
    required double maxLengthM,
    required double maxDraftM,
    double? maxBeamM,
    required double pricePerNight,
    @Default([]) List<String> amenities,
    @Default(true) bool isActive,
  }) = _Berth;

  // Manual fromJson: the Supabase berths table has legacy aliases from the web
  // MVP ('length', 'draft', 'price') alongside the canonical columns.  We
  // always read the canonical names and deliberately ignore the aliases.
  // We also ignore the 'status' column ('available'/'occupied'/'maintenance')
  // which is for the port-operator dashboard only — berth availability for
  // vessel operators is determined exclusively by check_berth_availability().
  factory Berth.fromJson(Map<String, dynamic> json) => Berth(
        id:            json['id'] as String,
        portId:        json['port_id'] as String,
        name:          json['name'] as String,
        maxLengthM:    (json['max_length_m'] as num).toDouble(),
        maxDraftM:     (json['max_draft_m'] as num).toDouble(),
        maxBeamM:      (json['max_beam_m'] as num?)?.toDouble(),
        pricePerNight: (json['price_per_night'] as num).toDouble(),
        amenities:     List<String>.from(json['amenities'] as List? ?? []),
        isActive:      json['is_active'] as bool? ?? true,
      );
}
