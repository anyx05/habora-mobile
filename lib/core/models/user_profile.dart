import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

const String roleVesselOperator = 'vessel_operator';
const String rolePortOperator = 'port_operator';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'full_name') String? fullName,
    required String role,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
