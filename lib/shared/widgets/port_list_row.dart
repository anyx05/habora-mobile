import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/models/port.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/port_availability.dart';

/// A single row in a port list — availability dot, name, meta info, price.
///
/// [distanceKm] and [maxLengthM] are optional display values that cannot be
/// derived from the [Port] model alone; omit them to suppress those segments
/// of the meta line.
///
/// Tapping anywhere in the row calls [onTap].
class PortListRow extends StatelessWidget {
  final Port port;
  final VoidCallback onTap;

  /// Distance from the user's current position, displayed as "X.X km".
  final double? distanceKm;

  /// Maximum vessel length accepted across all berths at this port, in metres.
  final double? maxLengthM;

  const PortListRow({
    super.key,
    required this.port,
    required this.onTap,
    this.distanceKm,
    this.maxLengthM,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final availability = availabilityFromCount(port.availableBerthCount);
    final dotColor = availabilityColor(availability);

    final metaParts = <String>[
      if (distanceKm != null)
        l10n.distanceKm(distanceKm!.toStringAsFixed(1)),
      if (port.availableBerthCount != null)
        '${port.availableBerthCount} free',
      if (maxLengthM != null)
        'max ${maxLengthM!.toStringAsFixed(0)} m',
    ];

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Availability dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
                const SizedBox(width: 12),

                // Port name + meta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        port.name,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: navyDeep,
                        ),
                      ),
                      if (metaParts.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          metaParts.join(' · '),
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: slateGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Price
                if (port.minPricePerNight != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    l10n.fromPricePerNight(port.minPricePerNight!),
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: tealPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: borderColor),
        ],
      ),
    );
  }
}
