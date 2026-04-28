// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get berthId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerEmail => throw _privateConstructorUsedError;
  String get vesselName => throw _privateConstructorUsedError;
  double get vesselLengthM => throw _privateConstructorUsedError;
  double? get vesselDraftM => throw _privateConstructorUsedError;
  DateTime get arrivalDate => throw _privateConstructorUsedError;
  DateTime get departureDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get confirmationCode => throw _privateConstructorUsedError;
  double? get totalPrice => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    String id,
    String berthId,
    String customerName,
    String customerEmail,
    String vesselName,
    double vesselLengthM,
    double? vesselDraftM,
    DateTime arrivalDate,
    DateTime departureDate,
    String status,
    String? confirmationCode,
    double? totalPrice,
  });
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? berthId = null,
    Object? customerName = null,
    Object? customerEmail = null,
    Object? vesselName = null,
    Object? vesselLengthM = null,
    Object? vesselDraftM = freezed,
    Object? arrivalDate = null,
    Object? departureDate = null,
    Object? status = null,
    Object? confirmationCode = freezed,
    Object? totalPrice = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            berthId: null == berthId
                ? _value.berthId
                : berthId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            customerEmail: null == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            vesselName: null == vesselName
                ? _value.vesselName
                : vesselName // ignore: cast_nullable_to_non_nullable
                      as String,
            vesselLengthM: null == vesselLengthM
                ? _value.vesselLengthM
                : vesselLengthM // ignore: cast_nullable_to_non_nullable
                      as double,
            vesselDraftM: freezed == vesselDraftM
                ? _value.vesselDraftM
                : vesselDraftM // ignore: cast_nullable_to_non_nullable
                      as double?,
            arrivalDate: null == arrivalDate
                ? _value.arrivalDate
                : arrivalDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            departureDate: null == departureDate
                ? _value.departureDate
                : departureDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            confirmationCode: freezed == confirmationCode
                ? _value.confirmationCode
                : confirmationCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalPrice: freezed == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String berthId,
    String customerName,
    String customerEmail,
    String vesselName,
    double vesselLengthM,
    double? vesselDraftM,
    DateTime arrivalDate,
    DateTime departureDate,
    String status,
    String? confirmationCode,
    double? totalPrice,
  });
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? berthId = null,
    Object? customerName = null,
    Object? customerEmail = null,
    Object? vesselName = null,
    Object? vesselLengthM = null,
    Object? vesselDraftM = freezed,
    Object? arrivalDate = null,
    Object? departureDate = null,
    Object? status = null,
    Object? confirmationCode = freezed,
    Object? totalPrice = freezed,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        berthId: null == berthId
            ? _value.berthId
            : berthId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        customerEmail: null == customerEmail
            ? _value.customerEmail
            : customerEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        vesselName: null == vesselName
            ? _value.vesselName
            : vesselName // ignore: cast_nullable_to_non_nullable
                  as String,
        vesselLengthM: null == vesselLengthM
            ? _value.vesselLengthM
            : vesselLengthM // ignore: cast_nullable_to_non_nullable
                  as double,
        vesselDraftM: freezed == vesselDraftM
            ? _value.vesselDraftM
            : vesselDraftM // ignore: cast_nullable_to_non_nullable
                  as double?,
        arrivalDate: null == arrivalDate
            ? _value.arrivalDate
            : arrivalDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        departureDate: null == departureDate
            ? _value.departureDate
            : departureDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        confirmationCode: freezed == confirmationCode
            ? _value.confirmationCode
            : confirmationCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalPrice: freezed == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingImpl extends _Booking {
  const _$BookingImpl({
    required this.id,
    required this.berthId,
    required this.customerName,
    required this.customerEmail,
    required this.vesselName,
    required this.vesselLengthM,
    this.vesselDraftM,
    required this.arrivalDate,
    required this.departureDate,
    required this.status,
    this.confirmationCode,
    this.totalPrice,
  }) : super._();

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final String berthId;
  @override
  final String customerName;
  @override
  final String customerEmail;
  @override
  final String vesselName;
  @override
  final double vesselLengthM;
  @override
  final double? vesselDraftM;
  @override
  final DateTime arrivalDate;
  @override
  final DateTime departureDate;
  @override
  final String status;
  @override
  final String? confirmationCode;
  @override
  final double? totalPrice;

  @override
  String toString() {
    return 'Booking(id: $id, berthId: $berthId, customerName: $customerName, customerEmail: $customerEmail, vesselName: $vesselName, vesselLengthM: $vesselLengthM, vesselDraftM: $vesselDraftM, arrivalDate: $arrivalDate, departureDate: $departureDate, status: $status, confirmationCode: $confirmationCode, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.berthId, berthId) || other.berthId == berthId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.vesselName, vesselName) ||
                other.vesselName == vesselName) &&
            (identical(other.vesselLengthM, vesselLengthM) ||
                other.vesselLengthM == vesselLengthM) &&
            (identical(other.vesselDraftM, vesselDraftM) ||
                other.vesselDraftM == vesselDraftM) &&
            (identical(other.arrivalDate, arrivalDate) ||
                other.arrivalDate == arrivalDate) &&
            (identical(other.departureDate, departureDate) ||
                other.departureDate == departureDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.confirmationCode, confirmationCode) ||
                other.confirmationCode == confirmationCode) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    berthId,
    customerName,
    customerEmail,
    vesselName,
    vesselLengthM,
    vesselDraftM,
    arrivalDate,
    departureDate,
    status,
    confirmationCode,
    totalPrice,
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(this);
  }
}

abstract class _Booking extends Booking {
  const factory _Booking({
    required final String id,
    required final String berthId,
    required final String customerName,
    required final String customerEmail,
    required final String vesselName,
    required final double vesselLengthM,
    final double? vesselDraftM,
    required final DateTime arrivalDate,
    required final DateTime departureDate,
    required final String status,
    final String? confirmationCode,
    final double? totalPrice,
  }) = _$BookingImpl;
  const _Booking._() : super._();

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  String get berthId;
  @override
  String get customerName;
  @override
  String get customerEmail;
  @override
  String get vesselName;
  @override
  double get vesselLengthM;
  @override
  double? get vesselDraftM;
  @override
  DateTime get arrivalDate;
  @override
  DateTime get departureDate;
  @override
  String get status;
  @override
  String? get confirmationCode;
  @override
  double? get totalPrice;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
