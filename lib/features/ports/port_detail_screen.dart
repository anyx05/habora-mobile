import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/models/berth.dart';
import 'package:myapp/core/models/port.dart';
import 'package:myapp/core/providers/bookings_provider.dart';
import 'package:myapp/core/providers/ports_provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';
import 'package:myapp/shared/widgets/berth_availability_badge.dart';
import 'package:myapp/shared/widgets/loading_shimmer.dart';
import 'package:myapp/shared/widgets/port_availability.dart';
import 'package:myapp/shared/widgets/section_header.dart';

/// Full-page detail view for a single port, navigated to via /ports/:id.
///
/// Fetches the port record by id, then allows the user to pick a date range
/// to see available berths. Each berth card offers a direct link into the
/// booking flow.
class PortDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const PortDetailScreen({super.key, required this.id});

  @override
  ConsumerState<PortDetailScreen> createState() => _PortDetailScreenState();
}

class _PortDetailScreenState extends ConsumerState<PortDetailScreen> {
  DateTime? _arrival;
  DateTime? _departure;

  Future<void> _pickDates() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _arrival != null && _departure != null
          ? DateTimeRange(start: _arrival!, end: _departure!)
          : null,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
                primary: tealPrimary,
                onPrimary: Colors.white,
              ),
        ),
        child: child!,
      ),
    );
    if (range != null && mounted) {
      setState(() {
        _arrival = range.start;
        _departure = range.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final portAsync = ref.watch(portByIdProvider(widget.id));

    return portAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(backgroundColor: navyDeep, foregroundColor: Colors.white),
        body: const Center(child: CircularProgressIndicator(color: tealPrimary)),
      ),
      error: (_, __) => Scaffold(
        appBar: AppBar(backgroundColor: navyDeep, foregroundColor: Colors.white),
        body: Center(
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
                  label: l10n.retry,
                  shrinkWrap: true,
                  onPressed: () =>
                      ref.invalidate(portByIdProvider(widget.id)),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (port) => _PortBody(
        port: port,
        arrival: _arrival,
        departure: _departure,
        onPickDates: _pickDates,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body — renders after port is loaded
// ---------------------------------------------------------------------------

class _PortBody extends ConsumerWidget {
  final Port port;
  final DateTime? arrival;
  final DateTime? departure;
  final VoidCallback onPickDates;

  const _PortBody({
    required this.port,
    required this.arrival,
    required this.departure,
    required this.onPickDates,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(port.name),
        backgroundColor: navyDeep,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _PortHeader(port: port)),
          SliverToBoxAdapter(child: _InfoSection(port: port, l10n: l10n)),
          if (port.amenities.isNotEmpty)
            SliverToBoxAdapter(
                child: _AmenitiesSection(amenities: port.amenities)),
          SliverToBoxAdapter(
            child: _DatePickerSection(
              l10n: l10n,
              arrival: arrival,
              departure: departure,
              onPickDates: onPickDates,
            ),
          ),
          _BerthsSliver(
            port: port,
            arrival: arrival,
            departure: departure,
            l10n: l10n,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header — navy gradient with port name and coordinates
// ---------------------------------------------------------------------------

class _PortHeader extends StatelessWidget {
  final Port port;

  const _PortHeader({required this.port});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [navyLight, navyDeep],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -24,
            child: Icon(
              Icons.anchor,
              size: 180,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  port.name,
                  style: GoogleFonts.dmSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: Colors.white54),
                    const SizedBox(width: 4),
                    Text(
                      '${port.latitude.toStringAsFixed(4)}°N  '
                      '${port.longitude.toStringAsFixed(4)}°E',
                      style: GoogleFonts.dmMono(
                          fontSize: 11, color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info — contact email + availability badge
// ---------------------------------------------------------------------------

class _InfoSection extends StatelessWidget {
  final Port port;
  final AppLocalizations l10n;

  const _InfoSection({required this.port, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mail_outline, size: 16, color: slateGrey),
              const SizedBox(width: 8),
              Text(
                port.contactEmail,
                style: GoogleFonts.dmSans(fontSize: 14, color: slateGrey),
              ),
            ],
          ),
          if (port.description != null && port.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              port.description!,
              style: GoogleFonts.dmSans(fontSize: 14, color: navyDeep, height: 1.5),
            ),
          ],
          if (port.availableBerthCount != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                BerthAvailabilityBadge(
                  status: availabilityFromCount(port.availableBerthCount),
                ),
                const SizedBox(width: 10),
                Text(
                  '${port.availableBerthCount} ${l10n.availableBerths.toLowerCase()}',
                  style: GoogleFonts.dmSans(fontSize: 14, color: slateGrey),
                ),
              ],
            ),
          ],
          if (port.minPricePerNight != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.fromPricePerNight(port.minPricePerNight!),
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: tealPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Amenities chips
// ---------------------------------------------------------------------------

class _AmenitiesSection extends StatelessWidget {
  final List<String> amenities;

  const _AmenitiesSection({required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: amenities
            .map(
              (a) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tealPale,
                  borderRadius: BorderRadius.circular(radiusChip),
                  border: Border.all(
                      color: tealPrimary.withValues(alpha: 0.25)),
                ),
                child: Text(
                  a,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: tealPrimary,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Date picker row
// ---------------------------------------------------------------------------

class _DatePickerSection extends StatelessWidget {
  final AppLocalizations l10n;
  final DateTime? arrival;
  final DateTime? departure;
  final VoidCallback onPickDates;

  const _DatePickerSection({
    required this.l10n,
    required this.arrival,
    required this.departure,
    required this.onPickDates,
  });

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final hasRange = arrival != null && departure != null;
    final label =
        hasRange ? '${_fmt(arrival!)}  →  ${_fmt(departure!)}' : l10n.selectDates;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(label: l10n.availableBerths),
          const SizedBox(height: 12),
          InkWell(
            onTap: onPickDates,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(12),
                color: offWhite,
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range_outlined,
                      size: 18, color: slateGrey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: hasRange ? navyDeep : slateLight,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 18, color: slateLight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Berths list sliver — only fetches when dates are selected
// ---------------------------------------------------------------------------

class _BerthsSliver extends ConsumerWidget {
  final Port port;
  final DateTime? arrival;
  final DateTime? departure;
  final AppLocalizations l10n;

  const _BerthsSliver({
    required this.port,
    required this.arrival,
    required this.departure,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (arrival == null || departure == null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text(
            l10n.selectDates,
            style: GoogleFonts.dmSans(fontSize: 14, color: slateLight),
          ),
        ),
      );
    }

    final query = BerthQuery(
      portId: port.id,
      arrival: arrival!,
      departure: departure!,
    );
    final berthsAsync = ref.watch(berthAvailabilityProvider(query));

    return berthsAsync.when(
      loading: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: LoadingShimmer(height: 130, borderRadius: radiusCard),
          ),
          childCount: 3,
        ),
      ),
      error: (_, __) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text(
            l10n.errorNetwork,
            style: GoogleFonts.dmSans(fontSize: 14, color: dangerRed),
          ),
        ),
      ),
      data: (berths) {
        if (berths.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  const Icon(Icons.anchor, size: 40, color: slateLight),
                  const SizedBox(height: 12),
                  Text(l10n.noPortsFound,
                      style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: navyDeep)),
                  const SizedBox(height: 4),
                  Text(l10n.tryAdjustingFilters,
                      style:
                          GoogleFonts.dmSans(fontSize: 13, color: slateGrey)),
                ],
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _BerthCard(
              berth:     berths[i],
              portId:    port.id,
              portName:  port.name,
              arrival:   arrival!,
              departure: departure!,
              l10n:      l10n,
            ),
            childCount: berths.length,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Individual berth card
// ---------------------------------------------------------------------------

class _BerthCard extends StatelessWidget {
  final Berth berth;
  final String portId;
  final String portName;
  final DateTime arrival;
  final DateTime departure;
  final AppLocalizations l10n;

  const _BerthCard({
    required this.berth,
    required this.portId,
    required this.portName,
    required this.arrival,
    required this.departure,
    required this.l10n,
  });

  int get _nights => departure.difference(arrival).inDays.clamp(1, 365);

  @override
  Widget build(BuildContext context) {
    final total = berth.pricePerNight * _nights;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radiusCard),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    berth.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: navyDeep,
                    ),
                  ),
                ),
                const BerthAvailabilityBadge(
                    status: PortAvailability.available),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'max ${berth.maxLengthM.toStringAsFixed(0)} m · '
              'draft ${berth.maxDraftM.toStringAsFixed(1)} m'
              '${berth.maxBeamM != null ? ' · beam ${berth.maxBeamM!.toStringAsFixed(1)} m' : ''}',
              style: GoogleFonts.dmMono(fontSize: 12, color: slateGrey),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '€${berth.pricePerNight.toStringAsFixed(0)}/night',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: tealPrimary,
                        ),
                      ),
                      Text(
                        '€${total.toStringAsFixed(0)} total · $_nights nights',
                        style:
                            GoogleFonts.dmSans(fontSize: 12, color: slateGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppButton(
              label: l10n.bookThisBerth,
              onPressed: () => context.pushNamed(
                'bookingNew',
                queryParameters: {
                  'berthId':    berth.id,
                  'portId':     portId,
                  'berthName':  berth.name,
                  'portName':   portName,
                  'berthPrice': berth.pricePerNight.toStringAsFixed(2),
                  'arrival':    arrival.toIso8601String().substring(0, 10),
                  'departure':  departure.toIso8601String().substring(0, 10),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
