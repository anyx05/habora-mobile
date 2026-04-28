// TEMPORARY — development-only screen for visual testing of shared widgets.
// Remove this file (and any route pointing to it) before shipping.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/app/theme.dart';
import 'package:myapp/core/models/booking.dart';
import 'package:myapp/core/models/port.dart';
import 'package:myapp/core/models/vessel.dart';
import 'package:myapp/shared/widgets/app_button.dart';
import 'package:myapp/shared/widgets/app_text_field.dart';
import 'package:myapp/shared/widgets/berth_availability_badge.dart';
import 'package:myapp/shared/widgets/booking_card.dart';
import 'package:myapp/shared/widgets/bottom_nav_bar.dart';
import 'package:myapp/shared/widgets/loading_shimmer.dart';
import 'package:myapp/shared/widgets/port_availability.dart';
import 'package:myapp/shared/widgets/port_list_row.dart';
import 'package:myapp/shared/widgets/port_marker.dart';
import 'package:myapp/shared/widgets/section_header.dart';
import 'package:myapp/shared/widgets/vessel_card.dart';

// ── Mock data ────────────────────────────────────────────────────────────────

final _portAvailable = Port(
  id: '1',
  name: 'Tallinn Old City Marina',
  latitude: 59.437,
  longitude: 24.745,
  contactEmail: 'marina@tallinn.ee',
  amenities: const ['WiFi', 'Power', 'Water'],
  availableBerthCount: 5,
  minPricePerNight: 45.0,
);

final _portLimited = Port(
  id: '2',
  name: 'Pirita Harbour',
  latitude: 59.467,
  longitude: 24.832,
  contactEmail: 'pirita@marina.ee',
  availableBerthCount: 2,
  minPricePerNight: 30.0,
);

final _portFull = Port(
  id: '3',
  name: 'Noblessner Marina',
  latitude: 59.449,
  longitude: 24.724,
  contactEmail: 'noblessner@marina.ee',
  availableBerthCount: 0,
  minPricePerNight: 55.0,
);

final _vesselSailboat = Vessel(
  id: 'v1',
  ownerId: 'u1',
  name: 'Nordic Dream',
  type: 'sailboat',
  lengthM: 12.5,
  draftM: 1.8,
  beamM: 3.9,
);

final _vesselMotor = Vessel(
  id: 'v2',
  ownerId: 'u1',
  name: 'Sea Breeze',
  type: 'motorboat',
  lengthM: 8.0,
  draftM: 0.9,
);

final _bookingUpcoming = Booking(
  id: 'b1',
  berthId: 'berth-1',
  customerName: 'Emmanuel Alabi',
  customerEmail: 'emmanuelalabi05@gmail.com',
  vesselName: 'Nordic Dream',
  vesselLengthM: 12.5,
  vesselDraftM: 1.8,
  arrivalDate: DateTime(2026, 7, 15),
  departureDate: DateTime(2026, 7, 20),
  status: 'pending',
  confirmationCode: 'BK-4721',
  totalPrice: 225.0,
);

final _bookingActive = Booking(
  id: 'b2',
  berthId: 'berth-2',
  customerName: 'Emmanuel Alabi',
  customerEmail: 'emmanuelalabi05@gmail.com',
  vesselName: 'Sea Breeze',
  vesselLengthM: 8.0,
  arrivalDate: DateTime(2026, 4, 25),
  departureDate: DateTime(2026, 4, 28),
  status: 'confirmed',
  confirmationCode: 'BK-3310',
  totalPrice: 90.0,
);

final _bookingPast = Booking(
  id: 'b3',
  berthId: 'berth-3',
  customerName: 'Emmanuel Alabi',
  customerEmail: 'emmanuelalabi05@gmail.com',
  vesselName: 'Nordic Dream',
  vesselLengthM: 12.5,
  arrivalDate: DateTime(2026, 3, 10),
  departureDate: DateTime(2026, 3, 12),
  status: 'confirmed',
  confirmationCode: 'BK-2204',
  totalPrice: 60.0,
);

// ── Screen ───────────────────────────────────────────────────────────────────

/// Scrollable catalogue of every shared widget.
///
/// Each section header names the widget; the section body shows meaningful
/// variants with realistic SadamaAgent data. Tap the "Validate" button to
/// trigger form validation on the text fields.
class WidgetShowcaseScreen extends StatefulWidget {
  const WidgetShowcaseScreen({super.key});

  @override
  State<WidgetShowcaseScreen> createState() => _WidgetShowcaseScreenState();
}

