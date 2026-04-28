import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/router.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/repositories/booking_exception.dart';
import 'package:myapp/features/bookings/booking_flow/booking_flow_controller.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';

/// Step 3 of the booking flow — summary card and final confirmation.
class Step3Confirm extends ConsumerWidget {
  const Step3Confirm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n  = AppLocalizations.of(context)!;
    final state = ref.watch(activeBookingFlowProvider);
    final dateFmt = DateFormat('d MMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Summary card ──────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color:        Colors.white,
              borderRadius: BorderRadius.circular(radiusCard),
              border:       Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                // Navy header
                Container(
                  width:  double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: const BoxDecoration(
                    color: navyDeep,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(radiusCard),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.portName ?? '—',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (state.berthName != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(radiusChip),
                          ),
                          child: Text(
                            state.berthName!,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Body rows
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: l10n.arrivalDate,
                        value: state.arrivalDate != null
                            ? dateFmt.format(state.arrivalDate!)
                            : '—',
                      ),
                      const _Divider(),
                      _SummaryRow(
                        label: l10n.departureDate,
                        value: state.departureDate != null
                            ? dateFmt.format(state.departureDate!)
                            : '—',
                      ),
                      const _Divider(),
                      _SummaryRow(
                        label: l10n.vesselName,
                        value: state.vesselName ?? '—',
                      ),
                      const _Divider(),
                      _SummaryRow(
                        label: l10n.fullName,
                        value: state.customerName ?? '—',
                      ),
                      const _Divider(),
                      _SummaryRow(
                        label: l10n.email,
                        value: state.customerEmail ?? '—',
                      ),
                    ],
                  ),
                ),

                // Price footer
                Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: borderColor)),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(radiusCard),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Text(
                        '${state.nights} nights'
                        ' × €${(state.berthPricePerNight ?? 0).toStringAsFixed(0)}/night',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: slateGrey,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '€${state.totalPrice.toStringAsFixed(0)}',
                        style: GoogleFonts.dmSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: navyDeep,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Error banner ─────────────────────────────────────────────────
          if (state.error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:        dangerRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border:       Border.all(color: dangerRed.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, size: 18, color: dangerRed),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: GoogleFonts.dmSans(
                          fontSize: 13, color: dangerRed),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),

          // ── Confirm button ───────────────────────────────────────────────
          AppButton(
            label:     l10n.confirmBooking(state.totalPrice),
            isLoading: state.isLoading,
            onPressed: state.isLoading
                ? null
                : () => _confirm(context, ref, l10n, state),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    BookingFlowState state,
  ) async {
    final notifier = ref.read(activeBookingFlowProvider.notifier);
    notifier.clearError();

    try {
      final booking = await notifier.submitBooking();
      if (booking == null) return;
      if (!context.mounted) return;
      context.go(
        Uri(
          path: Routes.bookingSuccess,
          queryParameters: {
            'bookingId': booking.id,
            'code':      booking.confirmationCode ?? '',
            'port':      state.portName  ?? '',
            'berth':     state.berthName ?? '',
            'arrival':   booking.arrivalDate.toIso8601String().substring(0, 10),
            'departure': booking.departureDate.toIso8601String().substring(0, 10),
            'total':     (booking.totalPrice ?? state.totalPrice).toStringAsFixed(2),
            'email':     booking.customerEmail,
          },
        ).toString(),
      );
    } on BookingException catch (e) {
      if (!context.mounted) return;
      final message = switch (e.code) {
        BookingErrorCode.berthNotFound    => l10n.bookingErrorBerthNotFound,
        BookingErrorCode.vesselTooLong    => l10n.bookingErrorVesselTooLong,
        BookingErrorCode.vesselTooDeep    => l10n.bookingErrorVesselTooDeep,
        BookingErrorCode.berthUnavailable => l10n.bookingErrorBerthUnavailable,
        BookingErrorCode.unknown          => l10n.errorNetwork,
      };
      await showDialog<void>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: Text(
            l10n.bookingFailed,
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: navyDeep),
          ),
          content: Text(message, style: GoogleFonts.dmSans(color: slateGrey)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(l10n.ok),
            ),
            if (e.code == BookingErrorCode.berthUnavailable)
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                  context.go(Routes.ports);
                },
                child: Text(l10n.findAnotherBerth),
              ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}

// ── Private helpers ────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label,
              style: GoogleFonts.dmSans(fontSize: 13, color: slateGrey)),
          const Spacer(),
          Text(value,
              style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: navyDeep)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(color: borderColor, height: 1);
}
