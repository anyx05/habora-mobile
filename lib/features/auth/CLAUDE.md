# CLAUDE.md — lib/features/auth/
## Auth Feature Agent context

Your role: login, signup, and guest flow screens.
Do not build business logic beyond auth — that is in auth_provider.dart.

### AuthScreen (lib/features/auth/auth_screen.dart)
Route: /auth/login and /auth/signup (same screen, tab controls mode)

Two-part layout:
  Top hero (220px fixed height):
    Background: navy deep (#0D1F3C)
    SVG nautical chart decoration (grid lines, island shapes, glowing markers)
      - render this as a CustomPaint or embedded SVG asset
    Logo row (top-left): teal rounded square + anchor emoji + "SadamaAgent" text
    Tagline (bottom-left):
      H1: "Find your berth anywhere in Estonia"
      Sub: "Real-time port availability for vessel operators"

  Bottom auth body (white, rounded top corners 24px, fills remaining space):
    Toggle row: "Sign in" | "Create account" (pill toggle, active = white on off-white)
    
    Sign in fields:
      AppTextField (email, email keyboard, mail prefix icon)
      AppTextField (password, obscureText, lock prefix icon)
      "Forgot password?" right-aligned link (teal, 11px)
      AppButton("Sign in", variant: primary)
    
    Create account fields (when toggle = signup):
      AppTextField (full name, person prefix icon)
      AppTextField (email)
      AppTextField (password)
      AppTextField (confirm password, validate match)
      AppButton("Create account", variant: primary)
    
    Divider "or"
    AppButton("Continue with Google", variant: ghost, icon: Google SVG asset)
    Divider "or"
    AppButton("Continue as guest", variant: ghost, dashed border)
      Subtitle below: "No account needed · Book instantly"
    
    Footer: "Don't have an account? Sign up free" (links switch toggle)

### Auth logic (call providers, don't implement directly)
Sign in → ref.read(authProvider.notifier).signInWithEmail(email, password)
Sign up → ref.read(authProvider.notifier).signUpWithEmail(email, password, fullName)
Google → ref.read(authProvider.notifier).signInWithGoogle()
Guest → ref.read(authProvider.notifier).signInAnonymously()

After any successful auth:
  If returnTo param exists → context.go(returnTo)
  Else → context.go(Routes.ports)

Error handling:
  AuthException 'Invalid login credentials' → "Email or password incorrect"
  AuthException 'User already registered' → "Account exists. Sign in instead?" 
  Network error → "Connection problem. Check your connection."
  All errors → show via AppSnackbar.error(context, message)

### ForgotPasswordScreen (lib/features/auth/forgot_password_screen.dart)
Route: /auth/forgot-password
  Simple: email field + "Send reset link" button
  On success: "Check your email" confirmation state replaces form

### Auth redirects (handled in router.dart, documented here for reference)
  Public routes (no auth needed): /ports, /ports/:slug, /auth/*
  Guest-ok routes: /booking/new (anonymous session created inline)
  Auth-required routes: /bookings, /account, /account/vessels
  If unauthenticated hits auth-required → redirect to /auth/login?returnTo={path}