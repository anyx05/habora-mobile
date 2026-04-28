import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/berth.dart';
import '../supabase/supabase_client.dart';
import 'port_repository.dart';

abstract class BerthRepository {
  Future<List<Berth>> getAvailableBerths({
    required String portId,
    required DateTime arrival,
    required DateTime departure,
    double? vesselLength,
    double? vesselDraft,
  });

  Future<Berth> getBerthById(String berthId);
}

class SupabaseBerthRepository implements BerthRepository {
  @override
  Future<Berth> getBerthById(String berthId) async {
    try {
      final data = await supabase
          .from('berths')
          .select()
          .eq('id', berthId)
          .single();
      return Berth.fromJson(data);
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }

  @override
  Future<List<Berth>> getAvailableBerths({
    required String portId,
    required DateTime arrival,
    required DateTime departure,
    double? vesselLength,
    double? vesselDraft,
  }) async {
    try {
      // Availability is determined by the RPC, not by berths.status.
      // The status column ('available'/'occupied'/'maintenance') is owned by
      // the port-operator dashboard and must never be used here.
      // Any direct query on the berths table elsewhere must use
      //   .eq('is_active', true)
      // — NOT .eq('status', 'available') — to exclude soft-deleted berths.
      final data = await supabase.rpc('check_berth_availability', params: {
        'p_port_id':      portId,
        'p_arrival':      arrival.toIso8601String().substring(0, 10),
        'p_departure':    departure.toIso8601String().substring(0, 10),
        'p_vessel_length': vesselLength ?? 0,
        'p_vessel_draft':  vesselDraft ?? 0,
      });

      return (data as List)
          .map((e) => Berth.fromJson(e as Map<String, dynamic>))
          .where((b) => b.isActive)   // defensive: exclude soft-deleted berths
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }
}
