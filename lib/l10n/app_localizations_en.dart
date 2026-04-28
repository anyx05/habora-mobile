// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SadamaAgent';

  @override
  String get tagline => 'Find your berth anywhere in Estonia';

  @override
  String get taglineSub => 'Real-time port availability for vessel operators';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get fullName => 'Full name';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get checkEmail => 'Check your email';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get guestSubtitle => 'No account needed · Book instantly';

  @override
  String get noAccountSignUp => 'Don\'t have an account? Sign up free';

  @override
  String get orDivider => 'or';

  @override
  String get fieldRequired => 'Required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get resetEmailSentBody =>
      'We sent a reset link to your email. Check your inbox.';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get errorInvalidCredentials => 'Email or password incorrect';

  @override
  String get errorUserExists => 'Account exists. Sign in instead?';

  @override
  String get errorNetwork => 'Connection problem. Check your connection.';

  @override
  String get portsTabLabel => 'Ports';

  @override
  String get bookingsTabLabel => 'Bookings';

  @override
  String get meTabLabel => 'Me';

  @override
  String get searchHint => 'Search ports, destinations…';

  @override
  String portsFound(int count) {
    return '$count ports found';
  }

  @override
  String get seeAll => 'See all';

  @override
  String get filterNearest => 'Nearest';

  @override
  String get filterAvailableNow => 'Available now';

  @override
  String get filterPriceAsc => 'Price ↑';

  @override
  String get filterSaved => 'Saved';

  @override
  String get checkAvailability => 'Check availability';

  @override
  String get availableBerths => 'Available berths';

  @override
  String get bookThisBerth => 'Book this berth';

  @override
  String fromPricePerNight(double price) {
    return 'from $price€/night';
  }

  @override
  String get myBookings => 'My Bookings';

  @override
  String get bookingsSubtitle => 'Your berth reservations';

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabPast => 'Past';

  @override
  String get tabCancelled => 'Cancelled';

  @override
  String get noUpcomingBookings => 'No upcoming bookings';

  @override
  String get noTripsYet => 'No trips yet';

  @override
  String get noCancellations => 'No cancellations';

  @override
  String get findAPort => 'Find a port →';

  @override
  String get bookingDetails => 'Booking details';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get cancelConfirmTitle => 'Cancel this booking?';

  @override
  String get cancelConfirmBody => 'This action cannot be undone.';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get backAction => 'Back';

  @override
  String get bookingConfirmed => 'Booking confirmed!';

  @override
  String confirmationEmailSent(String email) {
    return 'Confirmation email sent to $email';
  }

  @override
  String get viewBooking => 'View booking';

  @override
  String get findMorePorts => 'Find more ports';

  @override
  String get vesselDetails => 'Vessel details';

  @override
  String get contactInfo => 'Contact info';

  @override
  String confirmBooking(double price) {
    return 'Confirm booking €$price';
  }

  @override
  String get continueAction => 'Continue';

  @override
  String get enterManually => 'Enter manually';

  @override
  String get useThisVessel => 'Use this vessel';

  @override
  String get vesselName => 'Vessel name';

  @override
  String get vesselLength => 'Length (m)';

  @override
  String get vesselDraft => 'Draft (m)';

  @override
  String get vesselBeam => 'Beam (m)';

  @override
  String get vesselType => 'Vessel type';

  @override
  String get vesselTypeSailboat => 'Sailboat';

  @override
  String get vesselTypeMotorboat => 'Motorboat';

  @override
  String get vesselTypeCatamaran => 'Catamaran';

  @override
  String get vesselTypeWaterTaxi => 'Water taxi';

  @override
  String get vesselTypeOther => 'Other';

  @override
  String get accountTitle => 'SadamaAgent';

  @override
  String get myVessels => 'My Vessels';

  @override
  String get addVessel => '+ Add';

  @override
  String get addFirstVessel => 'Add your first vessel';

  @override
  String get addVesselTitle => 'Add vessel';

  @override
  String get saveVessel => 'Save vessel';

  @override
  String get preferences => 'Preferences';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsSubtitle => 'Booking confirmations, reminders';

  @override
  String get language => 'Language';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get paymentMethodsSubtitle => 'Add card for faster checkout';

  @override
  String get termsPrivacy => 'Terms & Privacy';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get guestAccountTitle => 'Sail with SadamaAgent';

  @override
  String get guestAccountBody =>
      'Create a free account to save your vessels and track bookings';

  @override
  String get browsingAsGuest =>
      'Browsing as guest · Your bookings are tied to your email';

  @override
  String memberSince(String monthYear) {
    return 'Member since $monthYear';
  }

  @override
  String get appVersion => 'SadamaAgent v1.0.0 · Made in Estonia 🇪🇪';

  @override
  String get availabilityAvailable => 'Available';

  @override
  String get availabilityLimited => 'Limited';

  @override
  String get availabilityFull => 'Full';

  @override
  String get bookingStatusActive => 'Active';

  @override
  String nightsCount(int count) {
    return '${count}n';
  }

  @override
  String distanceKm(String distance) {
    return '$distance km';
  }

  @override
  String get filterSheetTitle => 'Filters';

  @override
  String get filterApply => 'Apply filters';

  @override
  String get filterReset => 'Reset';

  @override
  String get arrivalDate => 'Arrival';

  @override
  String get departureDate => 'Departure';

  @override
  String get selectDates => 'Select dates';

  @override
  String get noPortsFound => 'No ports found';

  @override
  String get tryAdjustingFilters => 'Try adjusting your filters';

  @override
  String get retry => 'Retry';

  @override
  String get deleteVesselTitle => 'Remove this vessel?';

  @override
  String get removeAction => 'Remove';

  @override
  String get notesLabel => 'Notes';

  @override
  String get notesHint => 'Arrival time, special requests…';

  @override
  String get editAction => 'Edit';

  @override
  String get signInToBook => 'Sign in to confirm your booking';

  @override
  String get berthConflictError => 'Berth no longer available';

  @override
  String get getDirections => 'Get directions';

  @override
  String arrivingInDays(int days) {
    return 'Arriving in $days days';
  }

  @override
  String get currentlyBerthed => 'Currently berthed';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingCancelledSuccess => 'Booking cancelled';

  @override
  String get vesselSavedSuccess => 'Vessel saved!';

  @override
  String get nights => 'Nights';

  @override
  String get checkInTime => 'Check-in: 14:00';

  @override
  String get checkOutTime => 'Check-out: 11:00';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusPending => 'Pending';

  @override
  String berthsFreeCount(int count) {
    return '$count berths free';
  }

  @override
  String get bookingFailed => 'Booking failed';

  @override
  String get ok => 'OK';

  @override
  String get findAnotherBerth => 'Find another berth';

  @override
  String get bookingErrorBerthNotFound =>
      'This berth is no longer available. Please choose another.';

  @override
  String get bookingErrorVesselTooLong =>
      'Your vessel is too long for this berth.';

  @override
  String get bookingErrorVesselTooDeep =>
      'Your vessel\'s draft exceeds this berth\'s depth limit.';

  @override
  String get bookingErrorBerthUnavailable =>
      'This berth was just booked by someone else. Please choose different dates or another berth.';

  @override
  String get signupConfirmationTitle => 'Check your email';

  @override
  String signupConfirmationMessage(String email) {
    return 'We sent a confirmation link to $email. Click it to activate your account.';
  }

  @override
  String get openMailApp => 'Open mail app';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get didntGetEmail => 'Didn\'t get the email? Check spam or';

  @override
  String resendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get resendNow => 'Resend confirmation email';

  @override
  String get wrongAccountTitle => 'Wrong account type';

  @override
  String get wrongAccountMessage =>
      'This account is a port manager account. The mobile app is for vessel operators. Please use the web dashboard instead.';
}
