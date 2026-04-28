# CLAUDE.md — lib/features/account/
## Account Feature Agent context

Your role: the Me tab screen and vessel management.
This screen looks different for authenticated vs guest users.

### AccountScreen (lib/features/account/account_screen.dart)
Watch: currentUserProvider, isGuestProvider, userVesselsProvider

### State: Guest user
Show a simplified screen:
  Large illustration or icon (anchor in teal circle)
  "Sail with SadamaAgent"
  "Create a free account to save your vessels and track bookings"
  AppButton("Create account", primary) → Routes.signup
  AppButton("Sign in", ghost) → Routes.login
  Thin divider
  Text: "Browsing as guest · Your bookings are tied to your email"

### State: Authenticated user
Navy header:
  Avatar circle (teal gradient, initial letter of name, 52px)
  Name (bold white 16px)
  Email (dim white 12px)
  "Member since {month year}" (very dim white 10px)
  Edit icon (top right) → Routes.editProfile

Scrollable body:

Section 1 — My Vessels (VesselSection widget)
  SectionHeader("My Vessels", action: "+ Add")
  If vessels loaded:
    List of VesselCard widgets (from shared/widgets)
    Swipe-to-delete → confirmation dialog → deleteVessel
  If empty:
    Dashed add button: "Add your first vessel"
  "+ Add" or dashed button → Routes.addVessel

Section 2 — Preferences (white card, border)
  SectionHeader("Preferences")
  SettingsItem(icon: bell, "Notifications", sub: "Booking confirmations, reminders")
  SettingsItem(icon: globe, "Language", sub: current locale)
    → opens language picker bottom sheet (EN / ET)
  SettingsItem(icon: credit card, "Payment methods", sub: "Add card for faster checkout")
    → Routes.paymentMethods (stub screen for now)

Section 3 — Other (white card, border)
  SettingsItem(icon: document, "Terms & Privacy")
    → launches URL
  SettingsItem(icon: door, "Sign out", isDanger: true)
    → confirmation dialog → ref.read(authProvider.notifier).signOut()
    → context.go(Routes.ports)

Footer: "SadamaAgent v1.0.0 · Made in Estonia 🇪🇪"
  DM Mono, 10px, slateLight, centered

### AddVesselScreen (lib/features/account/add_vessel_screen.dart)
Route: /account/vessels/add
  AppBar: "Add vessel" + close X
  Form:
    AppTextField: Vessel name
    DropdownButton: Vessel type (Sailboat / Motorboat / Catamaran / Water taxi / Other)
    AppTextField: Length (metres, number keyboard, suffix "m")
    AppTextField: Draft (metres, number keyboard, suffix "m")
    AppTextField: Beam (optional, metres)
    AppTextField: Registration number (optional)
  "Save vessel" primary button
  On save → createVessel → invalidate userVesselsProvider → pop → show success snackbar

### SettingsItem widget (local to account feature, not shared)
  Row: icon box (32px rounded, colored bg) | label + subtitle | chevron
  Optional isDanger: true → label in dangerRed, no chevron