# CLAUDE.md — SadamaAgent Mobile
## Root context — every agent reads this first

### What this project is
SadamaAgent is a Flutter mobile app for vessel operators to discover Estonian ports,
check berth availability, and make reservations. It is the mobile client for the
SadamaAgent platform — equivalent to booking.com but for maritime berths.

### Target users
Vessel operators (private sailors, charter boats, water taxis) booking berths.
Port operators do NOT use this app — they have a separate web dashboard.

### What is built (do not rebuild these)
The web MVP is complete. This is a standalone Flutter app only.

### Tech stack — use exactly these, no alternatives
- Flutter 3.x (Dart)
- Supabase (auth + database — direct client, no Spring Boot yet)
- Riverpod 2.x (state management — NOT Provider, NOT Bloc, NOT GetX)
- GoRouter (navigation — NOT Navigator.push directly)
- Dio (HTTP client for any non-Supabase calls)
- flutter_map + OpenStreetMap (maps — NOT Google Maps, NOT Mapbox Flutter SDK)
- Hive (offline cache for ports and vessel profiles)
- firebase_messaging (push notifications)
- flutter_localizations + intl (i18n — EN and ET for MVP)
- go_router (already listed, just confirming)

### Design tokens — use these exact values everywhere
```dart
// Colors
const Color navyDeep    = Color(0xFF0D1F3C);
const Color navyLight   = Color(0xFF162845);
const Color tealPrimary = Color(0xFF0B8B72);
const Color tealLight   = Color(0xFF12A688);
const Color tealPale    = Color(0xFFE8F5F2);
const Color amber       = Color(0xFFE8961E);
const Color slateGrey   = Color(0xFF6B7A8D);
const Color slateLight  = Color(0xFFA8B4C0);
const Color borderColor = Color(0xFFE4E8EE);
const Color offWhite    = Color(0xFFF7F8FA);
const Color dangerRed   = Color(0xFFE83A3A);

// Typography: DM Sans for body, DM Mono for codes/specs
// Border radius: cards = 16, chips = 20, buttons = 14, bottom sheet = 24 top corners

// Marker colors by berth availability:
// available = tealPrimary, limited = amber, full = dangerRed
```

### Folder structure — must follow this exactly
```
lib/
├── main.dart
├── app/
│   ├── router.dart          ← GoRouter config, all named routes
│   └── theme.dart           ← ThemeData, all tokens as constants
├── core/
│   ├── supabase/
│   │   └── supabase_client.dart   ← single init, exported client
│   ├── models/              ← Dart freezed data classes
│   │   ├── port.dart
│   │   ├── berth.dart
│   │   ├── booking.dart
│   │   └── vessel.dart
│   ├── repositories/
│   │   ├── port_repository.dart   ← abstract class + impl
│   │   ├── berth_repository.dart
│   │   ├── booking_repository.dart
│   │   └── vessel_repository.dart
│   └── providers/           ← Riverpod providers
│       ├── auth_provider.dart
│       ├── ports_provider.dart
│       ├── bookings_provider.dart
│       └── vessel_provider.dart
├── features/
│   ├── auth/
│   ├── ports/
│   ├── bookings/
│   └── account/
├── shared/
│   └── widgets/             ← reusable UI components
└── l10n/
    ├── app_en.arb
    └── app_et.arb
```

### Non-negotiable rules for every agent
1. Never use Navigator.push directly — always use GoRouter named routes via context.goNamed()
2. Never use setState in feature screens — all state through Riverpod providers
3. Never hardcode strings that appear in the UI — use AppLocalizations
4. Never call Supabase directly from a widget — always through a repository
5. Always handle loading, error, and empty states explicitly — no unhandled AsyncValues
6. Every file gets a single responsibility — no 300-line widgets

### Supabase tables available (read-only reference for agents)
- ports: id, name, slug, location (geography), description_en, description_et, contact_email, amenities[]
- berths: id, port_id, name, max_length_m, max_draft_m, price_per_night, amenities[], is_active
- bookings: id, berth_id, customer_name, customer_email, vessel_name, vessel_length_m, vessel_draft_m, arrival_date, departure_date, status, confirmation_code, total_price
- vessels: id, owner_id, name, type, length_m, draft_m, beam_m

### Environment
- Supabase URL and anon key stored in .env (never hardcoded)
- Use flutter_dotenv to load them
- Firebase config via google-services.json (Android) and GoogleService-Info.plist (iOS)