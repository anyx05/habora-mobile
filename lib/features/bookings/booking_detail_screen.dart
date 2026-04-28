import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/models/booking.dart';
import 'package:myapp/core/providers/bookings_provider.dart';
import 'package:myapp/core/repositories/booking_repository.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';
import 'package:myapp/shared/widgets/loading_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows full details for a single booking — status, location, dates,
/// vessel, price and (for upcoming bookings) a cancel action.
class BookingDetailScreen extends ConsumerWidget {
  final String id;
  const BookingDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n        = AppLocalizations.of(context)!;
    final detailAsync = ref.watch(bookingDetailProvider(id));

    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        title:           Text(l10n.bookingDetails),
        backgroundColor: navyDeep,
        foregroundColor: Colors.white,
        elevation:       0,
      ),
      body: detailAsync.when(
        loading: () => const _LoadingSkeleton(),
        error:   (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.errorNetwork,
                    style: const TextStyle(color: slateGrey),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                AppButton(
                  label:      l10n.retry,
                  shrinkWrap: true,
                  onPressed:  () => ref.invalidate(bookingDetailProvider(id)),
                ),
              ],
            ),
          ),
        ),
        data: (detail) => _DetailBody(detail: detail, l10n: l10n),
      ),
    );
  }
}

// ── Body ────────────────────────────────────────────────────────────────────

class _DetailBody extends ConsumerWidget {
  final BookingWithRelated detail;
  final AppLocalizations l10n;

  const _DetailBody({required this.detail, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = detail.booking;
    final dateFmt = DateFormat('d MMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Confirmation code subtitle
          if (booking.confirmationCode != null &&
              booking.confirmationCode!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                booking.confirmationCode!,
                style: dmMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: slateGrey),
              ),
            ),

          // ── Status banner ─────────────────────────────────────────────
          _StatusBanner(booking: booking, l10n: l10n),
          const SizedBox(height: 16),

          // ── Location card ─────────────────────────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.portName,
                  style: GoogleFonts.dmSans(
                    fontSize: 18, fontWeight: FontWeight.w700, color: navyDeep,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:        tealPale,
                    borderRadius: BorderRadius.circular(radiusChip),
                  ),
                  child: Text(
                    detail.berthName,
                    style: GoogleFonts.dmSans(
                      fontSize: 12, fontWeight: FontWeight.w500, color: tealPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AppButton(
                  label:     l10n.getDirections,
                  variant:   AppButtonVariant.ghost,
                  icon:      Icons.directions_outlined,
                  shrinkWrap: true,
                  onPressed: () => _openMaps(
                    detail.portLatitude,
                    detail.portLongitude,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Dates card ────────────────────────────────────────────────
          _Card(
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      _DateCell(
                        label: l10n.arrivalDate,
                        value: dateFmt.format(booking.arrivalDate),
                      ),
                      const _VerticalDivider(),
                      _DateCell(
                        label: l10n.departureDate,
                        value: dateFmt.format(booking.departureDate),
                      ),
                      const _VerticalDivider(),
                      _DateCell(
                        label: l10n.nights,
                        value: '${booking.nights}',
                      ),
                    ],
                  ),
                ),
                const Divider(color: borderColor, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.checkInTime,
                        style:
                            GoogleFonts.dmSans(fontSize: 12, color: slateGrey)),
                    Text(l10n.checkOutTime,
                        style:
                            GoogleFonts.dmSans(fontSize: 12, color: slateGrey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Vessel card ───────────────────────────────────────────────
          Container(
            width:   double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:        navyLight,
              borderRadius: BorderRadius.circular(radiusCard),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.vesselName,
                  style: GoogleFonts.dmSans(
                    fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  [
                    'L: ${booking.vesselLengthM.toStringAsFixed(1)} m',
                    if (booking.vesselDraftM != null)
                      'D: ${booking.vesselDraftM!.toStringAsFixed(1)} m',
                  ].join('  '),
                  style: dmMono(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.60),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Price summary card ────────────────────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${booking.nights} nights'
                      ' × €${detail.berthPricePerNight.toStringAsFixed(0)}/night',
                      style: GoogleFonts.dmSans(
                          fontSize: 13, color: slateGrey),
                    ),
                    Text(
                      '€${(booking.totalPrice ?? detail.berthPricePerNight * booking.nights).toStringAsFixed(0)}',
                      style: GoogleFonts.dmSans(
                        fontSize:   16,
                        fontWeight: FontWeight.w700,
                        color:      navyDeep,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _PaymentBadge(status: booking.bookingStatus, l10n: l10n),
              ],
            ),
          ),

          // ── Cancel action (upcoming only) ─────────────────────────────
          if (booking.isUpcoming) ...[
            const SizedBox(height: 24),
            AppButton(
              label:     l10n.cancelBooking,
              variant:   AppButtonVariant.danger,
              onPressed: () => _showCancelDialog(context, ref, booking),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openMaps(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  Future<void> _showCancelDialog(
    BuildContext context,
    WidgetRef ref,
    Booking booking,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.cancelConfirmTitle,
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: navyDeep),
        ),
        content: Text(l10n.cancelConfirmBody,
            style: GoogleFonts.dmSans(color: slateGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.backAction),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.cancelBooking,
                style: const TextStyle(color: dangerRed)),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    try {
      await ref
          .read(bookingRepositoryProvider)
          .cancelBooking(booking.id);
      ref.invalidate(userBookingsProvider);
      ref.invalidate(bookingDetailProvider(booking.id));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.bookingCancelledSuccess,
              style: GoogleFonts.dmSans(color: Colors.white),
            ),
            backgroundColor: slateGrey,
          ),
        );
        context.pop();
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorNetwork,
                style: GoogleFonts.dmSans(color: Colors.white)),
            backgroundColor: dangerRed,
          ),
        );
      }
    }
  }
}

