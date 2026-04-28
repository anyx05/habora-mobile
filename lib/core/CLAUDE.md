# CLAUDE.md — lib/core/
## Data + State Agent context

Your role is to build the data and state layer only.
You do NOT build any screens or widgets.
You do NOT use any design tokens — that is the Design System Agent's job.

### Your deliverables in order

1. lib/app/theme.dart
   - All color constants as static const Color values
   - ThemeData using ColorScheme.fromSeed with tealPrimary as seed
   - Text theme using DM Sans (GoogleFonts.dmSans) for body
   - DM Mono (GoogleFonts.dmMono) as a separate constant for code/spec text
   - Card theme: elevation 0, border, border radius 16
   - Input decoration theme: filled, off-white fill, teal focus border

2. lib/app/router.dart
   - All routes defined as GoRoute with named constants
   - Route names as static const strings in a Routes class:
     Routes.ports = '/ports'
     Routes.portDetail = '/ports/:slug'
     Routes.bookings = '/bookings'
     Routes.bookingDetail = '/bookings/:id'
     Routes.account = '/account'
     Routes.login = '/auth/login'
     Routes.signup = '/auth/signup'
   - ShellRoute wrapping the three main tabs with bottom nav
   - Auth redirect: if not authenticated AND route requires auth, redirect to /auth/login
   - Guest access: ports tab is always accessible; bookings and account redirect to login
     unless user is a guest (anonymous Supabase session)

3. lib/core/supabase/supabase_client.dart
   - Initialize with env vars via flutter_dotenv
   - Export a single `supabase` getter used everywhere
   - Export `supabaseAdmin` using service role key (for server ops)

4. lib/core/models/ — use freezed for all models
   Port:
     String id, String name, String slug,
     double latitude, double longitude,
     String? descriptionEn, String? descriptionEt,
     String contactEmail, List<String> amenities,
     int? availableBerthCount, double? minPricePerNight
   
   Berth:
     String id, String portId, String name,
     double maxLengthM, double maxDraftM,
     double? maxBeamM, double pricePerNight,
     List<String> amenities, bool isActive

   Booking:
     String id, String berthId,
     String customerName, String customerEmail,
     String vesselName, double vesselLengthM, double? vesselDraftM,
     DateTime arrivalDate, DateTime departureDate,
     String status, String confirmationCode, double totalPrice,
     // computed:
     int get nights => departureDate.difference(arrivalDate).inDays

   Vessel:
     String id, String ownerId, String name,
     String type, double lengthM, double? draftM, double? beamM

5. lib/core/repositories/ — abstract class + Supabase implementation

   PortRepository:
     Future<List<Port>> searchPorts({
       required double lat, required double lng,
       required int radiusKm,
       double? vesselLength, double? vesselDraft,
       DateTime? arrival, DateTime? departure
     })
     Future<Port> getPortBySlug(String slug)
     Future<List<Port>> getSavedPorts(String userId)

   BerthRepository:
     Future<List<Berth>> getAvailableBerths({
       required String portId,
       required DateTime arrival, required DateTime departure,
       double? vesselLength, double? vesselDraft
     })

   BookingRepository:
     Future<List<Booking>> getUserBookings(String userEmail)
     Future<Booking> createBooking(CreateBookingRequest request)
     Future<Booking> getBookingByCode(String confirmationCode)

   VesselRepository:
     Future<List<Vessel>> getUserVessels(String userId)
     Future<Vessel> createVessel(CreateVesselRequest request)
     Future<void> deleteVessel(String vesselId)

6. lib/core/providers/ — Riverpod providers

   auth_provider.dart:
     - supabaseClientProvider (Provider<SupabaseClient>)
     - authStateProvider (StreamProvider<AuthState>)
     - currentUserProvider (Provider<User?>) derived from authState
     - isGuestProvider (Provider<bool>) — true if session exists but no email
     
   ports_provider.dart:
     - portSearchParamsProvider (StateProvider<PortSearchParams?>)
     - portsResultsProvider (FutureProvider<List<Port>>) watches searchParams
     - selectedPortProvider (StateProvider<Port?>)

   bookings_provider.dart:
     - userBookingsProvider (FutureProvider<List<Booking>>)
     - bookingsByStatusProvider (filters upcoming/past/cancelled)
     - activeBookingFlowProvider (StateNotifierProvider for multi-step booking)

   vessel_provider.dart:
     - userVesselsProvider (FutureProvider<List<Vessel>>)
     - selectedVesselProvider (StateProvider<Vessel?>)

### Supabase RPC calls to use
For port search with geo:
  supabase.rpc('find_ports_near', params: {
    'p_lat': lat, 'p_lng': lng, 'p_radius_km': radiusKm,
    'p_vessel_length': vesselLength ?? 0,
    'p_vessel_draft': vesselDraft ?? 0,
  })

For berth availability:
  supabase.rpc('check_berth_availability', params: {
    'p_port_id': portId,
    'p_arrival': arrival.toIso8601String().substring(0,10),
    'p_departure': departure.toIso8601String().substring(0,10),
    'p_vessel_length': vesselLength ?? 0,
    'p_vessel_draft': vesselDraft ?? 0,
  })

### Error handling pattern
Every repository method wraps Supabase calls:
  try {
    final data = await supabase...;
    return data.map(Port.fromJson).toList();
  } on PostgrestException catch (e) {
    throw RepositoryException(e.message, code: e.code);
  } catch (e) {
    throw RepositoryException('Unexpected error: $e');
  }