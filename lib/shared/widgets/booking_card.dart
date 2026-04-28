import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/models/booking.dart';
import 'package:myapp/l10n/app_localizations.dart';

/// A card summarising a [Booking] with a navy header, date/vessel body row,
/// and a berth-chip + price footer.
///
/// Status badge colour is derived from the booking's computed getters:
/// * upcoming  (pending / confirmed, arrival in future) → amber
/// * active    (confirmed, currently ongoing)           → tealPrimary
/// * past      (confirmed, departure in past)           → slateGrey
/// * cancelled                                          → dangerRed
///
/// [portName] and [berthName] are shown in the header and footer respectively.
/// Both are optional — pass them from the calling screen once you have resolved
/// the related berth/port objects.
class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;

  /// Port name shown as the card headline. Defaults to the confirmation code.
  final String? portName;

  /// Berth name shown as a chip in the footer.
  final String? berthName;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
    this.portName,
    this.berthName,
  });

  // ── status helpers ──────────────────────────────────────────────────────────

  _StatusStyle _statusStyle(Booking booking, AppLocalizations l10n) {
    if (booking.bookingStatus.isCancelled) {
      return _StatusStyle(label: l10n.tabCancelled, color: dangerRed);
    }
    if (booking.isPast) {
      return _StatusStyle(label: l10n.tabPast, color: slateGrey);
    }
    if (booking.isUpcoming) {
      return _StatusStyle(label: l10n.tabUpcoming, color: amber);
    }
    // Confirmed and currently ongoing: arrival passed but departure is still future
    return _StatusStyle(label: l10n.bookingStatusActive, color: tealPrimary);
  }

  // ── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFmt = DateFormat('d MMM');
    final s = _statusStyle(booking, l10n);

    final headline = portName?.isNotEmpty == true
        ? portName!
        : (booking.confirmationCode ?? '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusCard),
          border: Border.all(color: borderColor),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Navy header ─────────────────────────────────────────────────
            Container(
              color: navyDeep,
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Port name + confirmation code
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headline,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        if (booking.confirmationCode != null &&
                            booking.confirmationCode!.isNotEmpty)
                          Text(
                            booking.confirmationCode!,
                            style: dmMono(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.55),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Status badge
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(radiusChip),
                    ),
                    child: Text(
                      s.label,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: s.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── White body ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date / nights row
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        _DateCell(
                          topLabel: 'Arrival',
                          value: dateFmt.format(booking.arrivalDate),
                        ),
                        const _Divider(),
                        _DateCell(
                          topLabel: 'Departure',
                          value: dateFmt.format(booking.departureDate),
                        ),
                        const _Divider(),
                        _DateCell(
                          topLabel: 'Nights',
                          value: l10n.nightsCount(booking.nights),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Vessel name + length
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_boat_outlined,
                        size: 14,
                        color: slateGrey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          booking.vesselName,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: navyDeep,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${booking.vesselLengthM.toStringAsFixed(1)} m',
                        style: dmMono(fontSize: 12, color: slateGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Footer ──────────────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: borderColor),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Berth chip
                  if (berthName != null && berthName!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tealPale,
                        borderRadius: BorderRadius.circular(radiusChip),
                      ),
                      child: Text(
                        berthName!,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: tealPrimary,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Total price
                  Text(
                    '€${(booking.totalPrice ?? 0).toStringAsFixed(0)}',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: navyDeep,
                    ),
                  ),
                  Text(
                    ' total',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: slateGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _StatusStyle {
  final String label;
  final Color color;
  const _StatusStyle({required this.label, required this.color});
}

class _DateCell extends StatelessWidget {
  final String topLabel;
  final String value;

  const _DateCell({required this.topLabel, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topLabel.toUpperCase(),
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: slateLight,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: navyDeep,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: borderColor,
    );
  }
}
