import 'package:freezed_annotation/freezed_annotation.dart';

part 'port.freezed.dart';
part 'port.g.dart';

@freezed
class Port with _$Port {
  const factory Port({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    String? description,
    required String contactEmail,
    @Default([]) List<String> amenities,
    int? availableBerthCount,
    double? minPricePerNight,
  }) = _Port;

  factory Port.fromJson(Map<String, dynamic> json) => Port(
        id:                  json['id'] as String,
        name:                json['name'] as String,
        latitude:            (json['latitude'] as num).toDouble(),
        longitude:           (json['longitude'] as num).toDouble(),
        description:         json['description'] as String?,
        contactEmail:        json['contact_email'] as String,
        amenities:           List<String>.from(json['amenities'] as List? ?? []),
        availableBerthCount: (json['available_berth_count'] as num?)?.toInt(),
        minPricePerNight:    (json['min_price_per_night'] as num?)?.toDouble(),
      );
}
