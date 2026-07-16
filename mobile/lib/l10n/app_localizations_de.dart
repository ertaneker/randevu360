// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Randevu 360';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get all => 'Alle';

  @override
  String get errorTitle => 'Fehler';

  @override
  String get pressBackAgainToExit => 'Erneut drücken, um zu beenden';

  @override
  String get appTagline => 'Terminverwaltung\nfür kleine Unternehmen';

  @override
  String get signInWithGoogle => 'Mit Google anmelden';

  @override
  String get termsNotice =>
      'Durch die Anmeldung akzeptieren Sie die Nutzungsbedingungen';

  @override
  String welcomeUser(String name) {
    return 'Willkommen,\n$name';
  }

  @override
  String get howToContinue => 'Wie möchten Sie fortfahren?';

  @override
  String get roleOwnerTitle => 'Ich bin Geschäftsinhaber';

  @override
  String get roleOwnerSubtitle =>
      'Neues Unternehmen erstellen oder bestehendes verwalten';

  @override
  String get roleEmployeeTitle => 'Ich bin Mitarbeiter';

  @override
  String get roleEmployeeSubtitle =>
      'Über die Einladung des Inhabers auf mein Konto zugreifen';

  @override
  String get useDifferentAccount => 'Anderes Konto verwenden';

  @override
  String get notSignedInTitle => 'Nicht angemeldet';

  @override
  String get notSignedInMessage =>
      'Bitte melden Sie sich zuerst mit Ihrem Google-Konto an.';

  @override
  String get inviteNotFoundTitle => 'Einladung nicht gefunden';

  @override
  String get inviteNotFoundMessage =>
      'Für diese E-Mail-Adresse wurde keine Einladung gefunden.\n\nBitten Sie den Geschäftsinhaber, Sie zum System hinzuzufügen.';

  @override
  String get invalidBusinessInfo => 'Unternehmensinformationen sind ungültig.';

  @override
  String businessRecordFailed(String error) {
    return 'Unternehmensdatensatz konnte nicht erstellt werden: $error';
  }

  @override
  String get connectionErrorTitle => 'Verbindungsfehler';

  @override
  String get inviteCheckFailed =>
      'Die Mitarbeitereinladung konnte nicht überprüft werden. Überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get tabHome => 'Start';

  @override
  String get tabAppointments => 'Termine';

  @override
  String get tabCustomers => 'Kunden';

  @override
  String get tabFinance => 'Finanzen';

  @override
  String get tabEmployees => 'Mitarbeiter';

  @override
  String get tabProfile => 'Profil';

  @override
  String greetingHello(String name) {
    return 'Hallo $name';
  }

  @override
  String get greetingSubtitle => 'Bereit, Ihr Unternehmen zu verwalten';

  @override
  String get statToday => 'Heute';

  @override
  String get statCompleted => 'Erledigt';

  @override
  String get statPending => 'Ausstehend';

  @override
  String get statTotalCustomers => 'Kunden gesamt';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get quickNewAppointment => 'Neuer Termin';

  @override
  String get quickAddCustomer => 'Kunde hinzufügen';

  @override
  String get quickBulkMessage => 'Massenachricht';

  @override
  String get whatsappConnection => 'WhatsApp-Verbindung';

  @override
  String get waConnected => 'Verbunden';

  @override
  String get waPairing => 'Kopplung...';

  @override
  String get waNotConnected => 'Noch nicht verbunden';

  @override
  String get manage => 'Verwalten';

  @override
  String get connect => 'Verbinden';

  @override
  String get todaysAppointments => 'Heutige Termine';

  @override
  String get noAppointmentsToday => 'Keine Termine heute';

  @override
  String get customerFallback => 'Kunde';

  @override
  String get statusConfirmed => 'Bestätigt';

  @override
  String get statusCompleted => 'Abgeschlossen';

  @override
  String get statusCancelled => 'Storniert';

  @override
  String get statusPending => 'Ausstehend';

  @override
  String get statusShortConfirmed => 'Bestätigt';

  @override
  String get statusShortCompleted => 'Fertig';

  @override
  String get statusShortCancelled => 'Storniert';

  @override
  String get statusShortPending => 'Offen';

  @override
  String get appointmentsTitle => 'Termine';

  @override
  String appointmentCountLabel(int count) {
    return '$count Termine';
  }

  @override
  String get allEmployees => 'Alle Mitarbeiter';

  @override
  String get noAppointmentsThisDay => 'Keine Termine an diesem Tag';

  @override
  String get addAppointment => 'Termin hinzufügen';

  @override
  String get appointmentDetail => 'Termindetails';

  @override
  String get customerLabel => 'Kunde';

  @override
  String get dateLabel => 'Datum';

  @override
  String get timeLabel => 'Uhrzeit';

  @override
  String get serviceLabel => 'Dienstleistung';

  @override
  String get priceLabel => 'Preis';

  @override
  String get noteLabel => 'Notiz';

  @override
  String get completedPaidNote => 'Abgeschlossen, Zahlung erhalten';

  @override
  String get cancelAppointment => 'Stornieren';

  @override
  String get markCompleted => 'Abgeschlossen';

  @override
  String get appointmentCancelled => 'Termin storniert';

  @override
  String get appointmentCancelFailed => 'Termin konnte nicht storniert werden';

  @override
  String collectedSummary(String amount, String method) {
    return '$amount ₺ erhalten in $method';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ als Schulden erfasst';
  }

  @override
  String get appointmentCompletedMsg => 'Termin abgeschlossen';

  @override
  String get paymentSaveFailed => 'Zahlung konnte nicht gespeichert werden';

  @override
  String get paymentCash => 'Bar';

  @override
  String get paymentCard => 'Karte';

  @override
  String get paymentTransfer => 'Überweisung';

  @override
  String get paymentCashLower => 'bar';

  @override
  String get paymentCardLower => 'karte';

  @override
  String get newAppointment => 'Neuer Termin';

  @override
  String get businessInfoNotFound => 'Unternehmensinformationen nicht gefunden';

  @override
  String get appointmentCreateFailed => 'Termin konnte nicht erstellt werden';

  @override
  String get appointmentCreated => 'Termin erfolgreich erstellt';

  @override
  String get customerPhoneRequired => 'Kundentelefon ist erforderlich';

  @override
  String get customerNameRequired => 'Kundenname ist erforderlich';

  @override
  String get customerCreateFailed => 'Kunde konnte nicht erstellt werden';

  @override
  String get sectionCustomer => 'Kunde';

  @override
  String get selectCustomer => 'Kunde auswählen';

  @override
  String get addNewCustomerItem => '+ Neuen Kunden hinzufügen';

  @override
  String get customerNameField => 'Kundenname *';

  @override
  String get phoneField => 'Telefon *';

  @override
  String get phoneRequired => 'Telefonnummer ist erforderlich';

  @override
  String get sectionService => 'Dienstleistung';

  @override
  String get noServicesDefined =>
      'Noch keine Dienstleistungen definiert.\nDefinieren Sie Dienstleistungen und Preise unter Profil > Dienstleistungen.';

  @override
  String get selectServiceField => 'Dienstleistung wählen *';

  @override
  String get serviceRequired => 'Dienstleistungsauswahl ist erforderlich';

  @override
  String get priceField => 'Preis *';

  @override
  String get priceRequired => 'Preis ist erforderlich';

  @override
  String get priceInvalid => 'Gültigen Preis eingeben';

  @override
  String get sectionEmployee => 'Mitarbeiter';

  @override
  String get selectEmployeeField => 'Mitarbeiter wählen *';

  @override
  String get employeeRequired => 'Mitarbeiterauswahl ist erforderlich';

  @override
  String get sectionDateTime => 'Datum und Uhrzeit';

  @override
  String get dateField => 'Datum *';

  @override
  String get timeField => 'Uhrzeit *';

  @override
  String get sectionNote => 'Notiz';

  @override
  String get noteOptional => 'Notiz (optional)';

  @override
  String get noteHint => 'Notizen zum Termin...';

  @override
  String get saveAppointment => 'Termin speichern';

  @override
  String get takePayment => 'Zahlung entgegennehmen';

  @override
  String appointmentPriceInfo(String amount) {
    return 'Terminpreis: $amount ₺';
  }

  @override
  String get amountReceived => 'Erhaltener Betrag (₺)';

  @override
  String remainingWillBeDebt(String amount) {
    return 'Verbleibende $amount ₺ werden als Schulden erfasst';
  }

  @override
  String get paymentMethodLabel => 'Zahlungsmethode';

  @override
  String get allAsDebt => 'Alles als Schulden';

  @override
  String get complete => 'Abschließen';

  @override
  String get financeTitle => 'Finanzen';

  @override
  String get statisticsTooltip => 'Statistiken';

  @override
  String get monthlyBalance => 'Monatsbilanz';

  @override
  String get income => 'Einnahmen';

  @override
  String get expense => 'Ausgaben';

  @override
  String get net => 'Netto';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String receivablesLabel(int count) {
    return 'Forderungen ($count)';
  }

  @override
  String get recentTransactions => 'Letzte Transaktionen';

  @override
  String get viewAllShort => 'Alle';

  @override
  String get addIncomeExpense => 'Einnahme/Ausgabe hinzufügen';

  @override
  String get amountField => 'Betrag (₺)';

  @override
  String get categoryField => 'Kategorie';

  @override
  String get descriptionField => 'Beschreibung';

  @override
  String get enterValidAmount => 'Gültigen Betrag eingeben';

  @override
  String get otherIncome => 'Sonstige Einnahmen';

  @override
  String get otherExpense => 'Sonstige Ausgaben';

  @override
  String get allTransactions => 'Alle Transaktionen';

  @override
  String get incomes => 'Einnahmen';

  @override
  String get expenses => 'Ausgaben';

  @override
  String get noTransactionsFound => 'Keine Transaktionen gefunden';

  @override
  String get debtorCustomers => 'Kunden mit Schulden';

  @override
  String get noDebtors => 'Keine Kunden mit Schulden';

  @override
  String get totalReceivable => 'Gesamtforderung';

  @override
  String customersCountShort(int count) {
    return '$count Kunden';
  }

  @override
  String openDebtCount(int count) {
    return '$count offene Schulden';
  }

  @override
  String get remindViaWhatsApp => 'Per WhatsApp erinnern';

  @override
  String reminderSentTo(String name) {
    return 'Erinnerung gesendet: $name';
  }

  @override
  String get reminderSendFailed =>
      'Erinnerung konnte nicht gesendet werden (WhatsApp-Verbindung prüfen)';

  @override
  String get collectPayment => 'Einziehen';

  @override
  String remainingDebtInfo(String amount) {
    return 'Verbleibende Schulden: $amount ₺';
  }

  @override
  String get collectedAmountField => 'Eingezogener Betrag (₺)';

  @override
  String amountExceedsDebt(String amount) {
    return 'Betrag darf die Restschuld nicht übersteigen ($amount ₺)';
  }

  @override
  String remainingTracked(String amount) {
    return 'Verbleibende $amount ₺ werden als Schulden verfolgt';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '$amount ₺ erhalten, $left ₺ verbleibend';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '$amount ₺ erhalten, Schulden beglichen';
  }

  @override
  String get collectionFailed => 'Einzug konnte nicht gespeichert werden';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ Schulden';
  }

  @override
  String get statisticsTitle => 'Statistiken';

  @override
  String get periodWeek => 'Woche';

  @override
  String get periodMonth => 'Monat';

  @override
  String get periodYear => 'Jahr';

  @override
  String get employeeFilter => 'Mitarbeiter';

  @override
  String get noTransactionsInPeriod => 'Keine Transaktionen in diesem Zeitraum';

  @override
  String get incomeTrend => 'Einnahmetrend';

  @override
  String get noIncomeRecords => 'Keine Einnahmendaten';

  @override
  String get paymentDistribution => 'Zahlungsmethoden-Verteilung';

  @override
  String get employeeEarnings => 'Mitarbeiterverdienste';

  @override
  String get unassigned => 'Nicht zugewiesen';

  @override
  String get topServices => 'Umsatzstärkste Dienstleistungen';

  @override
  String get topCustomers => 'Beste Kunden';

  @override
  String get expenseItems => 'Ausgabenposten';

  @override
  String get employeeDebtsTitle => 'Schulden nach Mitarbeiter';

  @override
  String get generalTitle => 'Allgemein';

  @override
  String get noRecords => 'Keine Einträge';

  @override
  String get transactionCount => 'Anzahl Transaktionen';

  @override
  String get avgTransaction => 'Durchschnittliche Transaktion';

  @override
  String get incomeTransactionCount => 'Anzahl Einnahmetransaktionen';

  @override
  String get avgTransactionAmount => 'Durchschnittlicher Transaktionsbetrag';

  @override
  String get appointmentsTotal => 'Termine (gesamt)';

  @override
  String get completedAppointmentsStat => 'Abgeschlossene Termine';

  @override
  String get cancelledAppointmentsStat => 'Stornierte Termine';

  @override
  String get cashRatio => 'Baranteil';

  @override
  String get openDebtTotal => 'Offene Schulden gesamt';

  @override
  String get employeeDebtHint =>
      'Schulden sind nach dem ausführenden Mitarbeiter gruppiert. Zeile antippen, um die Schuldnerkunden anzuzeigen.';

  @override
  String debtorCountLabel(int count) {
    return '$count Schuldnerkunden';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — Schuldnerkunden ($amount ₺)';
  }

  @override
  String get employeesTitle => 'Mitarbeiter';

  @override
  String get addEmployee => 'Mitarbeiter hinzufügen';

  @override
  String get noEmployeesYet => 'Noch keine Mitarbeiter hinzugefügt';

  @override
  String get searchEmployeeHint => 'Name, E-Mail oder Telefon suchen';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleEmployee => 'Mitarbeiter';

  @override
  String get noMatchingEmployees => 'Keine passenden Mitarbeiter';

  @override
  String get makeEmployee => 'Zum Mitarbeiter machen';

  @override
  String get makeAdmin => 'Zum Admin machen';

  @override
  String get deleteEmployeeTitle => 'Mitarbeiter löschen';

  @override
  String deleteEmployeeConfirm(String name) {
    return '$name wird gelöscht. Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get employeeDeleted => 'Mitarbeiter gelöscht';

  @override
  String get deleteFailed => 'Löschen fehlgeschlagen';

  @override
  String get fullNameRequired => 'Vollständiger Name ist erforderlich';

  @override
  String get enterValidEmailInvite =>
      'Gültige E-Mail eingeben — der Mitarbeiter meldet sich mit dem Google-Konto dieser Adresse an';

  @override
  String get fullNameField => 'Vollständiger Name';

  @override
  String get phoneOnlyField => 'Telefon';

  @override
  String get emailField => 'E-Mail';

  @override
  String get roleField => 'Rolle';

  @override
  String employeeAddedInfo(String name, String email) {
    return '$name hinzugefügt. Er kann sich mit dem Google-Konto bei $email anmelden und die Option \"Ich bin Mitarbeiter\" wählen.';
  }

  @override
  String get employeeAddFailed => 'Mitarbeiter konnte nicht hinzugefügt werden';

  @override
  String get customersTitle => 'Kunden';

  @override
  String get addCustomerTooltip => 'Kunde hinzufügen';

  @override
  String get searchCustomerHint => 'Name, Telefon oder E-Mail suchen';

  @override
  String get filterDebtor => 'Mit Schulden';

  @override
  String get filterContacts => 'Aus Kontakten';

  @override
  String get filterManual => 'Manuell';

  @override
  String customersCountLabel(int count) {
    return '$count Kunden';
  }

  @override
  String get noCustomersYet => 'Noch keine Kunden hinzugefügt';

  @override
  String get noMatchingCustomers => 'Keine passenden Kunden';

  @override
  String get addCustomerTitle => 'Kunde hinzufügen';

  @override
  String get contactPermissionRequired => 'Kontakte-Berechtigung erforderlich';

  @override
  String get noContactsFound => 'Keine Kontakte gefunden';

  @override
  String get noContactsWithPhone => 'Keine Kontakte mit Telefonnummer';

  @override
  String addedFromContacts(int count) {
    return '$count Personen aus Kontakten hinzugefügt';
  }

  @override
  String contactReadError(String error) {
    return 'Fehler beim Lesen der Kontakte: $error';
  }

  @override
  String get businessInfoMissing =>
      'Unternehmensinformationen fehlen. Bitte versuchen Sie es erneut.';

  @override
  String customerAddedSuccess(String name) {
    return '$name erfolgreich hinzugefügt';
  }

  @override
  String get customerAddError => 'Fehler beim Hinzufügen des Kunden';

  @override
  String get pickFromContacts => 'Aus Kontakten hinzufügen (Mehrfachauswahl)';

  @override
  String get loadingContacts => 'Kontakte werden geladen...';

  @override
  String get orEnterManually => 'oder manuell eingeben';

  @override
  String get fullNameStarField => 'Vollständiger Name *';

  @override
  String get noteField => 'Notiz';

  @override
  String get pickContactTitle => 'Aus Kontakten auswählen';

  @override
  String selectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get searchNameOrPhone => 'Name oder Telefon suchen...';

  @override
  String get selectNone => 'Alle abwählen';

  @override
  String selectAllCount(int count) {
    return 'Alle auswählen ($count)';
  }

  @override
  String get noMatchingContacts => 'Keine Kontakte gefunden';

  @override
  String get emptyList => 'Liste ist leer';

  @override
  String addNPeople(int count) {
    return '$count Personen hinzufügen';
  }

  @override
  String get defineBusiness => 'Unternehmen einrichten';

  @override
  String get businessInfoTitle => 'Unternehmensinformationen';

  @override
  String get businessSetupSubtitle =>
      'Richten Sie Ihr Unternehmen ein, um Randevu 360 zu nutzen';

  @override
  String get businessNameField => 'Unternehmensname';

  @override
  String get businessNameRequired => 'Unternehmensname ist erforderlich';

  @override
  String get addressField => 'Adresse';

  @override
  String get emailInvalid => 'Gültige E-Mail eingeben';

  @override
  String get workingHoursTitle => 'Arbeitszeiten';

  @override
  String get workingDaysTitle => 'Arbeitstage';

  @override
  String get opening => 'Öffnung';

  @override
  String get closing => 'Schließung';

  @override
  String get saveAndStart => 'Speichern und starten';

  @override
  String get dayMon => 'Montag';

  @override
  String get dayTue => 'Dienstag';

  @override
  String get dayWed => 'Mittwoch';

  @override
  String get dayThu => 'Donnerstag';

  @override
  String get dayFri => 'Freitag';

  @override
  String get daySat => 'Samstag';

  @override
  String get daySun => 'Sonntag';

  @override
  String get businessInfoUpdated => 'Unternehmensinformationen aktualisiert';

  @override
  String get updateFailed => 'Aktualisierung fehlgeschlagen';

  @override
  String get onlyOwnerCanEdit =>
      'Nur der Geschäftsinhaber kann diese Informationen ändern.';

  @override
  String get workingHoursUpdated => 'Arbeitszeiten aktualisiert';

  @override
  String get profileTitle => 'Profil';

  @override
  String get userFallback => 'Benutzer';

  @override
  String get whatsappSettings => 'WhatsApp-Einstellungen';

  @override
  String get servicesAndPrices => 'Dienstleistungen und Preise';

  @override
  String get incomeExpenseCategories => 'Einnahme-/Ausgabenkategorien';

  @override
  String get messageTemplatesTitle => 'Nachrichtenvorlagen';

  @override
  String get workingHoursMenu => 'Arbeitszeiten';

  @override
  String get backupMenu => 'Backup';

  @override
  String get restoreMenu => 'Aus Backup wiederherstellen';

  @override
  String googleSignInFailed(String error) {
    return 'Google-Anmeldung fehlgeschlagen: $error';
  }

  @override
  String get backedUp => 'Gesichert ✅';

  @override
  String backupFailedMsg(String error) {
    return 'Backup-Fehler: $error';
  }

  @override
  String restoreFailedMsg(String error) {
    return 'Wiederherstellungsfehler: $error';
  }

  @override
  String get backupDownloadedTitle => 'Backup heruntergeladen';

  @override
  String get backupDownloadedMessage =>
      'Die App wird jetzt geschlossen, um die Wiederherstellung abzuschließen. Beim erneuten Öffnen sind Ihre Daten aus dem Backup wiederhergestellt.';

  @override
  String get autoBackupTitle => 'Automatisches nächtliches Backup';

  @override
  String get autoBackupSubtitle =>
      'Sichert jede Nacht zwischen 02:00-03:00 Uhr auf Drive';

  @override
  String get aboutApp => 'Über die App';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get signOut => 'Abmelden';

  @override
  String get categoriesTitle => 'Einnahme-/Ausgabenkategorien';

  @override
  String get incomeCategories => 'Einnahmekategorien';

  @override
  String get expenseCategories => 'Ausgabenkategorien';

  @override
  String get addIncomeCategory => 'Einnahmekategorie hinzufügen';

  @override
  String get addExpenseCategory => 'Ausgabenkategorie hinzufügen';

  @override
  String get categoryNameField => 'Kategoriename';

  @override
  String get categoryExists => 'Diese Kategorie existiert bereits';

  @override
  String get categoryAddFailed => 'Kategorie konnte nicht hinzugefügt werden';

  @override
  String get deleteCategoryTitle => 'Kategorie löschen';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\" wird gelöscht. Vergangene Transaktionen sind nicht betroffen.';
  }

  @override
  String get noCategories => 'Keine Kategorien';

  @override
  String get availableVariables => 'Verfügbare Variablen';

  @override
  String get templateHelp =>
      'Diese Variablen werden beim Senden durch Termindetails ersetzt. Wenn Sie eine Vorlage vollständig leeren, wird diese Nachricht nie gesendet.';

  @override
  String get emptyToDisable =>
      'Leer lassen, um diese Nachricht nicht zu senden';

  @override
  String get resetToDefault => 'Auf Standard zurücksetzen';

  @override
  String get templatesSaved => 'Vorlagen gespeichert';

  @override
  String get templatesSaveFailed => 'Vorlagen konnten nicht gespeichert werden';

  @override
  String get templatesLoadFailed => 'Vorlagen konnten nicht geladen werden';

  @override
  String get templatesServerNote =>
      'Vorlagen werden auf dem WhatsApp-Server gespeichert; eine Verbindung ist erforderlich.';

  @override
  String get debtReminderFrequency => 'Schuldenerinnerung-Häufigkeit';

  @override
  String get debtReminderFrequencyHelp =>
      'Die Vorlage \"Schuldenerinnerung\" wird automatisch an Kunden mit Schulden in der gewählten Häufigkeit gesendet (zwischen 10:00-20:00 Uhr).';

  @override
  String get freqOff => 'Aus';

  @override
  String get freqDaily => 'Einmal täglich';

  @override
  String get freqWeekly => 'Einmal wöchentlich';

  @override
  String get freqMonthly => 'Einmal monatlich';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get languageSystemDefault => 'Systemstandard';
}
