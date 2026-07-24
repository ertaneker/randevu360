// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Esnaf Takvim';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get add => 'जोड़ें';

  @override
  String get ok => 'ठीक है';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get all => 'सभी';

  @override
  String get errorTitle => 'त्रुटि';

  @override
  String get pressBackAgainToExit => 'बाहर निकलने के लिए फिर से दबाएं';

  @override
  String get appTagline => 'छोटे व्यवसायों के लिए\nअपॉइंटमेंट प्रबंधन';

  @override
  String get signInWithGoogle => 'Google से साइन इन करें';

  @override
  String get termsNotice =>
      'साइन इन करके आप उपयोग की शर्तों को स्वीकार करते हैं';

  @override
  String welcomeUser(String name) {
    return 'स्वागत है,\n$name';
  }

  @override
  String get howToContinue => 'आप कैसे आगे बढ़ना चाहेंगे?';

  @override
  String get roleOwnerTitle => 'मैं व्यवसाय का मालिक हूं';

  @override
  String get roleOwnerSubtitle =>
      'नया व्यवसाय बनाएं या अपने मौजूदा व्यवसाय का प्रबंधन करें';

  @override
  String get roleEmployeeTitle => 'मैं कर्मचारी हूं';

  @override
  String get roleEmployeeSubtitle =>
      'मालिक के निमंत्रण से अपने खाते तक पहुंचें';

  @override
  String get useDifferentAccount => 'अलग खाता उपयोग करें';

  @override
  String get notSignedInTitle => 'साइन इन नहीं है';

  @override
  String get notSignedInMessage =>
      'कृपया पहले अपने Google खाते से साइन इन करें।';

  @override
  String get inviteNotFoundTitle => 'निमंत्रण नहीं मिला';

  @override
  String get inviteNotFoundMessage =>
      'इस ईमेल पते के लिए कोई निमंत्रण नहीं मिला।\n\nव्यवसाय के मालिक से आपको सिस्टम में जोड़ने के लिए कहें।';

  @override
  String get invalidBusinessInfo => 'व्यवसाय की जानकारी अमान्य है।';

  @override
  String businessRecordFailed(String error) {
    return 'व्यवसाय रिकॉर्ड नहीं बनाया जा सका: $error';
  }

  @override
  String get connectionErrorTitle => 'कनेक्शन त्रुटि';

  @override
  String get inviteCheckFailed =>
      'कर्मचारी निमंत्रण की जांच नहीं की जा सकी। अपना इंटरनेट कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String get tabHome => 'होम';

  @override
  String get tabAppointments => 'अपॉइंटमेंट';

  @override
  String get tabCustomers => 'ग्राहक';

  @override
  String get tabFinance => 'वित्त';

  @override
  String get tabEmployees => 'कर्मचारी';

  @override
  String get tabProfile => 'प्रोफ़ाइल';

  @override
  String greetingHello(String name) {
    return 'नमस्ते $name';
  }

  @override
  String get greetingSubtitle => 'अपने व्यवसाय का प्रबंधन करने के लिए तैयार';

  @override
  String get statToday => 'आज';

  @override
  String get statCompleted => 'पूर्ण';

  @override
  String get statPending => 'लंबित';

  @override
  String get statTotalCustomers => 'कुल ग्राहक';

  @override
  String get quickActions => 'त्वरित कार्रवाई';

  @override
  String get quickNewAppointment => 'नया अपॉइंटमेंट';

  @override
  String get quickAddCustomer => 'ग्राहक जोड़ें';

  @override
  String get quickBulkMessage => 'सामूहिक संदेश';

  @override
  String get whatsappConnection => 'WhatsApp कनेक्शन';

  @override
  String get waConnected => 'जुड़ा हुआ';

  @override
  String get waPairing => 'पेयरिंग हो रही है...';

  @override
  String get waNotConnected => 'अभी तक कनेक्ट नहीं है';

  @override
  String get manage => 'प्रबंधित करें';

  @override
  String get connect => 'कनेक्ट करें';

  @override
  String get todaysAppointments => 'आज के अपॉइंटमेंट';

  @override
  String get noAppointmentsToday => 'आज कोई अपॉइंटमेंट नहीं';

  @override
  String get customerFallback => 'ग्राहक';

  @override
  String get statusConfirmed => 'पुष्टि की गई';

  @override
  String get statusCompleted => 'पूर्ण';

  @override
  String get statusCancelled => 'रद्द';

  @override
  String get statusPending => 'लंबित';

  @override
  String get statusShortConfirmed => 'पुष्ट';

  @override
  String get statusShortCompleted => 'पूर्ण';

  @override
  String get statusShortCancelled => 'रद्द';

  @override
  String get statusShortPending => 'लंबित';

  @override
  String get appointmentsTitle => 'अपॉइंटमेंट';

  @override
  String appointmentCountLabel(int count) {
    return '$count अपॉइंटमेंट';
  }

  @override
  String get allEmployees => 'सभी कर्मचारी';

  @override
  String get noAppointmentsThisDay => 'इस दिन कोई अपॉइंटमेंट नहीं';

  @override
  String get addAppointment => 'अपॉइंटमेंट जोड़ें';

  @override
  String get appointmentDetail => 'अपॉइंटमेंट विवरण';

  @override
  String get customerLabel => 'ग्राहक';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get timeLabel => 'समय';

  @override
  String get serviceLabel => 'सेवा';

  @override
  String get priceLabel => 'कीमत';

  @override
  String get noteLabel => 'नोट';

  @override
  String get completedPaidNote => 'पूर्ण, भुगतान प्राप्त';

  @override
  String get cancelAppointment => 'रद्द करें';

  @override
  String get markCompleted => 'पूर्ण';

  @override
  String get appointmentCancelled => 'अपॉइंटमेंट रद्द किया गया';

  @override
  String get appointmentCancelFailed => 'अपॉइंटमेंट रद्द नहीं किया जा सका';

  @override
  String collectedSummary(String amount, String method) {
    return '$amount ₺ $method में प्राप्त';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ कर्ज के रूप में दर्ज';
  }

  @override
  String get appointmentCompletedMsg => 'अपॉइंटमेंट पूर्ण हुआ';

  @override
  String get paymentSaveFailed => 'भुगतान सहेजा नहीं जा सका';

  @override
  String get paymentCash => 'नकद';

  @override
  String get paymentCard => 'कार्ड';

  @override
  String get paymentTransfer => 'ट्रांसफर';

  @override
  String get paymentCashLower => 'नकद';

  @override
  String get paymentCardLower => 'कार्ड';

  @override
  String get newAppointment => 'नया अपॉइंटमेंट';

  @override
  String get businessInfoNotFound => 'व्यवसाय की जानकारी नहीं मिली';

  @override
  String get appointmentCreateFailed => 'अपॉइंटमेंट नहीं बनाया जा सका';

  @override
  String get appointmentCreated => 'अपॉइंटमेंट सफलतापूर्वक बनाया गया';

  @override
  String get customerPhoneRequired => 'ग्राहक का फ़ोन आवश्यक है';

  @override
  String get customerNameRequired => 'ग्राहक का नाम आवश्यक है';

  @override
  String get customerCreateFailed => 'ग्राहक नहीं बनाया जा सका';

  @override
  String get sectionCustomer => 'ग्राहक';

  @override
  String get selectCustomer => 'ग्राहक चुनें';

  @override
  String get addNewCustomerItem => '+ नया ग्राहक जोड़ें';

  @override
  String get customerNameField => 'ग्राहक का नाम *';

  @override
  String get phoneField => 'फ़ोन *';

  @override
  String get phoneRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get sectionService => 'सेवा';

  @override
  String get noServicesDefined =>
      'अभी तक कोई सेवा परिभाषित नहीं है।\nप्रोफ़ाइल > सेवाएं में सेवाएं और कीमतें परिभाषित करें।';

  @override
  String get selectServiceField => 'सेवा चुनें *';

  @override
  String get serviceRequired => 'सेवा चयन आवश्यक है';

  @override
  String get priceField => 'कीमत *';

  @override
  String get priceRequired => 'कीमत आवश्यक है';

  @override
  String get priceInvalid => 'मान्य कीमत दर्ज करें';

  @override
  String get sectionEmployee => 'कर्मचारी';

  @override
  String get selectEmployeeField => 'कर्मचारी चुनें *';

  @override
  String get employeeRequired => 'कर्मचारी चयन आवश्यक है';

  @override
  String get sectionDateTime => 'तारीख और समय';

  @override
  String get dateField => 'तारीख *';

  @override
  String get timeField => 'समय *';

  @override
  String get sectionNote => 'नोट';

  @override
  String get noteOptional => 'नोट (वैकल्पिक)';

  @override
  String get noteHint => 'अपॉइंटमेंट के बारे में नोट्स...';

  @override
  String get saveAppointment => 'अपॉइंटमेंट सहेजें';

  @override
  String get takePayment => 'भुगतान लें';

  @override
  String appointmentPriceInfo(String amount) {
    return 'अपॉइंटमेंट की कीमत: $amount ₺';
  }

  @override
  String get amountReceived => 'प्राप्त राशि (₺)';

  @override
  String remainingWillBeDebt(String amount) {
    return 'शेष $amount ₺ कर्ज के रूप में दर्ज होगा';
  }

  @override
  String get paymentMethodLabel => 'भुगतान विधि';

  @override
  String get allAsDebt => 'सब कर्ज में';

  @override
  String get complete => 'पूरा करें';

  @override
  String get financeTitle => 'वित्त';

  @override
  String get statisticsTooltip => 'आंकड़े';

  @override
  String get monthlyBalance => 'मासिक शेष';

  @override
  String get income => 'आय';

  @override
  String get expense => 'व्यय';

  @override
  String get net => 'शुद्ध';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String receivablesLabel(int count) {
    return 'प्राप्य ($count)';
  }

  @override
  String get recentTransactions => 'हालिया लेन-देन';

  @override
  String get viewAllShort => 'सभी';

  @override
  String get addIncomeExpense => 'आय/व्यय जोड़ें';

  @override
  String get amountField => 'राशि (₺)';

  @override
  String get categoryField => 'श्रेणी';

  @override
  String get descriptionField => 'विवरण';

  @override
  String get enterValidAmount => 'मान्य राशि दर्ज करें';

  @override
  String get otherIncome => 'अन्य आय';

  @override
  String get otherExpense => 'अन्य व्यय';

  @override
  String get allTransactions => 'सभी लेन-देन';

  @override
  String get incomes => 'आय';

  @override
  String get expenses => 'व्यय';

  @override
  String get noTransactionsFound => 'कोई लेन-देन नहीं मिला';

  @override
  String get debtorCustomers => 'कर्जदार ग्राहक';

  @override
  String get noDebtors => 'कोई कर्जदार ग्राहक नहीं';

  @override
  String get totalReceivable => 'कुल प्राप्य';

  @override
  String customersCountShort(int count) {
    return '$count ग्राहक';
  }

  @override
  String openDebtCount(int count) {
    return '$count खुले कर्ज';
  }

  @override
  String get remindViaWhatsApp => 'WhatsApp से याद दिलाएं';

  @override
  String reminderSentTo(String name) {
    return 'याद दिलाया गया: $name';
  }

  @override
  String get reminderSendFailed =>
      'याद दिलाने का संदेश नहीं भेजा जा सका (WhatsApp कनेक्शन जांचें)';

  @override
  String get collectPayment => 'वसूली करें';

  @override
  String remainingDebtInfo(String amount) {
    return 'शेष कर्ज: $amount ₺';
  }

  @override
  String get collectedAmountField => 'वसूल की गई राशि (₺)';

  @override
  String amountExceedsDebt(String amount) {
    return 'राशि शेष कर्ज से अधिक नहीं हो सकती ($amount ₺)';
  }

  @override
  String remainingTracked(String amount) {
    return 'शेष $amount ₺ कर्ज के रूप में ट्रैक किया जाएगा';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '$amount ₺ वसूल, $left ₺ शेष';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '$amount ₺ वसूल, कर्ज बंद';
  }

  @override
  String get collectionFailed => 'वसूली सहेजी नहीं जा सकी';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ कर्ज';
  }

  @override
  String get statisticsTitle => 'आंकड़े';

  @override
  String get periodWeek => 'सप्ताह';

  @override
  String get periodMonth => 'महीना';

  @override
  String get periodYear => 'वर्ष';

  @override
  String get employeeFilter => 'कर्मचारी';

  @override
  String get noTransactionsInPeriod => 'इस अवधि में कोई लेन-देन नहीं';

  @override
  String get incomeTrend => 'आय का रुझान';

  @override
  String get noIncomeRecords => 'कोई आय रिकॉर्ड नहीं';

  @override
  String get paymentDistribution => 'भुगतान विधियों का वितरण';

  @override
  String get employeeEarnings => 'कर्मचारियों की कमाई';

  @override
  String get unassigned => 'असाइन नहीं';

  @override
  String get topServices => 'सबसे अधिक कमाई वाली सेवाएं';

  @override
  String get topCustomers => 'सर्वोत्तम ग्राहक';

  @override
  String get expenseItems => 'व्यय मदें';

  @override
  String get employeeDebtsTitle => 'कर्मचारी-वार कर्ज';

  @override
  String get generalTitle => 'सामान्य';

  @override
  String get noRecords => 'कोई रिकॉर्ड नहीं';

  @override
  String get transactionCount => 'लेन-देन की संख्या';

  @override
  String get avgTransaction => 'औसत लेन-देन';

  @override
  String get incomeTransactionCount => 'आय लेन-देन की संख्या';

  @override
  String get avgTransactionAmount => 'औसत लेन-देन राशि';

  @override
  String get appointmentsTotal => 'अपॉइंटमेंट (कुल)';

  @override
  String get completedAppointmentsStat => 'पूर्ण अपॉइंटमेंट';

  @override
  String get cancelledAppointmentsStat => 'रद्द अपॉइंटमेंट';

  @override
  String get cashRatio => 'नकद अनुपात';

  @override
  String get openDebtTotal => 'कुल खुले कर्ज';

  @override
  String get employeeDebtHint =>
      'कर्ज उस कर्मचारी के अनुसार समूहित हैं जिसने काम किया। कर्जदार ग्राहकों की सूची देखने के लिए पंक्ति पर टैप करें।';

  @override
  String debtorCountLabel(int count) {
    return '$count कर्जदार ग्राहक';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — कर्जदार ग्राहक ($amount ₺)';
  }

  @override
  String get employeesTitle => 'कर्मचारी';

  @override
  String get addEmployee => 'कर्मचारी जोड़ें';

  @override
  String get noEmployeesYet => 'अभी तक कोई कर्मचारी नहीं जोड़ा गया';

  @override
  String get searchEmployeeHint => 'नाम, ईमेल या फ़ोन खोजें';

  @override
  String get roleAdmin => 'एडमिन';

  @override
  String get roleEmployee => 'कर्मचारी';

  @override
  String get noMatchingEmployees => 'कोई मेल खाने वाला कर्मचारी नहीं';

  @override
  String get makeEmployee => 'कर्मचारी बनाएं';

  @override
  String get makeAdmin => 'एडमिन बनाएं';

  @override
  String get deleteEmployeeTitle => 'कर्मचारी हटाएं';

  @override
  String deleteEmployeeConfirm(String name) {
    return '$name को हटा दिया जाएगा। यह वापस नहीं लाया जा सकता।';
  }

  @override
  String get employeeDeleted => 'कर्मचारी हटाया गया';

  @override
  String get deleteFailed => 'हटाना विफल';

  @override
  String get fullNameRequired => 'पूरा नाम आवश्यक है';

  @override
  String get enterValidEmailInvite =>
      'मान्य ईमेल दर्ज करें — कर्मचारी इस पते के Google खाते से साइन इन करेगा';

  @override
  String get fullNameField => 'पूरा नाम';

  @override
  String get phoneOnlyField => 'फ़ोन';

  @override
  String get emailField => 'ईमेल';

  @override
  String get roleField => 'भूमिका';

  @override
  String employeeAddedInfo(String name, String email) {
    return '$name जोड़ा गया। वह $email पर Google खाते से साइन इन करके \"मैं कर्मचारी हूं\" विकल्प चुन सकता है।';
  }

  @override
  String get employeeAddFailed => 'कर्मचारी नहीं जोड़ा जा सका';

  @override
  String get customersTitle => 'ग्राहक';

  @override
  String get addCustomerTooltip => 'ग्राहक जोड़ें';

  @override
  String get searchCustomerHint => 'नाम, फ़ोन या ईमेल खोजें';

  @override
  String get filterDebtor => 'कर्जदार';

  @override
  String get filterContacts => 'संपर्कों से';

  @override
  String get filterManual => 'मैनुअल';

  @override
  String customersCountLabel(int count) {
    return '$count ग्राहक';
  }

  @override
  String get noCustomersYet => 'अभी तक कोई ग्राहक नहीं जोड़ा गया';

  @override
  String get noMatchingCustomers => 'कोई मेल खाने वाला ग्राहक नहीं';

  @override
  String get addCustomerTitle => 'ग्राहक जोड़ें';

  @override
  String get contactPermissionRequired => 'संपर्कों की अनुमति आवश्यक है';

  @override
  String get noContactsFound => 'कोई संपर्क नहीं मिला';

  @override
  String get noContactsWithPhone => 'फ़ोन नंबर वाले कोई संपर्क नहीं';

  @override
  String addedFromContacts(int count) {
    return '$count लोग संपर्कों से जोड़े गए';
  }

  @override
  String contactReadError(String error) {
    return 'संपर्क पढ़ने में त्रुटि: $error';
  }

  @override
  String get businessInfoMissing =>
      'व्यवसाय की जानकारी गायब है। कृपया पुनः प्रयास करें।';

  @override
  String customerAddedSuccess(String name) {
    return '$name सफलतापूर्वक जोड़ा गया';
  }

  @override
  String get customerAddError => 'ग्राहक जोड़ते समय त्रुटि हुई';

  @override
  String get pickFromContacts => 'संपर्कों से जोड़ें (बहु-चयन)';

  @override
  String get loadingContacts => 'संपर्क लोड हो रहे हैं...';

  @override
  String get orEnterManually => 'या मैन्युअल रूप से दर्ज करें';

  @override
  String get fullNameStarField => 'पूरा नाम *';

  @override
  String get noteField => 'नोट';

  @override
  String get pickContactTitle => 'संपर्कों से चुनें';

  @override
  String selectedCount(int count) {
    return '$count चयनित';
  }

  @override
  String get searchNameOrPhone => 'नाम या फ़ोन खोजें...';

  @override
  String get selectNone => 'सभी अचयनित करें';

  @override
  String selectAllCount(int count) {
    return 'सभी चुनें ($count)';
  }

  @override
  String get noMatchingContacts => 'आपकी खोज से मेल खाने वाला कोई संपर्क नहीं';

  @override
  String get emptyList => 'सूची खाली है';

  @override
  String addNPeople(int count) {
    return '$count लोग जोड़ें';
  }

  @override
  String get defineBusiness => 'अपना व्यवसाय सेट करें';

  @override
  String get businessInfoTitle => 'व्यवसाय की जानकारी';

  @override
  String get businessSetupSubtitle =>
      'Esnaf Takvim का उपयोग करने के लिए अपना व्यवसाय सेट करें';

  @override
  String get businessNameField => 'व्यवसाय का नाम';

  @override
  String get businessNameRequired => 'व्यवसाय का नाम आवश्यक है';

  @override
  String get addressField => 'पता';

  @override
  String get emailInvalid => 'मान्य ईमेल दर्ज करें';

  @override
  String get workingHoursTitle => 'काम के घंटे';

  @override
  String get workingDaysTitle => 'कार्य दिवस';

  @override
  String get opening => 'खुलने का समय';

  @override
  String get closing => 'बंद होने का समय';

  @override
  String get saveAndStart => 'सहेजें और शुरू करें';

  @override
  String get dayMon => 'सोमवार';

  @override
  String get dayTue => 'मंगलवार';

  @override
  String get dayWed => 'बुधवार';

  @override
  String get dayThu => 'गुरुवार';

  @override
  String get dayFri => 'शुक्रवार';

  @override
  String get daySat => 'शनिवार';

  @override
  String get daySun => 'रविवार';

  @override
  String get businessInfoUpdated => 'व्यवसाय की जानकारी अपडेट की गई';

  @override
  String get updateFailed => 'अपडेट विफल';

  @override
  String get onlyOwnerCanEdit =>
      'केवल व्यवसाय का मालिक ही यह जानकारी बदल सकता है।';

  @override
  String get workingHoursUpdated => 'काम के घंटे अपडेट किए गए';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get userFallback => 'उपयोगकर्ता';

  @override
  String get whatsappSettings => 'WhatsApp सेटिंग्स';

  @override
  String get servicesAndPrices => 'सेवाएं और कीमतें';

  @override
  String get incomeExpenseCategories => 'आय/व्यय श्रेणियां';

  @override
  String get messageTemplatesTitle => 'संदेश टेम्पलेट';

  @override
  String get workingHoursMenu => 'काम के घंटे';

  @override
  String get backupMenu => 'बैकअप';

  @override
  String get restoreMenu => 'बैकअप से पुनर्स्थापित करें';

  @override
  String googleSignInFailed(String error) {
    return 'Google साइन इन विफल: $error';
  }

  @override
  String get backedUp => 'बैकअप हो गया ✅';

  @override
  String backupFailedMsg(String error) {
    return 'बैकअप त्रुटि: $error';
  }

  @override
  String restoreFailedMsg(String error) {
    return 'पुनर्स्थापन त्रुटि: $error';
  }

  @override
  String get backupDownloadedTitle => 'बैकअप डाउनलोड हुआ';

  @override
  String get backupDownloadedMessage =>
      'पुनर्स्थापना पूरी करने के लिए ऐप अब बंद होगा। दोबारा खोलने पर आपका डेटा बैकअप से पुनर्स्थापित हो जाएगा।';

  @override
  String get autoBackupTitle => 'स्वचालित रात्रि बैकअप';

  @override
  String get autoBackupSubtitle =>
      'हर रात 02:00-03:00 के बीच Drive पर बैकअप करता है';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get termsOfUse => 'उपयोग की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get categoriesTitle => 'आय/व्यय श्रेणियां';

  @override
  String get incomeCategories => 'आय श्रेणियां';

  @override
  String get expenseCategories => 'व्यय श्रेणियां';

  @override
  String get addIncomeCategory => 'आय श्रेणी जोड़ें';

  @override
  String get addExpenseCategory => 'व्यय श्रेणी जोड़ें';

  @override
  String get categoryNameField => 'श्रेणी का नाम';

  @override
  String get categoryExists => 'यह श्रेणी पहले से मौजूद है';

  @override
  String get categoryAddFailed => 'श्रेणी नहीं जोड़ी जा सकी';

  @override
  String get deleteCategoryTitle => 'श्रेणी हटाएं';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\" हटा दी जाएगी। पिछले लेन-देन प्रभावित नहीं होंगे।';
  }

  @override
  String get noCategories => 'कोई श्रेणी नहीं';

  @override
  String get availableVariables => 'उपलब्ध चर';

  @override
  String get templateHelp =>
      'संदेश भेजते समय ये चर अपॉइंटमेंट विवरण से बदल दिए जाते हैं। यदि आप किसी टेम्पलेट को पूरी तरह खाली कर देते हैं, तो वह संदेश कभी नहीं भेजा जाएगा।';

  @override
  String get emptyToDisable => 'यह संदेश न भेजने के लिए खाली छोड़ें';

  @override
  String get resetToDefault => 'डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get templatesSaved => 'टेम्पलेट सहेजे गए';

  @override
  String get templatesSaveFailed => 'टेम्पलेट सहेजे नहीं जा सके';

  @override
  String get templatesLoadFailed => 'टेम्पलेट लोड नहीं किए जा सके';

  @override
  String get templatesServerNote =>
      'टेम्पलेट WhatsApp सर्वर पर संग्रहीत हैं; कनेक्शन आवश्यक है।';

  @override
  String get debtReminderFrequency => 'कर्ज याद दिलाने की आवृत्ति';

  @override
  String get debtReminderFrequencyHelp =>
      '\"कर्ज याद दिलाने\" का टेम्पलेट चयनित आवृत्ति पर कर्जदार ग्राहकों को स्वचालित रूप से भेजा जाता है (10:00-20:00 के बीच)।';

  @override
  String get freqOff => 'बंद';

  @override
  String get freqDaily => 'दिन में एक बार';

  @override
  String get freqWeekly => 'सप्ताह में एक बार';

  @override
  String get freqMonthly => 'महीने में एक बार';

  @override
  String get languageLabel => 'भाषा';

  @override
  String get languageSystemDefault => 'सिस्टम डिफ़ॉल्ट';

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
