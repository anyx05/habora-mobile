// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      berthId: json['berthId'] as String,
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
      vesselName: json['vesselName'] as String,
      vesselLengthM: (json['vesselLengthM'] as num).toDouble(),
      vesselDraftM: (json['vesselDraftM'] as num?)?.toDouble(),
      arrivalDate: DateTime.parse(json['arrivalDate'] as String),
      departureDate: DateTime.parse(json['departureDate'] as String),
      status: json['status'] as String,
      confirmationCode: json['confirmationCode'] as String?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'berthId': instance.berthId,
      'customerName': instance.customerName,
      'customerEmail': instance.customerEmail,
      'vesselName': instance.vesselName,
      'vesselLengthM': instance.vesselLengthM,
      'vesselDraftM': instance.vesselDraftM,
      'arrivalDate': instance.arrivalDate.toIso8601String(),
      'departureDate': instance.departureDate.toIso8601String(),
      'status': instance.status,
      'confirmationCode': instance.confirmationCode,
      'totalPrice': instance.totalPrice,
    };
