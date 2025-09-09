import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

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
    Locale('kk'),
    Locale('ru')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Til Bil'**
  String get appTitle;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboarding;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @learnKazakhFree.
  ///
  /// In en, this message translates to:
  /// **'Learn Kazakh language for free!'**
  String get learnKazakhFree;

  /// No description provided for @joinMillions.
  ///
  /// In en, this message translates to:
  /// **'Join millions of people learning languages with us'**
  String get joinMillions;

  /// No description provided for @learnAtYourPace.
  ///
  /// In en, this message translates to:
  /// **'Learn at your own pace'**
  String get learnAtYourPace;

  /// No description provided for @personalizedLessons.
  ///
  /// In en, this message translates to:
  /// **'Personalized lessons that adapt to your schedule'**
  String get personalizedLessons;

  /// No description provided for @practiceDaily.
  ///
  /// In en, this message translates to:
  /// **'Practice every day'**
  String get practiceDaily;

  /// No description provided for @tenMinutesDaily.
  ///
  /// In en, this message translates to:
  /// **'Just 10 minutes a day will help you master a new language'**
  String get tenMinutesDaily;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @startLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'👤 My Profile'**
  String get myProfile;

  /// No description provided for @youngLearner.
  ///
  /// In en, this message translates to:
  /// **'🌟 Young Learner'**
  String get youngLearner;

  /// No description provided for @beginnerExplorer.
  ///
  /// In en, this message translates to:
  /// **'🚀 A1 • Beginner Explorer'**
  String get beginnerExplorer;

  /// No description provided for @studyTime.
  ///
  /// In en, this message translates to:
  /// **'Study Time'**
  String get studyTime;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'⚙️ Settings'**
  String get appSettings;

  /// No description provided for @myAchievements.
  ///
  /// In en, this message translates to:
  /// **'🎖️ My Achievements'**
  String get myAchievements;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'🔒 Security'**
  String get security;

  /// No description provided for @switchUser.
  ///
  /// In en, this message translates to:
  /// **'🔄 Switch User'**
  String get switchUser;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'👋 Sign Out'**
  String get signOut;

  /// No description provided for @seeYouLater.
  ///
  /// In en, this message translates to:
  /// **'See you later!'**
  String get seeYouLater;

  /// No description provided for @sureToSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get sureToSignOut;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @signOutAction.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutAction;

  /// No description provided for @goodbye.
  ///
  /// In en, this message translates to:
  /// **'Goodbye!'**
  String get goodbye;

  /// No description provided for @oopsError.
  ///
  /// In en, this message translates to:
  /// **'😔 Oops! Something went wrong. Try again!'**
  String get oopsError;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'🌍 Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your language'**
  String get selectLanguage;

  /// No description provided for @kazakh.
  ///
  /// In en, this message translates to:
  /// **'Қазақша'**
  String get kazakh;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'🔔 Notifications'**
  String get notifications;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'🔊 Sound'**
  String get sound;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'🎨 Theme'**
  String get theme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'ℹ️ About'**
  String get about;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signInToAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @enterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password to continue'**
  String get enterEmailPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started!'**
  String get getStarted;

  /// No description provided for @createAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start learning'**
  String get createAccountDescription;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minutes;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @daysInRow.
  ///
  /// In en, this message translates to:
  /// **'Days in a row'**
  String get daysInRow;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @switchUserAction.
  ///
  /// In en, this message translates to:
  /// **'Switch User'**
  String get switchUserAction;

  /// No description provided for @signOutOfAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign out of account'**
  String get signOutOfAccount;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of account'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out of your account?'**
  String get signOutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @errorSigningOut.
  ///
  /// In en, this message translates to:
  /// **'Error signing out: {error}'**
  String errorSigningOut(String error);

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {error}'**
  String loginFailed(String error);

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccessful;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed: {error}'**
  String registrationFailed(String error);

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @alreadyHaveAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccountQuestion;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello! 👋'**
  String get hello;

  /// No description provided for @readyToLearnKazakh.
  ///
  /// In en, this message translates to:
  /// **'Ready to learn Kazakh?'**
  String get readyToLearnKazakh;

  /// No description provided for @dayStreakSeries.
  ///
  /// In en, this message translates to:
  /// **'Day streak series'**
  String get dayStreakSeries;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going!'**
  String get keepGoing;

  /// No description provided for @pronunciation.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation'**
  String get pronunciation;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'exercises'**
  String get exercises;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get yourProgress;

  /// No description provided for @alphabet.
  ///
  /// In en, this message translates to:
  /// **'Alphabet'**
  String get alphabet;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there!'**
  String get almostThere;

  /// No description provided for @grammar.
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get grammar;

  /// No description provided for @keepItUp.
  ///
  /// In en, this message translates to:
  /// **'Keep it up!'**
  String get keepItUp;

  /// No description provided for @greatStart.
  ///
  /// In en, this message translates to:
  /// **'Great start!'**
  String get greatStart;

  /// No description provided for @levelProgress.
  ///
  /// In en, this message translates to:
  /// **'Level Progress'**
  String get levelProgress;

  /// No description provided for @xp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @earnedRewards.
  ///
  /// In en, this message translates to:
  /// **'Earned {count} rewards out of {total}'**
  String earnedRewards(int count, int total);

  /// No description provided for @quickLearner.
  ///
  /// In en, this message translates to:
  /// **'Quick Learner'**
  String get quickLearner;

  /// No description provided for @quickLearnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Completed 10 lessons in less than 5 minutes'**
  String get quickLearnerDesc;

  /// No description provided for @ambitious.
  ///
  /// In en, this message translates to:
  /// **'Ambitious'**
  String get ambitious;

  /// No description provided for @ambitiousDesc.
  ///
  /// In en, this message translates to:
  /// **'Reached 15 learning goals'**
  String get ambitiousDesc;

  /// No description provided for @consistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get consistency;

  /// No description provided for @consistencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Study for 30 days in a row'**
  String get consistencyDesc;

  /// No description provided for @wordMaster.
  ///
  /// In en, this message translates to:
  /// **'Word Master'**
  String get wordMaster;

  /// No description provided for @wordMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn 500 new words'**
  String get wordMasterDesc;

  /// No description provided for @languageLevels.
  ///
  /// In en, this message translates to:
  /// **'Language Levels'**
  String get languageLevels;

  /// No description provided for @availableLevels.
  ///
  /// In en, this message translates to:
  /// **'Available Levels'**
  String get availableLevels;

  /// No description provided for @currentLevel.
  ///
  /// In en, this message translates to:
  /// **'Current Level'**
  String get currentLevel;

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nextLevel;

  /// No description provided for @continueLevel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLevel;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @chooseLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you want to use for the app interface'**
  String get chooseLanguageDescription;

  /// No description provided for @confirmLanguage.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmLanguage;
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
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
