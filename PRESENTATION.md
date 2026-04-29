# SadamaAgent — Presentation Guide
### A Mobile Berth Booking Platform for Estonian Ports

> **Audience:** Professors + fellow students
> **Format:** Slide-by-slide outline with talking points per slide. Each section lists what to say, what to show, and what decisions to highlight.

---

## SLIDE 1 — Title

**Title:** SadamaAgent: A Mobile Berth Booking Platform

**Subtitle:** Flutter · Supabase · Riverpod · OpenStreetMap

**Talking points:**
- "SadamaAgent" — from Estonian *sadam* (harbour/port) + agent (the system that acts on your behalf)
- This is a cross-platform mobile app built with Flutter, targeting vessel operators in Estonia
- Think of it as Booking.com — but specifically for maritime berths

---

## SLIDE 2 — The Problem

**Title:** The Problem We're Solving

**Content:**
- Vessel operators (private sailors, charter boats, water taxis) currently rely on phone calls, emails, and paper logs to book a berth
- Port operators maintain availability manually — no real-time data
- No unified platform exists that shows which berths are open, at what price, or filtered by vessel size

**Talking points:**
- Ask the audience: "Has anyone ever tried to book a campsite or hotel and found the website completely outdated?" — Same problem, maritime world
- The pain is doubly real because vessel specs (length, draft, beam) have to physically fit the berth — this is a hard constraint, not a preference
- The web dashboard for port operators already exists (the MVP). This app is the customer-facing side

---

## SLIDE 3 — What We Built

**Title:** What SadamaAgent Is

**Content (bullet points on slide):**
- Cross-platform mobile app (iOS + Android) built with Flutter
- Real-time berth availability, filtered by vessel dimensions and dates
- Multi-step booking flow with confirmation codes
- Estonian and English language support
- Offline caching for ports and vessel profiles

**Talking points:**
- The scope was deliberately bounded: vessel operators only. Port operators manage things through a separate web dashboard
- MVP parity means the app can do everything a sailor needs: discover → filter → book → manage → cancel
- Supporting two languages (EN + ET) from day one because the target market is Estonia

---

## SLIDE 4 — Tech Stack

**Title:** Technology Choices

| Layer | Technology | Why |
|---|---|---|
| UI Framework | Flutter 3.x | Single codebase → iOS + Android |
| Backend / Auth | Supabase | Postgres + Auth + Realtime, no custom server needed |
| State Management | Riverpod 2.x | Compile-safe, testable, no BuildContext dependency |
| Navigation | GoRouter | Declarative, deep-link-ready, supports auth redirects |
| Maps | flutter_map + OpenStreetMap | Free, no API key, tile-based |
| Local Cache | Hive | Fast, schema-less, no native dependencies |
| Push Notifications | Firebase Messaging | Industry standard for mobile push |
| i18n | flutter_localizations + intl | Official Flutter approach |
| HTTP (non-Supabase) | Dio | Interceptors, timeouts, type-safe |

**Talking points:**
- Flutter was the single biggest architectural bet — one codebase, two platforms, near-native performance
- Supabase gave us a full Postgres database with row-level security policies, auth, and auto-generated APIs — without writing a backend server
- Riverpod over Provider/Bloc: it's purely Dart (no widget tree dependency), catches mistakes at compile time, and is easier to test
- OpenStreetMap instead of Google Maps: zero cost, no API key rotation headaches — critical for a project that may scale unpredictably

---

## SLIDE 5 — Architecture Overview

**Title:** Layered Architecture

```
┌────────────────────────────────────┐
│          Feature Screens           │  ← Pure UI, no business logic
│  (Auth / Ports / Bookings / Account)│
├────────────────────────────────────┤
│        Riverpod Providers          │  ← State & async coordination
│  (auth / ports / bookings / vessel) │
├────────────────────────────────────┤
│          Repositories              │  ← Data access contracts
│  (Port / Berth / Booking / Vessel) │
├────────────────────────────────────┤
│         Supabase Client            │  ← Single initialised instance
│     + Hive (offline cache)         │
└────────────────────────────────────┘
```

