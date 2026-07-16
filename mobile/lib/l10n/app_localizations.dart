import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ko'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Randevu 360'**
  String get appTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

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

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Appointment management\nfor small businesses'**
  String get appTagline;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @termsNotice.
  ///
  /// In en, this message translates to:
  /// **'By signing in you accept the Terms of Use'**
  String get termsNotice;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome,\n{name}'**
  String welcomeUser(String name);

  /// No description provided for @howToContinue.
  ///
  /// In en, this message translates to:
  /// **'How would you like to continue?'**
  String get howToContinue;

  /// No description provided for @roleOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m a business owner'**
  String get roleOwnerTitle;

  /// No description provided for @roleOwnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new business or manage my existing one'**
  String get roleOwnerSubtitle;

  /// No description provided for @roleEmployeeTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m an employee'**
  String get roleEmployeeTitle;

  /// No description provided for @roleEmployeeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access my account via the owner\'s invitation'**
  String get roleEmployeeSubtitle;

  /// No description provided for @useDifferentAccount.
  ///
  /// In en, this message translates to:
  /// **'Use a different account'**
  String get useDifferentAccount;

  /// No description provided for @notSignedInTitle.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedInTitle;

  /// No description provided for @notSignedInMessage.
  ///
  /// In en, this message translates to:
  /// **'Please sign in with your Google account first.'**
  String get notSignedInMessage;

  /// No description provided for @inviteNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Invitation not found'**
  String get inviteNotFoundTitle;

  /// No description provided for @inviteNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No invitation was found for this e-mail address.\n\nAsk the business owner to add you to the system.'**
  String get inviteNotFoundMessage;

  /// No description provided for @invalidBusinessInfo.
  ///
  /// In en, this message translates to:
  /// **'Business information is invalid.'**
  String get invalidBusinessInfo;

  /// No description provided for @businessRecordFailed.
  ///
  /// In en, this message translates to:
  /// **'Business record could not be created: {error}'**
  String businessRecordFailed(String error);

  /// No description provided for @connectionErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connectionErrorTitle;

  /// No description provided for @inviteCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'The employee invitation could not be checked. Check your internet connection and try again.'**
  String get inviteCheckFailed;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get tabAppointments;

  /// No description provided for @tabCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get tabCustomers;

  /// No description provided for @tabFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get tabFinance;

  /// No description provided for @tabEmployees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get tabEmployees;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @greetingHello.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}'**
  String greetingHello(String name);

  /// No description provided for @greetingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to manage your business'**
  String get greetingSubtitle;

  /// No description provided for @statToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statToday;

  /// No description provided for @statCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statCompleted;

  /// No description provided for @statPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statPending;

  /// No description provided for @statTotalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total customers'**
  String get statTotalCustomers;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @quickNewAppointment.
  ///
  /// In en, this message translates to:
  /// **'New appointment'**
  String get quickNewAppointment;

  /// No description provided for @quickAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get quickAddCustomer;

  /// No description provided for @quickBulkMessage.
  ///
  /// In en, this message translates to:
  /// **'Bulk message'**
  String get quickBulkMessage;

  /// No description provided for @whatsappConnection.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp connection'**
  String get whatsappConnection;

  /// No description provided for @waConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get waConnected;

  /// No description provided for @waPairing.
  ///
  /// In en, this message translates to:
  /// **'Pairing...'**
  String get waPairing;

  /// No description provided for @waNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected yet'**
  String get waNotConnected;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @todaysAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s appointments'**
  String get todaysAppointments;

  /// No description provided for @noAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'No appointments today'**
  String get noAppointmentsToday;

  /// No description provided for @customerFallback.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerFallback;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusShortConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusShortConfirmed;

  /// No description provided for @statusShortCompleted.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusShortCompleted;

  /// No description provided for @statusShortCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusShortCancelled;

  /// No description provided for @statusShortPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusShortPending;

  /// No description provided for @appointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointmentsTitle;

  /// No description provided for @appointmentCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} appointments'**
  String appointmentCountLabel(int count);

  /// No description provided for @allEmployees.
  ///
  /// In en, this message translates to:
  /// **'All employees'**
  String get allEmployees;

  /// No description provided for @noAppointmentsThisDay.
  ///
  /// In en, this message translates to:
  /// **'No appointments on this day'**
  String get noAppointmentsThisDay;

  /// No description provided for @addAppointment.
  ///
  /// In en, this message translates to:
  /// **'Add appointment'**
  String get addAppointment;

  /// No description provided for @appointmentDetail.
  ///
  /// In en, this message translates to:
  /// **'Appointment detail'**
  String get appointmentDetail;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @serviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get serviceLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @completedPaidNote.
  ///
  /// In en, this message translates to:
  /// **'Completed, payment received'**
  String get completedPaidNote;

  /// No description provided for @cancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAppointment;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get markCompleted;

  /// No description provided for @appointmentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled'**
  String get appointmentCancelled;

  /// No description provided for @appointmentCancelFailed.
  ///
  /// In en, this message translates to:
  /// **'Appointment could not be cancelled'**
  String get appointmentCancelFailed;

  /// No description provided for @collectedSummary.
  ///
  /// In en, this message translates to:
  /// **'{amount} ₺ collected in {method}'**
  String collectedSummary(String amount, String method);

  /// No description provided for @debtRecordedSummary.
  ///
  /// In en, this message translates to:
  /// **'{amount} ₺ recorded as debt'**
  String debtRecordedSummary(String amount);

  /// No description provided for @appointmentCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Appointment completed'**
  String get appointmentCompletedMsg;

  /// No description provided for @paymentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment could not be saved'**
  String get paymentSaveFailed;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentCard;

  /// No description provided for @paymentTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get paymentTransfer;

  /// No description provided for @paymentCashLower.
  ///
  /// In en, this message translates to:
  /// **'cash'**
  String get paymentCashLower;

  /// No description provided for @paymentCardLower.
  ///
  /// In en, this message translates to:
  /// **'card'**
  String get paymentCardLower;

  /// No description provided for @newAppointment.
  ///
  /// In en, this message translates to:
  /// **'New appointment'**
  String get newAppointment;

  /// No description provided for @businessInfoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Business information not found'**
  String get businessInfoNotFound;

  /// No description provided for @appointmentCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Appointment could not be created'**
  String get appointmentCreateFailed;

  /// No description provided for @appointmentCreated.
  ///
  /// In en, this message translates to:
  /// **'Appointment created successfully'**
  String get appointmentCreated;

  /// No description provided for @customerPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer phone is required'**
  String get customerPhoneRequired;

  /// No description provided for @customerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer name is required'**
  String get customerNameRequired;

  /// No description provided for @customerCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Customer could not be created'**
  String get customerCreateFailed;

  /// No description provided for @sectionCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get sectionCustomer;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select customer'**
  String get selectCustomer;

  /// No description provided for @addNewCustomerItem.
  ///
  /// In en, this message translates to:
  /// **'+ Add new customer'**
  String get addNewCustomerItem;

  /// No description provided for @customerNameField.
  ///
  /// In en, this message translates to:
  /// **'Customer name *'**
  String get customerNameField;

  /// No description provided for @phoneField.
  ///
  /// In en, this message translates to:
  /// **'Phone *'**
  String get phoneField;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @sectionService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get sectionService;

  /// No description provided for @noServicesDefined.
  ///
  /// In en, this message translates to:
  /// **'No services defined yet.\nDefine services and prices in Profile > Services.'**
  String get noServicesDefined;

  /// No description provided for @selectServiceField.
  ///
  /// In en, this message translates to:
  /// **'Select service *'**
  String get selectServiceField;

  /// No description provided for @serviceRequired.
  ///
  /// In en, this message translates to:
  /// **'Service selection is required'**
  String get serviceRequired;

  /// No description provided for @priceField.
  ///
  /// In en, this message translates to:
  /// **'Price *'**
  String get priceField;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceRequired;

  /// No description provided for @priceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get priceInvalid;

  /// No description provided for @sectionEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get sectionEmployee;

  /// No description provided for @selectEmployeeField.
  ///
  /// In en, this message translates to:
  /// **'Select employee *'**
  String get selectEmployeeField;

  /// No description provided for @employeeRequired.
  ///
  /// In en, this message translates to:
  /// **'Employee selection is required'**
  String get employeeRequired;

  /// No description provided for @sectionDateTime.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get sectionDateTime;

  /// No description provided for @dateField.
  ///
  /// In en, this message translates to:
  /// **'Date *'**
  String get dateField;

  /// No description provided for @timeField.
  ///
  /// In en, this message translates to:
  /// **'Time *'**
  String get timeField;

  /// No description provided for @sectionNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get sectionNote;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Notes about the appointment...'**
  String get noteHint;

  /// No description provided for @saveAppointment.
  ///
  /// In en, this message translates to:
  /// **'Save appointment'**
  String get saveAppointment;

  /// No description provided for @takePayment.
  ///
  /// In en, this message translates to:
  /// **'Take payment'**
  String get takePayment;

  /// No description provided for @appointmentPriceInfo.
  ///
  /// In en, this message translates to:
  /// **'Appointment price: {amount} ₺'**
  String appointmentPriceInfo(String amount);

  /// No description provided for @amountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received (₺)'**
  String get amountReceived;

  /// No description provided for @remainingWillBeDebt.
  ///
  /// In en, this message translates to:
  /// **'Remaining {amount} ₺ will be recorded as debt'**
  String remainingWillBeDebt(String amount);

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodLabel;

  /// No description provided for @allAsDebt.
  ///
  /// In en, this message translates to:
  /// **'All as debt'**
  String get allAsDebt;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @financeTitle.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeTitle;

  /// No description provided for @statisticsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTooltip;

  /// No description provided for @monthlyBalance.
  ///
  /// In en, this message translates to:
  /// **'Monthly balance'**
  String get monthlyBalance;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @receivablesLabel.
  ///
  /// In en, this message translates to:
  /// **'Receivables ({count})'**
  String receivablesLabel(int count);

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get recentTransactions;

  /// No description provided for @viewAllShort.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get viewAllShort;

  /// No description provided for @addIncomeExpense.
  ///
  /// In en, this message translates to:
  /// **'Add income/expense'**
  String get addIncomeExpense;

  /// No description provided for @amountField.
  ///
  /// In en, this message translates to:
  /// **'Amount (₺)'**
  String get amountField;

  /// No description provided for @categoryField.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryField;

  /// No description provided for @descriptionField.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionField;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @otherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other income'**
  String get otherIncome;

  /// No description provided for @otherExpense.
  ///
  /// In en, this message translates to:
  /// **'Other expense'**
  String get otherExpense;

  /// No description provided for @allTransactions.
  ///
  /// In en, this message translates to:
  /// **'All transactions'**
  String get allTransactions;

  /// No description provided for @incomes.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomes;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// No description provided for @debtorCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers with debt'**
  String get debtorCustomers;

  /// No description provided for @noDebtors.
  ///
  /// In en, this message translates to:
  /// **'No customers with debt'**
  String get noDebtors;

  /// No description provided for @totalReceivable.
  ///
  /// In en, this message translates to:
  /// **'Total receivable'**
  String get totalReceivable;

  /// No description provided for @customersCountShort.
  ///
  /// In en, this message translates to:
  /// **'{count} customers'**
  String customersCountShort(int count);

  /// No description provided for @openDebtCount.
  ///
  /// In en, this message translates to:
  /// **'{count} open debts'**
  String openDebtCount(int count);

  /// No description provided for @remindViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Remind via WhatsApp'**
  String get remindViaWhatsApp;

  /// No description provided for @reminderSentTo.
  ///
  /// In en, this message translates to:
  /// **'Reminder sent: {name}'**
  String reminderSentTo(String name);

  /// No description provided for @reminderSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Reminder could not be sent (check the WhatsApp connection)'**
  String get reminderSendFailed;

  /// No description provided for @collectPayment.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get collectPayment;

  /// No description provided for @remainingDebtInfo.
  ///
  /// In en, this message translates to:
  /// **'Remaining debt: {amount} ₺'**
  String remainingDebtInfo(String amount);

  /// No description provided for @collectedAmountField.
  ///
  /// In en, this message translates to:
  /// **'Amount collected (₺)'**
  String get collectedAmountField;

  /// No description provided for @amountExceedsDebt.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot exceed the remaining debt ({amount} ₺)'**
  String amountExceedsDebt(String amount);

  /// No description provided for @remainingTracked.
  ///
  /// In en, this message translates to:
  /// **'Remaining {amount} ₺ is tracked as debt'**
  String remainingTracked(String amount);

  /// No description provided for @collectedWithRemaining.
  ///
  /// In en, this message translates to:
  /// **'{amount} ₺ collected, {left} ₺ remaining'**
  String collectedWithRemaining(String amount, String left);

  /// No description provided for @collectedDebtClosed.
  ///
  /// In en, this message translates to:
  /// **'{amount} ₺ collected, debt closed'**
  String collectedDebtClosed(String amount);

  /// No description provided for @collectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Collection could not be saved'**
  String get collectionFailed;

  /// No description provided for @debtBadge.
  ///
  /// In en, this message translates to:
  /// **'{amount} ₺ debt'**
  String debtBadge(String amount);

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @periodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get periodYear;

  /// No description provided for @employeeFilter.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employeeFilter;

  /// No description provided for @noTransactionsInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this period'**
  String get noTransactionsInPeriod;

  /// No description provided for @incomeTrend.
  ///
  /// In en, this message translates to:
  /// **'Income trend'**
  String get incomeTrend;

  /// No description provided for @noIncomeRecords.
  ///
  /// In en, this message translates to:
  /// **'No income records'**
  String get noIncomeRecords;

  /// No description provided for @paymentDistribution.
  ///
  /// In en, this message translates to:
  /// **'Payment method distribution'**
  String get paymentDistribution;

  /// No description provided for @employeeEarnings.
  ///
  /// In en, this message translates to:
  /// **'Employee earnings'**
  String get employeeEarnings;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @topServices.
  ///
  /// In en, this message translates to:
  /// **'Top earning services'**
  String get topServices;

  /// No description provided for @topCustomers.
  ///
  /// In en, this message translates to:
  /// **'Best customers'**
  String get topCustomers;

  /// No description provided for @expenseItems.
  ///
  /// In en, this message translates to:
  /// **'Expense items'**
  String get expenseItems;

  /// No description provided for @employeeDebtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Debts by employee'**
  String get employeeDebtsTitle;

  /// No description provided for @generalTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalTitle;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records'**
  String get noRecords;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'Number of transactions'**
  String get transactionCount;

  /// No description provided for @avgTransaction.
  ///
  /// In en, this message translates to:
  /// **'Average transaction'**
  String get avgTransaction;

  /// No description provided for @incomeTransactionCount.
  ///
  /// In en, this message translates to:
  /// **'Income transaction count'**
  String get incomeTransactionCount;

  /// No description provided for @avgTransactionAmount.
  ///
  /// In en, this message translates to:
  /// **'Average transaction amount'**
  String get avgTransactionAmount;

  /// No description provided for @appointmentsTotal.
  ///
  /// In en, this message translates to:
  /// **'Appointments (total)'**
  String get appointmentsTotal;

  /// No description provided for @completedAppointmentsStat.
  ///
  /// In en, this message translates to:
  /// **'Completed appointments'**
  String get completedAppointmentsStat;

  /// No description provided for @cancelledAppointmentsStat.
  ///
  /// In en, this message translates to:
  /// **'Cancelled appointments'**
  String get cancelledAppointmentsStat;

  /// No description provided for @cashRatio.
  ///
  /// In en, this message translates to:
  /// **'Cash ratio'**
  String get cashRatio;

  /// No description provided for @openDebtTotal.
  ///
  /// In en, this message translates to:
  /// **'Total open debt'**
  String get openDebtTotal;

  /// No description provided for @employeeDebtHint.
  ///
  /// In en, this message translates to:
  /// **'Debts are grouped by the employee who did the work. Tap a row to list the debtor customers.'**
  String get employeeDebtHint;

  /// No description provided for @debtorCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} debtor customers'**
  String debtorCountLabel(int count);

  /// No description provided for @employeeDebtorsSheet.
  ///
  /// In en, this message translates to:
  /// **'{name} — debtor customers ({amount} ₺)'**
  String employeeDebtorsSheet(String name, String amount);

  /// No description provided for @employeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employeesTitle;

  /// No description provided for @addEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add employee'**
  String get addEmployee;

  /// No description provided for @noEmployeesYet.
  ///
  /// In en, this message translates to:
  /// **'No employees added yet'**
  String get noEmployeesYet;

  /// No description provided for @searchEmployeeHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, e-mail or phone'**
  String get searchEmployeeHint;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get roleEmployee;

  /// No description provided for @noMatchingEmployees.
  ///
  /// In en, this message translates to:
  /// **'No matching employees'**
  String get noMatchingEmployees;

  /// No description provided for @makeEmployee.
  ///
  /// In en, this message translates to:
  /// **'Make employee'**
  String get makeEmployee;

  /// No description provided for @makeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make admin'**
  String get makeAdmin;

  /// No description provided for @deleteEmployeeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete employee'**
  String get deleteEmployeeTitle;

  /// No description provided for @deleteEmployeeConfirm.
  ///
  /// In en, this message translates to:
  /// **'{name} will be deleted. This cannot be undone.'**
  String deleteEmployeeConfirm(String name);

  /// No description provided for @employeeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Employee deleted'**
  String get employeeDeleted;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get deleteFailed;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @enterValidEmailInvite.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid e-mail — the employee will sign in with the Google account at this address'**
  String get enterValidEmailInvite;

  /// No description provided for @fullNameField.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameField;

  /// No description provided for @phoneOnlyField.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneOnlyField;

  /// No description provided for @emailField.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get emailField;

  /// No description provided for @roleField.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleField;

  /// No description provided for @employeeAddedInfo.
  ///
  /// In en, this message translates to:
  /// **'{name} added. They can sign in with the Google account at {email} and use the \"I\'m an employee\" option.'**
  String employeeAddedInfo(String name, String email);

  /// No description provided for @employeeAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Employee could not be added'**
  String get employeeAddFailed;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTitle;

  /// No description provided for @addCustomerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get addCustomerTooltip;

  /// No description provided for @searchCustomerHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, phone or e-mail'**
  String get searchCustomerHint;

  /// No description provided for @filterDebtor.
  ///
  /// In en, this message translates to:
  /// **'With debt'**
  String get filterDebtor;

  /// No description provided for @filterContacts.
  ///
  /// In en, this message translates to:
  /// **'From contacts'**
  String get filterContacts;

  /// No description provided for @filterManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get filterManual;

  /// No description provided for @customersCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} customers'**
  String customersCountLabel(int count);

  /// No description provided for @noCustomersYet.
  ///
  /// In en, this message translates to:
  /// **'No customers added yet'**
  String get noCustomersYet;

  /// No description provided for @noMatchingCustomers.
  ///
  /// In en, this message translates to:
  /// **'No matching customers'**
  String get noMatchingCustomers;

  /// No description provided for @addCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get addCustomerTitle;

  /// No description provided for @contactPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission is required'**
  String get contactPermissionRequired;

  /// No description provided for @noContactsFound.
  ///
  /// In en, this message translates to:
  /// **'No contacts found'**
  String get noContactsFound;

  /// No description provided for @noContactsWithPhone.
  ///
  /// In en, this message translates to:
  /// **'No contacts with a phone number'**
  String get noContactsWithPhone;

  /// No description provided for @addedFromContacts.
  ///
  /// In en, this message translates to:
  /// **'{count} people added from contacts'**
  String addedFromContacts(int count);

  /// No description provided for @contactReadError.
  ///
  /// In en, this message translates to:
  /// **'Error reading contacts: {error}'**
  String contactReadError(String error);

  /// No description provided for @businessInfoMissing.
  ///
  /// In en, this message translates to:
  /// **'Business information is missing. Please try again.'**
  String get businessInfoMissing;

  /// No description provided for @customerAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} added successfully'**
  String customerAddedSuccess(String name);

  /// No description provided for @customerAddError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while adding the customer'**
  String get customerAddError;

  /// No description provided for @pickFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Add from contacts (multi-select)'**
  String get pickFromContacts;

  /// No description provided for @loadingContacts.
  ///
  /// In en, this message translates to:
  /// **'Loading contacts...'**
  String get loadingContacts;

  /// No description provided for @orEnterManually.
  ///
  /// In en, this message translates to:
  /// **'or enter manually'**
  String get orEnterManually;

  /// No description provided for @fullNameStarField.
  ///
  /// In en, this message translates to:
  /// **'Full name *'**
  String get fullNameStarField;

  /// No description provided for @noteField.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteField;

  /// No description provided for @pickContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick from contacts'**
  String get pickContactTitle;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @searchNameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search name or phone...'**
  String get searchNameOrPhone;

  /// No description provided for @selectNone.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get selectNone;

  /// No description provided for @selectAllCount.
  ///
  /// In en, this message translates to:
  /// **'Select all ({count})'**
  String selectAllCount(int count);

  /// No description provided for @noMatchingContacts.
  ///
  /// In en, this message translates to:
  /// **'No contacts match your search'**
  String get noMatchingContacts;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'List is empty'**
  String get emptyList;

  /// No description provided for @addNPeople.
  ///
  /// In en, this message translates to:
  /// **'Add {count} people'**
  String addNPeople(int count);

  /// No description provided for @defineBusiness.
  ///
  /// In en, this message translates to:
  /// **'Set up your business'**
  String get defineBusiness;

  /// No description provided for @businessInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Business information'**
  String get businessInfoTitle;

  /// No description provided for @businessSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your business to start using Randevu 360'**
  String get businessSetupSubtitle;

  /// No description provided for @businessNameField.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get businessNameField;

  /// No description provided for @businessNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Business name is required'**
  String get businessNameRequired;

  /// No description provided for @addressField.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressField;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid e-mail'**
  String get emailInvalid;

  /// No description provided for @workingHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get workingHoursTitle;

  /// No description provided for @workingDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Working days'**
  String get workingDaysTitle;

  /// No description provided for @opening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get opening;

  /// No description provided for @closing.
  ///
  /// In en, this message translates to:
  /// **'Closing'**
  String get closing;

  /// No description provided for @saveAndStart.
  ///
  /// In en, this message translates to:
  /// **'Save and start'**
  String get saveAndStart;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get daySun;

  /// No description provided for @businessInfoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Business information updated'**
  String get businessInfoUpdated;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// No description provided for @onlyOwnerCanEdit.
  ///
  /// In en, this message translates to:
  /// **'Only the business owner can change this information.'**
  String get onlyOwnerCanEdit;

  /// No description provided for @workingHoursUpdated.
  ///
  /// In en, this message translates to:
  /// **'Working hours updated'**
  String get workingHoursUpdated;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @userFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userFallback;

  /// No description provided for @whatsappSettings.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp settings'**
  String get whatsappSettings;

  /// No description provided for @servicesAndPrices.
  ///
  /// In en, this message translates to:
  /// **'Services and prices'**
  String get servicesAndPrices;

  /// No description provided for @incomeExpenseCategories.
  ///
  /// In en, this message translates to:
  /// **'Income/expense categories'**
  String get incomeExpenseCategories;

  /// No description provided for @messageTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Message templates'**
  String get messageTemplatesTitle;

  /// No description provided for @workingHoursMenu.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get workingHoursMenu;

  /// No description provided for @backupMenu.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupMenu;

  /// No description provided for @restoreMenu.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get restoreMenu;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed: {error}'**
  String googleSignInFailed(String error);

  /// No description provided for @backedUp.
  ///
  /// In en, this message translates to:
  /// **'Backed up ✅'**
  String get backedUp;

  /// No description provided for @backupFailedMsg.
  ///
  /// In en, this message translates to:
  /// **'Backup error: {error}'**
  String backupFailedMsg(String error);

  /// No description provided for @restoreFailedMsg.
  ///
  /// In en, this message translates to:
  /// **'Restore error: {error}'**
  String restoreFailedMsg(String error);

  /// No description provided for @backupDownloadedTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup downloaded'**
  String get backupDownloadedTitle;

  /// No description provided for @backupDownloadedMessage.
  ///
  /// In en, this message translates to:
  /// **'The app will now close to finish the restore. When you reopen it, your data will be restored from the backup.'**
  String get backupDownloadedMessage;

  /// No description provided for @autoBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic nightly backup'**
  String get autoBackupTitle;

  /// No description provided for @autoBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Backs up to Drive every night between 02:00-03:00'**
  String get autoBackupSubtitle;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutApp;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Income/expense categories'**
  String get categoriesTitle;

  /// No description provided for @incomeCategories.
  ///
  /// In en, this message translates to:
  /// **'Income categories'**
  String get incomeCategories;

  /// No description provided for @expenseCategories.
  ///
  /// In en, this message translates to:
  /// **'Expense categories'**
  String get expenseCategories;

  /// No description provided for @addIncomeCategory.
  ///
  /// In en, this message translates to:
  /// **'Add income category'**
  String get addIncomeCategory;

  /// No description provided for @addExpenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Add expense category'**
  String get addExpenseCategory;

  /// No description provided for @categoryNameField.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryNameField;

  /// No description provided for @categoryExists.
  ///
  /// In en, this message translates to:
  /// **'This category already exists'**
  String get categoryExists;

  /// No description provided for @categoryAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Category could not be added'**
  String get categoryAddFailed;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be deleted. Past transactions are not affected.'**
  String deleteCategoryConfirm(String name);

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get noCategories;

  /// No description provided for @availableVariables.
  ///
  /// In en, this message translates to:
  /// **'Available variables'**
  String get availableVariables;

  /// No description provided for @templateHelp.
  ///
  /// In en, this message translates to:
  /// **'These variables are replaced with appointment details when the message is sent. If you clear a template completely, that message is never sent.'**
  String get templateHelp;

  /// No description provided for @emptyToDisable.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to not send this message'**
  String get emptyToDisable;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get resetToDefault;

  /// No description provided for @templatesSaved.
  ///
  /// In en, this message translates to:
  /// **'Templates saved'**
  String get templatesSaved;

  /// No description provided for @templatesSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Templates could not be saved'**
  String get templatesSaveFailed;

  /// No description provided for @templatesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Templates could not be loaded'**
  String get templatesLoadFailed;

  /// No description provided for @templatesServerNote.
  ///
  /// In en, this message translates to:
  /// **'Templates are stored on the WhatsApp server; a connection is required.'**
  String get templatesServerNote;

  /// No description provided for @debtReminderFrequency.
  ///
  /// In en, this message translates to:
  /// **'Debt reminder frequency'**
  String get debtReminderFrequency;

  /// No description provided for @debtReminderFrequencyHelp.
  ///
  /// In en, this message translates to:
  /// **'The \"Debt reminder\" template is sent automatically to customers with debt at the selected frequency (between 10:00-20:00).'**
  String get debtReminderFrequencyHelp;

  /// No description provided for @freqOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get freqOff;

  /// No description provided for @freqDaily.
  ///
  /// In en, this message translates to:
  /// **'Once a day'**
  String get freqDaily;

  /// No description provided for @freqWeekly.
  ///
  /// In en, this message translates to:
  /// **'Once a week'**
  String get freqWeekly;

  /// No description provided for @freqMonthly.
  ///
  /// In en, this message translates to:
  /// **'Once a month'**
  String get freqMonthly;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;
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
        'de',
        'en',
        'fr',
        'hi',
        'it',
        'ko',
        'ru',
        'tr',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ko':
      return AppLocalizationsKo();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
