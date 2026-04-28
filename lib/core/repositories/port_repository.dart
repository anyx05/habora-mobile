import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/port.dart';
import '../supabase/supabase_client.dart';

class RepositoryException implements Exception {
  final String message;
  final String? code;
  RepositoryException(this.message, {this.code});

  @override
  String toString() => 'RepositoryException($code): $message';
}

abstract class PortRepository {
  Future<List<Port>> searchPorts({
    required double lat,
    required double lng,
    required int radiusKm,
    double? vesselLength,
    double? vesselDraft,
    DateTime? arrival,
    DateTime? departure,
  });

  Future<Port> getPortById(String id);

  Future<List<Port>> getSavedPorts(String userId);
}

class SupabasePortRepository implements PortRepository {
  @override
  Future<List<Port>> searchPorts({
    required double lat,
    required double lng,
    required int radiusKm,
    double? vesselLength,
    double? vesselDraft,
    DateTime? arrival,
    DateTime? departure,
  }) async {
    try {
      final data = await supabase.rpc('find_ports_near', params: {
        'p_lat': lat,
        'p_lng': lng,
        'p_radius_km': radiusKm,
        'p_vessel_length': vesselLength ?? 0,
        'p_vessel_draft': vesselDraft ?? 0,
      });
      return (data as List).map((e) => Port.fromJson(e as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }

  @override
  Future<Port> getPortById(String id) async {
    try {
      final data = await supabase
          .from('ports')
          .select()
          .eq('id', id)
          .single();
      return Port.fromJson(data);
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }

  @override
  Future<List<Port>> getSavedPorts(String userId) async {
    try {
      final box = Hive.box<List>('saved_ports');
      final raw = box.get(userId);
      final portIds =
          raw != null ? List<String>.from(raw) : <String>[];
      if (portIds.isEmpty) return [];
      final data = await supabase
          .from('ports')
          .select()
          .inFilter('id', portIds);
      return (data as List)
          .map((e) => Port.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, code: e.code);
    } catch (e) {
      throw RepositoryException('Unexpected error: $e');
    }
  }
}
