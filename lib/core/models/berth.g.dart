// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'berth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BerthImpl _$$BerthImplFromJson(Map<String, dynamic> json) => _$BerthImpl(
  id: json['id'] as String,
  portId: json['portId'] as String,
  name: json['name'] as String,
  maxLengthM: (json['maxLengthM'] as num).toDouble(),
  maxDraftM: (json['maxDraftM'] as num).toDouble(),
  maxBeamM: (json['maxBeamM'] as num?)?.toDouble(),
  pricePerNight: (json['pricePerNight'] as num).toDouble(),
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$$BerthImplToJson(_$BerthImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'portId': instance.portId,
      'name': instance.name,
      'maxLengthM': instance.maxLengthM,
      'maxDraftM': instance.maxDraftM,
      'maxBeamM': instance.maxBeamM,
      'pricePerNight': instance.pricePerNight,
      'amenities': instance.amenities,
      'isActive': instance.isActive,
    };
