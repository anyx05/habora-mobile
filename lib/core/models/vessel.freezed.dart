// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vessel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Vessel _$VesselFromJson(Map<String, dynamic> json) {
  return _Vessel.fromJson(json);
}

/// @nodoc
mixin _$Vessel {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get lengthM => throw _privateConstructorUsedError;
  double? get draftM => throw _privateConstructorUsedError;
  double? get beamM => throw _privateConstructorUsedError;

  /// Serializes this Vessel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vessel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VesselCopyWith<Vessel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VesselCopyWith<$Res> {
  factory $VesselCopyWith(Vessel value, $Res Function(Vessel) then) =
      _$VesselCopyWithImpl<$Res, Vessel>;
  @useResult
  $Res call({
    String id,
    String ownerId,
    String name,
    String type,
    double lengthM,
    double? draftM,
    double? beamM,
  });
}

/// @nodoc
class _$VesselCopyWithImpl<$Res, $Val extends Vessel>
    implements $VesselCopyWith<$Res> {
  _$VesselCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vessel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? type = null,
    Object? lengthM = null,
    Object? draftM = freezed,
    Object? beamM = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            lengthM: null == lengthM
                ? _value.lengthM
                : lengthM // ignore: cast_nullable_to_non_nullable
                      as double,
            draftM: freezed == draftM
                ? _value.draftM
                : draftM // ignore: cast_nullable_to_non_nullable
                      as double?,
            beamM: freezed == beamM
                ? _value.beamM
                : beamM // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VesselImplCopyWith<$Res> implements $VesselCopyWith<$Res> {
  factory _$$VesselImplCopyWith(
    _$VesselImpl value,
    $Res Function(_$VesselImpl) then,
  ) = __$$VesselImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ownerId,
    String name,
    String type,
    double lengthM,
    double? draftM,
    double? beamM,
  });
}

/// @nodoc
class __$$VesselImplCopyWithImpl<$Res>
    extends _$VesselCopyWithImpl<$Res, _$VesselImpl>
    implements _$$VesselImplCopyWith<$Res> {
  __$$VesselImplCopyWithImpl(
    _$VesselImpl _value,
    $Res Function(_$VesselImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Vessel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? type = null,
    Object? lengthM = null,
    Object? draftM = freezed,
    Object? beamM = freezed,
  }) {
    return _then(
      _$VesselImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        lengthM: null == lengthM
            ? _value.lengthM
            : lengthM // ignore: cast_nullable_to_non_nullable
                  as double,
        draftM: freezed == draftM
            ? _value.draftM
            : draftM // ignore: cast_nullable_to_non_nullable
                  as double?,
        beamM: freezed == beamM
            ? _value.beamM
            : beamM // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VesselImpl implements _Vessel {
  const _$VesselImpl({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.type,
    required this.lengthM,
    this.draftM,
    this.beamM,
  });

  factory _$VesselImpl.fromJson(Map<String, dynamic> json) =>
      _$$VesselImplFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String name;
  @override
  final String type;
  @override
  final double lengthM;
  @override
  final double? draftM;
  @override
  final double? beamM;

  @override
  String toString() {
    return 'Vessel(id: $id, ownerId: $ownerId, name: $name, type: $type, lengthM: $lengthM, draftM: $draftM, beamM: $beamM)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VesselImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.lengthM, lengthM) || other.lengthM == lengthM) &&
            (identical(other.draftM, draftM) || other.draftM == draftM) &&
            (identical(other.beamM, beamM) || other.beamM == beamM));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, ownerId, name, type, lengthM, draftM, beamM);

  /// Create a copy of Vessel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VesselImplCopyWith<_$VesselImpl> get copyWith =>
      __$$VesselImplCopyWithImpl<_$VesselImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VesselImplToJson(this);
  }
}

abstract class _Vessel implements Vessel {
  const factory _Vessel({
    required final String id,
    required final String ownerId,
    required final String name,
    required final String type,
    required final double lengthM,
    final double? draftM,
    final double? beamM,
  }) = _$VesselImpl;

  factory _Vessel.fromJson(Map<String, dynamic> json) = _$VesselImpl.fromJson;

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get name;
  @override
  String get type;
  @override
  double get lengthM;
  @override
  double? get draftM;
  @override
  double? get beamM;

  /// Create a copy of Vessel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VesselImplCopyWith<_$VesselImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
