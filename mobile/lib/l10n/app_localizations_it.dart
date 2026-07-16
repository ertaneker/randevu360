// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Randevu 360';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get add => 'Aggiungi';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Riprova';

  @override
  String get all => 'Tutti';

  @override
  String get errorTitle => 'Errore';

  @override
  String get pressBackAgainToExit => 'Premi ancora per uscire';

  @override
  String get appTagline => 'Gestione appuntamenti\nper piccole imprese';

  @override
  String get signInWithGoogle => 'Accedi con Google';

  @override
  String get termsNotice => 'Accedendo accetti i Termini di utilizzo';

  @override
  String welcomeUser(String name) {
    return 'Benvenuto,\n$name';
  }

  @override
  String get howToContinue => 'Come vuoi continuare?';

  @override
  String get roleOwnerTitle => 'Sono il titolare';

  @override
  String get roleOwnerSubtitle =>
      'Crea una nuova attività o gestisci quella esistente';

  @override
  String get roleEmployeeTitle => 'Sono un dipendente';

  @override
  String get roleEmployeeSubtitle =>
      'Accedi al mio account tramite l\'invito del titolare';

  @override
  String get useDifferentAccount => 'Usa un altro account';

  @override
  String get notSignedInTitle => 'Accesso non effettuato';

  @override
  String get notSignedInMessage => 'Accedi prima con il tuo account Google.';

  @override
  String get inviteNotFoundTitle => 'Invito non trovato';

  @override
  String get inviteNotFoundMessage =>
      'Nessun invito trovato per questo indirizzo e-mail.\n\nChiedi al titolare di aggiungerti al sistema.';

  @override
  String get invalidBusinessInfo => 'Informazioni dell\'attività non valide.';

  @override
  String businessRecordFailed(String error) {
    return 'Impossibile creare il record dell\'attività: $error';
  }

  @override
  String get connectionErrorTitle => 'Errore di connessione';

  @override
  String get inviteCheckFailed =>
      'Impossibile verificare l\'invito del dipendente. Controlla la connessione Internet e riprova.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabAppointments => 'Appuntamenti';

  @override
  String get tabCustomers => 'Clienti';

  @override
  String get tabFinance => 'Finanze';

  @override
  String get tabEmployees => 'Dipendenti';

  @override
  String get tabProfile => 'Profilo';

  @override
  String greetingHello(String name) {
    return 'Ciao $name';
  }

  @override
  String get greetingSubtitle => 'Pronto a gestire la tua attività';

  @override
  String get statToday => 'Oggi';

  @override
  String get statCompleted => 'Completati';

  @override
  String get statPending => 'In attesa';

  @override
  String get statTotalCustomers => 'Totale clienti';

  @override
  String get quickActions => 'Azioni rapide';

  @override
  String get quickNewAppointment => 'Nuovo appuntamento';

  @override
  String get quickAddCustomer => 'Aggiungi cliente';

  @override
  String get quickBulkMessage => 'Messaggio collettivo';

  @override
  String get whatsappConnection => 'Connessione WhatsApp';

  @override
  String get waConnected => 'Connesso';

  @override
  String get waPairing => 'Associazione...';

  @override
  String get waNotConnected => 'Non ancora connesso';

  @override
  String get manage => 'Gestisci';

  @override
  String get connect => 'Connetti';

  @override
  String get todaysAppointments => 'Appuntamenti di oggi';

  @override
  String get noAppointmentsToday => 'Nessun appuntamento oggi';

  @override
  String get customerFallback => 'Cliente';

  @override
  String get statusConfirmed => 'Confermato';

  @override
  String get statusCompleted => 'Completato';

  @override
  String get statusCancelled => 'Annullato';

  @override
  String get statusPending => 'In attesa';

  @override
  String get statusShortConfirmed => 'Confermato';

  @override
  String get statusShortCompleted => 'Fatto';

  @override
  String get statusShortCancelled => 'Annullato';

  @override
  String get statusShortPending => 'Attesa';

  @override
  String get appointmentsTitle => 'Appuntamenti';

  @override
  String appointmentCountLabel(int count) {
    return '$count appuntamenti';
  }

  @override
  String get allEmployees => 'Tutti i dipendenti';

  @override
  String get noAppointmentsThisDay => 'Nessun appuntamento in questo giorno';

  @override
  String get addAppointment => 'Aggiungi appuntamento';

  @override
  String get appointmentDetail => 'Dettaglio appuntamento';

  @override
  String get customerLabel => 'Cliente';

  @override
  String get dateLabel => 'Data';

  @override
  String get timeLabel => 'Ora';

  @override
  String get serviceLabel => 'Servizio';

  @override
  String get priceLabel => 'Prezzo';

  @override
  String get noteLabel => 'Nota';

  @override
  String get completedPaidNote => 'Completato, pagamento ricevuto';

  @override
  String get cancelAppointment => 'Annulla';

  @override
  String get markCompleted => 'Completato';

  @override
  String get appointmentCancelled => 'Appuntamento annullato';

  @override
  String get appointmentCancelFailed => 'Impossibile annullare l\'appuntamento';

  @override
  String collectedSummary(String amount, String method) {
    return '$amount ₺ incassato in $method';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ registrato come debito';
  }

  @override
  String get appointmentCompletedMsg => 'Appuntamento completato';

  @override
  String get paymentSaveFailed => 'Impossibile salvare il pagamento';

  @override
  String get paymentCash => 'Contanti';

  @override
  String get paymentCard => 'Carta';

  @override
  String get paymentTransfer => 'Bonifico';

  @override
  String get paymentCashLower => 'contanti';

  @override
  String get paymentCardLower => 'carta';

  @override
  String get newAppointment => 'Nuovo appuntamento';

  @override
  String get businessInfoNotFound => 'Informazioni dell\'attività non trovate';

  @override
  String get appointmentCreateFailed => 'Impossibile creare l\'appuntamento';

  @override
  String get appointmentCreated => 'Appuntamento creato con successo';

  @override
  String get customerPhoneRequired => 'Il telefono del cliente è obbligatorio';

  @override
  String get customerNameRequired => 'Il nome del cliente è obbligatorio';

  @override
  String get customerCreateFailed => 'Impossibile creare il cliente';

  @override
  String get sectionCustomer => 'Cliente';

  @override
  String get selectCustomer => 'Seleziona cliente';

  @override
  String get addNewCustomerItem => '+ Aggiungi nuovo cliente';

  @override
  String get customerNameField => 'Nome cliente *';

  @override
  String get phoneField => 'Telefono *';

  @override
  String get phoneRequired => 'Il numero di telefono è obbligatorio';

  @override
  String get sectionService => 'Servizio';

  @override
  String get noServicesDefined =>
      'Nessun servizio definito.\nDefinisci servizi e prezzi in Profilo > Servizi.';

  @override
  String get selectServiceField => 'Seleziona servizio *';

  @override
  String get serviceRequired => 'La selezione del servizio è obbligatoria';

  @override
  String get priceField => 'Prezzo *';

  @override
  String get priceRequired => 'Il prezzo è obbligatorio';

  @override
  String get priceInvalid => 'Inserisci un prezzo valido';

  @override
  String get sectionEmployee => 'Dipendente';

  @override
  String get selectEmployeeField => 'Seleziona dipendente *';

  @override
  String get employeeRequired => 'La selezione del dipendente è obbligatoria';

  @override
  String get sectionDateTime => 'Data e ora';

  @override
  String get dateField => 'Data *';

  @override
  String get timeField => 'Ora *';

  @override
  String get sectionNote => 'Nota';

  @override
  String get noteOptional => 'Nota (facoltativa)';

  @override
  String get noteHint => 'Note sull\'appuntamento...';

  @override
  String get saveAppointment => 'Salva appuntamento';

  @override
  String get takePayment => 'Prendi pagamento';

  @override
  String appointmentPriceInfo(String amount) {
    return 'Prezzo appuntamento: $amount ₺';
  }

  @override
  String get amountReceived => 'Importo ricevuto (₺)';

  @override
  String remainingWillBeDebt(String amount) {
    return 'I restanti $amount ₺ saranno registrati come debito';
  }

  @override
  String get paymentMethodLabel => 'Metodo di pagamento';

  @override
  String get allAsDebt => 'Tutto a debito';

  @override
  String get complete => 'Completa';

  @override
  String get financeTitle => 'Finanze';

  @override
  String get statisticsTooltip => 'Statistiche';

  @override
  String get monthlyBalance => 'Bilancio mensile';

  @override
  String get income => 'Entrate';

  @override
  String get expense => 'Uscite';

  @override
  String get net => 'Netto';

  @override
  String get thisWeek => 'Questa settimana';

  @override
  String receivablesLabel(int count) {
    return 'Crediti ($count)';
  }

  @override
  String get recentTransactions => 'Transazioni recenti';

  @override
  String get viewAllShort => 'Tutte';

  @override
  String get addIncomeExpense => 'Aggiungi entrata/uscita';

  @override
  String get amountField => 'Importo (₺)';

  @override
  String get categoryField => 'Categoria';

  @override
  String get descriptionField => 'Descrizione';

  @override
  String get enterValidAmount => 'Inserisci un importo valido';

  @override
  String get otherIncome => 'Altre entrate';

  @override
  String get otherExpense => 'Altre uscite';

  @override
  String get allTransactions => 'Tutte le transazioni';

  @override
  String get incomes => 'Entrate';

  @override
  String get expenses => 'Uscite';

  @override
  String get noTransactionsFound => 'Nessuna transazione trovata';

  @override
  String get debtorCustomers => 'Clienti con debiti';

  @override
  String get noDebtors => 'Nessun cliente con debiti';

  @override
  String get totalReceivable => 'Totale crediti';

  @override
  String customersCountShort(int count) {
    return '$count clienti';
  }

  @override
  String openDebtCount(int count) {
    return '$count debiti aperti';
  }

  @override
  String get remindViaWhatsApp => 'Ricorda via WhatsApp';

  @override
  String reminderSentTo(String name) {
    return 'Promemoria inviato: $name';
  }

  @override
  String get reminderSendFailed =>
      'Impossibile inviare il promemoria (controlla la connessione WhatsApp)';

  @override
  String get collectPayment => 'Incassa';

  @override
  String remainingDebtInfo(String amount) {
    return 'Debito rimanente: $amount ₺';
  }

  @override
  String get collectedAmountField => 'Importo incassato (₺)';

  @override
  String amountExceedsDebt(String amount) {
    return 'L\'importo non può superare il debito residuo ($amount ₺)';
  }

  @override
  String remainingTracked(String amount) {
    return 'I restanti $amount ₺ sono tracciati come debito';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '$amount ₺ incassato, $left ₺ rimanenti';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '$amount ₺ incassato, debito saldato';
  }

  @override
  String get collectionFailed => 'Impossibile salvare l\'incasso';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ debito';
  }

  @override
  String get statisticsTitle => 'Statistiche';

  @override
  String get periodWeek => 'Settimana';

  @override
  String get periodMonth => 'Mese';

  @override
  String get periodYear => 'Anno';

  @override
  String get employeeFilter => 'Dipendente';

  @override
  String get noTransactionsInPeriod => 'Nessuna transazione in questo periodo';

  @override
  String get incomeTrend => 'Andamento entrate';

  @override
  String get noIncomeRecords => 'Nessun record di entrate';

  @override
  String get paymentDistribution => 'Distribuzione metodi di pagamento';

  @override
  String get employeeEarnings => 'Guadagni dipendenti';

  @override
  String get unassigned => 'Non assegnato';

  @override
  String get topServices => 'Servizi più redditizi';

  @override
  String get topCustomers => 'Migliori clienti';

  @override
  String get expenseItems => 'Voci di spesa';

  @override
  String get employeeDebtsTitle => 'Debiti per dipendente';

  @override
  String get generalTitle => 'Generale';

  @override
  String get noRecords => 'Nessun record';

  @override
  String get transactionCount => 'Numero di transazioni';

  @override
  String get avgTransaction => 'Transazione media';

  @override
  String get incomeTransactionCount => 'Numero transazioni di entrata';

  @override
  String get avgTransactionAmount => 'Importo medio transazione';

  @override
  String get appointmentsTotal => 'Appuntamenti (totale)';

  @override
  String get completedAppointmentsStat => 'Appuntamenti completati';

  @override
  String get cancelledAppointmentsStat => 'Appuntamenti annullati';

  @override
  String get cashRatio => 'Quota contanti';

  @override
  String get openDebtTotal => 'Totale debiti aperti';

  @override
  String get employeeDebtHint =>
      'I debiti sono raggruppati per il dipendente che ha svolto il lavoro. Tocca una riga per elencare i clienti debitori.';

  @override
  String debtorCountLabel(int count) {
    return '$count clienti debitori';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — clienti debitori ($amount ₺)';
  }

  @override
  String get employeesTitle => 'Dipendenti';

  @override
  String get addEmployee => 'Aggiungi dipendente';

  @override
  String get noEmployeesYet => 'Nessun dipendente aggiunto';

  @override
  String get searchEmployeeHint => 'Cerca nome, e-mail o telefono';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleEmployee => 'Dipendente';

  @override
  String get noMatchingEmployees => 'Nessun dipendente corrispondente';

  @override
  String get makeEmployee => 'Rendi dipendente';

  @override
  String get makeAdmin => 'Rendi admin';

  @override
  String get deleteEmployeeTitle => 'Elimina dipendente';

  @override
  String deleteEmployeeConfirm(String name) {
    return '$name sarà eliminato. Questa azione è irreversibile.';
  }

  @override
  String get employeeDeleted => 'Dipendente eliminato';

  @override
  String get deleteFailed => 'Eliminazione fallita';

  @override
  String get fullNameRequired => 'Il nome completo è obbligatorio';

  @override
  String get enterValidEmailInvite =>
      'Inserisci un\'e-mail valida — il dipendente accederà con l\'account Google a questo indirizzo';

  @override
  String get fullNameField => 'Nome completo';

  @override
  String get phoneOnlyField => 'Telefono';

  @override
  String get emailField => 'E-mail';

  @override
  String get roleField => 'Ruolo';

  @override
  String employeeAddedInfo(String name, String email) {
    return '$name aggiunto. Può accedere con l\'account Google a $email e scegliere l\'opzione \"Sono un dipendente\".';
  }

  @override
  String get employeeAddFailed => 'Impossibile aggiungere il dipendente';

  @override
  String get customersTitle => 'Clienti';

  @override
  String get addCustomerTooltip => 'Aggiungi cliente';

  @override
  String get searchCustomerHint => 'Cerca nome, telefono o e-mail';

  @override
  String get filterDebtor => 'Con debiti';

  @override
  String get filterContacts => 'Dai contatti';

  @override
  String get filterManual => 'Manuale';

  @override
  String customersCountLabel(int count) {
    return '$count clienti';
  }

  @override
  String get noCustomersYet => 'Nessun cliente aggiunto';

  @override
  String get noMatchingCustomers => 'Nessun cliente corrispondente';

  @override
  String get addCustomerTitle => 'Aggiungi cliente';

  @override
  String get contactPermissionRequired =>
      'Permesso di accesso ai contatti richiesto';

  @override
  String get noContactsFound => 'Nessun contatto trovato';

  @override
  String get noContactsWithPhone => 'Nessun contatto con numero di telefono';

  @override
  String addedFromContacts(int count) {
    return '$count persone aggiunte dai contatti';
  }

  @override
  String contactReadError(String error) {
    return 'Errore nella lettura dei contatti: $error';
  }

  @override
  String get businessInfoMissing =>
      'Informazioni dell\'attività mancanti. Riprova.';

  @override
  String customerAddedSuccess(String name) {
    return '$name aggiunto con successo';
  }

  @override
  String get customerAddError => 'Errore durante l\'aggiunta del cliente';

  @override
  String get pickFromContacts => 'Aggiungi dai contatti (selezione multipla)';

  @override
  String get loadingContacts => 'Caricamento contatti...';

  @override
  String get orEnterManually => 'oppure inserisci manualmente';

  @override
  String get fullNameStarField => 'Nome completo *';

  @override
  String get noteField => 'Nota';

  @override
  String get pickContactTitle => 'Seleziona dai contatti';

  @override
  String selectedCount(int count) {
    return '$count selezionati';
  }

  @override
  String get searchNameOrPhone => 'Cerca nome o telefono...';

  @override
  String get selectNone => 'Deseleziona tutto';

  @override
  String selectAllCount(int count) {
    return 'Seleziona tutto ($count)';
  }

  @override
  String get noMatchingContacts => 'Nessun contatto corrisponde alla ricerca';

  @override
  String get emptyList => 'La lista è vuota';

  @override
  String addNPeople(int count) {
    return 'Aggiungi $count persone';
  }

  @override
  String get defineBusiness => 'Configura la tua attività';

  @override
  String get businessInfoTitle => 'Informazioni dell\'attività';

  @override
  String get businessSetupSubtitle =>
      'Configura la tua attività per usare Randevu 360';

  @override
  String get businessNameField => 'Nome dell\'attività';

  @override
  String get businessNameRequired => 'Il nome dell\'attività è obbligatorio';

  @override
  String get addressField => 'Indirizzo';

  @override
  String get emailInvalid => 'Inserisci un\'e-mail valida';

  @override
  String get workingHoursTitle => 'Orari di lavoro';

  @override
  String get workingDaysTitle => 'Giorni lavorativi';

  @override
  String get opening => 'Apertura';

  @override
  String get closing => 'Chiusura';

  @override
  String get saveAndStart => 'Salva e inizia';

  @override
  String get dayMon => 'Lunedì';

  @override
  String get dayTue => 'Martedì';

  @override
  String get dayWed => 'Mercoledì';

  @override
  String get dayThu => 'Giovedì';

  @override
  String get dayFri => 'Venerdì';

  @override
  String get daySat => 'Sabato';

  @override
  String get daySun => 'Domenica';

  @override
  String get businessInfoUpdated => 'Informazioni dell\'attività aggiornate';

  @override
  String get updateFailed => 'Aggiornamento fallito';

  @override
  String get onlyOwnerCanEdit =>
      'Solo il titolare può modificare queste informazioni.';

  @override
  String get workingHoursUpdated => 'Orari di lavoro aggiornati';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get userFallback => 'Utente';

  @override
  String get whatsappSettings => 'Impostazioni WhatsApp';

  @override
  String get servicesAndPrices => 'Servizi e prezzi';

  @override
  String get incomeExpenseCategories => 'Categorie entrate/uscite';

  @override
  String get messageTemplatesTitle => 'Modelli di messaggio';

  @override
  String get workingHoursMenu => 'Orari di lavoro';

  @override
  String get backupMenu => 'Backup';

  @override
  String get restoreMenu => 'Ripristina da backup';

  @override
  String googleSignInFailed(String error) {
    return 'Accesso Google fallito: $error';
  }

  @override
  String get backedUp => 'Backup completato ✅';

  @override
  String backupFailedMsg(String error) {
    return 'Errore di backup: $error';
  }

  @override
  String restoreFailedMsg(String error) {
    return 'Errore di ripristino: $error';
  }

  @override
  String get backupDownloadedTitle => 'Backup scaricato';

  @override
  String get backupDownloadedMessage =>
      'L\'app si chiuderà ora per completare il ripristino. Quando la riaprirai, i tuoi dati saranno ripristinati dal backup.';

  @override
  String get autoBackupTitle => 'Backup automatico notturno';

  @override
  String get autoBackupSubtitle =>
      'Esegue il backup su Drive ogni notte tra le 02:00 e le 03:00';

  @override
  String get aboutApp => 'Informazioni sull\'app';

  @override
  String get termsOfUse => 'Termini di utilizzo';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get signOut => 'Disconnetti';

  @override
  String get categoriesTitle => 'Categorie entrate/uscite';

  @override
  String get incomeCategories => 'Categorie di entrata';

  @override
  String get expenseCategories => 'Categorie di uscita';

  @override
  String get addIncomeCategory => 'Aggiungi categoria di entrata';

  @override
  String get addExpenseCategory => 'Aggiungi categoria di uscita';

  @override
  String get categoryNameField => 'Nome categoria';

  @override
  String get categoryExists => 'Questa categoria esiste già';

  @override
  String get categoryAddFailed => 'Impossibile aggiungere la categoria';

  @override
  String get deleteCategoryTitle => 'Elimina categoria';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\" sarà eliminata. Le transazioni passate non sono interessate.';
  }

  @override
  String get noCategories => 'Nessuna categoria';

  @override
  String get availableVariables => 'Variabili disponibili';

  @override
  String get templateHelp =>
      'Queste variabili vengono sostituite con i dettagli dell\'appuntamento all\'invio. Se svuoti completamente un modello, quel messaggio non viene mai inviato.';

  @override
  String get emptyToDisable => 'Lascia vuoto per non inviare questo messaggio';

  @override
  String get resetToDefault => 'Ripristina predefinito';

  @override
  String get templatesSaved => 'Modelli salvati';

  @override
  String get templatesSaveFailed => 'Impossibile salvare i modelli';

  @override
  String get templatesLoadFailed => 'Impossibile caricare i modelli';

  @override
  String get templatesServerNote =>
      'I modelli sono archiviati sul server WhatsApp; è richiesta una connessione.';

  @override
  String get debtReminderFrequency => 'Frequenza promemoria debiti';

  @override
  String get debtReminderFrequencyHelp =>
      'Il modello \"Promemoria debito\" viene inviato automaticamente ai clienti con debiti alla frequenza selezionata (tra le 10:00 e le 20:00).';

  @override
  String get freqOff => 'Disattivato';

  @override
  String get freqDaily => 'Una volta al giorno';

  @override
  String get freqWeekly => 'Una volta a settimana';

  @override
  String get freqMonthly => 'Una volta al mese';

  @override
  String get languageLabel => 'Lingua';

  @override
  String get languageSystemDefault => 'Predefinito di sistema';
}
