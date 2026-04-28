import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/models/vessel.dart';

/// A compact card displaying a [Vessel]'s details on a navy background.
///
/// Shows a type-appropriate emoji, the vessel name in bold white, and key
/// specs (length, draft, beam) in DM Mono. Supply [onDelete] to show a
/// trailing delete icon; supply [onTap] to make the whole card tappable.
class VesselCard extends StatelessWidget {
  final Vessel vessel;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const VesselCard({
    super.key,
    required this.vessel,
    this.onTap,
    this.onDelete,
  });

  String get _emoji {
    switch (vessel.type.toLowerCase()) {
      case 'sailboat':
        return '⛵';
      case 'motorboat':
        return '🚤';
      case 'catamaran':
        return '⛵';
      case 'water_taxi':
      case 'watertaxi':
        return '⛴';
      default:
        return '🚢';
    }
  }

  String _specsLine() {
    final parts = <String>['L: ${vessel.lengthM.toStringAsFixed(1)} m'];
    if (vessel.draftM != null) {
      parts.add('D: ${vessel.draftM!.toStringAsFixed(1)} m');
    }
    if (vessel.beamM != null) {
      parts.add('B: ${vessel.beamM!.toStringAsFixed(1)} m');
    }
    return parts.join('  ');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: navyLight,
          borderRadius: BorderRadius.circular(radiusCard),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Emoji avatar
            Text(
              _emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 14),

            // Name + specs
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vessel.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _specsLine(),
                    style: dmMono(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.60),
                    ),
                  ),
                ],
              ),
            ),

            // Optional delete icon
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
