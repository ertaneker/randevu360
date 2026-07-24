// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Esnaf Takvim';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Try again';

  @override
  String get all => 'All';

  @override
  String get errorTitle => 'Error';

  @override
  String get pressBackAgainToExit => 'Press back again to exit';

  @override
  String get appTagline => 'Appointment management\nfor small businesses';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get termsNotice => 'By signing in you accept the Terms of Use';

  @override
  String welcomeUser(String name) {
    return 'Welcome,\n$name';
  }

  @override
  String get howToContinue => 'How would you like to continue?';

  @override
  String get roleOwnerTitle => 'I\'m a business owner';

  @override
  String get roleOwnerSubtitle =>
      'Create a new business or manage my existing one';

  @override
  String get roleEmployeeTitle => 'I\'m an employee';

  @override
  String get roleEmployeeSubtitle =>
      'Access my account via the owner\'s invitation';

  @override
  String get useDifferentAccount => 'Use a different account';

  @override
  String get notSignedInTitle => 'Not signed in';

  @override
  String get notSignedInMessage =>
      'Please sign in with your Google account first.';

  @override
  String get inviteNotFoundTitle => 'Invitation not found';

  @override
  String get inviteNotFoundMessage =>
      'No invitation was found for this e-mail address.\n\nAsk the business owner to add you to the system.';

  @override
  String get invalidBusinessInfo => 'Business information is invalid.';

  @override
  String businessRecordFailed(String error) {
    return 'Business record could not be created: $error';
  }

  @override
  String get connectionErrorTitle => 'Connection error';

  @override
  String get inviteCheckFailed =>
      'The employee invitation could not be checked. Check your internet connection and try again.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabAppointments => 'Appointments';

  @override
  String get tabCustomers => 'Customers';

  @override
  String get tabFinance => 'Finance';

  @override
  String get tabEmployees => 'Employees';

  @override
  String get tabProfile => 'Profile';

  @override
  String greetingHello(String name) {
    return 'Hello $name';
  }

  @override
  String get greetingSubtitle => 'Ready to manage your business';

  @override
  String get statToday => 'Today';

  @override
  String get statCompleted => 'Completed';

  @override
  String get statPending => 'Pending';

  @override
  String get statTotalCustomers => 'Total customers';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get quickNewAppointment => 'New appointment';

  @override
  String get quickAddCustomer => 'Add customer';

  @override
  String get quickBulkMessage => 'Bulk message';

  @override
  String get whatsappConnection => 'WhatsApp connection';

  @override
  String get waConnected => 'Connected';

  @override
  String get waPairing => 'Pairing...';

  @override
  String get waNotConnected => 'Not connected yet';

  @override
  String get manage => 'Manage';

  @override
  String get connect => 'Connect';

  @override
  String get todaysAppointments => 'Today\'s appointments';

  @override
  String get noAppointmentsToday => 'No appointments today';

  @override
  String get customerFallback => 'Customer';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusShortConfirmed => 'Confirmed';

  @override
  String get statusShortCompleted => 'Done';

  @override
  String get statusShortCancelled => 'Cancelled';

  @override
  String get statusShortPending => 'Pending';

  @override
  String get appointmentsTitle => 'Appointments';

  @override
  String appointmentCountLabel(int count) {
    return '$count appointments';
  }

  @override
  String get allEmployees => 'All employees';

  @override
  String get noAppointmentsThisDay => 'No appointments on this day';

  @override
  String get addAppointment => 'Add appointment';

  @override
  String get appointmentDetail => 'Appointment detail';

  @override
  String get customerLabel => 'Customer';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get serviceLabel => 'Service';

  @override
  String get priceLabel => 'Price';

  @override
  String get noteLabel => 'Note';

  @override
  String get completedPaidNote => 'Completed, payment received';

  @override
  String get cancelAppointment => 'Cancel';

  @override
  String get markCompleted => 'Completed';

  @override
  String get appointmentCancelled => 'Appointment cancelled';

  @override
  String get appointmentCancelFailed => 'Appointment could not be cancelled';

  @override
  String collectedSummary(String amount, String method) {
    return '$amount ₺ collected in $method';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ recorded as debt';
  }

  @override
  String get appointmentCompletedMsg => 'Appointment completed';

  @override
  String get paymentSaveFailed => 'Payment could not be saved';

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentCard => 'Card';

  @override
  String get paymentTransfer => 'Transfer';

  @override
  String get paymentCashLower => 'cash';

  @override
  String get paymentCardLower => 'card';

  @override
  String get newAppointment => 'New appointment';

  @override
  String get businessInfoNotFound => 'Business information not found';

  @override
  String get appointmentCreateFailed => 'Appointment could not be created';

  @override
  String get appointmentCreated => 'Appointment created successfully';

  @override
  String get customerPhoneRequired => 'Customer phone is required';

  @override
  String get customerNameRequired => 'Customer name is required';

  @override
  String get customerCreateFailed => 'Customer could not be created';

  @override
  String get sectionCustomer => 'Customer';

  @override
  String get selectCustomer => 'Select customer';

  @override
  String get addNewCustomerItem => '+ Add new customer';

  @override
  String get customerNameField => 'Customer name *';

  @override
  String get phoneField => 'Phone *';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get sectionService => 'Service';

  @override
  String get noServicesDefined =>
      'No services defined yet.\nDefine services and prices in Profile > Services.';

  @override
  String get selectServiceField => 'Select service *';

  @override
  String get serviceRequired => 'Service selection is required';

  @override
  String get priceField => 'Price *';

  @override
  String get priceRequired => 'Price is required';

  @override
  String get priceInvalid => 'Enter a valid price';

  @override
  String get sectionEmployee => 'Employee';

  @override
  String get selectEmployeeField => 'Select employee *';

  @override
  String get employeeRequired => 'Employee selection is required';

  @override
  String get sectionDateTime => 'Date and time';

  @override
  String get dateField => 'Date *';

  @override
  String get timeField => 'Time *';

  @override
  String get sectionNote => 'Note';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get noteHint => 'Notes about the appointment...';

  @override
  String get saveAppointment => 'Save appointment';

  @override
  String get takePayment => 'Take payment';

  @override
  String appointmentPriceInfo(String amount) {
    return 'Appointment price: $amount ₺';
  }

  @override
  String get amountReceived => 'Amount received (₺)';

  @override
  String remainingWillBeDebt(String amount) {
    return 'Remaining $amount ₺ will be recorded as debt';
  }

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get allAsDebt => 'All as debt';

  @override
  String get complete => 'Complete';

  @override
  String get financeTitle => 'Finance';

  @override
  String get statisticsTooltip => 'Statistics';

  @override
  String get monthlyBalance => 'Monthly balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get net => 'Net';

  @override
  String get thisWeek => 'This week';

  @override
  String receivablesLabel(int count) {
    return 'Receivables ($count)';
  }

  @override
  String get recentTransactions => 'Recent transactions';

  @override
  String get viewAllShort => 'All';

  @override
  String get addIncomeExpense => 'Add income/expense';

  @override
  String get amountField => 'Amount (₺)';

  @override
  String get categoryField => 'Category';

  @override
  String get descriptionField => 'Description';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get otherIncome => 'Other income';

  @override
  String get otherExpense => 'Other expense';

  @override
  String get allTransactions => 'All transactions';

  @override
  String get incomes => 'Income';

  @override
  String get expenses => 'Expenses';

  @override
  String get noTransactionsFound => 'No transactions found';

  @override
  String get debtorCustomers => 'Customers with debt';

  @override
  String get noDebtors => 'No customers with debt';

  @override
  String get totalReceivable => 'Total receivable';

  @override
  String customersCountShort(int count) {
    return '$count customers';
  }

  @override
  String openDebtCount(int count) {
    return '$count open debts';
  }

  @override
  String get remindViaWhatsApp => 'Remind via WhatsApp';

  @override
  String reminderSentTo(String name) {
    return 'Reminder sent: $name';
  }

  @override
  String get reminderSendFailed =>
      'Reminder could not be sent (check the WhatsApp connection)';

  @override
  String get collectPayment => 'Collect';

  @override
  String remainingDebtInfo(String amount) {
    return 'Remaining debt: $amount ₺';
  }

  @override
  String get collectedAmountField => 'Amount collected (₺)';

  @override
  String amountExceedsDebt(String amount) {
    return 'Amount cannot exceed the remaining debt ($amount ₺)';
  }

  @override
  String remainingTracked(String amount) {
    return 'Remaining $amount ₺ is tracked as debt';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '$amount ₺ collected, $left ₺ remaining';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '$amount ₺ collected, debt closed';
  }

  @override
  String get collectionFailed => 'Collection could not be saved';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ debt';
  }

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodYear => 'Year';

  @override
  String get employeeFilter => 'Employee';

  @override
  String get noTransactionsInPeriod => 'No transactions in this period';

  @override
  String get incomeTrend => 'Income trend';

  @override
  String get noIncomeRecords => 'No income records';

  @override
  String get paymentDistribution => 'Payment method distribution';

  @override
  String get employeeEarnings => 'Employee earnings';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get topServices => 'Top earning services';

  @override
  String get topCustomers => 'Best customers';

  @override
  String get expenseItems => 'Expense items';

  @override
  String get employeeDebtsTitle => 'Debts by employee';

  @override
  String get generalTitle => 'General';

  @override
  String get noRecords => 'No records';

  @override
  String get transactionCount => 'Number of transactions';

  @override
  String get avgTransaction => 'Average transaction';

  @override
  String get incomeTransactionCount => 'Income transaction count';

  @override
  String get avgTransactionAmount => 'Average transaction amount';

  @override
  String get appointmentsTotal => 'Appointments (total)';

  @override
  String get completedAppointmentsStat => 'Completed appointments';

  @override
  String get cancelledAppointmentsStat => 'Cancelled appointments';

  @override
  String get cashRatio => 'Cash ratio';

  @override
  String get openDebtTotal => 'Total open debt';

  @override
  String get employeeDebtHint =>
      'Debts are grouped by the employee who did the work. Tap a row to list the debtor customers.';

  @override
  String debtorCountLabel(int count) {
    return '$count debtor customers';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — debtor customers ($amount ₺)';
  }

  @override
  String get employeesTitle => 'Employees';

  @override
  String get addEmployee => 'Add employee';

  @override
  String get noEmployeesYet => 'No employees added yet';

  @override
  String get searchEmployeeHint => 'Search name, e-mail or phone';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleEmployee => 'Employee';

  @override
  String get noMatchingEmployees => 'No matching employees';

  @override
  String get makeEmployee => 'Make employee';

  @override
  String get makeAdmin => 'Make admin';

  @override
  String get deleteEmployeeTitle => 'Delete employee';

  @override
  String deleteEmployeeConfirm(String name) {
    return '$name will be deleted. This cannot be undone.';
  }

  @override
  String get employeeDeleted => 'Employee deleted';

  @override
  String get deleteFailed => 'Delete failed';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get enterValidEmailInvite =>
      'Enter a valid e-mail — the employee will sign in with the Google account at this address';

  @override
  String get fullNameField => 'Full name';

  @override
  String get phoneOnlyField => 'Phone';

  @override
  String get emailField => 'E-mail';

  @override
  String get roleField => 'Role';

  @override
  String employeeAddedInfo(String name, String email) {
    return '$name added. They can sign in with the Google account at $email and use the \"I\'m an employee\" option.';
  }

  @override
  String get employeeAddFailed => 'Employee could not be added';

  @override
  String get customersTitle => 'Customers';

  @override
  String get addCustomerTooltip => 'Add customer';

  @override
  String get searchCustomerHint => 'Search name, phone or e-mail';

  @override
  String get filterDebtor => 'With debt';

  @override
  String get filterContacts => 'From contacts';

  @override
  String get filterManual => 'Manual';

  @override
  String customersCountLabel(int count) {
    return '$count customers';
  }

  @override
  String get noCustomersYet => 'No customers added yet';

  @override
  String get noMatchingCustomers => 'No matching customers';

  @override
  String get addCustomerTitle => 'Add customer';

  @override
  String get contactPermissionRequired => 'Contacts permission is required';

  @override
  String get noContactsFound => 'No contacts found';

  @override
  String get noContactsWithPhone => 'No contacts with a phone number';

  @override
  String addedFromContacts(int count) {
    return '$count people added from contacts';
  }

  @override
  String contactReadError(String error) {
    return 'Error reading contacts: $error';
  }

  @override
  String get businessInfoMissing =>
      'Business information is missing. Please try again.';

  @override
  String customerAddedSuccess(String name) {
    return '$name added successfully';
  }

  @override
  String get customerAddError => 'An error occurred while adding the customer';

  @override
  String get pickFromContacts => 'Add from contacts (multi-select)';

  @override
  String get loadingContacts => 'Loading contacts...';

  @override
  String get orEnterManually => 'or enter manually';

  @override
  String get fullNameStarField => 'Full name *';

  @override
  String get noteField => 'Note';

  @override
  String get pickContactTitle => 'Pick from contacts';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get searchNameOrPhone => 'Search name or phone...';

  @override
  String get selectNone => 'Deselect all';

  @override
  String selectAllCount(int count) {
    return 'Select all ($count)';
  }

  @override
  String get noMatchingContacts => 'No contacts match your search';

  @override
  String get emptyList => 'List is empty';

  @override
  String addNPeople(int count) {
    return 'Add $count people';
  }

  @override
  String get defineBusiness => 'Set up your business';

  @override
  String get businessInfoTitle => 'Business information';

  @override
  String get businessSetupSubtitle =>
      'Set up your business to start using Esnaf Takvim';

  @override
  String get businessNameField => 'Business name';

  @override
  String get businessNameRequired => 'Business name is required';

  @override
  String get addressField => 'Address';

  @override
  String get emailInvalid => 'Enter a valid e-mail';

  @override
  String get workingHoursTitle => 'Working hours';

  @override
  String get workingDaysTitle => 'Working days';

  @override
  String get opening => 'Opening';

  @override
  String get closing => 'Closing';

  @override
  String get saveAndStart => 'Save and start';

  @override
  String get dayMon => 'Monday';

  @override
  String get dayTue => 'Tuesday';

  @override
  String get dayWed => 'Wednesday';

  @override
  String get dayThu => 'Thursday';

  @override
  String get dayFri => 'Friday';

  @override
  String get daySat => 'Saturday';

  @override
  String get daySun => 'Sunday';

  @override
  String get businessInfoUpdated => 'Business information updated';

  @override
  String get updateFailed => 'Update failed';

  @override
  String get onlyOwnerCanEdit =>
      'Only the business owner can change this information.';

  @override
  String get workingHoursUpdated => 'Working hours updated';

  @override
  String get profileTitle => 'Profile';

  @override
  String get userFallback => 'User';

  @override
  String get whatsappSettings => 'WhatsApp settings';

  @override
  String get servicesAndPrices => 'Services and prices';

  @override
  String get incomeExpenseCategories => 'Income/expense categories';

  @override
  String get messageTemplatesTitle => 'Message templates';

  @override
  String get workingHoursMenu => 'Working hours';

  @override
  String get backupMenu => 'Backup';

  @override
  String get restoreMenu => 'Restore from backup';

  @override
  String googleSignInFailed(String error) {
    return 'Google sign-in failed: $error';
  }

  @override
  String get backedUp => 'Backed up ✅';

  @override
  String backupFailedMsg(String error) {
    return 'Backup error: $error';
  }

  @override
  String restoreFailedMsg(String error) {
    return 'Restore error: $error';
  }

  @override
  String get backupDownloadedTitle => 'Backup downloaded';

  @override
  String get backupDownloadedMessage =>
      'The app will now close to finish the restore. When you reopen it, your data will be restored from the backup.';

  @override
  String get autoBackupTitle => 'Automatic nightly backup';

  @override
  String get autoBackupSubtitle =>
      'Backs up to Drive every night between 02:00-03:00';

  @override
  String get aboutApp => 'About the app';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get signOut => 'Sign out';

  @override
  String get categoriesTitle => 'Income/expense categories';

  @override
  String get incomeCategories => 'Income categories';

  @override
  String get expenseCategories => 'Expense categories';

  @override
  String get addIncomeCategory => 'Add income category';

  @override
  String get addExpenseCategory => 'Add expense category';

  @override
  String get categoryNameField => 'Category name';

  @override
  String get categoryExists => 'This category already exists';

  @override
  String get categoryAddFailed => 'Category could not be added';

  @override
  String get deleteCategoryTitle => 'Delete category';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\" will be deleted. Past transactions are not affected.';
  }

  @override
  String get noCategories => 'No categories';

  @override
  String get availableVariables => 'Available variables';

  @override
  String get templateHelp =>
      'These variables are replaced with appointment details when the message is sent. If you clear a template completely, that message is never sent.';

  @override
  String get emptyToDisable => 'Leave empty to not send this message';

  @override
  String get resetToDefault => 'Reset to default';

  @override
  String get templatesSaved => 'Templates saved';

  @override
  String get templatesSaveFailed => 'Templates could not be saved';

  @override
  String get templatesLoadFailed => 'Templates could not be loaded';

  @override
  String get templatesServerNote =>
      'Templates are stored on the WhatsApp server; a connection is required.';

  @override
  String get debtReminderFrequency => 'Debt reminder frequency';

  @override
  String get debtReminderFrequencyHelp =>
      'The \"Debt reminder\" template is sent automatically to customers with debt at the selected frequency (between 10:00-20:00).';

  @override
  String get freqOff => 'Off';

  @override
  String get freqDaily => 'Once a day';

  @override
  String get freqWeekly => 'Once a week';

  @override
  String get freqMonthly => 'Once a month';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get gridView => 'Grid View';

  @override
  String get listView => 'List View';

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get tapToAddAppointment => 'Tap to add appointment';

  @override
  String get employeeColor => 'Employee color';

  @override
  String get gridDisplayHours => 'Grid display hours';

  @override
  String get gridStartHour => 'Start hour';

  @override
  String get gridEndHour => 'End hour';

  @override
  String get gridSettingsSaved => 'Grid settings saved';

  @override
  String get changeColor => 'Change Color';

  @override
  String get selectColor => 'Select Color';
}
