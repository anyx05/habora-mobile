import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/router.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';

/// Full-screen celebration screen shown after a booking is created.
///
/// Displays the confirmation code, booking summary, and navigation
/// actions. Receives all display data as constructor params from the
/// booking flow — no additional network calls are made here.
class BookingSuccessScreen extends StatelessWidget {
  final String bookingId;
  final String confirmationCode;
  final String portName;
  final String berthName;
  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final double totalPrice;
  final String customerEmail;

  const BookingSuccessScreen({
    super.key,
    required this.bookingId,
    this.confirmationCode = '',
    this.portName         = '',
    this.berthName        = '',
    this.arrivalDate,
    this.departureDate,
    this.totalPrice       = 0,
    this.customerEmail    = '',
  });

  @override
  Widget build(BuildContext context) {
    final l10n    = AppLocalizations.of(context)!;
    final dateFmt = DateFormat('d MMM yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Anchor icon ──────────────────────────────────────────────
              Container(
                width:  88,
                height: 88,
                decoration: const BoxDecoration(
                  color: tealPale,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.anchor, size: 44, color: tealPrimary),
              ),
              const SizedBox(height: 24),

              // ── Headline ─────────────────────────────────────────────────
              Text(
                l10n.bookingConfirmed,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize:   26,
                  fontWeight: FontWeight.w700,
                  color:      navyDeep,
                ),
              ),
              const SizedBox(height: 12),

              // ── Confirmation code ─────────────────────────────────────────
              if (confirmationCode.isNotEmpty) ...[
                Text(
                  confirmationCode,
                  style: dmMono(
                    fontSize:   22,
                    fontWeight: FontWeight.w700,
                    color:      tealPrimary,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Summary card ──────────────────────────────────────────────
              Container(
                width:  double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:        offWhite,
                  borderRadius: BorderRadius.circular(radiusCard),
                  border:       Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    if (portName.isNotEmpty)
                      _SummaryRow(
                        icon:  Icons.location_on_outlined,
                        label: portName,
                        sub:   berthName.isNotEmpty ? berthName : null,
                      ),
                    if (portName.isNotEmpty) const SizedBox(height: 16),

                    if (arrivalDate != null && departureDate != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.date_range_outlined,
                              size: 16, color: slateGrey),
                          const SizedBox(width: 10),
                          Text(
                            '${dateFmt.format(arrivalDate!)} → ${dateFmt.format(departureDate!)}',
                            style: GoogleFonts.dmSans(
                                fontSize: 13, color: navyDeep),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (totalPrice > 0)
                      Row(
                        children: [
                          const Icon(Icons.payments_outlined,
                              size: 16, color: slateGrey),
                          const SizedBox(width: 10),
                          Text(
                            '€${totalPrice.toStringAsFixed(0)} total',
                            style: GoogleFonts.dmSans(
                              fontSize:   14,
                              fontWeight: FontWeight.w700,
                              color:      navyDeep,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Email note ────────────────────────────────────────────────
              if (customerEmail.isNotEmpty)
                Text(
                  l10n.confirmationEmailSent(customerEmail),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(fontSize: 12, color: slateGrey),
                ),

              const SizedBox(height: 36),

              // ── Actions ───────────────────────────────────────────────────
              AppButton(
                label:     l10n.viewBooking,
                onPressed: () => context.goNamed(
                  'bookingDetail',
                  pathParameters: {'id': bookingId},
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label:     l10n.findMorePorts,
                variant:   AppButtonVariant.ghost,
                onPressed: () => context.go(Routes.ports),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;

  const _SummaryRow({required this.icon, required this.label, this.sub});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: slateGrey),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.dmSans(
                    fontSize: 14, fontWeight: FontWeight.w600, color: navyDeep,
                  )),
              if (sub != null)
                Text(sub!,
                    style:
                        GoogleFonts.dmSans(fontSize: 12, color: slateGrey)),
            ],
          ),
        ),
      ],
    );
  }
}
