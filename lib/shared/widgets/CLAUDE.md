# CLAUDE.md — lib/shared/widgets/
## Design System Agent context

Your role is to build reusable widget components only.
You do NOT build screens (that is Feature Agents' job).
You do NOT write business logic or providers.
You translate the visual design into reusable Flutter components.

### Reference design
The visual design is defined in the root CLAUDE.md design tokens.
Navy + teal + amber palette. DM Sans + DM Mono typography.
Clean maritime aesthetic. Rounded cards with subtle shadows.

### Your deliverables

lib/shared/widgets/

1. app_button.dart
   AppButton(
     label: String, onPressed: VoidCallback?,
     variant: AppButtonVariant (primary | ghost | danger),
     isLoading: bool, icon: IconData?
   )
   - primary: teal fill, white text, teal shadow
   - ghost: white fill, navy border (1.5px), navy text
   - Loading: CircularProgressIndicator replaces label, button disabled
   - Full width by default, shrink-wrap option

2. app_text_field.dart
   AppTextField(
     label: String, hint: String?,
     controller: TextEditingController,
     keyboardType: TextInputType,
     obscureText: bool, prefixIcon: IconData?,
     validator: String? Function(String?)?
   )
   - Off-white fill, 12px border radius, teal focus border
   - Error state shows dangerRed border + message below

3. port_marker.dart
   PortMarker(
     availability: PortAvailability (available | limited | full),
     onTap: VoidCallback
   )
   PortAvailability maps to:
     available → tealPrimary
     limited → amber
     full → dangerRed
   - Outer pulsing circle (animate opacity 0.15–0.3 on loop)
   - Inner solid circle with anchor icon
   - Tap calls onTap

4. port_list_row.dart
   PortListRow(port: Port, onTap: VoidCallback)
   - Dot indicator (color by availability)
   - Port name (bold navy), meta (distance · berths free · max length)
   - Price: "from X€/night" right-aligned in teal
   - Thin border-bottom divider

5. booking_card.dart
   BookingCard(booking: Booking, onTap: VoidCallback)
   - Navy header: port name (bold white) + confirmation code (DM Mono, dim white)
   - Status badge top right: upcoming=amber/dim, active=teal/dim, past=grey
   - Body: arrival/departure/nights in 3-column row, vessel + length in row below
   - Footer: berth chip (teal pale background) + total price right
   - Tap navigates to booking detail

6. bottom_nav_bar.dart
   AppBottomNavBar(currentIndex: int, onTap: ValueChanged<int>)
   - Three items: Ports (home icon), Bookings (calendar icon), Me (person icon)
   - Active: icon strokes teal, label teal, small teal dot below label
   - Inactive: slateLight
   - White background, top border borderColor
   - Safe area padding for home indicator

7. berth_availability_badge.dart
   BerthAvailabilityBadge(status: PortAvailability)
   - Small pill: "Available" / "Limited" / "Full"
   - Pale background matching status color, bold colored text

8. vessel_card.dart
   VesselCard(vessel: Vessel, onTap: VoidCallback?, onDelete: VoidCallback?)
   - Navy background, boat emoji by type
   - Vessel name bold white, specs in dim white (DM Mono)
   - Optional delete icon top-right

9. section_header.dart
   SectionHeader(label: String, action: Widget?)
   - ALL CAPS label in slateGrey, 11px, letter-spacing 1px
   - Optional action widget right (e.g. "+ Add" in teal)

10. loading_shimmer.dart
    LoadingShimmer(height: double, width: double?, borderRadius: double)
    - Animated shimmer using TweenAnimationBuilder
    - Navy 5% → navy 10% gradient sweep

### Constraints
- Every widget is stateless unless animation requires stateful
- No business logic — no Supabase calls, no provider reads
- Props only — data passed in, callbacks passed out
- Add dartdoc comment to every public widget class