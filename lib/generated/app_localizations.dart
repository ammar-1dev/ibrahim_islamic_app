import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru'),
    Locale('tr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Ibrahim'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your daily spiritual companion'**
  String get appTagline;

  /// No description provided for @appShareText.
  ///
  /// In en, this message translates to:
  /// **'Ibrahim - Your daily spiritual companion\nEverything you need for a complete faith journey: Quran, Azkar, Dua, Prayer times, and more!\nDownload it now'**
  String get appShareText;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get navQuran;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navBooks.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navBooks;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'Ibrahim AI'**
  String get navAiAssistant;

  /// No description provided for @navAzkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get navAzkar;

  /// No description provided for @navDua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get navDua;

  /// No description provided for @navQibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get navQibla;

  /// No description provided for @navSeerah.
  ///
  /// In en, this message translates to:
  /// **'Seerah'**
  String get navSeerah;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @quickAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccessTitle;

  /// No description provided for @quickMushaf.
  ///
  /// In en, this message translates to:
  /// **'Mushaf'**
  String get quickMushaf;

  /// No description provided for @quickHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get quickHadith;

  /// No description provided for @quickPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get quickPrayerTimes;

  /// No description provided for @quickQibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get quickQibla;

  /// No description provided for @quickMosqueMap.
  ///
  /// In en, this message translates to:
  /// **'Nearby Mosques'**
  String get quickMosqueMap;

  /// No description provided for @quickDua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get quickDua;

  /// No description provided for @quickMorningAzkar.
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get quickMorningAzkar;

  /// No description provided for @quickEveningAzkar.
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar'**
  String get quickEveningAzkar;

  /// No description provided for @quickMiscAzkar.
  ///
  /// In en, this message translates to:
  /// **'Various Azkar'**
  String get quickMiscAzkar;

  /// No description provided for @quickQuranAudio.
  ///
  /// In en, this message translates to:
  /// **'Quran Audio'**
  String get quickQuranAudio;

  /// No description provided for @quickQuranSearch.
  ///
  /// In en, this message translates to:
  /// **'Quran Search'**
  String get quickQuranSearch;

  /// No description provided for @quickBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get quickBookmarks;

  /// No description provided for @quickLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get quickLibrary;

  /// No description provided for @quickSeerah.
  ///
  /// In en, this message translates to:
  /// **'Prophetic Biography'**
  String get quickSeerah;

  /// No description provided for @quickFiqh.
  ///
  /// In en, this message translates to:
  /// **'Fiqh of Worship'**
  String get quickFiqh;

  /// No description provided for @quickJourney.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get quickJourney;

  /// No description provided for @quickCompanions.
  ///
  /// In en, this message translates to:
  /// **'Islamic Figures'**
  String get quickCompanions;

  /// No description provided for @quickTajweed.
  ///
  /// In en, this message translates to:
  /// **'Tajweed'**
  String get quickTajweed;

  /// No description provided for @quickWomensSection.
  ///
  /// In en, this message translates to:
  /// **'Women\'s Section'**
  String get quickWomensSection;

  /// No description provided for @quickRuqyah.
  ///
  /// In en, this message translates to:
  /// **'Ruqyah'**
  String get quickRuqyah;

  /// No description provided for @quickSocial.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get quickSocial;

  /// No description provided for @quickNamesOfAllah.
  ///
  /// In en, this message translates to:
  /// **'Names of Allah'**
  String get quickNamesOfAllah;

  /// No description provided for @quickAsbabNuzul.
  ///
  /// In en, this message translates to:
  /// **'Asbab al-Nuzul'**
  String get quickAsbabNuzul;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @prayerNext.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get prayerNext;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @prayerTimesToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Prayer Times'**
  String get prayerTimesToday;

  /// No description provided for @prayerCountdown.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get prayerCountdown;

  /// No description provided for @prayerTapToSeeAll.
  ///
  /// In en, this message translates to:
  /// **'Tap to see all prayer times'**
  String get prayerTapToSeeAll;

  /// No description provided for @prayerChangeCity.
  ///
  /// In en, this message translates to:
  /// **'Change City'**
  String get prayerChangeCity;

  /// No description provided for @prayerSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get prayerSelectCity;

  /// No description provided for @prayerSearchCity.
  ///
  /// In en, this message translates to:
  /// **'Search for a city...'**
  String get prayerSearchCity;

  /// No description provided for @prayerEnableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable location for auto-update'**
  String get prayerEnableLocation;

  /// No description provided for @prayerEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get prayerEnable;

  /// No description provided for @prayerAdhan.
  ///
  /// In en, this message translates to:
  /// **'Adhan'**
  String get prayerAdhan;

  /// No description provided for @prayerNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get prayerNow;

  /// No description provided for @prayerLocationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not determine your location'**
  String get prayerLocationFailed;

  /// No description provided for @prayerDayTracker.
  ///
  /// In en, this message translates to:
  /// **'Prayers Today'**
  String get prayerDayTracker;

  /// No description provided for @quranPages.
  ///
  /// In en, this message translates to:
  /// **'Quran Pages'**
  String get quranPages;

  /// No description provided for @quranTitle.
  ///
  /// In en, this message translates to:
  /// **'Holy Quran'**
  String get quranTitle;

  /// No description provided for @quranMushafMode.
  ///
  /// In en, this message translates to:
  /// **'Mushaf Mode'**
  String get quranMushafMode;

  /// No description provided for @quranSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a surah...'**
  String get quranSearchHint;

  /// No description provided for @quranSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for a word or verse...'**
  String get quranSearchPlaceholder;

  /// No description provided for @quranSearchInQuran.
  ///
  /// In en, this message translates to:
  /// **'Search in the Holy Quran'**
  String get quranSearchInQuran;

  /// No description provided for @quranSearchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter a word or phrase to search'**
  String get quranSearchPrompt;

  /// No description provided for @quranSearchError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: \$error'**
  String get quranSearchError;

  /// No description provided for @quranNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get quranNoResults;

  /// No description provided for @quranNoResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No verses containing \"\$query\"'**
  String get quranNoResultsFor;

  /// No description provided for @quranSearchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'\$count result(s) for \"\$query\"'**
  String get quranSearchResultsCount;

  /// No description provided for @quranSurahNumber.
  ///
  /// In en, this message translates to:
  /// **'Surah \$number'**
  String get quranSurahNumber;

  /// No description provided for @quranVerseOfDay.
  ///
  /// In en, this message translates to:
  /// **'Verse of the Day'**
  String get quranVerseOfDay;

  /// No description provided for @quranVerseFormat.
  ///
  /// In en, this message translates to:
  /// **'— Surah \$surah, Verse \$ayah'**
  String get quranVerseFormat;

  /// No description provided for @quranMeccan.
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get quranMeccan;

  /// No description provided for @quranMedinan.
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get quranMedinan;

  /// No description provided for @quranVerses.
  ///
  /// In en, this message translates to:
  /// **'\$count verses'**
  String get quranVerses;

  /// No description provided for @quranLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load Quran'**
  String get quranLoadFailed;

  /// No description provided for @quranRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get quranRetry;

  /// No description provided for @quranSurahLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load surah'**
  String get quranSurahLoadFailed;

  /// No description provided for @quranTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get quranTranslation;

  /// No description provided for @quranTafsir.
  ///
  /// In en, this message translates to:
  /// **'Tafsir'**
  String get quranTafsir;

  /// No description provided for @quranAsbabNuzul.
  ///
  /// In en, this message translates to:
  /// **'Asbab al-Nuzul'**
  String get quranAsbabNuzul;

  /// No description provided for @quranAudio.
  ///
  /// In en, this message translates to:
  /// **'Quran Audio'**
  String get quranAudio;

  /// No description provided for @quranSelectReciter.
  ///
  /// In en, this message translates to:
  /// **'Select Reciter'**
  String get quranSelectReciter;

  /// No description provided for @quranMushafPage.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get quranMushafPage;

  /// No description provided for @quranContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get quranContinueReading;

  /// No description provided for @quranContinueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue from where you left off in the Mushaf'**
  String get quranContinueSubtitle;

  /// No description provided for @quranBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get quranBookmarks;

  /// No description provided for @quranNoBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks'**
  String get quranNoBookmarks;

  /// No description provided for @quranNoBookmarksHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark icon next to a verse to save it'**
  String get quranNoBookmarksHint;

  /// No description provided for @quranBookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Verse \$ayah removed from \$surah'**
  String get quranBookmarkRemoved;

  /// No description provided for @hadithTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith Encyclopedia'**
  String get hadithTitle;

  /// No description provided for @hadithCollections.
  ///
  /// In en, this message translates to:
  /// **'Hadith Collections'**
  String get hadithCollections;

  /// No description provided for @hadithHadiths.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get hadithHadiths;

  /// No description provided for @hadithCount.
  ///
  /// In en, this message translates to:
  /// **'\$count Hadith'**
  String get hadithCount;

  /// No description provided for @hadithNumber.
  ///
  /// In en, this message translates to:
  /// **'Hadith \$number'**
  String get hadithNumber;

  /// No description provided for @hadithFrom.
  ///
  /// In en, this message translates to:
  /// **'Narrated by \$narrator, may Allah be pleased with him:'**
  String get hadithFrom;

  /// No description provided for @hadithFromHer.
  ///
  /// In en, this message translates to:
  /// **'Narrated by \$narrator, may Allah be pleased with her:'**
  String get hadithFromHer;

  /// No description provided for @hadithHideTranslation.
  ///
  /// In en, this message translates to:
  /// **'Hide Translation'**
  String get hadithHideTranslation;

  /// No description provided for @hadithShowTranslation.
  ///
  /// In en, this message translates to:
  /// **'Show Translation'**
  String get hadithShowTranslation;

  /// No description provided for @hadithBukhari.
  ///
  /// In en, this message translates to:
  /// **'Sahih al-Bukhari'**
  String get hadithBukhari;

  /// No description provided for @hadithBukhariAuthor.
  ///
  /// In en, this message translates to:
  /// **'Imam Muhammad ibn Ismail al-Bukhari'**
  String get hadithBukhariAuthor;

  /// No description provided for @hadithMuslim.
  ///
  /// In en, this message translates to:
  /// **'Sahih Muslim'**
  String get hadithMuslim;

  /// No description provided for @hadithMuslimAuthor.
  ///
  /// In en, this message translates to:
  /// **'Imam Muslim ibn al-Hajjaj al-Naysaburi'**
  String get hadithMuslimAuthor;

  /// No description provided for @hadithNawawi.
  ///
  /// In en, this message translates to:
  /// **'Al-Arba\'un al-Nawawiyyah'**
  String get hadithNawawi;

  /// No description provided for @hadithNawawiAuthor.
  ///
  /// In en, this message translates to:
  /// **'Imam al-Nawawi'**
  String get hadithNawawiAuthor;

  /// No description provided for @hadithDailyHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith of the Day — \$number'**
  String get hadithDailyHadith;

  /// No description provided for @azkarMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get azkarMorning;

  /// No description provided for @azkarEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar'**
  String get azkarEvening;

  /// No description provided for @azkarVarious.
  ///
  /// In en, this message translates to:
  /// **'Various Azkar'**
  String get azkarVarious;

  /// No description provided for @azkarTitle.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkarTitle;

  /// No description provided for @azkarPlay.
  ///
  /// In en, this message translates to:
  /// **'Play All'**
  String get azkarPlay;

  /// No description provided for @azkarStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get azkarStop;

  /// No description provided for @azkarListenTo.
  ///
  /// In en, this message translates to:
  /// **'Listen to \$label'**
  String get azkarListenTo;

  /// No description provided for @azkarByReciter.
  ///
  /// In en, this message translates to:
  /// **'Voice: Mishary Al-Afasy'**
  String get azkarByReciter;

  /// No description provided for @azkarCount.
  ///
  /// In en, this message translates to:
  /// **'\$count dhikr'**
  String get azkarCount;

  /// No description provided for @azkarNoAzkar.
  ///
  /// In en, this message translates to:
  /// **'No azkar in this category'**
  String get azkarNoAzkar;

  /// No description provided for @azkarLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load azkar'**
  String get azkarLoadFailed;

  /// No description provided for @azkarDataError.
  ///
  /// In en, this message translates to:
  /// **'Data format error'**
  String get azkarDataError;

  /// No description provided for @azkarAudioFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to play audio, check your internet connection'**
  String get azkarAudioFailed;

  /// No description provided for @azkarMorningAndEvening.
  ///
  /// In en, this message translates to:
  /// **'Morning and Evening Azkar'**
  String get azkarMorningAndEvening;

  /// No description provided for @azkarOfEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar'**
  String get azkarOfEvening;

  /// No description provided for @azkarOfMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get azkarOfMorning;

  /// No description provided for @azkarDhikrCount.
  ///
  /// In en, this message translates to:
  /// **'Dhikr {index} of {total}'**
  String azkarDhikrCount(Object index, Object total);

  /// No description provided for @duaTitle.
  ///
  /// In en, this message translates to:
  /// **'Duas and Supplications'**
  String get duaTitle;

  /// No description provided for @duaCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get duaCategoryAll;

  /// No description provided for @duaCategoryAnxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get duaCategoryAnxious;

  /// No description provided for @duaCategoryGrateful.
  ///
  /// In en, this message translates to:
  /// **'Grateful'**
  String get duaCategoryGrateful;

  /// No description provided for @duaCategorySad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get duaCategorySad;

  /// No description provided for @duaCategoryHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get duaCategoryHappy;

  /// No description provided for @duaCategoryAfraid.
  ///
  /// In en, this message translates to:
  /// **'Afraid'**
  String get duaCategoryAfraid;

  /// No description provided for @duaCategorySick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get duaCategorySick;

  /// No description provided for @duaCategoryTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get duaCategoryTired;

  /// No description provided for @duaCategoryOptimistic.
  ///
  /// In en, this message translates to:
  /// **'Optimistic'**
  String get duaCategoryOptimistic;

  /// No description provided for @duaCount.
  ///
  /// In en, this message translates to:
  /// **'\$count dua'**
  String get duaCount;

  /// No description provided for @duaNoDuas.
  ///
  /// In en, this message translates to:
  /// **'No duas in this category'**
  String get duaNoDuas;

  /// No description provided for @duaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'From Quran and Sunnah'**
  String get duaSubtitle;

  /// No description provided for @duaTitle2.
  ///
  /// In en, this message translates to:
  /// **'Supplications'**
  String get duaTitle2;

  /// No description provided for @tasbeehTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasbeeh'**
  String get tasbeehTitle;

  /// No description provided for @tasbeehSubhanallah.
  ///
  /// In en, this message translates to:
  /// **'Subhanallah'**
  String get tasbeehSubhanallah;

  /// No description provided for @tasbeehAlhamdulillah.
  ///
  /// In en, this message translates to:
  /// **'Alhamdulillah'**
  String get tasbeehAlhamdulillah;

  /// No description provided for @tasbeehAllahuAkbar.
  ///
  /// In en, this message translates to:
  /// **'Allahu Akbar'**
  String get tasbeehAllahuAkbar;

  /// No description provided for @tasbeehLaIlahaIllaAllah.
  ///
  /// In en, this message translates to:
  /// **'La ilaha illa Allah'**
  String get tasbeehLaIlahaIllaAllah;

  /// No description provided for @tasbeehAstaghfirullah.
  ///
  /// In en, this message translates to:
  /// **'Astaghfirullah'**
  String get tasbeehAstaghfirullah;

  /// No description provided for @tasbeehAllahummaSalli.
  ///
  /// In en, this message translates to:
  /// **'Allahumma salli ala Muhammad'**
  String get tasbeehAllahummaSalli;

  /// No description provided for @tasbeehLaHawla.
  ///
  /// In en, this message translates to:
  /// **'La hawla wa la quwwata illa billah'**
  String get tasbeehLaHawla;

  /// No description provided for @tasbeehHasbiyallah.
  ///
  /// In en, this message translates to:
  /// **'Hasbiyallah wa ni\'mal wakeel'**
  String get tasbeehHasbiyallah;

  /// No description provided for @tasbeehSubhanallahWaBihamdih.
  ///
  /// In en, this message translates to:
  /// **'Subhanallah wa bihamdih'**
  String get tasbeehSubhanallahWaBihamdih;

  /// No description provided for @tasbeehSmartTasbeeh.
  ///
  /// In en, this message translates to:
  /// **'Smart Tasbeeh'**
  String get tasbeehSmartTasbeeh;

  /// No description provided for @tasbeehOf.
  ///
  /// In en, this message translates to:
  /// **'of \$target'**
  String get tasbeehOf;

  /// No description provided for @tasbeehCycles.
  ///
  /// In en, this message translates to:
  /// **'Cycles: \$count'**
  String get tasbeehCycles;

  /// No description provided for @seerahTitle.
  ///
  /// In en, this message translates to:
  /// **'Prophetic Biography'**
  String get seerahTitle;

  /// No description provided for @seerahSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The biography of the best of mankind, Muhammad ﷺ'**
  String get seerahSubtitle;

  /// No description provided for @seerahBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get seerahBook;

  /// No description provided for @seerahChapters.
  ///
  /// In en, this message translates to:
  /// **'\$read of \$total chapters'**
  String get seerahChapters;

  /// No description provided for @seerahSections.
  ///
  /// In en, this message translates to:
  /// **'\$count sections'**
  String get seerahSections;

  /// No description provided for @seerahHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get seerahHide;

  /// No description provided for @seerahShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get seerahShowAll;

  /// No description provided for @seerahOtherSources.
  ///
  /// In en, this message translates to:
  /// **'Other Sources'**
  String get seerahOtherSources;

  /// No description provided for @seerahRahiq.
  ///
  /// In en, this message translates to:
  /// **'Ar-Raheeq Al-Makhtum'**
  String get seerahRahiq;

  /// No description provided for @seerahRahiqAuthor.
  ///
  /// In en, this message translates to:
  /// **'Shaykh Safiur Rahman al-Mubarakfuri'**
  String get seerahRahiqAuthor;

  /// No description provided for @booksTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Library'**
  String get booksTitle;

  /// No description provided for @booksSearch.
  ///
  /// In en, this message translates to:
  /// **'Search for a book...'**
  String get booksSearch;

  /// No description provided for @booksCount.
  ///
  /// In en, this message translates to:
  /// **'\$count book(s)'**
  String get booksCount;

  /// No description provided for @booksBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get booksBook;

  /// No description provided for @booksChaptersRead.
  ///
  /// In en, this message translates to:
  /// **'\$read / \$total chapters'**
  String get booksChaptersRead;

  /// No description provided for @booksNotFound.
  ///
  /// In en, this message translates to:
  /// **'Book not found'**
  String get booksNotFound;

  /// No description provided for @booksComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Content for this book is being added'**
  String get booksComingSoon;

  /// No description provided for @booksTableOfContents.
  ///
  /// In en, this message translates to:
  /// **'Table of Contents'**
  String get booksTableOfContents;

  /// No description provided for @booksCategory.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get booksCategory;

  /// No description provided for @categoryTafsir.
  ///
  /// In en, this message translates to:
  /// **'Tafsir'**
  String get categoryTafsir;

  /// No description provided for @categoryHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get categoryHadith;

  /// No description provided for @categoryFiqh.
  ///
  /// In en, this message translates to:
  /// **'Fiqh'**
  String get categoryFiqh;

  /// No description provided for @categoryAqeedah.
  ///
  /// In en, this message translates to:
  /// **'Aqeedah'**
  String get categoryAqeedah;

  /// No description provided for @categorySeerah.
  ///
  /// In en, this message translates to:
  /// **'Seerah'**
  String get categorySeerah;

  /// No description provided for @categoryHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get categoryHistory;

  /// No description provided for @categoryRiqaq.
  ///
  /// In en, this message translates to:
  /// **'Heart Softeners'**
  String get categoryRiqaq;

  /// No description provided for @categoryTazkiyah.
  ///
  /// In en, this message translates to:
  /// **'Tazkiyah'**
  String get categoryTazkiyah;

  /// No description provided for @categoryAzkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get categoryAzkar;

  /// No description provided for @categoryDua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get categoryDua;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileUser;

  /// No description provided for @profileLocalAccount.
  ///
  /// In en, this message translates to:
  /// **'Local Account'**
  String get profileLocalAccount;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @profileFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get profileFontSize;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profileThemeDark;

  /// No description provided for @profileThemeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get profileThemeAuto;

  /// No description provided for @profileFontSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get profileFontSmall;

  /// No description provided for @profileFontMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get profileFontMedium;

  /// No description provided for @profileFontLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get profileFontLarge;

  /// No description provided for @profileFontXLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get profileFontXLarge;

  /// No description provided for @profileShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get profileShareApp;

  /// No description provided for @profileAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get profileAboutApp;

  /// No description provided for @profileContactDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Contact Developer'**
  String get profileContactDeveloper;

  /// No description provided for @profileWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get profileWhatsApp;

  /// No description provided for @profileBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get profileBookmarks;

  /// No description provided for @profileNoBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get profileNoBookmarks;

  /// No description provided for @profileAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get profileAppVersion;

  /// No description provided for @profileAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your daily spiritual companion'**
  String get profileAppSubtitle;

  /// No description provided for @profileDuaRequest.
  ///
  /// In en, this message translates to:
  /// **'Please remember us in your good prayers'**
  String get profileDuaRequest;

  /// No description provided for @profileDuaRequest2.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget us in your righteous prayers'**
  String get profileDuaRequest2;

  /// No description provided for @profileSendWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Contact developer via WhatsApp'**
  String get profileSendWhatsApp;

  /// No description provided for @profileClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get profileClose;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsPrayerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Prayer Time Notifications'**
  String get settingsPrayerNotifications;

  /// No description provided for @settingsPrayerDesc.
  ///
  /// In en, this message translates to:
  /// **'Alert at the time of each prayer'**
  String get settingsPrayerDesc;

  /// No description provided for @settingsMorningAzkarNotif.
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get settingsMorningAzkarNotif;

  /// No description provided for @settingsMorningAzkarDesc.
  ///
  /// In en, this message translates to:
  /// **'Notification after sunrise with morning azkar'**
  String get settingsMorningAzkarDesc;

  /// No description provided for @settingsEveningAzkarNotif.
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar'**
  String get settingsEveningAzkarNotif;

  /// No description provided for @settingsEveningAzkarDesc.
  ///
  /// In en, this message translates to:
  /// **'Notification after Asr with evening azkar'**
  String get settingsEveningAzkarDesc;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Various Reminders'**
  String get settingsReminders;

  /// No description provided for @settingsRemindDhikr.
  ///
  /// In en, this message translates to:
  /// **'Reminder to remember Allah and send blessings upon the Prophet'**
  String get settingsRemindDhikr;

  /// No description provided for @settingsRandomReminders.
  ///
  /// In en, this message translates to:
  /// **'Random notifications throughout the day'**
  String get settingsRandomReminders;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ibrahim'**
  String get onboardingWelcome;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Your daily spiritual companion — everything you need for a complete faith journey in one app.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get onboardingPrayerTimes;

  /// No description provided for @onboardingPrayerTimesDesc.
  ///
  /// In en, this message translates to:
  /// **'Accurate prayer times with customizable notifications, and Qibla direction anywhere.'**
  String get onboardingPrayerTimesDesc;

  /// No description provided for @onboardingQuran.
  ///
  /// In en, this message translates to:
  /// **'Holy Quran'**
  String get onboardingQuran;

  /// No description provided for @onboardingQuranDesc.
  ///
  /// In en, this message translates to:
  /// **'Read the complete Mushaf, listen to recitations, and follow verses with tafsir.'**
  String get onboardingQuranDesc;

  /// No description provided for @onboardingAzkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar & Dua'**
  String get onboardingAzkar;

  /// No description provided for @onboardingAzkarDesc.
  ///
  /// In en, this message translates to:
  /// **'Morning and evening azkar, diverse duas for every situation, and a smart tasbeeh.'**
  String get onboardingAzkarDesc;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start the Journey'**
  String get onboardingStart;

  /// No description provided for @aiTitle.
  ///
  /// In en, this message translates to:
  /// **'Ibrahim AI'**
  String get aiTitle;

  /// No description provided for @aiNewChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get aiNewChat;

  /// No description provided for @aiApiKeyEmpty.
  ///
  /// In en, this message translates to:
  /// **'API Key Empty'**
  String get aiApiKeyEmpty;

  /// No description provided for @aiNoApiKey.
  ///
  /// In en, this message translates to:
  /// **'No API key configured. Tap ⚙️ above to add one.'**
  String get aiNoApiKey;

  /// No description provided for @aiInvalidKey.
  ///
  /// In en, this message translates to:
  /// **'Invalid API key. Check your settings.'**
  String get aiInvalidKey;

  /// No description provided for @aiRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Try again later.'**
  String get aiRateLimited;

  /// No description provided for @aiNoConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection.'**
  String get aiNoConnection;

  /// No description provided for @aiTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Try again.'**
  String get aiTimeout;

  /// No description provided for @aiServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable. Try again later.'**
  String get aiServerUnavailable;

  /// No description provided for @aiError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: \$error'**
  String get aiError;

  /// No description provided for @aiAllahKnowsBest.
  ///
  /// In en, this message translates to:
  /// **'And Allah knows best'**
  String get aiAllahKnowsBest;

  /// No description provided for @aiSettings.
  ///
  /// In en, this message translates to:
  /// **'AI Settings'**
  String get aiSettings;

  /// No description provided for @aiProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get aiProvider;

  /// No description provided for @aiModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get aiModel;

  /// No description provided for @aiKeyAuto.
  ///
  /// In en, this message translates to:
  /// **'Key set automatically — leave empty or enter your own'**
  String get aiKeyAuto;

  /// No description provided for @aiPasteKey.
  ///
  /// In en, this message translates to:
  /// **'Paste your API key here'**
  String get aiPasteKey;

  /// No description provided for @aiTesting.
  ///
  /// In en, this message translates to:
  /// **'Testing...'**
  String get aiTesting;

  /// No description provided for @aiTestConnection.
  ///
  /// In en, this message translates to:
  /// **'🔍 Test Connection'**
  String get aiTestConnection;

  /// No description provided for @aiGetFreeKey.
  ///
  /// In en, this message translates to:
  /// **'📌 To get a free key:'**
  String get aiGetFreeKey;

  /// No description provided for @aiCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get aiCancel;

  /// No description provided for @aiSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get aiSave;

  /// No description provided for @aiPreviousChats.
  ///
  /// In en, this message translates to:
  /// **'Previous Chats'**
  String get aiPreviousChats;

  /// No description provided for @aiNoPreviousChats.
  ///
  /// In en, this message translates to:
  /// **'No previous chats'**
  String get aiNoPreviousChats;

  /// No description provided for @aiAskMe.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything...'**
  String get aiAskMe;

  /// No description provided for @aiSetupKeyFirst.
  ///
  /// In en, this message translates to:
  /// **'Tap ⚙️ to configure the API key first'**
  String get aiSetupKeyFirst;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTitle;

  /// No description provided for @exploreSearch.
  ///
  /// In en, this message translates to:
  /// **'Search the library...'**
  String get exploreSearch;

  /// No description provided for @exploreCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get exploreCategoryAll;

  /// No description provided for @exploreCategoryAzkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get exploreCategoryAzkar;

  /// No description provided for @exploreCategoryDua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get exploreCategoryDua;

  /// No description provided for @exploreCategoryHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get exploreCategoryHadith;

  /// No description provided for @exploreCategoryWorship.
  ///
  /// In en, this message translates to:
  /// **'Worship'**
  String get exploreCategoryWorship;

  /// No description provided for @exploreCategoryBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get exploreCategoryBooks;

  /// No description provided for @exploreCategoryTafsir.
  ///
  /// In en, this message translates to:
  /// **'Tafsir'**
  String get exploreCategoryTafsir;

  /// No description provided for @exploreCategorySeerah.
  ///
  /// In en, this message translates to:
  /// **'Seerah'**
  String get exploreCategorySeerah;

  /// No description provided for @searchGlobal.
  ///
  /// In en, this message translates to:
  /// **'Global Search'**
  String get searchGlobal;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Quran, Hadith, Dua, Azkar, Books...'**
  String get searchHint;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for anything...'**
  String get searchPlaceholder;

  /// No description provided for @searchCategories.
  ///
  /// In en, this message translates to:
  /// **'Quran — Hadith — Dua — Azkar — Books — Names of Allah — Islamic Figures'**
  String get searchCategories;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No results for \"\$query\"'**
  String get searchNoResultsFor;

  /// No description provided for @searchQuran.
  ///
  /// In en, this message translates to:
  /// **'Holy Quran'**
  String get searchQuran;

  /// No description provided for @searchHadith.
  ///
  /// In en, this message translates to:
  /// **'Prophetic Hadith'**
  String get searchHadith;

  /// No description provided for @searchDua.
  ///
  /// In en, this message translates to:
  /// **'Supplications'**
  String get searchDua;

  /// No description provided for @searchAzkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get searchAzkar;

  /// No description provided for @searchBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get searchBooks;

  /// No description provided for @searchNamesOfAllah.
  ///
  /// In en, this message translates to:
  /// **'Names of Allah'**
  String get searchNamesOfAllah;

  /// No description provided for @searchCompanions.
  ///
  /// In en, this message translates to:
  /// **'Islamic Figures'**
  String get searchCompanions;

  /// No description provided for @moodQuestion.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling now?'**
  String get moodQuestion;

  /// No description provided for @moodAnxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get moodAnxious;

  /// No description provided for @moodGrateful.
  ///
  /// In en, this message translates to:
  /// **'Grateful'**
  String get moodGrateful;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get moodTired;

  /// No description provided for @suggestionNow.
  ///
  /// In en, this message translates to:
  /// **'Suggestion Now'**
  String get suggestionNow;

  /// No description provided for @suggestionFajrPrayer.
  ///
  /// In en, this message translates to:
  /// **'Pray the Fajr Sunnah'**
  String get suggestionFajrPrayer;

  /// No description provided for @suggestionMorningAzkar.
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get suggestionMorningAzkar;

  /// No description provided for @suggestionDhuhrOnTime.
  ///
  /// In en, this message translates to:
  /// **'Pray Dhuhr on time'**
  String get suggestionDhuhrOnTime;

  /// No description provided for @suggestionReadQuran.
  ///
  /// In en, this message translates to:
  /// **'Read your daily Quran portion'**
  String get suggestionReadQuran;

  /// No description provided for @suggestionEveningAzkar.
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar'**
  String get suggestionEveningAzkar;

  /// No description provided for @suggestionNightPrayer.
  ///
  /// In en, this message translates to:
  /// **'Night prayer (Qiyam)'**
  String get suggestionNightPrayer;

  /// No description provided for @suggestionRememberAllah.
  ///
  /// In en, this message translates to:
  /// **'Always remember Allah'**
  String get suggestionRememberAllah;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recently'**
  String get recentActivity;

  /// No description provided for @khatmaTitle.
  ///
  /// In en, this message translates to:
  /// **'Khatma Planner'**
  String get khatmaTitle;

  /// No description provided for @khatmaPart.
  ///
  /// In en, this message translates to:
  /// **'Part \$start'**
  String get khatmaPart;

  /// No description provided for @khatmaParts.
  ///
  /// In en, this message translates to:
  /// **'Parts \$start - \$end'**
  String get khatmaParts;

  /// No description provided for @khatmaPage.
  ///
  /// In en, this message translates to:
  /// **'Page \$start'**
  String get khatmaPage;

  /// No description provided for @khatmaPages.
  ///
  /// In en, this message translates to:
  /// **'Pages \$start - \$end'**
  String get khatmaPages;

  /// No description provided for @khatmaCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get khatmaCompleted;

  /// No description provided for @khatmaNewKhatma.
  ///
  /// In en, this message translates to:
  /// **'New Khatma'**
  String get khatmaNewKhatma;

  /// No description provided for @khatmaStartKhatma.
  ///
  /// In en, this message translates to:
  /// **'Start Khatma'**
  String get khatmaStartKhatma;

  /// No description provided for @khatmaDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Current progress will be deleted. Are you sure?'**
  String get khatmaDeleteConfirm;

  /// No description provided for @khatmaCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get khatmaCancel;

  /// No description provided for @khatmaConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get khatmaConfirm;

  /// No description provided for @khatmaShareProgress.
  ///
  /// In en, this message translates to:
  /// **'Share Progress'**
  String get khatmaShareProgress;

  /// No description provided for @khatmaDaysToComplete.
  ///
  /// In en, this message translates to:
  /// **'How many days to complete the Quran?'**
  String get khatmaDaysToComplete;

  /// No description provided for @khatmaDaysCount.
  ///
  /// In en, this message translates to:
  /// **'\$days day(s)'**
  String get khatmaDaysCount;

  /// No description provided for @khatmaDailyPlan.
  ///
  /// In en, this message translates to:
  /// **'Daily Reading Plan'**
  String get khatmaDailyPlan;

  /// No description provided for @khatmaPartsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Parts per day'**
  String get khatmaPartsPerDay;

  /// No description provided for @khatmaPagesPerDay.
  ///
  /// In en, this message translates to:
  /// **'\$pages pages per day'**
  String get khatmaPagesPerDay;

  /// No description provided for @khatmaTotalDays.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get khatmaTotalDays;

  /// No description provided for @khatmaDaysCompleted.
  ///
  /// In en, this message translates to:
  /// **'Days Completed'**
  String get khatmaDaysCompleted;

  /// No description provided for @khatmaDaysRemaining.
  ///
  /// In en, this message translates to:
  /// **'Days Remaining'**
  String get khatmaDaysRemaining;

  /// No description provided for @khatmaReadingStreak.
  ///
  /// In en, this message translates to:
  /// **'Reading streak: \$streak consecutive days'**
  String get khatmaReadingStreak;

  /// No description provided for @khatmaCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Khatma Completed Successfully!'**
  String get khatmaCompletedTitle;

  /// No description provided for @khatmaCompletionDate.
  ///
  /// In en, this message translates to:
  /// **'Completion Date: \$date'**
  String get khatmaCompletionDate;

  /// No description provided for @khatmaActualDays.
  ///
  /// In en, this message translates to:
  /// **'Days taken: \$days days'**
  String get khatmaActualDays;

  /// No description provided for @khatmaKhatmDua.
  ///
  /// In en, this message translates to:
  /// **'O Allah, have mercy on me through the Great Quran, make it my guide, light, guidance and mercy...'**
  String get khatmaKhatmDua;

  /// No description provided for @khatmaTodayReading.
  ///
  /// In en, this message translates to:
  /// **'Today\'s reading: \$pages'**
  String get khatmaTodayReading;

  /// No description provided for @khatmaReadingList.
  ///
  /// In en, this message translates to:
  /// **'Daily Reading List'**
  String get khatmaReadingList;

  /// No description provided for @khatmaToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get khatmaToday;

  /// No description provided for @khatmaMilestoneCongrats.
  ///
  /// In en, this message translates to:
  /// **'🎉 Congratulations! You completed the Khatma!'**
  String get khatmaMilestoneCongrats;

  /// No description provided for @khatmaMilestoneLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'🌟 Last quarter — keep reading!'**
  String get khatmaMilestoneLastQuarter;

  /// No description provided for @khatmaMilestoneHalf.
  ///
  /// In en, this message translates to:
  /// **'💪 Half the Khatma — keep going!'**
  String get khatmaMilestoneHalf;

  /// No description provided for @khatmaMilestoneQuarter.
  ///
  /// In en, this message translates to:
  /// **'✨ Quarter of the Khatma — Allah bless you!'**
  String get khatmaMilestoneQuarter;

  /// No description provided for @khatmaMilestoneStart.
  ///
  /// In en, this message translates to:
  /// **'🌱 Auspicious beginning — keep going!'**
  String get khatmaMilestoneStart;

  /// No description provided for @comapnionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic Figures'**
  String get comapnionsTitle;

  /// No description provided for @companionsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get companionsAll;

  /// No description provided for @companionsNoFigures.
  ///
  /// In en, this message translates to:
  /// **'No figures in this category'**
  String get companionsNoFigures;

  /// No description provided for @companionsPlaceOfDeath.
  ///
  /// In en, this message translates to:
  /// **'Place of Death'**
  String get companionsPlaceOfDeath;

  /// No description provided for @companionsKnownFor.
  ///
  /// In en, this message translates to:
  /// **'Known for'**
  String get companionsKnownFor;

  /// No description provided for @companionsAchievements.
  ///
  /// In en, this message translates to:
  /// **'Key Achievements:'**
  String get companionsAchievements;

  /// No description provided for @qiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qiblaTitle;

  /// No description provided for @qiblaCalibrate.
  ///
  /// In en, this message translates to:
  /// **'Move your phone in a circle to calibrate'**
  String get qiblaCalibrate;

  /// No description provided for @qiblaRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get qiblaRetry;

  /// No description provided for @qiblaFacing.
  ///
  /// In en, this message translates to:
  /// **'✅ Facing the Qibla'**
  String get qiblaFacing;

  /// No description provided for @qiblaCorrectDirection.
  ///
  /// In en, this message translates to:
  /// **'✔️ You are facing the Qibla'**
  String get qiblaCorrectDirection;

  /// No description provided for @qiblaMovePhone.
  ///
  /// In en, this message translates to:
  /// **'Move your phone until the pointer faces the Qibla'**
  String get qiblaMovePhone;

  /// No description provided for @qiblaNorth.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get qiblaNorth;

  /// No description provided for @qiblaSouth.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get qiblaSouth;

  /// No description provided for @qiblaEast.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get qiblaEast;

  /// No description provided for @qiblaWest.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get qiblaWest;

  /// No description provided for @tajweedTitle.
  ///
  /// In en, this message translates to:
  /// **'Tajweed'**
  String get tajweedTitle;

  /// No description provided for @tajweedMushaf.
  ///
  /// In en, this message translates to:
  /// **'Color-coded Tajweed Mushaf'**
  String get tajweedMushaf;

  /// No description provided for @tajweedSelectSurah.
  ///
  /// In en, this message translates to:
  /// **'Select a Surah'**
  String get tajweedSelectSurah;

  /// No description provided for @tajweedSurahList.
  ///
  /// In en, this message translates to:
  /// **'Surah List'**
  String get tajweedSurahList;

  /// No description provided for @tajweedShowTextOnly.
  ///
  /// In en, this message translates to:
  /// **'Show Text Only'**
  String get tajweedShowTextOnly;

  /// No description provided for @tajweedShowTajweed.
  ///
  /// In en, this message translates to:
  /// **'Show Tajweed'**
  String get tajweedShowTajweed;

  /// No description provided for @tajweedLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load surah'**
  String get tajweedLoadFailed;

  /// No description provided for @tajweedMadd.
  ///
  /// In en, this message translates to:
  /// **'Madd'**
  String get tajweedMadd;

  /// No description provided for @tajweedGhunnah.
  ///
  /// In en, this message translates to:
  /// **'Ghunnah/Idgham with Ghunnah'**
  String get tajweedGhunnah;

  /// No description provided for @tajweedIkhfa.
  ///
  /// In en, this message translates to:
  /// **'Ikhfa'**
  String get tajweedIkhfa;

  /// No description provided for @tajweedIqlab.
  ///
  /// In en, this message translates to:
  /// **'Iqlab'**
  String get tajweedIqlab;

  /// No description provided for @tajweedIdgham.
  ///
  /// In en, this message translates to:
  /// **'Idgham without Ghunnah'**
  String get tajweedIdgham;

  /// No description provided for @tajweedQalqalah.
  ///
  /// In en, this message translates to:
  /// **'Qalqalah'**
  String get tajweedQalqalah;

  /// No description provided for @tajweedTafkheem.
  ///
  /// In en, this message translates to:
  /// **'Tafkheem'**
  String get tajweedTafkheem;

  /// No description provided for @ruqyahTitle.
  ///
  /// In en, this message translates to:
  /// **'Ruqyah'**
  String get ruqyahTitle;

  /// No description provided for @ruqyahAyahTab.
  ///
  /// In en, this message translates to:
  /// **'Ruqyah Verses'**
  String get ruqyahAyahTab;

  /// No description provided for @ruqyahDuaTab.
  ///
  /// In en, this message translates to:
  /// **'Ruqyah Duas'**
  String get ruqyahDuaTab;

  /// No description provided for @ruqyahMethodTab.
  ///
  /// In en, this message translates to:
  /// **'Ruqyah Method'**
  String get ruqyahMethodTab;

  /// No description provided for @ruqyahConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions of Shar\'i Ruqyah'**
  String get ruqyahConditions;

  /// No description provided for @ruqyahSelfRuqyah.
  ///
  /// In en, this message translates to:
  /// **'How to Perform Ruqyah on Yourself'**
  String get ruqyahSelfRuqyah;

  /// No description provided for @ruqyahOnOthers.
  ///
  /// In en, this message translates to:
  /// **'How to Perform Ruqyah on Others'**
  String get ruqyahOnOthers;

  /// No description provided for @ruqyahVisitingSick.
  ///
  /// In en, this message translates to:
  /// **'What to Say When Visiting the Sick'**
  String get ruqyahVisitingSick;

  /// No description provided for @ruqyahSignsEnvy.
  ///
  /// In en, this message translates to:
  /// **'Signs of Hasad (Envy) and Evil Eye'**
  String get ruqyahSignsEnvy;

  /// No description provided for @ruqyahTreatmentSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps of Shar\'i Treatment'**
  String get ruqyahTreatmentSteps;

  /// No description provided for @ruqyahProhibitedPractices.
  ///
  /// In en, this message translates to:
  /// **'Prohibited Practices'**
  String get ruqyahProhibitedPractices;

  /// No description provided for @hajjTitle.
  ///
  /// In en, this message translates to:
  /// **'Hajj & Umrah Guide'**
  String get hajjTitle;

  /// No description provided for @hajjHajj.
  ///
  /// In en, this message translates to:
  /// **'Hajj'**
  String get hajjHajj;

  /// No description provided for @hajjUmrah.
  ///
  /// In en, this message translates to:
  /// **'Umrah'**
  String get hajjUmrah;

  /// No description provided for @hajjPilgrimKit.
  ///
  /// In en, this message translates to:
  /// **'Pilgrim\'s Kit'**
  String get hajjPilgrimKit;

  /// No description provided for @hajjProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress:'**
  String get hajjProgress;

  /// No description provided for @hajjDuaLabel.
  ///
  /// In en, this message translates to:
  /// **'Supplication:'**
  String get hajjDuaLabel;

  /// No description provided for @hajjImportantRulings.
  ///
  /// In en, this message translates to:
  /// **'Important Rulings:'**
  String get hajjImportantRulings;

  /// No description provided for @hajjChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist:'**
  String get hajjChecklist;

  /// No description provided for @hajjKitTitle.
  ///
  /// In en, this message translates to:
  /// **'Pilgrim\'s Kit'**
  String get hajjKitTitle;

  /// No description provided for @hajjKitDesc.
  ///
  /// In en, this message translates to:
  /// **'Everything a pilgrim needs'**
  String get hajjKitDesc;

  /// No description provided for @hajjShareText.
  ///
  /// In en, this message translates to:
  /// **'Join me on Ibrahim app...'**
  String get hajjShareText;

  /// No description provided for @womensSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Women\'s Section'**
  String get womensSectionTitle;

  /// No description provided for @socialTitle.
  ///
  /// In en, this message translates to:
  /// **'Social Integration'**
  String get socialTitle;

  /// No description provided for @socialChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get socialChallenges;

  /// No description provided for @socialAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get socialAchievements;

  /// No description provided for @socialFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get socialFriends;

  /// No description provided for @socialYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get socialYou;

  /// No description provided for @socialPageRead.
  ///
  /// In en, this message translates to:
  /// **'Page Read'**
  String get socialPageRead;

  /// No description provided for @socialConsecutiveDays.
  ///
  /// In en, this message translates to:
  /// **'Consecutive Days'**
  String get socialConsecutiveDays;

  /// No description provided for @socialKhatma.
  ///
  /// In en, this message translates to:
  /// **'Khatma'**
  String get socialKhatma;

  /// No description provided for @socialLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get socialLeaderboard;

  /// No description provided for @socialInviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get socialInviteFriends;

  /// No description provided for @socialJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined ✓'**
  String get socialJoined;

  /// No description provided for @socialJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get socialJoin;

  /// No description provided for @socialPages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get socialPages;

  /// No description provided for @socialDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get socialDays;

  /// No description provided for @socialKhatmas.
  ///
  /// In en, this message translates to:
  /// **'Khatmas'**
  String get socialKhatmas;

  /// No description provided for @zakatTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get zakatTitle;

  /// No description provided for @zakatCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate Zakat'**
  String get zakatCalculate;

  /// No description provided for @zakatDescription.
  ///
  /// In en, this message translates to:
  /// **'Zakat is 2.5% of total wealth if it reaches the Nisab and one lunar year has passed.'**
  String get zakatDescription;

  /// No description provided for @zakatCash.
  ///
  /// In en, this message translates to:
  /// **'Cash & Savings'**
  String get zakatCash;

  /// No description provided for @zakatGold.
  ///
  /// In en, this message translates to:
  /// **'Gold (grams)'**
  String get zakatGold;

  /// No description provided for @zakatSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver (grams)'**
  String get zakatSilver;

  /// No description provided for @zakatStocks.
  ///
  /// In en, this message translates to:
  /// **'Stocks & Investments'**
  String get zakatStocks;

  /// No description provided for @zakatDue.
  ///
  /// In en, this message translates to:
  /// **'Zakat Due'**
  String get zakatDue;

  /// No description provided for @zakatBelowNisab.
  ///
  /// In en, this message translates to:
  /// **'Your wealth has not reached the Nisab yet.'**
  String get zakatBelowNisab;

  /// No description provided for @sadaqahTitle.
  ///
  /// In en, this message translates to:
  /// **'Sadaqah'**
  String get sadaqahTitle;

  /// No description provided for @sadaqahType.
  ///
  /// In en, this message translates to:
  /// **'Sadaqah'**
  String get sadaqahType;

  /// No description provided for @sadaqahZakat.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get sadaqahZakat;

  /// No description provided for @sadaqahKaffarah.
  ///
  /// In en, this message translates to:
  /// **'Kaffarah'**
  String get sadaqahKaffarah;

  /// No description provided for @sadaqahDonation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get sadaqahDonation;

  /// No description provided for @sadaqahTrack.
  ///
  /// In en, this message translates to:
  /// **'Track Sadaqah'**
  String get sadaqahTrack;

  /// No description provided for @sadaqahTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Sadaqah'**
  String get sadaqahTotal;

  /// No description provided for @sadaqahTimes.
  ///
  /// In en, this message translates to:
  /// **'\$count time(s)'**
  String get sadaqahTimes;

  /// No description provided for @sadaqahAdd.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get sadaqahAdd;

  /// No description provided for @sadaqahAddBtn.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get sadaqahAddBtn;

  /// No description provided for @sadaqahSelectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get sadaqahSelectType;

  /// No description provided for @journeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Journey'**
  String get journeyTitle;

  /// No description provided for @journeyCurrentLevel.
  ///
  /// In en, this message translates to:
  /// **'Your Current Level'**
  String get journeyCurrentLevel;

  /// No description provided for @journeyLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get journeyLevelBeginner;

  /// No description provided for @journeyLevelBeginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Regular five daily prayers'**
  String get journeyLevelBeginnerDesc;

  /// No description provided for @journeyLevelTaaib.
  ///
  /// In en, this message translates to:
  /// **'Taa\'ib (Repentant)'**
  String get journeyLevelTaaib;

  /// No description provided for @journeyLevelTaaibDesc.
  ///
  /// In en, this message translates to:
  /// **'Morning and evening azkar for 30 days'**
  String get journeyLevelTaaibDesc;

  /// No description provided for @journeyLevelMukhbit.
  ///
  /// In en, this message translates to:
  /// **'Mukhbit (Humble)'**
  String get journeyLevelMukhbit;

  /// No description provided for @journeyLevelMukhbitDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete one full Quran khatma'**
  String get journeyLevelMukhbitDesc;

  /// No description provided for @journeyLevelAwwab.
  ///
  /// In en, this message translates to:
  /// **'Awwab (Oft-Returning)'**
  String get journeyLevelAwwab;

  /// No description provided for @journeyLevelAwwabDesc.
  ///
  /// In en, this message translates to:
  /// **'Night prayer for 30 days'**
  String get journeyLevelAwwabDesc;

  /// No description provided for @journeyLevelZahid.
  ///
  /// In en, this message translates to:
  /// **'Zahid (Ascetic)'**
  String get journeyLevelZahid;

  /// No description provided for @journeyLevelZahidDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily charity for 90 days'**
  String get journeyLevelZahidDesc;

  /// No description provided for @journeyLevelKhalil.
  ///
  /// In en, this message translates to:
  /// **'Khalil (Devoted Friend)'**
  String get journeyLevelKhalil;

  /// No description provided for @journeyLevelKhalilDesc.
  ///
  /// In en, this message translates to:
  /// **'All levels completed'**
  String get journeyLevelKhalilDesc;

  /// No description provided for @journeyCompletedLevel.
  ///
  /// In en, this message translates to:
  /// **'You completed this level ✓'**
  String get journeyCompletedLevel;

  /// No description provided for @journeySpiritualProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Spiritual Progress'**
  String get journeySpiritualProgress;

  /// No description provided for @wirdTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Wird'**
  String get wirdTitle;

  /// No description provided for @wirdDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Wird'**
  String get wirdDaily;

  /// No description provided for @wirdProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get wirdProgress;

  /// No description provided for @wirdPrayers.
  ///
  /// In en, this message translates to:
  /// **'Five Prayers'**
  String get wirdPrayers;

  /// No description provided for @wirdPrayersDesc.
  ///
  /// In en, this message translates to:
  /// **'Performing prayers on time'**
  String get wirdPrayersDesc;

  /// No description provided for @wirdQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran Portion'**
  String get wirdQuran;

  /// No description provided for @wirdQuranDesc.
  ///
  /// In en, this message translates to:
  /// **'Read a portion of the Holy Quran'**
  String get wirdQuranDesc;

  /// No description provided for @wirdMorningAzkar.
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get wirdMorningAzkar;

  /// No description provided for @wirdMorningAzkarDesc.
  ///
  /// In en, this message translates to:
  /// **'Azkar for the start of the day'**
  String get wirdMorningAzkarDesc;

  /// No description provided for @wirdEveningAzkar.
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar'**
  String get wirdEveningAzkar;

  /// No description provided for @wirdEveningAzkarDesc.
  ///
  /// In en, this message translates to:
  /// **'Azkar for the end of the day'**
  String get wirdEveningAzkarDesc;

  /// No description provided for @wirdDua.
  ///
  /// In en, this message translates to:
  /// **'Supplications'**
  String get wirdDua;

  /// No description provided for @wirdDuaDesc.
  ///
  /// In en, this message translates to:
  /// **'Dua and remembrance'**
  String get wirdDuaDesc;

  /// No description provided for @wirdSadaqah.
  ///
  /// In en, this message translates to:
  /// **'Sadaqah'**
  String get wirdSadaqah;

  /// No description provided for @wirdSadaqahDesc.
  ///
  /// In en, this message translates to:
  /// **'Charity, even if small'**
  String get wirdSadaqahDesc;

  /// No description provided for @fiqhTitle.
  ///
  /// In en, this message translates to:
  /// **'Fiqh of Worship'**
  String get fiqhTitle;

  /// No description provided for @recordingTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice Recording'**
  String get recordingTitle;

  /// No description provided for @recordingTapToRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap to Record'**
  String get recordingTapToRecord;

  /// No description provided for @recordingRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recordingRecording;

  /// No description provided for @recordingPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous Recordings'**
  String get recordingPrevious;

  /// No description provided for @recordingNoRecordings.
  ///
  /// In en, this message translates to:
  /// **'No recordings'**
  String get recordingNoRecordings;

  /// No description provided for @mosqueMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Mosques'**
  String get mosqueMapTitle;

  /// No description provided for @mosqueMapSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching for nearby mosques...'**
  String get mosqueMapSearching;

  /// No description provided for @mosqueMapLocationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not determine your location, please enable GPS'**
  String get mosqueMapLocationFailed;

  /// No description provided for @mosqueMapMosque.
  ///
  /// In en, this message translates to:
  /// **'Mosque'**
  String get mosqueMapMosque;

  /// No description provided for @familyHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Hub'**
  String get familyHubTitle;

  /// No description provided for @familyHubChallenges.
  ///
  /// In en, this message translates to:
  /// **'Family Challenges'**
  String get familyHubChallenges;

  /// No description provided for @familyHubGroupKhatma.
  ///
  /// In en, this message translates to:
  /// **'Group Khatma'**
  String get familyHubGroupKhatma;

  /// No description provided for @familyHubGroupKhatmaDesc.
  ///
  /// In en, this message translates to:
  /// **'Let\'s read Surah Al-Baqarah together this week'**
  String get familyHubGroupKhatmaDesc;

  /// No description provided for @familyHubFajrChallenge.
  ///
  /// In en, this message translates to:
  /// **'Fajr at the Mosque'**
  String get familyHubFajrChallenge;

  /// No description provided for @familyHubFajrChallengeDesc.
  ///
  /// In en, this message translates to:
  /// **'Early wake-up challenge for all family members'**
  String get familyHubFajrChallengeDesc;

  /// No description provided for @familyHubMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyHubMembers;

  /// No description provided for @familyHubPoints.
  ///
  /// In en, this message translates to:
  /// **'Family Points This Month'**
  String get familyHubPoints;

  /// No description provided for @familyHubRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get familyHubRank;

  /// No description provided for @familyHubFirst.
  ///
  /// In en, this message translates to:
  /// **'1st'**
  String get familyHubFirst;

  /// No description provided for @familyHubLevel.
  ///
  /// In en, this message translates to:
  /// **'Level: \$level'**
  String get familyHubLevel;

  /// No description provided for @familyHubAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add New Family Member'**
  String get familyHubAddMember;

  /// No description provided for @namesOfAllahTitle.
  ///
  /// In en, this message translates to:
  /// **'Names of Allah'**
  String get namesOfAllahTitle;

  /// No description provided for @namesOfAllahSubtitle.
  ///
  /// In en, this message translates to:
  /// **'99 Names'**
  String get namesOfAllahSubtitle;

  /// No description provided for @namesOfAllahVerse.
  ///
  /// In en, this message translates to:
  /// **'And to Allah belong the best names, so invoke Him by them'**
  String get namesOfAllahVerse;

  /// No description provided for @namesOfAllahHadith.
  ///
  /// In en, this message translates to:
  /// **'Whoever enumerates them will enter Paradise'**
  String get namesOfAllahHadith;

  /// No description provided for @namesOfAllahCount.
  ///
  /// In en, this message translates to:
  /// **'\$id of 99'**
  String get namesOfAllahCount;

  /// No description provided for @globalAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get globalAll;

  /// No description provided for @globalSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get globalSearch;

  /// No description provided for @globalCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get globalCancel;

  /// No description provided for @globalConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get globalConfirm;

  /// No description provided for @globalSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get globalSave;

  /// No description provided for @globalRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get globalRetry;

  /// No description provided for @globalError.
  ///
  /// In en, this message translates to:
  /// **'Error: \$error'**
  String get globalError;

  /// No description provided for @globalNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get globalNoData;

  /// No description provided for @globalLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get globalLoading;

  /// No description provided for @globalNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get globalNext;

  /// No description provided for @globalBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get globalBack;

  /// No description provided for @globalShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get globalShare;

  /// No description provided for @globalDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get globalDelete;

  /// No description provided for @globalEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get globalEdit;

  /// No description provided for @globalAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get globalAdd;

  /// No description provided for @globalRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get globalRemove;

  /// No description provided for @globalEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get globalEnable;

  /// No description provided for @globalDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get globalDisable;

  /// No description provided for @globalOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get globalOn;

  /// No description provided for @globalOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get globalOff;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get locationTitle;

  /// No description provided for @locationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable location service for accurate prayer times'**
  String get locationMessage;

  /// No description provided for @locationCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get locationCancel;

  /// No description provided for @locationEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get locationEnable;

  /// No description provided for @reciterAfasy.
  ///
  /// In en, this message translates to:
  /// **'Al-Afasy'**
  String get reciterAfasy;

  /// No description provided for @reciterMinshawi.
  ///
  /// In en, this message translates to:
  /// **'Al-Minshawi'**
  String get reciterMinshawi;

  /// No description provided for @reciterAbdulBaset.
  ///
  /// In en, this message translates to:
  /// **'Abdul Basit'**
  String get reciterAbdulBaset;

  /// No description provided for @reciterMaher.
  ///
  /// In en, this message translates to:
  /// **'Maher Al-Mu\'aiqly'**
  String get reciterMaher;

  /// No description provided for @notifPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get notifPrayerTimes;

  /// No description provided for @notifPrayerTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for prayer'**
  String get notifPrayerTimeTitle;

  /// No description provided for @notifPrayerTimeBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for \$prayer prayer'**
  String get notifPrayerTimeBody;

  /// No description provided for @notifMorningAzkarTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get notifMorningAzkarTitle;

  /// No description provided for @notifMorningAzkarBody.
  ///
  /// In en, this message translates to:
  /// **'🌅 The Messenger of Allah ﷺ said: Whoever says in the morning \'La ilaha illa Allah...\''**
  String get notifMorningAzkarBody;

  /// No description provided for @notifEveningAzkarTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar'**
  String get notifEveningAzkarTitle;

  /// No description provided for @notifConnectivityTest.
  ///
  /// In en, this message translates to:
  /// **'📡 Internet Connection'**
  String get notifConnectivityTest;

  /// No description provided for @notifConnectivityWorking.
  ///
  /// In en, this message translates to:
  /// **'Internet connection is working'**
  String get notifConnectivityWorking;

  /// No description provided for @notifConnectivityFailed.
  ///
  /// In en, this message translates to:
  /// **'📡 Internet Connection'**
  String get notifConnectivityFailed;

  /// No description provided for @notifConnectivityFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Internet connection failed: \$error'**
  String get notifConnectivityFailedBody;

  /// No description provided for @yearHijriFormat.
  ///
  /// In en, this message translates to:
  /// **'\$day \$month \$year AH'**
  String get yearHijriFormat;

  /// No description provided for @dateMiladiFormat.
  ///
  /// In en, this message translates to:
  /// **'\$day \$month \$year CE'**
  String get dateMiladiFormat;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'en',
        'es',
        'fr',
        'ru',
        'tr'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
