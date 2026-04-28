import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vessel.dart';
import '../supabase/supabase_client.dart';
import 'port_repository.dart';

class CreateVesselRequest {
  final String ownerId;
  final String name;
  final String type;
  final double lengthM;
  final double? draftM;
  final double? beamM;

  const CreateVesselRequest({
    required this.ownerId,
    required this.name,
    required this.type,
    required this.lengthM,
    this.draftM,
    this.beamM,
  });

  Map<String, dynamic> toJson() => {
        'owner_id': ownerId,
        'name': name,
        'type': type,
        'length_m': lengthM,
        if (draftM != null) 'draft_m': draftM,
        if (beamM != null) 'beam_m': beamM,
      };
}

abstract class VesselRepository {
  Future<List<Vessel>> getUserVessels(String userId);
  Future<Vessel> createVessel(CreateVesselRequest request);
  Future<void> deleteVessel(String vesselId, {required String ownerId});
}

class SupabaseVesselRepository implements VesselRepository {
  @override
  Future<List<Vessel>> getUserVessels(String userId) async {
    try {
      final data = await supabase
          .from('vessels')
          .select()
          .eq('owner_id', userId)
          .order('name');
      return (data as List).map((e) => Vessel.fromJson(e as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }

  @override
  Future<Vessel> createVessel(CreateVesselRequest request) async {
    try {
      final data = await supabase
          .from('vessels')
          .insert(request.toJson())
          .select()
          .single();
      return Vessel.fromJson(data);
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteVessel(String vesselId, {required String ownerId}) async {
    try {
      await supabase
          .from('vessels')
          .delete()
          .eq('id', vesselId)
          .eq('owner_id', ownerId);
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }
}
