// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'port.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PortImpl _$$PortImplFromJson(Map<String, dynamic> json) => _$PortImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  description: json['description'] as String?,
  contactEmail: json['contactEmail'] as String,
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  availableBerthCount: (json['availableBerthCount'] as num?)?.toInt(),
  minPricePerNight: (json['minPricePerNight'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$PortImplToJson(_$PortImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'contactEmail': instance.contactEmail,
      'amenities': instance.amenities,
      'availableBerthCount': instance.availableBerthCount,
      'minPricePerNight': instance.minPricePerNight,
    };
