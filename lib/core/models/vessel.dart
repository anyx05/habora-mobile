import 'package:freezed_annotation/freezed_annotation.dart';

part 'vessel.freezed.dart';
part 'vessel.g.dart';

@freezed
class Vessel with _$Vessel {
  const factory Vessel({
    required String id,
    required String ownerId,
    required String name,
    required String type,
    required double lengthM,
    double? draftM,
    double? beamM,
  }) = _Vessel;

  factory Vessel.fromJson(Map<String, dynamic> json) => _$VesselFromJson(json);
}
