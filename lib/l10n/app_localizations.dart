import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_et.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('et'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'SadamaAgent'**
  String get appName;

  /// Hero tagline on auth screen
  ///
  /// In en, this message translates to:
  /// **'Find your berth anywhere in Estonia'**
  String get tagline;

  /// Sub-tagline on auth screen
  ///
  /// In en, this message translates to:
  /// **'Real-time port availability for vessel operators'**
  String get taglineSub;

  /// Sign in button / tab label
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Create account button / tab label
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Send password reset link button
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// Confirmation message after password reset
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkEmail;

  /// Google OAuth button label
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Guest access button label
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// Subtitle under guest button
  ///
  /// In en, this message translates to:
  /// **'No account needed · Book instantly'**
  String get guestSubtitle;

  /// Footer link on sign-in form
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up free'**
  String get noAccountSignUp;

  /// Divider between auth options
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// Generic required-field validation error
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// Email format validation error
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// Body text shown after password reset email is sent
  ///
  /// In en, this message translates to:
  /// **'We sent a reset link to your email. Check your inbox.'**
  String get resetEmailSentBody;

  /// Validation error when passwords differ
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// Auth error for wrong credentials
  ///
  /// In en, this message translates to:
  /// **'Email or password incorrect'**
  String get errorInvalidCredentials;

  /// Auth error when email already registered
  ///
  /// In en, this message translates to:
  /// **'Account exists. Sign in instead?'**
  String get errorUserExists;

  /// Generic network error message
  ///
  /// In en, this message translates to:
  /// **'Connection problem. Check your connection.'**
  String get errorNetwork;

  /// Bottom nav tab label for ports
  ///
  /// In en, this message translates to:
  /// **'Ports'**
  String get portsTabLabel;

  /// Bottom nav tab label for bookings
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsTabLabel;

  /// Bottom nav tab label for account
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get meTabLabel;

  /// Search bar placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search ports, destinations…'**
  String get searchHint;

  /// Count of ports displayed in bottom sheet header
  ///
  /// In en, this message translates to:
  /// **'{count} ports found'**
  String portsFound(int count);

  /// See all ports link
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// Filter chip: nearest ports
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get filterNearest;

  /// Filter chip: available now
  ///
  /// In en, this message translates to:
  /// **'Available now'**
  String get filterAvailableNow;

  /// Filter chip: price ascending
  ///
  /// In en, this message translates to:
  /// **'Price ↑'**
  String get filterPriceAsc;

  /// Filter chip: saved ports
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get filterSaved;

  /// Button to open port detail screen
  ///
  /// In en, this message translates to:
  /// **'Check availability'**
  String get checkAvailability;

  /// Section heading on port detail
  ///
  /// In en, this message translates to:
  /// **'Available berths'**
  String get availableBerths;

  /// Button on berth card
  ///
  /// In en, this message translates to:
  /// **'Book this berth'**
  String get bookThisBerth;

  /// Price label on port list row
  ///
  /// In en, this message translates to:
  /// **'from {price}€/night'**
  String fromPricePerNight(double price);

  /// Bookings screen page title
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// Bookings screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Your berth reservations'**
  String get bookingsSubtitle;

  /// Bookings tab: upcoming
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabUpcoming;

  /// Bookings tab: past
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get tabPast;

  /// Bookings tab: cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tabCancelled;

  /// Empty state for upcoming bookings
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings'**
  String get noUpcomingBookings;

  /// Empty state for past bookings
  ///
  /// In en, this message translates to:
  /// **'No trips yet'**
  String get noTripsYet;

  /// Empty state for cancelled bookings
  ///
  /// In en, this message translates to:
  /// **'No cancellations'**
  String get noCancellations;

  /// CTA on empty upcoming bookings
  ///
  /// In en, this message translates to:
  /// **'Find a port →'**
  String get findAPort;

  /// Booking detail screen title
  ///
  /// In en, this message translates to:
  /// **'Booking details'**
  String get bookingDetails;

  /// Cancel booking button
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// Cancel confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking?'**
  String get cancelConfirmTitle;

  /// Cancel confirmation dialog body
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cancelConfirmBody;

  /// Confirm button in dialogs
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAction;

  /// Back button label
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backAction;

  /// Booking success headline
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed!'**
  String get bookingConfirmed;

  /// Note on booking success screen
  ///
  /// In en, this message translates to:
  /// **'Confirmation email sent to {email}'**
  String confirmationEmailSent(String email);

  /// Button on booking success screen
  ///
  /// In en, this message translates to:
  /// **'View booking'**
  String get viewBooking;

  /// Secondary button on booking success screen
  ///
  /// In en, this message translates to:
  /// **'Find more ports'**
  String get findMorePorts;

  /// Step 1 heading in booking flow
  ///
  /// In en, this message translates to:
  /// **'Vessel details'**
  String get vesselDetails;

  /// Step 2 heading in booking flow
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get contactInfo;

  /// Final confirm button in booking flow
  ///
  /// In en, this message translates to:
  /// **'Confirm booking €{price}'**
  String confirmBooking(double price);

  /// Continue button in multi-step flow
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Option to enter vessel details manually
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// Button on vessel selector card
  ///
  /// In en, this message translates to:
  /// **'Use this vessel'**
  String get useThisVessel;

  /// Vessel name field label
  ///
  /// In en, this message translates to:
  /// **'Vessel name'**
  String get vesselName;

  /// Vessel length field label
  ///
  /// In en, this message translates to:
  /// **'Length (m)'**
  String get vesselLength;

  /// Vessel draft field label
  ///
  /// In en, this message translates to:
  /// **'Draft (m)'**
  String get vesselDraft;

  /// Vessel beam field label
  ///
  /// In en, this message translates to:
  /// **'Beam (m)'**
  String get vesselBeam;

  /// Vessel type dropdown label
  ///
  /// In en, this message translates to:
  /// **'Vessel type'**
  String get vesselType;

  /// No description provided for @vesselTypeSailboat.
  ///
  /// In en, this message translates to:
  /// **'Sailboat'**
  String get vesselTypeSailboat;

  /// No description provided for @vesselTypeMotorboat.
  ///
  /// In en, this message translates to:
  /// **'Motorboat'**
  String get vesselTypeMotorboat;

  /// No description provided for @vesselTypeCatamaran.
  ///
  /// In en, this message translates to:
  /// **'Catamaran'**
  String get vesselTypeCatamaran;

  /// No description provided for @vesselTypeWaterTaxi.
  ///
  /// In en, this message translates to:
  /// **'Water taxi'**
  String get vesselTypeWaterTaxi;

  /// No description provided for @vesselTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vesselTypeOther;

  /// Account screen app bar title
  ///
  /// In en, this message translates to:
  /// **'SadamaAgent'**
  String get accountTitle;

  /// Section heading for vessels
  ///
  /// In en, this message translates to:
  /// **'My Vessels'**
  String get myVessels;

  /// Add vessel action label
  ///
  /// In en, this message translates to:
  /// **'+ Add'**
  String get addVessel;

  /// Empty state CTA for vessels
  ///
  /// In en, this message translates to:
  /// **'Add your first vessel'**
  String get addFirstVessel;

  /// Add vessel screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Add vessel'**
  String get addVesselTitle;

  /// Save vessel button
  ///
  /// In en, this message translates to:
  /// **'Save vessel'**
  String get saveVessel;

  /// Preferences section heading
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Notifications settings item
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Booking confirmations, reminders'**
  String get notificationsSubtitle;

  /// Language settings item
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Payment methods settings item
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethods;

  /// Payment methods subtitle
  ///
  /// In en, this message translates to:
  /// **'Add card for faster checkout'**
  String get paymentMethodsSubtitle;

  /// Terms and privacy settings item
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get termsPrivacy;

  /// Sign out settings item
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Sign out confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// Guest state headline on account screen
  ///
  /// In en, this message translates to:
  /// **'Sail with SadamaAgent'**
  String get guestAccountTitle;

  /// Guest state body on account screen
  ///
  /// In en, this message translates to:
  /// **'Create a free account to save your vessels and track bookings'**
  String get guestAccountBody;

  /// Guest footer note on account screen
  ///
  /// In en, this message translates to:
  /// **'Browsing as guest · Your bookings are tied to your email'**
  String get browsingAsGuest;

  /// Member since label in account header
  ///
  /// In en, this message translates to:
  /// **'Member since {monthYear}'**
  String memberSince(String monthYear);

  /// Footer version string on account screen
  ///
  /// In en, this message translates to:
  /// **'SadamaAgent v1.0.0 · Made in Estonia 🇪🇪'**
  String get appVersion;

  /// Berth availability badge: berths available
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availabilityAvailable;

  /// Berth availability badge: few berths remain
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get availabilityLimited;

  /// Berth availability badge: no berths available
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get availabilityFull;

  /// Booking status badge: reservation is currently active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get bookingStatusActive;

  /// Abbreviated night count shown in booking card (e.g. '3n')
  ///
  /// In en, this message translates to:
  /// **'{count}n'**
  String nightsCount(int count);

  /// Distance in kilometres shown in port list row
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String distanceKm(String distance);

  /// Title of the filter bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterSheetTitle;

  /// Apply filters button in filter sheet
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get filterApply;

  /// Reset filters button in filter sheet
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filterReset;

  /// Arrival date label
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrivalDate;

  /// Departure date label
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departureDate;

  /// Placeholder when no dates are selected
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get selectDates;

  /// Empty state when no ports match filters
  ///
  /// In en, this message translates to:
  /// **'No ports found'**
  String get noPortsFound;

  /// Subtitle on no-ports empty state
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// Retry button after an error
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Confirmation dialog title for vessel deletion
  ///
  /// In en, this message translates to:
  /// **'Remove this vessel?'**
  String get deleteVesselTitle;

  /// Confirm remove/delete action in dialogs
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeAction;

  /// Notes field label in booking flow step 2
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// Notes field hint in booking flow step 2
  ///
  /// In en, this message translates to:
  /// **'Arrival time, special requests…'**
  String get notesHint;

  /// Edit button to toggle read-only pre-filled fields
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// Auth prompt sheet title shown before booking flow
  ///
  /// In en, this message translates to:
  /// **'Sign in to confirm your booking'**
  String get signInToBook;

  /// Error shown when selected berth becomes unavailable during booking
  ///
  /// In en, this message translates to:
  /// **'Berth no longer available'**
  String get berthConflictError;

  /// Button to open maps for directions to a port
  ///
  /// In en, this message translates to:
  /// **'Get directions'**
  String get getDirections;

  /// Status banner for an upcoming booking
  ///
  /// In en, this message translates to:
  /// **'Arriving in {days} days'**
  String arrivingInDays(int days);

  /// Status banner for an active (currently berthed) booking
  ///
  /// In en, this message translates to:
  /// **'Currently berthed'**
  String get currentlyBerthed;

  /// Status banner for a completed booking
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// Snackbar shown after a booking is successfully cancelled
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookingCancelledSuccess;

  /// Snackbar shown after a vessel is saved successfully
  ///
  /// In en, this message translates to:
  /// **'Vessel saved!'**
  String get vesselSavedSuccess;

  /// Column header for night count in dates card
  ///
  /// In en, this message translates to:
  /// **'Nights'**
  String get nights;

  /// Check-in time label on booking detail
  ///
  /// In en, this message translates to:
  /// **'Check-in: 14:00'**
  String get checkInTime;

  /// Check-out time label on booking detail
  ///
  /// In en, this message translates to:
  /// **'Check-out: 11:00'**
  String get checkOutTime;

  /// Payment status badge: booking is paid / confirmed
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentStatusPaid;

  /// Payment status badge: booking is pending payment
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentStatusPending;

  /// Berth count label in port preview
  ///
  /// In en, this message translates to:
  /// **'{count} berths free'**
  String berthsFreeCount(int count);

  /// Title of the booking-error dialog
  ///
  /// In en, this message translates to:
  /// **'Booking failed'**
  String get bookingFailed;

  /// Generic OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Action button when a berth is unavailable
  ///
  /// In en, this message translates to:
  /// **'Find another berth'**
  String get findAnotherBerth;

  /// Error when the target berth is missing or inactive
  ///
  /// In en, this message translates to:
  /// **'This berth is no longer available. Please choose another.'**
  String get bookingErrorBerthNotFound;

  /// Error when vessel length exceeds berth maximum
  ///
  /// In en, this message translates to:
  /// **'Your vessel is too long for this berth.'**
  String get bookingErrorVesselTooLong;

  /// Error when vessel draft exceeds berth maximum
  ///
  /// In en, this message translates to:
  /// **'Your vessel\'s draft exceeds this berth\'s depth limit.'**
  String get bookingErrorVesselTooDeep;

  /// Error when an overlapping booking exists
  ///
  /// In en, this message translates to:
  /// **'This berth was just booked by someone else. Please choose different dates or another berth.'**
  String get bookingErrorBerthUnavailable;

  /// Headline on the signup email confirmation screen
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get signupConfirmationTitle;

  /// Body text on the signup email confirmation screen
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {email}. Click it to activate your account.'**
  String signupConfirmationMessage(String email);

  /// Button to open the default mail app
  ///
  /// In en, this message translates to:
  /// **'Open mail app'**
  String get openMailApp;

  /// Link to go back to the sign-in screen
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// Note above the resend button on signup confirmation screen
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the email? Check spam or'**
  String get didntGetEmail;

  /// Countdown label while the resend button is disabled
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// Button to resend the signup confirmation email
  ///
  /// In en, this message translates to:
  /// **'Resend confirmation email'**
  String get resendNow;

  /// Title of the dialog shown when a port operator tries to sign in on mobile
  ///
  /// In en, this message translates to:
  /// **'Wrong account type'**
  String get wrongAccountTitle;

  /// Body of the wrong-account-type dialog
  ///
  /// In en, this message translates to:
  /// **'This account is a port manager account. The mobile app is for vessel operators. Please use the web dashboard instead.'**
  String get wrongAccountMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'et'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'et':
      return AppLocalizationsEt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