class _WidgetShowcaseScreenState extends State<WidgetShowcaseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtrl;
  late final TextEditingController _vesselCtrl;

  int _navIndex = 0;
  bool _primaryLoading = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: 'captain@sea.ee');
    _vesselCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _vesselCtrl.dispose();
    super.dispose();
  }

  // ── helpers ─────────────────────────────────────────────────────────────────

  void _triggerPrimaryLoading() {
    setState(() => _primaryLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _primaryLoading = false);
    });
  }

  // ── build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        title: Text(
          'Widget Showcase',
          style: GoogleFonts.dmSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: navyDeep,
        elevation: 0,
      ),
      // Bottom nav lives outside the scroll so it stays pinned.
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // ─────────────────────────────────────────────────────────────────
            // 1. LoadingShimmer
            // ─────────────────────────────────────────────────────────────────
            const _Header('LoadingShimmer'),
            const LoadingShimmer(height: 18, borderRadius: 4),
            const SizedBox(height: 8),
            const LoadingShimmer(height: 56, borderRadius: 12),
            const SizedBox(height: 8),
            Row(
              children: [
                const LoadingShimmer(height: 44, width: 44, borderRadius: 22),
                const SizedBox(width: 12),
                const Expanded(
                  child: LoadingShimmer(height: 18, borderRadius: 4),
                ),
              ],
            ),

            // ─────────────────────────────────────────────────────────────────
            // 2. AppButton
            // ─────────────────────────────────────────────────────────────────
            const _Header('AppButton'),
            AppButton(label: 'Book now', onPressed: () {}),
            const SizedBox(height: 8),
            AppButton(
              label: _primaryLoading ? 'Loading…' : 'Tap to load',
              isLoading: _primaryLoading,
              icon: Icons.send_outlined,
              onPressed: _triggerPrimaryLoading,
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Save to favourites',
              variant: AppButtonVariant.ghost,
              icon: Icons.bookmark_border,
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Cancel booking',
              variant: AppButtonVariant.danger,
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Disabled',
              onPressed: null,
            ),

            // ─────────────────────────────────────────────────────────────────
            // 3. AppTextField
            // ─────────────────────────────────────────────────────────────────
            const _Header('AppTextField'),
            AppTextField(
              label: 'Email',
              hint: 'captain@sea.ee',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Vessel name',
              hint: 'Nordic Dream',
              controller: _vesselCtrl,
              prefixIcon: Icons.directions_boat_outlined,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Validate fields',
              variant: AppButtonVariant.ghost,
              shrinkWrap: true,
              onPressed: () => _formKey.currentState?.validate(),
            ),

            // ─────────────────────────────────────────────────────────────────
            // 4. SectionHeader
            // ─────────────────────────────────────────────────────────────────
            const _Header('SectionHeader'),
            const SectionHeader(label: 'My Vessels'),
            const SizedBox(height: 12),
            SectionHeader(
              label: 'Preferences',
              action: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '+ Add',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: tealPrimary,
                  ),
                ),
              ),
            ),

            // ─────────────────────────────────────────────────────────────────
            // 5. BerthAvailabilityBadge
            // ─────────────────────────────────────────────────────────────────
            const _Header('BerthAvailabilityBadge'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                BerthAvailabilityBadge(status: PortAvailability.available),
                BerthAvailabilityBadge(status: PortAvailability.limited),
                BerthAvailabilityBadge(status: PortAvailability.full),
              ],
            ),

            // ─────────────────────────────────────────────────────────────────
            // 6. PortMarker
            // ─────────────────────────────────────────────────────────────────
            const _Header('PortMarker'),
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFCBE0D6), // mock map tile colour
                borderRadius: BorderRadius.circular(radiusCard),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PortMarker(
                    availability: PortAvailability.available,
                    onTap: () {},
                  ),
                  PortMarker(
                    availability: PortAvailability.limited,
                    onTap: () {},
                  ),
                  PortMarker(
                    availability: PortAvailability.full,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // ─────────────────────────────────────────────────────────────────
            // 7. PortListRow
            // ─────────────────────────────────────────────────────────────────
            const _Header('PortListRow'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radiusCard),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  PortListRow(
                    port: _portAvailable,
                    onTap: () {},
                    distanceKm: 2.3,
                    maxLengthM: 20.0,
                  ),
                  PortListRow(
                    port: _portLimited,
                    onTap: () {},
                    distanceKm: 5.7,
                    maxLengthM: 15.0,
                  ),
                  PortListRow(
                    port: _portFull,
                    onTap: () {},
                    distanceKm: 8.1,
                  ),
                ],
              ),
            ),

            // ─────────────────────────────────────────────────────────────────
            // 8. VesselCard
            // ─────────────────────────────────────────────────────────────────
            const _Header('VesselCard'),
            VesselCard(
              vessel: _vesselSailboat,
              onTap: () {},
              onDelete: () {},
            ),
            const SizedBox(height: 8),
            VesselCard(
              vessel: _vesselMotor,
              onTap: () {},
            ),

            // ─────────────────────────────────────────────────────────────────
            // 9. BookingCard
            // ─────────────────────────────────────────────────────────────────
            const _Header('BookingCard'),
            BookingCard(
              booking: _bookingUpcoming,
              onTap: () {},
              portName: 'Tallinn Old City Marina',
              berthName: 'Berth A-12',
            ),
            const SizedBox(height: 8),
            BookingCard(
              booking: _bookingActive,
              onTap: () {},
              portName: 'Pirita Harbour',
              berthName: 'Berth B-3',
            ),
            const SizedBox(height: 8),
            BookingCard(
              booking: _bookingPast,
              onTap: () {},
              portName: 'Noblessner Marina',
            ),

            // ─────────────────────────────────────────────────────────────────
            // 10. AppBottomNavBar — pinned at the bottom; index shown here too.
            // ─────────────────────────────────────────────────────────────────
            const _Header('AppBottomNavBar'),
            Text(
              'Live below ↓  active tab: $_navIndex',
              style: GoogleFonts.dmSans(fontSize: 13, color: slateGrey),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Private section header helper ────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String label;
  const _Header(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 12),
      child: SectionHeader(label: label),
    );
  }
}