// ── Status banner ──────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final Booking booking;
  final AppLocalizations l10n;

  const _StatusBanner({required this.booking, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _style(booking, l10n);
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:        color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: color),
          const SizedBox(width: 10),
          Text(label,
              style: GoogleFonts.dmSans(
                  fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  (Color, String) _style(Booking b, AppLocalizations l10n) {
    if (b.bookingStatus.isCancelled) return (dangerRed,   l10n.tabCancelled);
    if (b.isPast)                    return (slateGrey,   l10n.bookingStatusCompleted);
    if (b.isUpcoming) {
      final days = b.arrivalDate.difference(DateTime.now()).inDays;
      return (amber, l10n.arrivingInDays(days.clamp(0, 9999)));
    }
    return (tealPrimary, l10n.currentlyBerthed);
  }
}

// ── Payment badge ──────────────────────────────────────────────────────────────

class _PaymentBadge extends StatelessWidget {
  final BookingStatus status;
  final AppLocalizations l10n;
  const _PaymentBadge({required this.status, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      BookingStatus.confirmed => (tealPrimary, l10n.paymentStatusPaid),
      BookingStatus.cancelled => (dangerRed,   l10n.tabCancelled),
      BookingStatus.pending   => (amber,       l10n.paymentStatusPending),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:        color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radiusChip),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
            fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

// ── Loading skeleton ───────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        children: [
          LoadingShimmer(height: 50, borderRadius: 12),
          const SizedBox(height: 12),
          LoadingShimmer(height: 120, borderRadius: radiusCard),
          const SizedBox(height: 12),
          LoadingShimmer(height: 110, borderRadius: radiusCard),
          const SizedBox(height: 12),
          LoadingShimmer(height: 80, borderRadius: radiusCard),
        ],
      ),
    );
  }
}

// ── Shared card wrapper ────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(radiusCard),
        border:       Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

// ── Date cell ──────────────────────────────────────────────────────────────────

class _DateCell extends StatelessWidget {
  final String label;
  final String value;

  const _DateCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.dmSans(
              fontSize: 10, fontWeight: FontWeight.w500,
              color: slateLight, letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.dmSans(
                fontSize: 13, fontWeight: FontWeight.w600, color: navyDeep,
              )),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color:  borderColor,
    );
  }
}
