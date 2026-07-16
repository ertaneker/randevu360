// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Randevu 360';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get add => 'إضافة';

  @override
  String get ok => 'موافق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get all => 'الكل';

  @override
  String get errorTitle => 'خطأ';

  @override
  String get pressBackAgainToExit => 'اضغط مرة أخرى للخروج';

  @override
  String get appTagline => 'إدارة المواعيد\nللشركات الصغيرة';

  @override
  String get signInWithGoogle => 'تسجيل الدخول عبر Google';

  @override
  String get termsNotice => 'بتسجيل الدخول، أنت توافق على شروط الاستخدام';

  @override
  String welcomeUser(String name) {
    return 'مرحباً،\n$name';
  }

  @override
  String get howToContinue => 'كيف تريد المتابعة؟';

  @override
  String get roleOwnerTitle => 'أنا صاحب العمل';

  @override
  String get roleOwnerSubtitle => 'إنشاء نشاط تجاري جديد أو إدارة نشاطي الحالي';

  @override
  String get roleEmployeeTitle => 'أنا موظف';

  @override
  String get roleEmployeeSubtitle => 'الوصول إلى حسابي عبر دعوة صاحب العمل';

  @override
  String get useDifferentAccount => 'استخدام حساب آخر';

  @override
  String get notSignedInTitle => 'لم يتم تسجيل الدخول';

  @override
  String get notSignedInMessage => 'يرجى تسجيل الدخول بحساب Google أولاً.';

  @override
  String get inviteNotFoundTitle => 'الدعوة غير موجودة';

  @override
  String get inviteNotFoundMessage =>
      'لم يتم العثور على دعوة لعنوان البريد الإلكتروني هذا.\n\nاطلب من صاحب العمل إضافتك إلى النظام.';

  @override
  String get invalidBusinessInfo => 'معلومات النشاط التجاري غير صالحة.';

  @override
  String businessRecordFailed(String error) {
    return 'تعذر إنشاء سجل النشاط التجاري: $error';
  }

  @override
  String get connectionErrorTitle => 'خطأ في الاتصال';

  @override
  String get inviteCheckFailed =>
      'تعذر التحقق من دعوة الموظف. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.';

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabAppointments => 'المواعيد';

  @override
  String get tabCustomers => 'العملاء';

  @override
  String get tabFinance => 'المالية';

  @override
  String get tabEmployees => 'الموظفون';

  @override
  String get tabProfile => 'الملف الشخصي';

  @override
  String greetingHello(String name) {
    return 'مرحباً $name';
  }

  @override
  String get greetingSubtitle => 'جاهز لإدارة نشاطك التجاري';

  @override
  String get statToday => 'اليوم';

  @override
  String get statCompleted => 'مكتمل';

  @override
  String get statPending => 'قيد الانتظار';

  @override
  String get statTotalCustomers => 'إجمالي العملاء';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get quickNewAppointment => 'موعد جديد';

  @override
  String get quickAddCustomer => 'إضافة عميل';

  @override
  String get quickBulkMessage => 'رسالة جماعية';

  @override
  String get whatsappConnection => 'اتصال WhatsApp';

  @override
  String get waConnected => 'متصل';

  @override
  String get waPairing => 'جاري الاقتران...';

  @override
  String get waNotConnected => 'غير متصل بعد';

  @override
  String get manage => 'إدارة';

  @override
  String get connect => 'اتصال';

  @override
  String get todaysAppointments => 'مواعيد اليوم';

  @override
  String get noAppointmentsToday => 'لا توجد مواعيد اليوم';

  @override
  String get customerFallback => 'عميل';

  @override
  String get statusConfirmed => 'مؤكد';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusShortConfirmed => 'مؤكد';

  @override
  String get statusShortCompleted => 'تم';

  @override
  String get statusShortCancelled => 'ملغي';

  @override
  String get statusShortPending => 'انتظار';

  @override
  String get appointmentsTitle => 'المواعيد';

  @override
  String appointmentCountLabel(int count) {
    return '$count مواعيد';
  }

  @override
  String get allEmployees => 'جميع الموظفين';

  @override
  String get noAppointmentsThisDay => 'لا توجد مواعيد في هذا اليوم';

  @override
  String get addAppointment => 'إضافة موعد';

  @override
  String get appointmentDetail => 'تفاصيل الموعد';

  @override
  String get customerLabel => 'العميل';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get timeLabel => 'الوقت';

  @override
  String get serviceLabel => 'الخدمة';

  @override
  String get priceLabel => 'السعر';

  @override
  String get noteLabel => 'ملاحظة';

  @override
  String get completedPaidNote => 'مكتمل، تم استلام الدفع';

  @override
  String get cancelAppointment => 'إلغاء';

  @override
  String get markCompleted => 'مكتمل';

  @override
  String get appointmentCancelled => 'تم إلغاء الموعد';

  @override
  String get appointmentCancelFailed => 'تعذر إلغاء الموعد';

  @override
  String collectedSummary(String amount, String method) {
    return '$amount ₺ تم تحصيله $method';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ مسجل كدين';
  }

  @override
  String get appointmentCompletedMsg => 'تم إكمال الموعد';

  @override
  String get paymentSaveFailed => 'تعذر حفظ الدفع';

  @override
  String get paymentCash => 'نقداً';

  @override
  String get paymentCard => 'بطاقة';

  @override
  String get paymentTransfer => 'تحويل';

  @override
  String get paymentCashLower => 'نقداً';

  @override
  String get paymentCardLower => 'بطاقة';

  @override
  String get newAppointment => 'موعد جديد';

  @override
  String get businessInfoNotFound => 'معلومات النشاط التجاري غير موجودة';

  @override
  String get appointmentCreateFailed => 'تعذر إنشاء الموعد';

  @override
  String get appointmentCreated => 'تم إنشاء الموعد بنجاح';

  @override
  String get customerPhoneRequired => 'رقم هاتف العميل مطلوب';

  @override
  String get customerNameRequired => 'اسم العميل مطلوب';

  @override
  String get customerCreateFailed => 'تعذر إنشاء العميل';

  @override
  String get sectionCustomer => 'العميل';

  @override
  String get selectCustomer => 'اختيار عميل';

  @override
  String get addNewCustomerItem => '+ إضافة عميل جديد';

  @override
  String get customerNameField => 'اسم العميل *';

  @override
  String get phoneField => 'الهاتف *';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get sectionService => 'الخدمة';

  @override
  String get noServicesDefined =>
      'لم يتم تعريف أي خدمات بعد.\nقم بتعريف الخدمات والأسعار في الملف الشخصي > الخدمات.';

  @override
  String get selectServiceField => 'اختيار خدمة *';

  @override
  String get serviceRequired => 'اختيار الخدمة مطلوب';

  @override
  String get priceField => 'السعر *';

  @override
  String get priceRequired => 'السعر مطلوب';

  @override
  String get priceInvalid => 'أدخل سعراً صالحاً';

  @override
  String get sectionEmployee => 'الموظف';

  @override
  String get selectEmployeeField => 'اختيار موظف *';

  @override
  String get employeeRequired => 'اختيار الموظف مطلوب';

  @override
  String get sectionDateTime => 'التاريخ والوقت';

  @override
  String get dateField => 'التاريخ *';

  @override
  String get timeField => 'الوقت *';

  @override
  String get sectionNote => 'ملاحظة';

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get noteHint => 'ملاحظات حول الموعد...';

  @override
  String get saveAppointment => 'حفظ الموعد';

  @override
  String get takePayment => 'استلام الدفع';

  @override
  String appointmentPriceInfo(String amount) {
    return 'سعر الموعد: $amount ₺';
  }

  @override
  String get amountReceived => 'المبلغ المستلم (₺)';

  @override
  String remainingWillBeDebt(String amount) {
    return 'المتبقي $amount ₺ سيسجل كدين';
  }

  @override
  String get paymentMethodLabel => 'طريقة الدفع';

  @override
  String get allAsDebt => 'الكل كدين';

  @override
  String get complete => 'إكمال';

  @override
  String get financeTitle => 'المالية';

  @override
  String get statisticsTooltip => 'إحصائيات';

  @override
  String get monthlyBalance => 'الرصيد الشهري';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get net => 'الصافي';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String receivablesLabel(int count) {
    return 'المستحقات ($count)';
  }

  @override
  String get recentTransactions => 'المعاملات الأخيرة';

  @override
  String get viewAllShort => 'الكل';

  @override
  String get addIncomeExpense => 'إضافة دخل/مصروف';

  @override
  String get amountField => 'المبلغ (₺)';

  @override
  String get categoryField => 'الفئة';

  @override
  String get descriptionField => 'الوصف';

  @override
  String get enterValidAmount => 'أدخل مبلغاً صالحاً';

  @override
  String get otherIncome => 'دخل آخر';

  @override
  String get otherExpense => 'مصروف آخر';

  @override
  String get allTransactions => 'جميع المعاملات';

  @override
  String get incomes => 'الدخل';

  @override
  String get expenses => 'المصروفات';

  @override
  String get noTransactionsFound => 'لم يتم العثور على معاملات';

  @override
  String get debtorCustomers => 'العملاء المدينون';

  @override
  String get noDebtors => 'لا يوجد عملاء مدينون';

  @override
  String get totalReceivable => 'إجمالي المستحقات';

  @override
  String customersCountShort(int count) {
    return '$count عملاء';
  }

  @override
  String openDebtCount(int count) {
    return '$count ديون مفتوحة';
  }

  @override
  String get remindViaWhatsApp => 'تذكير عبر WhatsApp';

  @override
  String reminderSentTo(String name) {
    return 'تم إرسال التذكير: $name';
  }

  @override
  String get reminderSendFailed =>
      'تعذر إرسال التذكير (تحقق من اتصال WhatsApp)';

  @override
  String get collectPayment => 'تحصيل';

  @override
  String remainingDebtInfo(String amount) {
    return 'الدين المتبقي: $amount ₺';
  }

  @override
  String get collectedAmountField => 'المبلغ المحصل (₺)';

  @override
  String amountExceedsDebt(String amount) {
    return 'لا يمكن أن يتجاوز المبلغ الدين المتبقي ($amount ₺)';
  }

  @override
  String remainingTracked(String amount) {
    return 'المتبقي $amount ₺ يتتبع كدين';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '$amount ₺ محصل، $left ₺ متبقي';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '$amount ₺ محصل، تم إغلاق الدين';
  }

  @override
  String get collectionFailed => 'تعذر حفظ التحصيل';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ دين';
  }

  @override
  String get statisticsTitle => 'إحصائيات';

  @override
  String get periodWeek => 'أسبوع';

  @override
  String get periodMonth => 'شهر';

  @override
  String get periodYear => 'سنة';

  @override
  String get employeeFilter => 'موظف';

  @override
  String get noTransactionsInPeriod => 'لا توجد معاملات في هذه الفترة';

  @override
  String get incomeTrend => 'اتجاه الدخل';

  @override
  String get noIncomeRecords => 'لا توجد سجلات دخل';

  @override
  String get paymentDistribution => 'توزيع طرق الدفع';

  @override
  String get employeeEarnings => 'أرباح الموظفين';

  @override
  String get unassigned => 'غير معين';

  @override
  String get topServices => 'الخدمات الأعلى ربحاً';

  @override
  String get topCustomers => 'أفضل العملاء';

  @override
  String get expenseItems => 'بنود المصروفات';

  @override
  String get employeeDebtsTitle => 'الديون حسب الموظف';

  @override
  String get generalTitle => 'عام';

  @override
  String get noRecords => 'لا توجد سجلات';

  @override
  String get transactionCount => 'عدد المعاملات';

  @override
  String get avgTransaction => 'متوسط المعاملة';

  @override
  String get incomeTransactionCount => 'عدد معاملات الدخل';

  @override
  String get avgTransactionAmount => 'متوسط مبلغ المعاملة';

  @override
  String get appointmentsTotal => 'المواعيد (الإجمالي)';

  @override
  String get completedAppointmentsStat => 'المواعيد المكتملة';

  @override
  String get cancelledAppointmentsStat => 'المواعيد الملغاة';

  @override
  String get cashRatio => 'نسبة النقد';

  @override
  String get openDebtTotal => 'إجمالي الديون المفتوحة';

  @override
  String get employeeDebtHint =>
      'يتم تجميع الديون حسب الموظف الذي قام بالعمل. اضغط على صف لعرض العملاء المدينين.';

  @override
  String debtorCountLabel(int count) {
    return '$count عملاء مدينين';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — عملاء مدينين ($amount ₺)';
  }

  @override
  String get employeesTitle => 'الموظفون';

  @override
  String get addEmployee => 'إضافة موظف';

  @override
  String get noEmployeesYet => 'لم تتم إضافة موظفين بعد';

  @override
  String get searchEmployeeHint =>
      'البحث بالاسم أو البريد الإلكتروني أو الهاتف';

  @override
  String get roleAdmin => 'مدير';

  @override
  String get roleEmployee => 'موظف';

  @override
  String get noMatchingEmployees => 'لا يوجد موظفون مطابقون';

  @override
  String get makeEmployee => 'جعله موظفاً';

  @override
  String get makeAdmin => 'جعله مديراً';

  @override
  String get deleteEmployeeTitle => 'حذف موظف';

  @override
  String deleteEmployeeConfirm(String name) {
    return 'سيتم حذف $name. لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get employeeDeleted => 'تم حذف الموظف';

  @override
  String get deleteFailed => 'فشل الحذف';

  @override
  String get fullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get enterValidEmailInvite =>
      'أدخل بريداً إلكترونياً صالحاً — سيسجل الموظف الدخول بحساب Google على هذا العنوان';

  @override
  String get fullNameField => 'الاسم الكامل';

  @override
  String get phoneOnlyField => 'الهاتف';

  @override
  String get emailField => 'البريد الإلكتروني';

  @override
  String get roleField => 'الدور';

  @override
  String employeeAddedInfo(String name, String email) {
    return 'تمت إضافة $name. يمكنه تسجيل الدخول بحساب Google على $email واختيار خيار \"أنا موظف\".';
  }

  @override
  String get employeeAddFailed => 'تعذرت إضافة الموظف';

  @override
  String get customersTitle => 'العملاء';

  @override
  String get addCustomerTooltip => 'إضافة عميل';

  @override
  String get searchCustomerHint =>
      'البحث بالاسم أو الهاتف أو البريد الإلكتروني';

  @override
  String get filterDebtor => 'مدينون';

  @override
  String get filterContacts => 'من جهات الاتصال';

  @override
  String get filterManual => 'يدوي';

  @override
  String customersCountLabel(int count) {
    return '$count عملاء';
  }

  @override
  String get noCustomersYet => 'لم تتم إضافة عملاء بعد';

  @override
  String get noMatchingCustomers => 'لا يوجد عملاء مطابقون';

  @override
  String get addCustomerTitle => 'إضافة عميل';

  @override
  String get contactPermissionRequired => 'إذن الوصول إلى جهات الاتصال مطلوب';

  @override
  String get noContactsFound => 'لم يتم العثور على جهات اتصال';

  @override
  String get noContactsWithPhone => 'لا توجد جهات اتصال برقم هاتف';

  @override
  String addedFromContacts(int count) {
    return 'تمت إضافة $count أشخاص من جهات الاتصال';
  }

  @override
  String contactReadError(String error) {
    return 'خطأ في قراءة جهات الاتصال: $error';
  }

  @override
  String get businessInfoMissing =>
      'معلومات النشاط التجاري مفقودة. يرجى المحاولة مرة أخرى.';

  @override
  String customerAddedSuccess(String name) {
    return 'تمت إضافة $name بنجاح';
  }

  @override
  String get customerAddError => 'حدث خطأ أثناء إضافة العميل';

  @override
  String get pickFromContacts => 'إضافة من جهات الاتصال (اختيار متعدد)';

  @override
  String get loadingContacts => 'جاري تحميل جهات الاتصال...';

  @override
  String get orEnterManually => 'أو أدخل يدوياً';

  @override
  String get fullNameStarField => 'الاسم الكامل *';

  @override
  String get noteField => 'ملاحظة';

  @override
  String get pickContactTitle => 'اختيار من جهات الاتصال';

  @override
  String selectedCount(int count) {
    return 'تم اختيار $count';
  }

  @override
  String get searchNameOrPhone => 'البحث بالاسم أو الهاتف...';

  @override
  String get selectNone => 'إلغاء تحديد الكل';

  @override
  String selectAllCount(int count) {
    return 'تحديد الكل ($count)';
  }

  @override
  String get noMatchingContacts => 'لا توجد جهات اتصال تطابق بحثك';

  @override
  String get emptyList => 'القائمة فارغة';

  @override
  String addNPeople(int count) {
    return 'إضافة $count أشخاص';
  }

  @override
  String get defineBusiness => 'إعداد نشاطك التجاري';

  @override
  String get businessInfoTitle => 'معلومات النشاط التجاري';

  @override
  String get businessSetupSubtitle =>
      'قم بإعداد نشاطك التجاري لاستخدام Randevu 360';

  @override
  String get businessNameField => 'اسم النشاط التجاري';

  @override
  String get businessNameRequired => 'اسم النشاط التجاري مطلوب';

  @override
  String get addressField => 'العنوان';

  @override
  String get emailInvalid => 'أدخل بريداً إلكترونياً صالحاً';

  @override
  String get workingHoursTitle => 'ساعات العمل';

  @override
  String get workingDaysTitle => 'أيام العمل';

  @override
  String get opening => 'الافتتاح';

  @override
  String get closing => 'الإغلاق';

  @override
  String get saveAndStart => 'حفظ وبدء';

  @override
  String get dayMon => 'الاثنين';

  @override
  String get dayTue => 'الثلاثاء';

  @override
  String get dayWed => 'الأربعاء';

  @override
  String get dayThu => 'الخميس';

  @override
  String get dayFri => 'الجمعة';

  @override
  String get daySat => 'السبت';

  @override
  String get daySun => 'الأحد';

  @override
  String get businessInfoUpdated => 'تم تحديث معلومات النشاط التجاري';

  @override
  String get updateFailed => 'فشل التحديث';

  @override
  String get onlyOwnerCanEdit => 'يمكن لصاحب العمل فقط تغيير هذه المعلومات.';

  @override
  String get workingHoursUpdated => 'تم تحديث ساعات العمل';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get userFallback => 'مستخدم';

  @override
  String get whatsappSettings => 'إعدادات WhatsApp';

  @override
  String get servicesAndPrices => 'الخدمات والأسعار';

  @override
  String get incomeExpenseCategories => 'فئات الدخل/المصروفات';

  @override
  String get messageTemplatesTitle => 'قوالب الرسائل';

  @override
  String get workingHoursMenu => 'ساعات العمل';

  @override
  String get backupMenu => 'نسخ احتياطي';

  @override
  String get restoreMenu => 'استعادة من النسخة الاحتياطية';

  @override
  String googleSignInFailed(String error) {
    return 'فشل تسجيل الدخول عبر Google: $error';
  }

  @override
  String get backedUp => 'تم النسخ الاحتياطي ✅';

  @override
  String backupFailedMsg(String error) {
    return 'خطأ في النسخ الاحتياطي: $error';
  }

  @override
  String restoreFailedMsg(String error) {
    return 'خطأ في الاستعادة: $error';
  }

  @override
  String get backupDownloadedTitle => 'تم تنزيل النسخة الاحتياطية';

  @override
  String get backupDownloadedMessage =>
      'سيتم إغلاق التطبيق الآن لإكمال الاستعادة. عند إعادة فتحه، ستتم استعادة بياناتك من النسخة الاحتياطية.';

  @override
  String get autoBackupTitle => 'نسخ احتياطي تلقائي ليلي';

  @override
  String get autoBackupSubtitle =>
      'ينسخ احتياطياً إلى Drive كل ليلة بين 02:00-03:00';

  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get categoriesTitle => 'فئات الدخل/المصروفات';

  @override
  String get incomeCategories => 'فئات الدخل';

  @override
  String get expenseCategories => 'فئات المصروفات';

  @override
  String get addIncomeCategory => 'إضافة فئة دخل';

  @override
  String get addExpenseCategory => 'إضافة فئة مصروفات';

  @override
  String get categoryNameField => 'اسم الفئة';

  @override
  String get categoryExists => 'هذه الفئة موجودة بالفعل';

  @override
  String get categoryAddFailed => 'تعذرت إضافة الفئة';

  @override
  String get deleteCategoryTitle => 'حذف الفئة';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\" سيتم حذفها. المعاملات السابقة لا تتأثر.';
  }

  @override
  String get noCategories => 'لا توجد فئات';

  @override
  String get availableVariables => 'المتغيرات المتاحة';

  @override
  String get templateHelp =>
      'يتم استبدال هذه المتغيرات بتفاصيل الموعد عند الإرسال. إذا قمت بمسح القالب بالكامل، فلن يتم إرسال تلك الرسالة أبداً.';

  @override
  String get emptyToDisable => 'اتركه فارغاً لعدم إرسال هذه الرسالة';

  @override
  String get resetToDefault => 'إعادة للافتراضي';

  @override
  String get templatesSaved => 'تم حفظ القوالب';

  @override
  String get templatesSaveFailed => 'تعذر حفظ القوالب';

  @override
  String get templatesLoadFailed => 'تعذر تحميل القوالب';

  @override
  String get templatesServerNote =>
      'يتم تخزين القوالب على خادم WhatsApp؛ الاتصال مطلوب.';

  @override
  String get debtReminderFrequency => 'تكرار تذكير الديون';

  @override
  String get debtReminderFrequencyHelp =>
      'يتم إرسال قالب \"تذكير الدين\" تلقائياً للعملاء المدينين بالتكرار المحدد (بين 10:00-20:00).';

  @override
  String get freqOff => 'إيقاف';

  @override
  String get freqDaily => 'مرة يومياً';

  @override
  String get freqWeekly => 'مرة أسبوعياً';

  @override
  String get freqMonthly => 'مرة شهرياً';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get languageSystemDefault => 'افتراضي النظام';
}
