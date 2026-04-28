# CLAUDE.md — lib/features/ports/
## Ports Feature Agent context

Your role: build the Ports tab (the map screen with bottom sheet).
All data comes through Riverpod providers — you do not call Supabase.
All UI components come from lib/shared/widgets/ — you do not rebuild them.

### Screen: PortsScreen (lib/features/ports/ports_screen.dart)

Layout structure:
  Scaffold (no AppBar — map is full bleed):
    Stack:
      ├── FlutterMap (full screen, positioned behind everything)
      ├── SafeArea → search bar overlay (top)
      ├── Map controls column (bottom-right, above sheet)
      ├── Availability legend (bottom-left, above sheet)
      └── DraggableScrollableSheet (bottom)
            minChildSize: 0.3
            maxChildSize: 0.85
            initialChildSize: 0.35
            Contains:
              sheet handle
              header row ("X ports found" + "See all")
              filter chips (Nearest | Available now | Price ↑ | Saved)
              ListView of PortListRow widgets

### FlutterMap setup
  FlutterMap(
    mapController: _mapController,
    options: MapOptions(
      center: LatLng(59.437, 24.745),  // Tallinn default
      zoom: 7.0,
      minZoom: 5.0, maxZoom: 14.0,
      onTap: (_, __) => // deselect port
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'ee.sadamaagent.app',
      ),
      MarkerLayer(markers: _buildMarkers(ports)),
    ]
  )

Each port becomes a Marker containing a PortMarker widget.
Tapping a marker:
  1. Animates map to center on port (mapController.move)
  2. Sets selectedPortProvider to that port
  3. Snaps bottom sheet to 0.6 child size
  4. Scrolls port list to show selected port highlighted

### Search bar overlay
  Row(
    search icon | TextField (hint: "Search ports, destinations…") | divider | filter icon
  )
  Tapping the TextField opens a separate SearchScreen (push, not replace)
  Filter icon opens a modal bottom sheet with FilterSheet widget

### FilterSheet (lib/features/ports/widgets/filter_sheet.dart)
  Sliders for: vessel length (0–30m), vessel draft (0–3m)
  Date range picker: arrival and departure
  "Apply filters" → updates portSearchParamsProvider
  "Reset" → clears filters

### Port detail bottom sheet expansion
When a port is selected, sheet expands to show:
  Port photo placeholder (navy gradient with port name)
  Port name + location
  Amenity chips (power, water, wifi, fuel...)
  Available berths count + price range
  "Check availability" button → navigates to Routes.portDetail

### Provider usage
  Watch: ref.watch(portsResultsProvider)
    - AsyncLoading → shimmer markers + shimmer list rows
    - AsyncError → error snackbar, retry button
    - AsyncData → render markers + list
  
  Read: ref.read(portSearchParamsProvider.notifier)
    - update when filters change
  
  Watch: ref.watch(selectedPortProvider)
    - highlights selected port in list + map

### Port detail screen (lib/features/ports/port_detail_screen.dart)
Route: /ports/:slug
  AppBar with port name (navy background, white text, back arrow)
  Body scrollable:
    Header image area (navy gradient, port name + location overlay)
    Info section: contact email, max vessel length
    Amenities row (icon + label chips)
    "Available berths" section title + date range selector
    BerthList (shows berths from getBerthAvailability)
    Each BerthCard:
      Berth name | type badge | max length/draft
      Price per night + total for selected dates
      "Book this berth" button → opens booking flow