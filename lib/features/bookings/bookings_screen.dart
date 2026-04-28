import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/router.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/providers/bookings_provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';
import 'package:myapp/shared/widgets/booking_card.dart';
import 'package:myapp/shared/widgets/loading_shimmer.dart';

/// Bookings tab — three-tab layout (Upcoming / Past / Cancelled).
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: offWhite,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.myBookings,
                      style: GoogleFonts.dmSans(
                        fontSize:   24,
                        fontWeight: FontWeight.w700,
                        color:      navyDeep,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.bookingsSubtitle,
                      style: GoogleFonts.dmSans(
                          fontSize: 13, color: slateGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Tab bar ─────────────────────────────────────────────────
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor)),
                ),
                child: TabBar(
                  labelColor:         tealPrimary,
                  unselectedLabelColor: slateGrey,
                  indicatorColor:     tealPrimary,
                  indicatorWeight:    2,
                  labelStyle: GoogleFonts.dmSans(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  unselectedLabelStyle:
                      GoogleFonts.dmSans(fontSize: 14),
                  tabs: [
                    Tab(text: l10n.tabUpcoming),
                    Tab(text: l10n.tabPast),
                    Tab(text: l10n.tabCancelled),
                  ],
                ),
              ),

              // ── Tab views ───────────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  children: [
                    _BookingsList(
                      category:       'upcoming',
                      emptyIcon:      Icons.anchor_outlined,
                      emptyMessage:   l10n.noUpcomingBookings,
                      showFindPort:   true,
                      l10n:           l10n,
                    ),
                    _BookingsList(
                      category:     'past',
                      emptyIcon:    Icons.history,
                      emptyMessage: l10n.noTripsYet,
                      l10n:         l10n,
                    ),
                    _BookingsList(
                      category:     'cancelled',
                      emptyIcon:    Icons.cancel_outlined,
                      emptyMessage: l10n.noCancellations,
                      l10n:         l10n,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bookings list for one tab ──────────────────────────────────────────────────

class _BookingsList extends ConsumerWidget {
  final String category;
  final IconData emptyIcon;
  final String emptyMessage;
  final bool showFindPort;
  final AppLocalizations l10n;

  const _BookingsList({
    required this.category,
    required this.emptyIcon,
    required this.emptyMessage,
    this.showFindPort = false,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsByStatusProvider(category));

    return bookingsAsync.when(
      loading: () => _shimmerList(),
      error:   (_, __) => _errorState(context, ref, l10n),
      data:    (bookings) {
        if (bookings.isEmpty) return _emptyState(context, l10n);
        return ListView.separated(
          padding:   const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: bookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final booking = bookings[i];
            return BookingCard(
              booking: booking,
              onTap:   () => context.pushNamed(
                'bookingDetail',
                pathParameters: {'id': booking.id},
              ),
            );
          },
        );
      },
    );
  }

  Widget _shimmerList() {
    return ListView.separated(
      padding:   const EdgeInsets.fromLTRB(16, 16, 16, 0),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => LoadingShimmer(height: 148, borderRadius: radiusCard),
    );
  }

  Widget _errorState(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Center(
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
              onPressed:  () => ref.invalidate(userBookingsProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(emptyIcon, size: 48, color: slateLight),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize:   16,
                fontWeight: FontWeight.w600,
                color:      navyDeep,
              ),
            ),
            if (showFindPort) ...[
              const SizedBox(height: 16),
              AppButton(
                label:      l10n.findAPort,
                shrinkWrap: true,
                onPressed:  () => context.go(Routes.ports),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