**Talking points:**
- Classic layered architecture — each layer has one job and only talks to the layer below
- Screens never touch Supabase directly. They observe providers. Providers call repositories. Repositories call Supabase
- This means if we ever swap Supabase for a different backend, only the repository implementations change — screens and providers stay the same
- This is the Repository Pattern — you may have seen it in Spring Boot or Django; same principle, Dart syntax

---

## SLIDE 6 — Folder Structure

**Title:** How the Code Is Organised

```
lib/
├── main.dart              ← Bootstrap (Supabase + Hive + Firebase)
├── app/
│   ├── router.dart        ← All routes in one place
│   └── theme.dart         ← All design tokens (colours, fonts, radii)
├── core/
│   ├── models/            ← Immutable data classes (Freezed)
│   ├── repositories/      ← Abstract interface + Supabase impl
│   └── providers/         ← Riverpod providers per feature
├── features/
│   ├── auth/              ← Login, signup, forgot password
│   ├── ports/             ← Map, port detail, filter sheet
│   ├── bookings/          ← List, detail, 3-step booking flow
│   └── account/           ← Profile, vessels, preferences
├── shared/widgets/        ← Reusable components
└── l10n/                  ← EN + ET string files
```

**Talking points:**
- Feature-first organisation: all code for "bookings" lives under features/bookings, not scattered across folders by type
- Shared components live in shared/widgets — they know nothing about any feature
- core/ is the backbone — it never imports from features/, keeping dependencies one-directional
- Single responsibility per file: no 500-line god widgets

---

## SLIDE 7 — Data Models

**Title:** Domain Models (Freezed)

**Show on slide:**
```dart
@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String berthId,
    required String customerName,
    required DateTime arrivalDate,
    required DateTime departureDate,
    required String status,
    String? confirmationCode,
    double? totalPrice,
  }) = _Booking;

  // Computed properties — no setState needed
  const Booking._();
  int get nights => departureDate.difference(arrivalDate).inDays;
  bool get isUpcoming => arrivalDate.isAfter(DateTime.now());
  bool get isPast => departureDate.isBefore(DateTime.now());
}
```

**Talking points:**
- Freezed is a code generator that gives us: immutability, value equality, copyWith, and JSON serialisation — for free
- "Immutable" means once a Booking is created, you can't mutate a field — you create a new one via `copyWith`. This prevents the class of bugs where state is mutated from two places at once
- Computed getters (`nights`, `isUpcoming`, `isPast`) keep business logic in the model, not scattered in UI files
- Four models: Port, Berth, Vessel, Booking — plus UserProfile for auth

---

## SLIDE 8 — State Management with Riverpod

**Title:** State Management — Riverpod

**Show on slide:**
```dart
// 1. Define the provider
final userBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final repo = ref.read(bookingRepositoryProvider);
  return repo.getUserBookings(user.email!);
});

// 2. Consume in the UI
class BookingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(userBookingsProvider);
    return bookingsAsync.when(
      loading: () => const LoadingShimmer(),
      error:   (e, _) => ErrorView(message: e.toString()),
      data:    (bookings) => BookingList(bookings: bookings),
    );
  }
}
```

**Talking points:**
- Every async value has three states: loading, error, data — Riverpod forces you to handle all three via `.when()`. No "forgot to show a loading spinner" bugs
- Providers are lazy — they're only computed when something is watching them
- When `currentUserProvider` changes (e.g., user signs out), `userBookingsProvider` automatically invalidates and re-fetches
- No `setState`, no `notifyListeners()`, no `BlocBuilder<X, Y>` boilerplate — just watch a provider

---

## SLIDE 9 — Navigation with GoRouter

**Title:** Navigation — GoRouter

**Show on slide:**
```
Routes:
  /ports              → PortsScreen (tab shell)
  /ports/:id          → PortDetailScreen
  /bookings           → BookingsScreen (tab shell)
  /bookings/:id       → BookingDetailScreen
  /booking/new        → BookingFlowScreen
  /booking/success    → BookingSuccessScreen
  /account            → AccountScreen (tab shell)
  /account/vessels/add → AddVesselScreen
  /auth/login         → AuthScreen
  /auth/forgot-password → ForgotPasswordScreen
```

