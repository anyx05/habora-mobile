import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/models/port.dart';
import 'package:myapp/core/providers/ports_provider.dart';
import 'package:myapp/features/ports/widgets/filter_sheet.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/shared/widgets/app_button.dart';
import 'package:myapp/shared/widgets/berth_availability_badge.dart';
import 'package:myapp/shared/widgets/loading_shimmer.dart';
import 'package:myapp/shared/widgets/port_availability.dart';
import 'package:myapp/shared/widgets/port_list_row.dart';
import 'package:myapp/shared/widgets/port_marker.dart';

/// Main Ports tab — full-bleed FlutterMap with a draggable bottom sheet.
///
/// The map shows a [PortMarker] for every port returned by
/// [portsResultsProvider]. Tapping a marker selects it, moves the camera,
/// and expands the bottom sheet to a port-preview card. The sheet also
/// contains a sortable list of all ports.
class PortsScreen extends ConsumerStatefulWidget {
  const PortsScreen({super.key});

  @override
  ConsumerState<PortsScreen> createState() => _PortsScreenState();
}

class _PortsScreenState extends ConsumerState<PortsScreen> {
  final _mapController = MapController();
  final _sheetController = DraggableScrollableController();

  // Local sort state — does not affect the API query
  _PortFilter _activeFilter = _PortFilter.nearest;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _onMarkerTap(Port port) {
    _mapController.move(LatLng(port.latitude, port.longitude), 10.0);
    ref.read(selectedPortProvider.notifier).state = port;
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        0.6,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
      );
    }
  }

  void _deselect() {
    ref.read(selectedPortProvider.notifier).state = null;
  }

  List<Marker> _buildMarkers(List<Port> ports) {
    return ports
        .map(
          (port) => Marker(
            point: LatLng(port.latitude, port.longitude),
            width: 44,
            height: 44,
            child: PortMarker(
              availability: availabilityFromCount(port.availableBerthCount),
              onTap: () => _onMarkerTap(port),
            ),
          ),
        )
        .toList();
  }

  List<Port> _sorted(List<Port> ports) {
    return switch (_activeFilter) {
      _PortFilter.nearest => ports,
      _PortFilter.available =>
        ports.where((p) => (p.availableBerthCount ?? 1) > 0).toList(),
      _PortFilter.price => [...ports]
        ..sort((a, b) => (a.minPricePerNight ?? 99999)
            .compareTo(b.minPricePerNight ?? 99999)),
      _PortFilter.saved => ports,
    };
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final portsAsync = ref.watch(portsResultsProvider);
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Stack(
        children: [
          // ── Full-bleed map ──────────────────────────────────────────────
          portsAsync.when(
            loading: () => _buildMap([]),
            error: (_, __) => _buildMap([]),
            data: _buildMap,
          ),

          // ── Search bar overlay ──────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _SearchBar(onFilterTap: _openFilterSheet),
            ),
          ),

          // ── Map controls (top-right, below search bar) ──────────────────
          Positioned(
            right: 16,
            bottom: screenHeight * 0.32 + 8,
            child: _MapControls(mapController: _mapController),
          ),

          // ── Availability legend (bottom-left, above sheet) ──────────────
          Positioned(
            left: 16,
            bottom: screenHeight * 0.32 + 8,
            child: const _AvailabilityLegend(),
          ),

          // ── Draggable bottom sheet ──────────────────────────────────────
          DraggableScrollableSheet(
            controller: _sheetController,
            minChildSize: 0.30,
            maxChildSize: 0.85,
            initialChildSize: 0.35,
            snap: true,
            snapSizes: const [0.35, 0.6, 0.85],
            builder: (context, scrollController) {
              return _PortsSheet(
                scrollController: scrollController,
                portsAsync: portsAsync,
                activeFilter: _activeFilter,
                onFilterChange: (f) => setState(() => _activeFilter = f),
                onPortTap: _onMarkerTap,
                onDeselect: _deselect,
                sortedPorts: portsAsync.valueOrNull != null
                    ? _sorted(portsAsync.valueOrNull!)
                    : [],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMap(List<Port> ports) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(59.437, 24.745),
        initialZoom: 7.0,
        minZoom: 5.0,
        maxZoom: 14.0,
        onTap: (_, __) => _deselect(),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'ee.sadamaagent.app',
        ),
        MarkerLayer(markers: _buildMarkers(ports)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Search bar
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  final VoidCallback onFilterTap;

  const _SearchBar({required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: navyDeep.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search, size: 20, color: slateGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.searchHint,
              style: GoogleFonts.dmSans(fontSize: 14, color: slateLight),
            ),
          ),
          Container(width: 1, height: 24, color: borderColor),
          IconButton(
            onPressed: onFilterTap,
            icon: const Icon(Icons.tune, size: 20, color: navyDeep),
            tooltip: 'Filters',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Map controls — zoom in / zoom out
// ---------------------------------------------------------------------------

class _MapControls extends StatelessWidget {
  final MapController mapController;

  const _MapControls({required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MapButton(
          icon: Icons.add,
          onTap: () => mapController.move(
            mapController.camera.center,
            (mapController.camera.zoom + 1).clamp(5.0, 14.0),
          ),
        ),
        const SizedBox(height: 4),
        _MapButton(
          icon: Icons.remove,
          onTap: () => mapController.move(
            mapController.camera.center,
            (mapController.camera.zoom - 1).clamp(5.0, 14.0),
          ),
        ),
      ],
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: navyDeep.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: navyDeep),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Availability legend
// ---------------------------------------------------------------------------

class _AvailabilityLegend extends StatelessWidget {
  const _AvailabilityLegend();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: navyDeep.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendRow(color: tealPrimary, label: l10n.availabilityAvailable),
          const SizedBox(height: 4),
          _LegendRow(color: amber,       label: l10n.availabilityLimited),
          const SizedBox(height: 4),
          _LegendRow(color: dangerRed,   label: l10n.availabilityFull),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.dmSans(fontSize: 10, color: slateGrey),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom sheet
// ---------------------------------------------------------------------------

enum _PortFilter { nearest, available, price, saved }

class _PortsSheet extends ConsumerWidget {
  final ScrollController scrollController;
  final AsyncValue<List<Port>> portsAsync;
  final List<Port> sortedPorts;
  final _PortFilter activeFilter;
  final ValueChanged<_PortFilter> onFilterChange;
  final void Function(Port) onPortTap;
  final VoidCallback onDeselect;

  const _PortsSheet({
    required this.scrollController,
    required this.portsAsync,
    required this.sortedPorts,
    required this.activeFilter,
    required this.onFilterChange,
    required this.onPortTap,
    required this.onDeselect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPort = ref.watch(selectedPortProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(radiusBottomSheet),
        ),
        boxShadow: [
          BoxShadow(
            color: navyDeep.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: selectedPort != null
          ? _SelectedPortView(
              scrollController: scrollController,
              port: selectedPort,
              onDeselect: onDeselect,
            )
          : _PortListView(
              scrollController: scrollController,
              portsAsync: portsAsync,
              sortedPorts: sortedPorts,
              activeFilter: activeFilter,
              onFilterChange: onFilterChange,
              onPortTap: onPortTap,
              onRetry: () => ref.invalidate(portsResultsProvider),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Selected port preview card inside the sheet
// ---------------------------------------------------------------------------

class _SelectedPortView extends StatelessWidget {
  final ScrollController scrollController;
  final Port port;
  final VoidCallback onDeselect;

  const _SelectedPortView({
    required this.scrollController,
    required this.port,
    required this.onDeselect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        _SheetHandle(),
        // Port photo placeholder
        Stack(
          children: [
            Container(
              height: 130,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [navyLight, navyDeep],
                ),
                borderRadius: BorderRadius.circular(radiusCard),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -16,
                    bottom: -16,
                    child: Icon(
                      Icons.anchor,
                      size: 100,
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          port.name,
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 12, color: Colors.white60),
                            const SizedBox(width: 4),
                            Text(
                              '${port.latitude.toStringAsFixed(3)}°N',
                              style: GoogleFonts.dmMono(
                                  fontSize: 11, color: Colors.white60),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 24,
              child: GestureDetector(
                onTap: onDeselect,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close,
                      size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),

        // Amenities
        if (port.amenities.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 32,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: port.amenities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tealPale,
                  borderRadius: BorderRadius.circular(radiusChip),
                ),
                child: Text(
                  port.amenities[i],
                  style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: tealPrimary),
                ),
              ),
            ),
          ),
        ],

        // Berth count + price
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              if (port.availableBerthCount != null) ...[
                BerthAvailabilityBadge(
                  status: availabilityFromCount(port.availableBerthCount),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.berthsFreeCount(port.availableBerthCount!),
                  style: GoogleFonts.dmSans(fontSize: 13, color: slateGrey),
                ),
              ],
              if (port.minPricePerNight != null) ...[
                const Spacer(),
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

        // CTA
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: AppButton(
            label: l10n.checkAvailability,
            onPressed: () => context.goNamed(
              'portDetail',
              pathParameters: {'id': port.id},
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Port list view (default sheet content)
// ---------------------------------------------------------------------------

class _PortListView extends StatelessWidget {
  final ScrollController scrollController;
  final AsyncValue<List<Port>> portsAsync;
  final List<Port> sortedPorts;
  final _PortFilter activeFilter;
  final ValueChanged<_PortFilter> onFilterChange;
  final void Function(Port) onPortTap;
  final VoidCallback onRetry;

  const _PortListView({
    required this.scrollController,
    required this.portsAsync,
    required this.sortedPorts,
    required this.activeFilter,
    required this.onFilterChange,
    required this.onPortTap,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(child: _SheetHandle()),

        // Header: count + see-all
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                portsAsync.when(
                  loading: () => const LoadingShimmer(
                      height: 18, width: 120, borderRadius: 4),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (ports) => Text(
                    l10n.portsFound(ports.length),
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: navyDeep,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: tealPrimary,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    l10n.seeAll,
                    style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: tealPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Filter chips
        SliverToBoxAdapter(
          child: _FilterChips(
            active: activeFilter,
            onSelect: onFilterChange,
          ),
        ),

        // Port rows or loading/error states
        portsAsync.when(
          loading: () => SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, __) => const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 1),
                child: LoadingShimmer(height: 64, borderRadius: 0),
              ),
              childCount: 6,
            ),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Text(l10n.errorNetwork,
                      style: GoogleFonts.dmSans(
                          fontSize: 14, color: dangerRed)),
                  const SizedBox(height: 16),
                  AppButton(
                    label: l10n.retry,
                    shrinkWrap: true,
                    onPressed: onRetry,
                  ),
                ],
              ),
            ),
          ),
          data: (_) {
            if (sortedPorts.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
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
                          style: GoogleFonts.dmSans(
                              fontSize: 13, color: slateGrey)),
                    ],
                  ),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => PortListRow(
                  port: sortedPorts[i],
                  onTap: () => onPortTap(sortedPorts[i]),
                ),
                childCount: sortedPorts.length,
              ),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Filter chips
// ---------------------------------------------------------------------------

class _FilterChips extends StatelessWidget {
  final _PortFilter active;
  final ValueChanged<_PortFilter> onSelect;

  const _FilterChips({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final chips = [
      (_PortFilter.nearest, l10n.filterNearest),
      (_PortFilter.available, l10n.filterAvailableNow),
      (_PortFilter.price, l10n.filterPriceAsc),
      (_PortFilter.saved, l10n.filterSaved),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (filter, label) = chips[i];
          final isActive = filter == active;
          return GestureDetector(
            onTap: () => onSelect(filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? tealPrimary : Colors.white,
                borderRadius: BorderRadius.circular(radiusChip),
                border: Border.all(
                  color: isActive ? tealPrimary : borderColor,
                ),
              ),
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? Colors.white : slateGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared handle widget
// ---------------------------------------------------------------------------

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: borderColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
