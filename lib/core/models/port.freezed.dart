// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'port.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Port _$PortFromJson(Map<String, dynamic> json) {
  return _Port.fromJson(json);
}

/// @nodoc
mixin _$Port {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get contactEmail => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  int? get availableBerthCount => throw _privateConstructorUsedError;
  double? get minPricePerNight => throw _privateConstructorUsedError;

  /// Serializes this Port to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Port
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortCopyWith<Port> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortCopyWith<$Res> {
  factory $PortCopyWith(Port value, $Res Function(Port) then) =
      _$PortCopyWithImpl<$Res, Port>;
  @useResult
  $Res call({
    String id,
    String name,
    double latitude,
    double longitude,
    String? description,
    String contactEmail,
    List<String> amenities,
    int? availableBerthCount,
    double? minPricePerNight,
  });
}

/// @nodoc
class _$PortCopyWithImpl<$Res, $Val extends Port>
    implements $PortCopyWith<$Res> {
  _$PortCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Port
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = freezed,
    Object? contactEmail = null,
    Object? amenities = null,
    Object? availableBerthCount = freezed,
    Object? minPricePerNight = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactEmail: null == contactEmail
                ? _value.contactEmail
                : contactEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            amenities: null == amenities
                ? _value.amenities
                : amenities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            availableBerthCount: freezed == availableBerthCount
                ? _value.availableBerthCount
                : availableBerthCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            minPricePerNight: freezed == minPricePerNight
                ? _value.minPricePerNight
                : minPricePerNight // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PortImplCopyWith<$Res> implements $PortCopyWith<$Res> {
  factory _$$PortImplCopyWith(
    _$PortImpl value,
    $Res Function(_$PortImpl) then,
  ) = __$$PortImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double latitude,
    double longitude,
    String? description,
    String contactEmail,
    List<String> amenities,
    int? availableBerthCount,
    double? minPricePerNight,
  });
}

/// @nodoc
class __$$PortImplCopyWithImpl<$Res>
    extends _$PortCopyWithImpl<$Res, _$PortImpl>
    implements _$$PortImplCopyWith<$Res> {
  __$$PortImplCopyWithImpl(_$PortImpl _value, $Res Function(_$PortImpl) _then)
    : super(_value, _then);

  /// Create a copy of Port
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = freezed,
    Object? contactEmail = null,
    Object? amenities = null,
    Object? availableBerthCount = freezed,
    Object? minPricePerNight = freezed,
  }) {
    return _then(
      _$PortImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactEmail: null == contactEmail
            ? _value.contactEmail
            : contactEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        amenities: null == amenities
            ? _value._amenities
            : amenities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        availableBerthCount: freezed == availableBerthCount
            ? _value.availableBerthCount
            : availableBerthCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        minPricePerNight: freezed == minPricePerNight
            ? _value.minPricePerNight
            : minPricePerNight // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PortImpl implements _Port {
  const _$PortImpl({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.description,
    required this.contactEmail,
    final List<String> amenities = const [],
    this.availableBerthCount,
    this.minPricePerNight,
  }) : _amenities = amenities;

  factory _$PortImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? description;
  @override
  final String contactEmail;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  @override
  final int? availableBerthCount;
  @override
  final double? minPricePerNight;

  @override
  String toString() {
    return 'Port(id: $id, name: $name, latitude: $latitude, longitude: $longitude, description: $description, contactEmail: $contactEmail, amenities: $amenities, availableBerthCount: $availableBerthCount, minPricePerNight: $minPricePerNight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            const DeepCollectionEquality().equals(
              other._amenities,
              _amenities,
            ) &&
            (identical(other.availableBerthCount, availableBerthCount) ||
                other.availableBerthCount == availableBerthCount) &&
            (identical(other.minPricePerNight, minPricePerNight) ||
                other.minPricePerNight == minPricePerNight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    latitude,
    longitude,
    description,
    contactEmail,
    const DeepCollectionEquality().hash(_amenities),
    availableBerthCount,
    minPricePerNight,
  );

  /// Create a copy of Port
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortImplCopyWith<_$PortImpl> get copyWith =>
      __$$PortImplCopyWithImpl<_$PortImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortImplToJson(this);
  }
}

abstract class _Port implements Port {
  const factory _Port({
    required final String id,
    required final String name,
    required final double latitude,
    required final double longitude,
    final String? description,
    required final String contactEmail,
    final List<String> amenities,
    final int? availableBerthCount,
    final double? minPricePerNight,
  }) = _$PortImpl;

  factory _Port.fromJson(Map<String, dynamic> json) = _$PortImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get description;
  @override
  String get contactEmail;
  @override
  List<String> get amenities;
  @override
  int? get availableBerthCount;
  @override
  double? get minPricePerNight;

  /// Create a copy of Port
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortImplCopyWith<_$PortImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