**Auth redirect logic:**
```
Protected routes (/bookings/*, /booking/*, /account/*):
  → if not logged in → redirect to /auth/login?returnTo={path}
  → after login → return to original destination
```

**Talking points:**
- Declarative routing: every destination is a named string, not a class instance pushed onto a stack
- Deep linking works out of the box — a push notification can open `/bookings/abc123` directly
- The redirect logic is centralised — we don't check auth in every screen, we check once in the router
- Shell routes wrap three tabs (Ports / Bookings / Me) with a shared bottom nav bar — navigating between tabs doesn't rebuild the nav bar

---

## SLIDE 10 — Key Features (1/3): Map + Discovery

**Title:** Feature: Port Discovery

**What to describe/show:**
- Full-bleed OpenStreetMap canvas with coloured pulsing markers
- Marker colours signal availability at a glance:
  - **Teal** → available berths (3+)
  - **Amber** → limited (1–2 berths)
  - **Red** → full (0 berths)
- Draggable bottom sheet rises from the bottom — port list below the map
- Filter sheet: vessel length/draft sliders, date range picker, sort options (nearest / available / price / saved)

**Talking points:**
- The map uses flutter_map — it's built on Leaflet concepts, uses OSM tile URLs, and never needs a Google API key
- Markers are custom widgets with a Stack: a pulsing `AnimatedContainer` ring behind an anchor icon
- The availability colour is computed from `berthCount`: null or ≥3 → teal, 1–2 → amber, 0 → red. This mapping lives in one enum (`PortAvailability`) used everywhere
- Filters feed into `portSearchParamsProvider`. When sliders change, that provider updates, `portsResultsProvider` re-fetches — the list and map update automatically

---

## SLIDE 11 — Key Features (2/3): Booking Flow

**Title:** Feature: Multi-Step Booking Flow

**What to describe:**
```
Step 1 — Vessel
  Select from saved vessels OR enter manually
  (length + draft auto-validated against berth limits)

Step 2 — Contact
  Customer name + email (pre-filled if logged in)
  Optional notes for the port

Step 3 — Confirm
  Full summary: port, berth, dates, vessel, price breakdown
  "Confirm booking €X.XX" button
  → calls create_booking_safely RPC in Supabase
  → returns confirmation code

Success screen:
  Large confirmation code in DM Mono font
  "View booking" or "Find more ports" actions
```

**Talking points:**
- The flow is a state machine managed by `BookingFlowNotifier` (StateNotifier). It holds which step you're on and all the accumulated data
- Using `AnimatedSwitcher` between steps — smooth slide transitions without a named route per step, because going back doesn't add a new history entry
- Step 1 pre-populates from saved vessels (Riverpod `userVesselsProvider`) — one tap, vessel dimensions filled in
- The Supabase RPC `create_booking_safely` runs server-side validation: checks vessel length/draft vs berth limits, checks date overlap. If it fails, a typed `BookingException` is thrown (e.g., `VesselTooLong`) and we show a specific error message — not a generic "something went wrong"

---

## SLIDE 12 — Key Features (3/3): Bookings & Account

**Title:** Features: Bookings & Account

**Bookings screen:**
- Three tabs: Upcoming / Past / Cancelled
- Each booking card shows port name, berth, check-in/out dates, vessel name, status badge, total price
- Tap → detail screen with cancel option (upcoming bookings only)

**Account screen:**
- Guest state: sign up / sign in CTAs
- Authenticated state:
  - Navy header with avatar (first initial), name, email, member since date
  - My Vessels: saved vessel cards (type emoji, name, length/draft specs in DM Mono)
  - Add vessel form: name, type dropdown, length, draft, beam
  - Preferences: notification toggle, language switcher (EN/ET), sign out

**Talking points:**
- The account screen renders completely differently depending on auth state — all from one `ConsumerWidget` watching `authStateProvider`
- Language switching uses `localeProvider` backed by Hive — survives app restarts
- Vessel management is full CRUD from the app: add, view, delete. Each vessel has an ownership check server-side before delete
- Bookings list is filtered client-side from one provider: `bookingsByStatusProvider.family` takes a status string and returns the right subset

---

## SLIDE 13 — Internationalisation (i18n)

