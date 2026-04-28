# CLAUDE.md — lib/features/bookings/
## Bookings Feature Agent context

Your role: build the Bookings tab and the booking creation flow.
Do not call Supabase directly. Do not build shared widgets.
Use BookingCard from lib/shared/widgets/booking_card.dart.

### Screen: BookingsScreen (lib/features/bookings/bookings_screen.dart)

State: watch userBookingsProvider and bookingsByStatusProvider

Layout:
  Column:
    page header ("My Bookings" / "Your berth reservations")
    TabBar: Upcoming | Past | Cancelled
    TabBarView:
      Each tab → BookingsList(status: BookingStatus)

BookingsList:
  AsyncValue handling:
    loading → 3x LoadingShimmer cards
    error → ErrorRetry widget
    empty → EmptyState widget:
      For "upcoming": icon + "No upcoming bookings" + "Find a port →" button
      For "past": icon + "No trips yet"
      For "cancelled": icon + "No cancellations"
    data → ListView of BookingCard widgets

Tapping a BookingCard → Routes.bookingDetail with booking id

### Screen: BookingDetailScreen (lib/features/bookings/booking_detail_screen.dart)
Route: /bookings/:id

AppBar: "Booking details" + confirmation code in subtitle (DM Mono)

Sections:
  Status banner:
    - upcoming: amber banner "Arriving in X days"
    - active: teal banner "Currently berthed"
    - past: grey banner "Completed"
    - cancelled: red banner "Cancelled"

  Location card:
    Port name (large, navy bold)
    Berth name chip
    "Get directions" button (opens maps app with port coordinates)

  Dates card:
    Arrival | Departure | Nights in 3-column layout (same as BookingCard)
    Check-in time: 14:00 | Check-out: 11:00

  Vessel card:
    Vessel name + length + draft
    (uses same navy background as VesselCard shared widget)

  Price summary:
    X nights × Y €/night = total
    Payment status badge

  Actions (only for upcoming bookings):
    "Cancel booking" button (danger ghost variant)
    Cancellation → confirmation dialog → calls bookingRepository.cancelBooking
    On success: invalidate userBookingsProvider, show success snackbar, go back

### Booking creation flow (lib/features/bookings/booking_flow/)

This is a multi-step flow, NOT navigation pushes — use a local step StateProvider.

BookingFlowScreen (route: /booking/new, receives berthId + portId + dates as params):
  Step 1 — Vessel details:
    If user has saved vessels: show vessel selector cards + "Use this vessel" 
    Plus "Enter manually" option
    Manual: AppTextField for vessel name, length, draft
    "Continue" → step 2

  Step 2 — Contact info:
    If logged-in user: pre-fill name + email (read-only with edit option)
    If guest: AppTextField for full name + email
    Optional notes field
    "Continue" → step 3

  Step 3 — Confirm:
    Summary card (berth, port, dates, vessel, price)
    "Confirm booking €XX" primary button
    On confirm → calls bookingRepository.createBooking
    Loading state: button shows spinner, disabled
    On success → navigate to BookingSuccessScreen
    On error (conflict) → error dialog "Berth no longer available, go back"

BookingSuccessScreen (lib/features/bookings/booking_success_screen.dart):
  Full-screen celebration layout (white background)
  Large teal anchor icon
  "Booking confirmed!" headline
  Confirmation code in DM Mono (large, prominent)
  Summary: port, berth, dates, total
  "View booking" button → Routes.bookingDetail
  "Find more ports" button → Routes.ports
  Note: "Confirmation email sent to {email}"

### Auth gate for booking
If user is not authenticated (not even guest):
  Show AuthPromptSheet (modal bottom sheet):
    "Sign in to confirm your booking"
    "Create account" button → Routes.signup with returnTo param
    "Continue as guest" button → creates anonymous Supabase session, continues
    "Sign in" text link