// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get appName => 'SadamaAgent';

  @override
  String get tagline => 'Leia oma kaid kõikjal Eestis';

  @override
  String get taglineSub =>
      'Reaalajas sadamakohtade saadavus laevaoperaatoritele';

  @override
  String get signIn => 'Logi sisse';

  @override
  String get createAccount => 'Loo konto';

  @override
  String get email => 'E-post';

  @override
  String get password => 'Salasõna';

  @override
  String get confirmPassword => 'Kinnita salasõna';

  @override
  String get fullName => 'Täisnimi';

  @override
  String get forgotPassword => 'Unustasid salasõna?';

  @override
  String get sendResetLink => 'Saada lähtestamislink';

  @override
  String get checkEmail => 'Kontrolli oma e-posti';

  @override
  String get continueWithGoogle => 'Jätka Google\'iga';

  @override
  String get continueAsGuest => 'Jätka külalisena';

  @override
  String get guestSubtitle => 'Kontot pole vaja · Broneeri kohe';

  @override
  String get noAccountSignUp => 'Pole kontot? Registreeru tasuta';

  @override
  String get orDivider => 'või';

  @override
  String get fieldRequired => 'Kohustuslik';

  @override
  String get invalidEmail => 'Sisesta kehtiv e-post';

  @override
  String get resetEmailSentBody =>
      'Saatsime lähtestamislingi sinu e-postile. Kontrolli postkasti.';

  @override
  String get passwordMismatch => 'Salasõnad ei kattu';

  @override
  String get errorInvalidCredentials => 'E-post või salasõna on vale';

  @override
  String get errorUserExists => 'Konto on olemas. Logi sisse?';

  @override
  String get errorNetwork => 'Ühenduse probleem. Kontrolli ühendust.';

  @override
  String get portsTabLabel => 'Sadamad';

  @override
  String get bookingsTabLabel => 'Broneeringud';

  @override
  String get meTabLabel => 'Mina';

  @override
  String get searchHint => 'Otsi sadamaid, sihtkohti…';

  @override
  String portsFound(int count) {
    return '$count sadamat leitud';
  }

  @override
  String get seeAll => 'Vaata kõiki';

  @override
  String get filterNearest => 'Lähimad';

  @override
  String get filterAvailableNow => 'Saadaval nüüd';

  @override
  String get filterPriceAsc => 'Hind ↑';

  @override
  String get filterSaved => 'Salvestatud';

  @override
  String get checkAvailability => 'Kontrolli saadavust';

  @override
  String get availableBerths => 'Saadaolevad kaied';

  @override
  String get bookThisBerth => 'Broneeri see kaid';

  @override
  String fromPricePerNight(double price) {
    return 'alates $price€/öö';
  }

  @override
  String get myBookings => 'Minu broneeringud';

  @override
  String get bookingsSubtitle => 'Sinu kaikoha reserveeringud';

  @override
  String get tabUpcoming => 'Tulevased';

  @override
  String get tabPast => 'Möödunud';

  @override
  String get tabCancelled => 'Tühistatud';

  @override
  String get noUpcomingBookings => 'Tulevasi broneeringuid pole';

  @override
  String get noTripsYet => 'Reise pole veel';

  @override
  String get noCancellations => 'Tühistusi pole';

  @override
  String get findAPort => 'Leia sadam →';

  @override
  String get bookingDetails => 'Broneeringu andmed';

  @override
  String get cancelBooking => 'Tühista broneering';

  @override
  String get cancelConfirmTitle => 'Tühista see broneering?';

  @override
  String get cancelConfirmBody => 'Seda toimingut ei saa tagasi võtta.';

  @override
  String get confirmAction => 'Kinnita';

  @override
  String get backAction => 'Tagasi';

  @override
  String get bookingConfirmed => 'Broneering kinnitatud!';

  @override
  String confirmationEmailSent(String email) {
    return 'Kinnituse e-kiri saadeti aadressile $email';
  }

  @override
  String get viewBooking => 'Vaata broneeringut';

  @override
  String get findMorePorts => 'Leia rohkem sadamaid';

  @override
  String get vesselDetails => 'Laeva andmed';

  @override
  String get contactInfo => 'Kontaktandmed';

  @override
  String confirmBooking(double price) {
    return 'Kinnita broneering €$price';
  }

  @override
  String get continueAction => 'Jätka';

  @override
  String get enterManually => 'Sisesta käsitsi';

  @override
  String get useThisVessel => 'Kasuta seda laeva';

  @override
  String get vesselName => 'Laeva nimi';

  @override
  String get vesselLength => 'Pikkus (m)';

  @override
  String get vesselDraft => 'Süvis (m)';

  @override
  String get vesselBeam => 'Laius (m)';

  @override
  String get vesselType => 'Laeva tüüp';

  @override
  String get vesselTypeSailboat => 'Purjelaev';

  @override
  String get vesselTypeMotorboat => 'Mootorpaat';

  @override
  String get vesselTypeCatamaran => 'Katamaran';

  @override
  String get vesselTypeWaterTaxi => 'Veetakso';

  @override
  String get vesselTypeOther => 'Muu';

  @override
  String get accountTitle => 'SadamaAgent';

  @override
  String get myVessels => 'Minu laevad';

  @override
  String get addVessel => '+ Lisa';

  @override
  String get addFirstVessel => 'Lisa oma esimene laev';

  @override
  String get addVesselTitle => 'Lisa laev';

  @override
  String get saveVessel => 'Salvesta laev';

  @override
  String get preferences => 'Eelistused';

  @override
  String get notifications => 'Teavitused';

  @override
  String get notificationsSubtitle =>
      'Broneeringute kinnitused, meeldetuletused';

  @override
  String get language => 'Keel';

  @override
  String get paymentMethods => 'Makseviisid';

  @override
  String get paymentMethodsSubtitle => 'Lisa kaart kiireks kassasse';

  @override
  String get termsPrivacy => 'Tingimused ja privaatsus';

  @override
  String get signOut => 'Logi välja';

  @override
  String get signOutConfirmTitle => 'Logid välja?';

  @override
  String get guestAccountTitle => 'Sõida SadamaAgentiga';

  @override
  String get guestAccountBody =>
      'Loo tasuta konto, et salvestada oma laevu ja jälgida broneeringuid';

  @override
  String get browsingAsGuest =>
      'Sirvin külalisena · Sinu broneeringud on seotud sinu e-postiga';

  @override
  String memberSince(String monthYear) {
    return 'Liige alates $monthYear';
  }

  @override
  String get appVersion => 'SadamaAgent v1.0.0 · Tehtud Eestis 🇪🇪';

  @override
  String get availabilityAvailable => 'Saadaval';

  @override
  String get availabilityLimited => 'Piiratud';

  @override
  String get availabilityFull => 'Täis';

  @override
  String get bookingStatusActive => 'Aktiivne';

  @override
  String nightsCount(int count) {
    return '$countö';
  }

  @override
  String distanceKm(String distance) {
    return '$distance km';
  }

  @override
  String get filterSheetTitle => 'Filtrid';

  @override
  String get filterApply => 'Rakenda filtrid';

  @override
  String get filterReset => 'Lähtesta';

  @override
  String get arrivalDate => 'Saabumine';

  @override
  String get departureDate => 'Väljumine';

  @override
  String get selectDates => 'Vali kuupäevad';

  @override
  String get noPortsFound => 'Sadamaid ei leitud';

  @override
  String get tryAdjustingFilters => 'Proovi filtreid muuta';

  @override
  String get retry => 'Proovi uuesti';

  @override
  String get deleteVesselTitle => 'Eemalda see laev?';

  @override
  String get removeAction => 'Eemalda';

  @override
  String get notesLabel => 'Märkused';

  @override
  String get notesHint => 'Saabumisaeg, eripäringud…';

  @override
  String get editAction => 'Muuda';

  @override
  String get signInToBook => 'Logi sisse broneeringu kinnitamiseks';

  @override
  String get berthConflictError => 'Kaid pole enam saadaval';

  @override
  String get getDirections => 'Juhised';

  @override
  String arrivingInDays(int days) {
    return 'Saabumine $days päeva pärast';
  }

  @override
  String get currentlyBerthed => 'Praegu kais';

  @override
  String get bookingStatusCompleted => 'Lõpetatud';

  @override
  String get bookingCancelledSuccess => 'Broneering tühistatud';

  @override
  String get vesselSavedSuccess => 'Laev salvestatud!';

  @override
  String get nights => 'Ööd';

  @override
  String get checkInTime => 'Sisseregistreerimine: 14:00';

  @override
  String get checkOutTime => 'Väljaregistreerimine: 11:00';

  @override
  String get paymentStatusPaid => 'Makstud';

  @override
  String get paymentStatusPending => 'Ootel';

  @override
  String berthsFreeCount(int count) {
    return '$count kaied vabad';
  }

  @override
  String get bookingFailed => 'Broneerimine ebaõnnestus';

  @override
  String get ok => 'OK';

  @override
  String get findAnotherBerth => 'Leia teine kaid';

  @override
  String get bookingErrorBerthNotFound =>
      'See kaikoht ei ole enam saadaval. Palun vali teine.';

  @override
  String get bookingErrorVesselTooLong =>
      'Teie alus on selle kaikoha jaoks liiga pikk.';

  @override
  String get bookingErrorVesselTooDeep =>
      'Teie aluse süvis ületab selle kaikoha sügavuse.';

  @override
  String get bookingErrorBerthUnavailable =>
      'See kaikoht broneeriti just kellegi teise poolt. Palun vali teised kuupäevad või teine kaid.';

  @override
  String get signupConfirmationTitle => 'Kontrolli oma e-posti';

  @override
  String signupConfirmationMessage(String email) {
    return 'Saatsime kinnituslingi aadressile $email. Klõpsa sellel, et oma konto aktiveerida.';
  }

  @override
  String get openMailApp => 'Ava e-posti rakendus';

  @override
  String get backToSignIn => 'Tagasi sisselogimisse';

  @override
  String get didntGetEmail => 'E-kirja ei saanud? Kontrolli rämpsposti või';

  @override
  String resendIn(int seconds) {
    return 'Saada uuesti ${seconds}s pärast';
  }

  @override
  String get resendNow => 'Saada kinnitus uuesti';

  @override
  String get wrongAccountTitle => 'Vale kontotüüp';

  @override
  String get wrongAccountMessage =>
      'See on sadama haldaja konto. Mobiilirakendus on aluste operaatoritele. Palun kasuta veebipõhist töölauda.';
}
