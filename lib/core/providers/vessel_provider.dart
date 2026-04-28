import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/vessel.dart';
import '../repositories/vessel_repository.dart';
import 'auth_provider.dart';

final vesselRepositoryProvider = Provider<VesselRepository>(
  (_) => SupabaseVesselRepository(),
);

final userVesselsProvider = FutureProvider<List<Vessel>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final repo = ref.watch(vesselRepositoryProvider);
  return repo.getUserVessels(user.id);
});

final selectedVesselProvider = StateProvider<Vessel?>((_) => null);
