// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'berth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Berth _$BerthFromJson(Map<String, dynamic> json) {
  return _Berth.fromJson(json);
}

/// @nodoc
mixin _$Berth {
  String get id => throw _privateConstructorUsedError;
  String get portId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get maxLengthM => throw _privateConstructorUsedError;
  double get maxDraftM => throw _privateConstructorUsedError;
  double? get maxBeamM => throw _privateConstructorUsedError;
  double get pricePerNight => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this Berth to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Berth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BerthCopyWith<Berth> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BerthCopyWith<$Res> {
  factory $BerthCopyWith(Berth value, $Res Function(Berth) then) =
      _$BerthCopyWithImpl<$Res, Berth>;
  @useResult
  $Res call({
    String id,
    String portId,
    String name,
    double maxLengthM,
    double maxDraftM,
    double? maxBeamM,
    double pricePerNight,
    List<String> amenities,
    bool isActive,
  });
}

/// @nodoc
class _$BerthCopyWithImpl<$Res, $Val extends Berth>
    implements $BerthCopyWith<$Res> {
  _$BerthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Berth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? portId = null,
    Object? name = null,
    Object? maxLengthM = null,
    Object? maxDraftM = null,
    Object? maxBeamM = freezed,
    Object? pricePerNight = null,
    Object? amenities = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            portId: null == portId
                ? _value.portId
                : portId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            maxLengthM: null == maxLengthM
                ? _value.maxLengthM
                : maxLengthM // ignore: cast_nullable_to_non_nullable
                      as double,
            maxDraftM: null == maxDraftM
                ? _value.maxDraftM
                : maxDraftM // ignore: cast_nullable_to_non_nullable
                      as double,
            maxBeamM: freezed == maxBeamM
                ? _value.maxBeamM
                : maxBeamM // ignore: cast_nullable_to_non_nullable
                      as double?,
            pricePerNight: null == pricePerNight
                ? _value.pricePerNight
                : pricePerNight // ignore: cast_nullable_to_non_nullable
                      as double,
            amenities: null == amenities
                ? _value.amenities
                : amenities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BerthImplCopyWith<$Res> implements $BerthCopyWith<$Res> {
  factory _$$BerthImplCopyWith(
    _$BerthImpl value,
    $Res Function(_$BerthImpl) then,
  ) = __$$BerthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String portId,
    String name,
    double maxLengthM,
    double maxDraftM,
    double? maxBeamM,
    double pricePerNight,
    List<String> amenities,
    bool isActive,
  });
}

/// @nodoc
class __$$BerthImplCopyWithImpl<$Res>
    extends _$BerthCopyWithImpl<$Res, _$BerthImpl>
    implements _$$BerthImplCopyWith<$Res> {
  __$$BerthImplCopyWithImpl(
    _$BerthImpl _value,
    $Res Function(_$BerthImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Berth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? portId = null,
    Object? name = null,
    Object? maxLengthM = null,
    Object? maxDraftM = null,
    Object? maxBeamM = freezed,
    Object? pricePerNight = null,
    Object? amenities = null,
    Object? isActive = null,
  }) {
    return _then(
      _$BerthImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        portId: null == portId
            ? _value.portId
            : portId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        maxLengthM: null == maxLengthM
            ? _value.maxLengthM
            : maxLengthM // ignore: cast_nullable_to_non_nullable
                  as double,
        maxDraftM: null == maxDraftM
            ? _value.maxDraftM
            : maxDraftM // ignore: cast_nullable_to_non_nullable
                  as double,
        maxBeamM: freezed == maxBeamM
            ? _value.maxBeamM
            : maxBeamM // ignore: cast_nullable_to_non_nullable
                  as double?,
        pricePerNight: null == pricePerNight
            ? _value.pricePerNight
            : pricePerNight // ignore: cast_nullable_to_non_nullable
                  as double,
        amenities: null == amenities
            ? _value._amenities
            : amenities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BerthImpl implements _Berth {
  const _$BerthImpl({
    required this.id,
    required this.portId,
    required this.name,
    required this.maxLengthM,
    required this.maxDraftM,
    this.maxBeamM,
    required this.pricePerNight,
    final List<String> amenities = const [],
    this.isActive = true,
  }) : _amenities = amenities;

  factory _$BerthImpl.fromJson(Map<String, dynamic> json) =>
      _$$BerthImplFromJson(json);

  @override
  final String id;
  @override
  final String portId;
  @override
  final String name;
  @override
  final double maxLengthM;
  @override
  final double maxDraftM;
  @override
  final double? maxBeamM;
  @override
  final double pricePerNight;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'Berth(id: $id, portId: $portId, name: $name, maxLengthM: $maxLengthM, maxDraftM: $maxDraftM, maxBeamM: $maxBeamM, pricePerNight: $pricePerNight, amenities: $amenities, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BerthImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.portId, portId) || other.portId == portId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maxLengthM, maxLengthM) ||
                other.maxLengthM == maxLengthM) &&
            (identical(other.maxDraftM, maxDraftM) ||
                other.maxDraftM == maxDraftM) &&
            (identical(other.maxBeamM, maxBeamM) ||
                other.maxBeamM == maxBeamM) &&
            (identical(other.pricePerNight, pricePerNight) ||
                other.pricePerNight == pricePerNight) &&
            const DeepCollectionEquality().equals(
              other._amenities,
              _amenities,
            ) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    portId,
    name,
    maxLengthM,
    maxDraftM,
    maxBeamM,
    pricePerNight,
    const DeepCollectionEquality().hash(_amenities),
    isActive,
  );

  /// Create a copy of Berth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BerthImplCopyWith<_$BerthImpl> get copyWith =>
      __$$BerthImplCopyWithImpl<_$BerthImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BerthImplToJson(this);
  }
}

abstract class _Berth implements Berth {
  const factory _Berth({
    required final String id,
    required final String portId,
    required final String name,
    required final double maxLengthM,
    required final double maxDraftM,
    final double? maxBeamM,
    required final double pricePerNight,
    final List<String> amenities,
    final bool isActive,
  }) = _$BerthImpl;

  factory _Berth.fromJson(Map<String, dynamic> json) = _$BerthImpl.fromJson;

  @override
  String get id;
  @override
  String get portId;
  @override
  String get name;
  @override
  double get maxLengthM;
  @override
  double get maxDraftM;
  @override
  double? get maxBeamM;
  @override
  double get pricePerNight;
  @override
  List<String> get amenities;
  @override
  bool get isActive;

  /// Create a copy of Berth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BerthImplCopyWith<_$BerthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