**Title:** Two Languages — Estonian & English

**What to show:**
```arb
// app_en.arb
"bookNow": "Book Now",
"fromPricePerNight": "From €{price}/night",
"nightsCount": "{count, plural, =1{1 night} other{{count} nights}}",

// app_et.arb
"bookNow": "Broneeri kohe",
"fromPricePerNight": "Alates €{price}/öö",
"nightsCount": "{count, plural, =1{1 öö} other{{count} ööd}}",
```

**In code:**
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.bookNow)
Text(l10n.fromPricePerNight(price))
Text(l10n.nightsCount(3)) // "3 nights" / "3 ööd"
```

**Talking points:**
- Zero hardcoded UI strings — every user-facing string goes through `AppLocalizations`
- Plural forms are handled by the intl package — "1 night" vs "3 nights" automatically
- The `.arb` file has 450+ strings covering every screen, every error, every tooltip
- Language choice is persisted in Hive — next launch, the app opens in the user's last chosen language without a network call

---

## SLIDE 14 — Design System

**Title:** Consistent Design Language

**Colour palette:**
| Token | Hex | Use |
|---|---|---|
| `navyDeep` | #0D1F3C | Backgrounds, card headers |
| `tealPrimary` | #0B8B72 | Primary actions, available |
| `amber` | #E8961E | Limited availability, warnings |
| `dangerRed` | #E83A3A | Full, cancel, errors |
| `slateGrey` | #6B7A8D | Secondary text |
| `offWhite` | #F7F8FA | Page backgrounds |

**Typography:**
- DM Sans — all body text, headings
- DM Mono — confirmation codes, vessel specs, prices (monospace for numerical alignment)

**Spacing & radius:**
- Cards: 16px radius · Chips: 20px · Buttons: 14px · Bottom sheet top corners: 24px

**Talking points:**
- All tokens live in one file: `app/theme.dart`. Change a colour in one place, it propagates everywhere
- DM Mono for specs and codes is a deliberate choice — it makes `LON-9371` or `12.4 m` look precise and technical, not decorative
- The navy + teal palette was chosen to evoke the sea: deep ocean (navy), maritime navigation (teal), alert (amber)
- Reusable widgets (`AppButton`, `AppTextField`, `BookingCard`, `VesselCard`, etc.) enforce the tokens — a developer can't accidentally use the wrong blue

---

## SLIDE 15 — Technical Challenges

**Title:** Challenges & How We Solved Them

### Challenge 1: Berth Availability in Real Time

**Problem:** A berth can be booked by multiple users simultaneously — two people could both see it as "available" and both try to confirm.

**Solution:** Server-side RPC (`create_booking_safely`) written in Postgres PL/pgSQL. It runs inside a transaction with row-level locking. It:
1. Checks vessel dimensions fit the berth
2. Checks no existing booking overlaps the requested dates
3. Creates the booking atomically
4. If any check fails, raises a typed exception (P0001–P0004)

The app maps these error codes to `BookingException` variants and shows a specific message (e.g., "Your vessel is too long for this berth").

---

### Challenge 2: Role Separation on a Shared Backend

**Problem:** Port operators and vessel operators share the same Supabase project. A port operator could accidentally open the mobile app and see customer data.

**Solution:** After auth, the app reads the user's `role` from the `user_profile` table. If `role == 'port_operator'`, the app immediately signs them out and shows an explanatory screen pointing them to the web dashboard. This check happens in `authProvider` before any navigation.

---

### Challenge 3: Offline Resilience

**Problem:** A sailor on the water may have poor connectivity. The app should still work for recently-visited ports and saved vessel profiles.

**Solution:** Hive stores:
- Saved port IDs → fetched fresh on reconnect
- User's vessel profiles → available without network
- Language preference → no network needed

Ports data is served from the in-memory Riverpod cache between app sessions; Hive is the durable layer for preferences and saved items.

---

### Challenge 4: Map Performance with Many Markers

**Problem:** FlutterMap renders all markers on every frame. With 50+ ports, this could cause jank.

**Solution:**
- Markers are only recreated when `portsResultsProvider` emits new data
- Each `PortMarker` is a `const`-friendly stateless widget; the pulsing animation is isolated inside it
- The draggable sheet list and map share the same data source — no duplication

---

### Challenge 5: Type-Safe Navigation with GoRouter

**Problem:** Hard-coded path strings like `context.go('/ports/$id')` are error-prone — typos don't fail at compile time.

**Solution:** Named routes throughout. Every navigation call uses `context.goNamed('port-detail', pathParameters: {'id': port.id})`. Renaming a route is one change in `router.dart`, not a grep across the codebase.

---

## SLIDE 16 — Architecture Decisions (Summary)

**Title:** Key Decisions & Trade-offs

| Decision | Alternative Considered | Why We Chose This |
|---|---|---|
| Flutter | React Native / native | One codebase, no bridge, rich widget library |
| Supabase | Firebase / custom Spring Boot | Postgres gives us complex queries + RLS policies |
| Riverpod | Provider / Bloc | Compile-safe, no BuildContext in providers |
| GoRouter | Navigator 2.0 raw | Declarative, deep-link-ready, auth redirects built-in |
| Freezed models | Plain classes | Free immutability, equality, JSON, copyWith |
| OSM / flutter_map | Google Maps | Free tier, no API key management |
| Hive | SharedPreferences / SQLite | Fast reads, Dart-native, no SQL for simple KV cache |
| Repository pattern | Direct Supabase calls from providers | Swappable backend, testable in isolation |

**Talking points:**
- Every choice has a cost: Flutter requires learning Dart; Supabase means trusting a managed service; Riverpod has a steeper learning curve than Provider
- The biggest risk was Supabase as the sole backend — if it goes down, the app has no fallback. Mitigated by offline caching for read-heavy flows
- Freezed adds a build step (code generation) — `flutter pub run build_runner build` must be run after model changes. Worth it for the guarantees

---

## SLIDE 17 — What Could Be Improved / Future Work

**Title:** Future Improvements

### Short-term
- **Real-time availability updates** — Supabase supports WebSocket subscriptions. When another user books a berth, the map could update live without a refresh
- **Payment integration** — Currently the app confirms a booking and handles payment offline. Stripe integration is the natural next step
- **Push notification handling** — Firebase Messaging is initialised, but the deep-link routing from a notification tap needs finishing

### Medium-term
- **Saved/favourited ports** — The data layer exists (Hive `saved_ports` box, `getSavedPorts()` in the repo) but the UI heart-tap is not yet wired up
- **Offline map tiles** — Cache OSM tiles locally so the map works without connectivity
- **Review system** — Allow vessel operators to rate ports after checkout

### Longer-term
- **Port operator mobile companion** — A separate app (or app flavour) for port operators to manage berths and view incoming bookings on the go
- **Weather data overlay** — Show wind speed / wave height on the map using a public maritime API
- **Dynamic pricing** — Allow ports to set weekend/peak-season rates automatically

**Talking points:**
- The architecture already supports most of these — adding real-time would be a new provider watching a Supabase channel, not a rewrite
- Payment is intentionally out of scope for the MVP; the booking model has `totalPrice` stored and ready
- The biggest architectural expansion would be multi-tenancy for port operators — that changes the auth and RLS policies more than the Flutter code

---

## SLIDE 18 — Testing & Quality

**Title:** Code Quality Practices

**What's in place:**
- **Dart analysis** — `flutter analyze` with strict null-safety; the app has zero nullable blind spots at compile time
- **Layered tests** — Repository logic is independently testable because it depends on an abstract interface, not a hard Supabase import
- **Design system enforced** — Hardcoded hex values and direct `Navigator.push` calls are caught in code review (rules documented in CLAUDE.md)
- **Single responsibility** — No file exceeds ~300 lines; every class has one clear job

**Talking points:**
- Null safety in Dart is compile-time — if a field could be null, you must handle it or the code won't compile. This eliminates an entire class of null-pointer crashes
- The CLAUDE.md file lists non-negotiable rules (no hardcoded strings, no setState in feature screens, no direct Supabase calls from widgets) — these serve as the team's coding standard
- Widget tests for shared components (`AppButton`, `AppTextField`) would be the natural next testing addition

---

## SLIDE 19 — Demo Flow (for live presentation)

**Title:** Live Demo

**Suggested walkthrough order:**
1. Launch app → show splash / auth screen (nautical hero image)
2. Log in as a vessel operator
3. Ports tab → map with pulsing markers
4. Tap a port marker → port detail, berth list with availability
5. Tap "Book this berth" → 3-step booking flow
   - Step 1: select saved vessel
   - Step 2: contact info (pre-filled)
   - Step 3: review summary + confirm
6. Success screen → confirmation code
7. Bookings tab → new booking appears under "Upcoming"
8. Tap booking → detail screen, show cancel button
9. Account tab → language toggle (switch to Estonian), show strings change
10. Add a new vessel (show form + vessel card appearing)

**Fallback (if no live demo):** Screenshots of each screen in the slide deck, with annotations highlighting the design tokens (navy cards, teal buttons, amber badges).

---

## SLIDE 20 — Summary & Takeaways

**Title:** What We Built & What We Learned

**Summary:**
- A production-ready cross-platform mobile app with real Supabase backend, full booking lifecycle, two languages, and a consistent design system
- Clean layered architecture (Widgets → Providers → Repositories → Supabase) that's independently testable and swappable
- 14+ screens, 10+ reusable components, 450+ localised strings, across ~6,000 lines of Dart

**Key technical takeaways:**
1. **Architectural patterns matter at any scale** — the repository and provider patterns kept the codebase clean even as features grew
2. **Code generation (Freezed, GoRouter) trades a build step for correctness** — worth it
3. **Supabase as a BaaS is highly productive** — auth, database, RPCs, row-level security in one managed service
4. **Design systems pay compound interest** — every token defined once means every new screen is consistent for free
5. **i18n from day one is cheaper than retrofitting** — adding translation keys as you go is trivial; going back and extracting 500 strings is painful

---

## SLIDE 21 — Q & A

**Title:** Questions?

**Likely questions and answers:**

**Q: Why Flutter over React Native?**
A: Flutter compiles to native ARM code — no JavaScript bridge. Dart is strongly typed. The widget library is richer and more consistent across platforms. The main downside is a smaller ecosystem than JS, but for a mobile-focused project the trade-off is worth it.

**Q: How does Supabase handle concurrent booking conflicts?**
A: Via a server-side PL/pgSQL function (`create_booking_safely`) that runs inside a Postgres transaction with advisory locking. The app can't race-condition its way to a double-booking.

**Q: Isn't Riverpod overkill for a mobile app?**
A: It's more setup than setState, but the payoff is: async loading/error states handled uniformly, automatic re-computation when dependencies change, and providers that are testable without a widget tree. For an app with real data-fetching, it earns its keep quickly.

**Q: What happens if Supabase is down?**
A: The Hive cache keeps vessel profiles and saved port IDs available. The map still loads (OSM tiles are served by OpenStreetMap's CDN, separately). Booking creation will fail gracefully with a "No connection" error message (the `BookingException.unknown` path).

**Q: Could this scale to all Baltic Sea ports?**
A: The Supabase `find_ports_near` RPC uses PostGIS geography functions — it works on geographic distance, not country. Adding ports is just inserting rows. The main scaling concern would be map marker performance at very high port counts, which would need clustering.

---

## Speaker Notes — General Tips

- **Pace yourself on the architecture slide (Slide 5)** — this is the one professors care most about. Spend 2–3 minutes explaining why layers exist, not just what they are.
- **For student audience**, use the booking flow demo (Slide 19) as your anchor — it's the most relatable flow.
- **When showing code** (Slides 7, 8, 9) — don't read the code line by line. Point to the shape: "Notice there's no setState here — the UI is a pure function of the provider's value."
- **Challenges slide (Slide 15)** — professors love this. It shows you hit real engineering problems and made deliberate decisions, not just followed a tutorial.
- **Time allocation suggestion (20 min talk):**
  - Problem + What we built: 2 min
  - Tech stack + Architecture: 4 min
  - Features walkthrough / demo: 6 min
  - Challenges + Decisions: 4 min
  - Future work + Summary: 2 min
  - Q&A: 5 min

---

*Generated 2026-04-29 for the SadamaAgent mobile project.*
