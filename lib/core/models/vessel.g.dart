// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vessel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VesselImpl _$$VesselImplFromJson(Map<String, dynamic> json) => _$VesselImpl(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  lengthM: (json['lengthM'] as num).toDouble(),
  draftM: (json['draftM'] as num?)?.toDouble(),
  beamM: (json['beamM'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$VesselImplToJson(_$VesselImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'type': instance.type,
      'lengthM': instance.lengthM,
      'draftM': instance.draftM,
      'beamM': instance.beamM,
    };
