// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Randevu 360';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get add => 'Ekle';

  @override
  String get ok => 'Tamam';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get all => 'Tümü';

  @override
  String get errorTitle => 'Hata';

  @override
  String get pressBackAgainToExit =>
      'Çıkmak için bir kez daha geri tuşuna basın';

  @override
  String get appTagline => 'Küçük işletmeler için\nrandevu yönetimi';

  @override
  String get signInWithGoogle => 'Google ile Giriş Yap';

  @override
  String get termsNotice =>
      'Giriş yaparak Kullanım Koşulları\'nı kabul etmiş olursunuz';

  @override
  String welcomeUser(String name) {
    return 'Hoş geldin,\n$name';
  }

  @override
  String get howToContinue => 'Nasıl devam etmek istersin?';

  @override
  String get roleOwnerTitle => 'İşletme Sahibiyim';

  @override
  String get roleOwnerSubtitle =>
      'Yeni işletme oluştur veya mevcut işletmemi yönet';

  @override
  String get roleEmployeeTitle => 'Çalışanım';

  @override
  String get roleEmployeeSubtitle =>
      'İşletme sahibinin davetiyle hesabıma eriş';

  @override
  String get useDifferentAccount => 'Farklı hesap kullan';

  @override
  String get notSignedInTitle => 'Giriş yapılmamış';

  @override
  String get notSignedInMessage =>
      'Lütfen önce Google hesabınızla giriş yapın.';

  @override
  String get inviteNotFoundTitle => 'Davet Bulunamadı';

  @override
  String get inviteNotFoundMessage =>
      'Bu e-posta adresiyle size yapılmış bir davet bulunamadı.\n\nİşletme sahibinden sizi sisteme eklemesini isteyin.';

  @override
  String get invalidBusinessInfo => 'İşletme bilgisi geçersiz.';

  @override
  String businessRecordFailed(String error) {
    return 'İşletme kaydı oluşturulamadı: $error';
  }

  @override
  String get connectionErrorTitle => 'Bağlantı Hatası';

  @override
  String get inviteCheckFailed =>
      'Çalışan daveti kontrol edilemedi. İnternet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get tabHome => 'Ana Sayfa';

  @override
  String get tabAppointments => 'Randevular';

  @override
  String get tabCustomers => 'Müşteriler';

  @override
  String get tabFinance => 'Finans';

  @override
  String get tabEmployees => 'Çalışanlar';

  @override
  String get tabProfile => 'Profil';

  @override
  String greetingHello(String name) {
    return 'Merhaba $name';
  }

  @override
  String get greetingSubtitle => 'İşletmeni yönetmeye hazırsın';

  @override
  String get statToday => 'Bugün';

  @override
  String get statCompleted => 'Tamamlanan';

  @override
  String get statPending => 'Bekleyen';

  @override
  String get statTotalCustomers => 'Toplam Müşteri';

  @override
  String get quickActions => 'Hızlı İşlemler';

  @override
  String get quickNewAppointment => 'Yeni Randevu';

  @override
  String get quickAddCustomer => 'Müşteri Ekle';

  @override
  String get quickBulkMessage => 'Toplu Mesaj';

  @override
  String get whatsappConnection => 'WhatsApp Bağlantısı';

  @override
  String get waConnected => 'Bağlandı';

  @override
  String get waPairing => 'Eşleştiriliyor...';

  @override
  String get waNotConnected => 'Henüz bağlanmadı';

  @override
  String get manage => 'Yönet';

  @override
  String get connect => 'Bağlan';

  @override
  String get todaysAppointments => 'Bugünkü Randevular';

  @override
  String get noAppointmentsToday => 'Bugün randevu yok';

  @override
  String get customerFallback => 'Müşteri';

  @override
  String get statusConfirmed => 'Onaylandı';

  @override
  String get statusCompleted => 'Tamamlandı';

  @override
  String get statusCancelled => 'İptal';

  @override
  String get statusPending => 'Bekliyor';

  @override
  String get statusShortConfirmed => 'Onaylı';

  @override
  String get statusShortCompleted => 'Bitti';

  @override
  String get statusShortCancelled => 'İptal';

  @override
  String get statusShortPending => 'Bekliyor';

  @override
  String get appointmentsTitle => 'Randevular';

  @override
  String appointmentCountLabel(int count) {
    return '$count randevu';
  }

  @override
  String get allEmployees => 'Tüm Çalışanlar';

  @override
  String get noAppointmentsThisDay => 'Bu günde randevu yok';

  @override
  String get addAppointment => 'Randevu Ekle';

  @override
  String get appointmentDetail => 'Randevu Detayı';

  @override
  String get customerLabel => 'Müşteri';

  @override
  String get dateLabel => 'Tarih';

  @override
  String get timeLabel => 'Saat';

  @override
  String get serviceLabel => 'Hizmet';

  @override
  String get priceLabel => 'Ücret';

  @override
  String get noteLabel => 'Not';

  @override
  String get completedPaidNote => 'Tamamlandı, ödemesi alındı';

  @override
  String get cancelAppointment => 'İptal Et';

  @override
  String get markCompleted => 'Tamamlandı';

  @override
  String get appointmentCancelled => 'Randevu iptal edildi';

  @override
  String get appointmentCancelFailed => 'Randevu iptal edilemedi';

  @override
  String collectedSummary(String amount, String method) {
    return '$amount ₺ $method tahsil edildi';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ borç yazıldı';
  }

  @override
  String get appointmentCompletedMsg => 'Randevu tamamlandı';

  @override
  String get paymentSaveFailed => 'Tahsilat kaydedilemedi';

  @override
  String get paymentCash => 'Nakit';

  @override
  String get paymentCard => 'Kart';

  @override
  String get paymentTransfer => 'Havale';

  @override
  String get paymentCashLower => 'nakit';

  @override
  String get paymentCardLower => 'kart';

  @override
  String get newAppointment => 'Yeni Randevu';

  @override
  String get businessInfoNotFound => 'İşletme bilgisi bulunamadı';

  @override
  String get appointmentCreateFailed => 'Randevu oluşturulamadı';

  @override
  String get appointmentCreated => 'Randevu başarıyla oluşturuldu';

  @override
  String get customerPhoneRequired => 'Müşteri telefonu gereklidir';

  @override
  String get customerNameRequired => 'Müşteri adı gerekli';

  @override
  String get customerCreateFailed => 'Müşteri oluşturulamadı';

  @override
  String get sectionCustomer => 'Müşteri';

  @override
  String get selectCustomer => 'Müşteri Seçin';

  @override
  String get addNewCustomerItem => '+ Yeni Müşteri Ekle';

  @override
  String get customerNameField => 'Müşteri Adı *';

  @override
  String get phoneField => 'Telefon *';

  @override
  String get phoneRequired => 'Telefon numarası gerekli';

  @override
  String get sectionService => 'Hizmet';

  @override
  String get noServicesDefined =>
      'Henüz hizmet tanımlanmamış.\nProfil > Hizmetler ekranından hizmet ve fiyat tanımlayın.';

  @override
  String get selectServiceField => 'Hizmet Seçin *';

  @override
  String get serviceRequired => 'Hizmet seçimi gerekli';

  @override
  String get priceField => 'Ücret (₺) *';

  @override
  String get priceRequired => 'Ücret gerekli';

  @override
  String get priceInvalid => 'Geçerli bir ücret girin';

  @override
  String get sectionEmployee => 'Çalışan';

  @override
  String get selectEmployeeField => 'Çalışan Seçin *';

  @override
  String get employeeRequired => 'Çalışan seçimi gerekli';

  @override
  String get sectionDateTime => 'Tarih ve Saat';

  @override
  String get dateField => 'Tarih *';

  @override
  String get timeField => 'Saat *';

  @override
  String get sectionNote => 'Not';

  @override
  String get noteOptional => 'Not (isteğe bağlı)';

  @override
  String get noteHint => 'Randevu ile ilgili notlar...';

  @override
  String get saveAppointment => 'Randevuyu Kaydet';

  @override
  String get takePayment => 'Ödeme Al';

  @override
  String appointmentPriceInfo(String amount) {
    return 'Randevu fiyatı: $amount ₺';
  }

  @override
  String get amountReceived => 'Alınan tutar (₺)';

  @override
  String remainingWillBeDebt(String amount) {
    return 'Kalan $amount ₺ borç yazılacak';
  }

  @override
  String get paymentMethodLabel => 'Ödeme Yöntemi';

  @override
  String get allAsDebt => 'Tümü Borç';

  @override
  String get complete => 'Tamamla';

  @override
  String get financeTitle => 'Finans';

  @override
  String get statisticsTooltip => 'İstatistikler';

  @override
  String get monthlyBalance => 'Aylık Bilanço';

  @override
  String get income => 'Gelir';

  @override
  String get expense => 'Gider';

  @override
  String get net => 'Net';

  @override
  String get thisWeek => 'Bu Hafta';

  @override
  String receivablesLabel(int count) {
    return 'Alacaklar ($count)';
  }

  @override
  String get recentTransactions => 'Son İşlemler';

  @override
  String get viewAllShort => 'Tümü';

  @override
  String get addIncomeExpense => 'Gelir/Gider Ekle';

  @override
  String get amountField => 'Tutar (₺)';

  @override
  String get categoryField => 'Kategori';

  @override
  String get descriptionField => 'Açıklama';

  @override
  String get enterValidAmount => 'Geçerli bir tutar girin';

  @override
  String get otherIncome => 'Diğer Gelir';

  @override
  String get otherExpense => 'Diğer Gider';

  @override
  String get allTransactions => 'Tüm İşlemler';

  @override
  String get incomes => 'Gelirler';

  @override
  String get expenses => 'Giderler';

  @override
  String get noTransactionsFound => 'İşlem bulunamadı';

  @override
  String get debtorCustomers => 'Borçlu Müşteriler';

  @override
  String get noDebtors => 'Borcu olan müşteri yok';

  @override
  String get totalReceivable => 'Toplam Alacak';

  @override
  String customersCountShort(int count) {
    return '$count müşteri';
  }

  @override
  String openDebtCount(int count) {
    return '$count açık borç';
  }

  @override
  String get remindViaWhatsApp => 'WhatsApp ile hatırlat';

  @override
  String reminderSentTo(String name) {
    return 'Hatırlatma gönderildi: $name';
  }

  @override
  String get reminderSendFailed =>
      'Hatırlatma gönderilemedi (WhatsApp bağlantısını kontrol edin)';

  @override
  String get collectPayment => 'Tahsil Et';

  @override
  String remainingDebtInfo(String amount) {
    return 'Kalan borç: $amount ₺';
  }

  @override
  String get collectedAmountField => 'Tahsil edilen tutar (₺)';

  @override
  String amountExceedsDebt(String amount) {
    return 'Tutar kalan borçtan fazla olamaz ($amount ₺)';
  }

  @override
  String remainingTracked(String amount) {
    return 'Kalan $amount ₺ borç olarak takip edilir';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '$amount ₺ tahsil edildi, kalan $left ₺';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '$amount ₺ tahsil edildi, borç kapandı';
  }

  @override
  String get collectionFailed => 'Tahsilat kaydedilemedi';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ borç';
  }

  @override
  String get statisticsTitle => 'İstatistikler';

  @override
  String get periodWeek => 'Hafta';

  @override
  String get periodMonth => 'Ay';

  @override
  String get periodYear => 'Yıl';

  @override
  String get employeeFilter => 'Çalışan';

  @override
  String get noTransactionsInPeriod => 'Bu dönemde işlem yok';

  @override
  String get incomeTrend => 'Gelir Trendi';

  @override
  String get noIncomeRecords => 'Gelir kaydı yok';

  @override
  String get paymentDistribution => 'Ödeme Yöntemi Dağılımı';

  @override
  String get employeeEarnings => 'Çalışan Kazançları';

  @override
  String get unassigned => 'Atanmamış';

  @override
  String get topServices => 'En Çok Kazandıran Hizmetler';

  @override
  String get topCustomers => 'En İyi Müşteriler';

  @override
  String get expenseItems => 'Gider Kalemleri';

  @override
  String get employeeDebtsTitle => 'Çalışan Bazlı Borçlar';

  @override
  String get generalTitle => 'Genel';

  @override
  String get noRecords => 'Kayıt yok';

  @override
  String get transactionCount => 'İşlem sayısı';

  @override
  String get avgTransaction => 'Ortalama işlem';

  @override
  String get incomeTransactionCount => 'Gelir işlemi sayısı';

  @override
  String get avgTransactionAmount => 'Ortalama işlem tutarı';

  @override
  String get appointmentsTotal => 'Randevu (toplam)';

  @override
  String get completedAppointmentsStat => 'Tamamlanan randevu';

  @override
  String get cancelledAppointmentsStat => 'İptal edilen randevu';

  @override
  String get cashRatio => 'Nakit oranı';

  @override
  String get openDebtTotal => 'Açık borç toplamı';

  @override
  String get employeeDebtHint =>
      'Borç, işi yapan çalışana göre gruplanır. Satıra dokununca borçlu müşteriler listelenir.';

  @override
  String debtorCountLabel(int count) {
    return '$count borçlu müşteri';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — borçlu müşteriler ($amount ₺)';
  }

  @override
  String get employeesTitle => 'Çalışanlar';

  @override
  String get addEmployee => 'Çalışan Ekle';

  @override
  String get noEmployeesYet => 'Henüz çalışan eklenmemiş';

  @override
  String get searchEmployeeHint => 'İsim, e-posta veya telefon ara';

  @override
  String get roleAdmin => 'Yönetici';

  @override
  String get roleEmployee => 'Çalışan';

  @override
  String get noMatchingEmployees => 'Eşleşen çalışan yok';

  @override
  String get makeEmployee => 'Çalışan Yap';

  @override
  String get makeAdmin => 'Yönetici Yap';

  @override
  String get deleteEmployeeTitle => 'Çalışanı Sil';

  @override
  String deleteEmployeeConfirm(String name) {
    return '$name silinecek. Bu işlem geri alınamaz.';
  }

  @override
  String get employeeDeleted => 'Çalışan silindi';

  @override
  String get deleteFailed => 'Silme başarısız';

  @override
  String get fullNameRequired => 'Ad Soyad gerekli';

  @override
  String get enterValidEmailInvite =>
      'Geçerli bir e-posta girin — çalışan bu adresteki Google hesabıyla giriş yapacak';

  @override
  String get fullNameField => 'Ad Soyad';

  @override
  String get phoneOnlyField => 'Telefon';

  @override
  String get emailField => 'E-posta';

  @override
  String get roleField => 'Yetki';

  @override
  String employeeAddedInfo(String name, String email) {
    return '$name eklendi. $email adresindeki Google hesabıyla giriş yapıp \"Çalışanım\" seçeneğini kullanabilir.';
  }

  @override
  String get employeeAddFailed => 'Çalışan eklenemedi';

  @override
  String get customersTitle => 'Müşteriler';

  @override
  String get addCustomerTooltip => 'Müşteri ekle';

  @override
  String get searchCustomerHint => 'İsim, telefon veya e-posta ara';

  @override
  String get filterDebtor => 'Borçlu';

  @override
  String get filterContacts => 'Rehberden';

  @override
  String get filterManual => 'Manuel';

  @override
  String customersCountLabel(int count) {
    return '$count müşteri';
  }

  @override
  String get noCustomersYet => 'Henüz müşteri eklenmemiş';

  @override
  String get noMatchingCustomers => 'Eşleşen müşteri yok';

  @override
  String get addCustomerTitle => 'Müşteri Ekle';

  @override
  String get contactPermissionRequired => 'Rehber erişim izni gerekli';

  @override
  String get noContactsFound => 'Rehberde kişi bulunamadı';

  @override
  String get noContactsWithPhone => 'Rehberde telefon numarası olan kişi yok';

  @override
  String addedFromContacts(int count) {
    return '$count kişi rehberden eklendi';
  }

  @override
  String contactReadError(String error) {
    return 'Rehber okunurken hata: $error';
  }

  @override
  String get businessInfoMissing =>
      'İşletme bilgisi eksik. Lütfen tekrar deneyin.';

  @override
  String customerAddedSuccess(String name) {
    return '$name başarıyla eklendi';
  }

  @override
  String get customerAddError => 'Müşteri eklenirken hata oluştu';

  @override
  String get pickFromContacts => 'Rehberden Kişi Ekle (Çoklu Seçim)';

  @override
  String get loadingContacts => 'Rehber Yükleniyor...';

  @override
  String get orEnterManually => 'veya manuel girin';

  @override
  String get fullNameStarField => 'Ad Soyad *';

  @override
  String get noteField => 'Not';

  @override
  String get pickContactTitle => 'Rehberden Kişi Seç';

  @override
  String selectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get searchNameOrPhone => 'İsim veya telefon ara...';

  @override
  String get selectNone => 'Hiçbirini Seçme';

  @override
  String selectAllCount(int count) {
    return 'Tümünü Seç ($count)';
  }

  @override
  String get noMatchingContacts => 'Aramanızla eşleşen kişi yok';

  @override
  String get emptyList => 'Liste boş';

  @override
  String addNPeople(int count) {
    return '$count Kişiyi Ekle';
  }

  @override
  String get defineBusiness => 'İşletmeni Tanımla';

  @override
  String get businessInfoTitle => 'İşletme Bilgileri';

  @override
  String get businessSetupSubtitle =>
      'Randevu 360\'ı kullanmak için işletmenizi tanımlayın';

  @override
  String get businessNameField => 'İşletme Adı';

  @override
  String get businessNameRequired => 'İşletme adı gerekli';

  @override
  String get addressField => 'Adres';

  @override
  String get emailInvalid => 'Geçerli bir e-posta girin';

  @override
  String get workingHoursTitle => 'Çalışma Saatleri';

  @override
  String get workingDaysTitle => 'Çalışma Günleri';

  @override
  String get opening => 'Açılış';

  @override
  String get closing => 'Kapanış';

  @override
  String get saveAndStart => 'Kaydet ve Başla';

  @override
  String get dayMon => 'Pazartesi';

  @override
  String get dayTue => 'Salı';

  @override
  String get dayWed => 'Çarşamba';

  @override
  String get dayThu => 'Perşembe';

  @override
  String get dayFri => 'Cuma';

  @override
  String get daySat => 'Cumartesi';

  @override
  String get daySun => 'Pazar';

  @override
  String get businessInfoUpdated => 'İşletme bilgileri güncellendi';

  @override
  String get updateFailed => 'Güncelleme başarısız';

  @override
  String get onlyOwnerCanEdit =>
      'Bu bilgileri yalnızca işletme sahibi değiştirebilir.';

  @override
  String get workingHoursUpdated => 'Çalışma saatleri güncellendi';

  @override
  String get profileTitle => 'Profil';

  @override
  String get userFallback => 'Kullanıcı';

  @override
  String get whatsappSettings => 'WhatsApp Ayarları';

  @override
  String get servicesAndPrices => 'Hizmetler ve Fiyatlar';

  @override
  String get incomeExpenseCategories => 'Gelir/Gider Kategorileri';

  @override
  String get messageTemplatesTitle => 'Mesaj Şablonları';

  @override
  String get workingHoursMenu => 'Çalışma Saatleri';

  @override
  String get backupMenu => 'Yedekleme';

  @override
  String get restoreMenu => 'Yedekten Geri Yükle';

  @override
  String googleSignInFailed(String error) {
    return 'Google girişi başarısız: $error';
  }

  @override
  String get backedUp => 'Yedeklendi ✅';

  @override
  String backupFailedMsg(String error) {
    return 'Yedekleme hatası: $error';
  }

  @override
  String restoreFailedMsg(String error) {
    return 'Geri yükleme hatası: $error';
  }

  @override
  String get backupDownloadedTitle => 'Yedek indirildi';

  @override
  String get backupDownloadedMessage =>
      'Geri yüklemenin tamamlanması için uygulama şimdi kapanacak. Tekrar açtığınızda verileriniz yedekten geri yüklenmiş olacak.';

  @override
  String get autoBackupTitle => 'Gece Otomatik Yedekleme';

  @override
  String get autoBackupSubtitle =>
      'Her gece 02:00-03:00 arasında Drive\'a yedekler';

  @override
  String get aboutApp => 'Uygulama Hakkında';

  @override
  String get termsOfUse => 'Kullanım Koşulları';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get categoriesTitle => 'Gelir/Gider Kategorileri';

  @override
  String get incomeCategories => 'Gelir Kategorileri';

  @override
  String get expenseCategories => 'Gider Kategorileri';

  @override
  String get addIncomeCategory => 'Gelir Kategorisi Ekle';

  @override
  String get addExpenseCategory => 'Gider Kategorisi Ekle';

  @override
  String get categoryNameField => 'Kategori adı';

  @override
  String get categoryExists => 'Bu kategori zaten var';

  @override
  String get categoryAddFailed => 'Kategori eklenemedi';

  @override
  String get deleteCategoryTitle => 'Kategoriyi Sil';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\" silinecek. Geçmiş işlemler etkilenmez.';
  }

  @override
  String get noCategories => 'Kategori yok';

  @override
  String get availableVariables => 'Kullanılabilir değişkenler';

  @override
  String get templateHelp =>
      'Mesaj gönderilirken bu değişkenler randevu bilgileriyle değiştirilir. Bir şablonu tamamen boşaltırsanız o mesaj hiç gönderilmez.';

  @override
  String get emptyToDisable => 'Mesaj göndermemek için boş bırakın';

  @override
  String get resetToDefault => 'Varsayılana dön';

  @override
  String get templatesSaved => 'Şablonlar kaydedildi';

  @override
  String get templatesSaveFailed => 'Şablonlar kaydedilemedi';

  @override
  String get templatesLoadFailed => 'Şablonlar yüklenemedi';

  @override
  String get templatesServerNote =>
      'Şablonlar WhatsApp sunucusunda tutulur; bağlantı gerekir.';

  @override
  String get debtReminderFrequency => 'Borç hatırlatma sıklığı';

  @override
  String get debtReminderFrequencyHelp =>
      'Borcu olan müşterilere \"Borç hatırlatma\" şablonu seçilen sıklıkta otomatik gönderilir (10:00-20:00 arasında).';

  @override
  String get freqOff => 'Kapalı';

  @override
  String get freqDaily => 'Günde bir';

  @override
  String get freqWeekly => 'Haftada bir';

  @override
  String get freqMonthly => 'Ayda bir';

  @override
  String get languageLabel => 'Dil';

  @override
  String get languageSystemDefault => 'Cihaz dilini kullan';
}
