import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/port_availability.dart';

/// Small pill badge showing berth availability in the appropriate brand colour.
///
/// Colours follow the design tokens:
/// * available → teal text on tealPale background
/// * limited   → amber text on amber-tinted background
/// * full      → dangerRed text on red-tinted background
class BerthAvailabilityBadge extends StatelessWidget {
  final PortAvailability status;

  const BerthAvailabilityBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final label = switch (status) {
      PortAvailability.available => l10n.availabilityAvailable,
      PortAvailability.limited   => l10n.availabilityLimited,
      PortAvailability.full      => l10n.availabilityFull,
    };

    final color = availabilityColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radiusChip),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
