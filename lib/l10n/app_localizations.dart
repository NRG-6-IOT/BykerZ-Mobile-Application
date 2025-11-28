import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('es'),
  ];

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @monitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get monitoring;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @expenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expenseDetails;

  /// No description provided for @createExpense.
  ///
  /// In en, this message translates to:
  /// **'Create Expense'**
  String get createExpense;

  /// No description provided for @vehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetails;

  /// No description provided for @createVehicle.
  ///
  /// In en, this message translates to:
  /// **'Create Vehicle'**
  String get createVehicle;

  /// No description provided for @metrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics for Vehicle'**
  String get metrics;

  /// No description provided for @ownerIdNotFound.
  ///
  /// In en, this message translates to:
  /// **'Owner ID not found. Please sign in again.'**
  String get ownerIdNotFound;

  /// No description provided for @loadingMaintenances.
  ///
  /// In en, this message translates to:
  /// **'Loading maintenances...'**
  String get loadingMaintenances;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @scheduledMaintenances.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Maintenances'**
  String get scheduledMaintenances;

  /// No description provided for @noScheduledMaintenances.
  ///
  /// In en, this message translates to:
  /// **'No scheduled maintenances'**
  String get noScheduledMaintenances;

  /// No description provided for @maintenancesDone.
  ///
  /// In en, this message translates to:
  /// **'Maintenances Done'**
  String get maintenancesDone;

  /// No description provided for @noCompletedMaintenances.
  ///
  /// In en, this message translates to:
  /// **'No completed maintenances'**
  String get noCompletedMaintenances;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @mechanic.
  ///
  /// In en, this message translates to:
  /// **'Mechanic'**
  String get mechanic;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @seeExpenseDetails.
  ///
  /// In en, this message translates to:
  /// **'See Expense Details'**
  String get seeExpenseDetails;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get deleteExpense;

  /// No description provided for @deleteExpenseConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this expense? This action cannot be undone.'**
  String get deleteExpenseConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @expenseDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Expense deleted successfully'**
  String get expenseDeletedSuccessfully;

  /// No description provided for @loadingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Loading expenses...'**
  String get loadingExpenses;

  /// No description provided for @noExpensesFound.
  ///
  /// In en, this message translates to:
  /// **'No expenses found'**
  String get noExpensesFound;

  /// No description provided for @clickToCreateFirstExpense.
  ///
  /// In en, this message translates to:
  /// **'Click the + button to create your first expense.'**
  String get clickToCreateFirstExpense;

  /// No description provided for @allExpenses.
  ///
  /// In en, this message translates to:
  /// **'All Expenses'**
  String get allExpenses;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'total expenses'**
  String get totalExpenses;

  /// No description provided for @tapToLoadExpenses.
  ///
  /// In en, this message translates to:
  /// **'Tap to load expenses'**
  String get tapToLoadExpenses;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New Expense'**
  String get newExpense;

  /// No description provided for @loadingDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading details...'**
  String get loadingDetails;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @loadingExpenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading expense details...'**
  String get loadingExpenseDetails;

  /// No description provided for @expenseName.
  ///
  /// In en, this message translates to:
  /// **'Expense Name'**
  String get expenseName;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @finalPrice.
  ///
  /// In en, this message translates to:
  /// **'Final Price'**
  String get finalPrice;

  /// No description provided for @fillAllItemFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all item fields'**
  String get fillAllItemFields;

  /// No description provided for @invalidAmountOrPrice.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0 and unit price cannot be negative'**
  String get invalidAmountOrPrice;

  /// No description provided for @enterExpenseName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an expense name'**
  String get enterExpenseName;

  /// No description provided for @addAtLeastOneItem.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one item'**
  String get addAtLeastOneItem;

  /// No description provided for @errorCreatingExpense.
  ///
  /// In en, this message translates to:
  /// **'Error creating expense'**
  String get errorCreatingExpense;

  /// No description provided for @expenseCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Expense created successfully!'**
  String get expenseCreatedSuccessfully;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPrice;

  /// No description provided for @itemType.
  ///
  /// In en, this message translates to:
  /// **'Item Type'**
  String get itemType;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @addItems.
  ///
  /// In en, this message translates to:
  /// **'Add Items'**
  String get addItems;

  /// No description provided for @addedItems.
  ///
  /// In en, this message translates to:
  /// **'Added Items'**
  String get addedItems;

  /// No description provided for @totalSum.
  ///
  /// In en, this message translates to:
  /// **'Total Sum'**
  String get totalSum;

  /// No description provided for @saveExpense.
  ///
  /// In en, this message translates to:
  /// **'Save Expense'**
  String get saveExpense;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @itemTypeFine.
  ///
  /// In en, this message translates to:
  /// **'Fine'**
  String get itemTypeFine;

  /// No description provided for @itemTypeParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get itemTypeParking;

  /// No description provided for @itemTypePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get itemTypePayment;

  /// No description provided for @itemTypeSupplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get itemTypeSupplies;

  /// No description provided for @itemTypeTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get itemTypeTax;

  /// No description provided for @itemTypeTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get itemTypeTools;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
