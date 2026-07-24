// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Esnaf Takvim';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get add => 'Ajouter';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Réessayer';

  @override
  String get all => 'Tout';

  @override
  String get errorTitle => 'Erreur';

  @override
  String get pressBackAgainToExit => 'Appuyez à nouveau pour quitter';

  @override
  String get appTagline => 'Gestion de rendez-vous\npour petites entreprises';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get termsNotice =>
      'En vous connectant, vous acceptez les conditions d\'utilisation';

  @override
  String welcomeUser(String name) {
    return 'Bienvenue,\n$name';
  }

  @override
  String get howToContinue => 'Comment souhaitez-vous continuer ?';

  @override
  String get roleOwnerTitle => 'Je suis propriétaire';

  @override
  String get roleOwnerSubtitle =>
      'Créer une nouvelle entreprise ou gérer mon entreprise existante';

  @override
  String get roleEmployeeTitle => 'Je suis employé';

  @override
  String get roleEmployeeSubtitle =>
      'Accéder à mon compte via l\'invitation du propriétaire';

  @override
  String get useDifferentAccount => 'Utiliser un autre compte';

  @override
  String get notSignedInTitle => 'Non connecté';

  @override
  String get notSignedInMessage =>
      'Veuillez d\'abord vous connecter avec votre compte Google.';

  @override
  String get inviteNotFoundTitle => 'Invitation introuvable';

  @override
  String get inviteNotFoundMessage =>
      'Aucune invitation trouvée pour cette adresse e-mail.\n\nDemandez au propriétaire de vous ajouter au système.';

  @override
  String get invalidBusinessInfo =>
      'Les informations de l\'entreprise sont invalides.';

  @override
  String businessRecordFailed(String error) {
    return 'L\'enregistrement de l\'entreprise n\'a pas pu être créé : $error';
  }

  @override
  String get connectionErrorTitle => 'Erreur de connexion';

  @override
  String get inviteCheckFailed =>
      'L\'invitation de l\'employé n\'a pas pu être vérifiée. Vérifiez votre connexion Internet et réessayez.';

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabAppointments => 'Rendez-vous';

  @override
  String get tabCustomers => 'Clients';

  @override
  String get tabFinance => 'Finances';

  @override
  String get tabEmployees => 'Employés';

  @override
  String get tabProfile => 'Profil';

  @override
  String greetingHello(String name) {
    return 'Bonjour $name';
  }

  @override
  String get greetingSubtitle => 'Prêt à gérer votre entreprise';

  @override
  String get statToday => 'Aujourd\'hui';

  @override
  String get statCompleted => 'Terminé';

  @override
  String get statPending => 'En attente';

  @override
  String get statTotalCustomers => 'Total clients';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get quickNewAppointment => 'Nouveau rendez-vous';

  @override
  String get quickAddCustomer => 'Ajouter un client';

  @override
  String get quickBulkMessage => 'Message groupé';

  @override
  String get whatsappConnection => 'Connexion WhatsApp';

  @override
  String get waConnected => 'Connecté';

  @override
  String get waPairing => 'Appairage...';

  @override
  String get waNotConnected => 'Pas encore connecté';

  @override
  String get manage => 'Gérer';

  @override
  String get connect => 'Connecter';

  @override
  String get todaysAppointments => 'Rendez-vous du jour';

  @override
  String get noAppointmentsToday => 'Aucun rendez-vous aujourd\'hui';

  @override
  String get customerFallback => 'Client';

  @override
  String get statusConfirmed => 'Confirmé';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusCancelled => 'Annulé';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusShortConfirmed => 'Confirmé';

  @override
  String get statusShortCompleted => 'Fait';

  @override
  String get statusShortCancelled => 'Annulé';

  @override
  String get statusShortPending => 'Attente';

  @override
  String get appointmentsTitle => 'Rendez-vous';

  @override
  String appointmentCountLabel(int count) {
    return '$count rendez-vous';
  }

  @override
  String get allEmployees => 'Tous les employés';

  @override
  String get noAppointmentsThisDay => 'Aucun rendez-vous ce jour';

  @override
  String get addAppointment => 'Ajouter un rendez-vous';

  @override
  String get appointmentDetail => 'Détail du rendez-vous';

  @override
  String get customerLabel => 'Client';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Heure';

  @override
  String get serviceLabel => 'Service';

  @override
  String get priceLabel => 'Prix';

  @override
  String get noteLabel => 'Note';

  @override
  String get completedPaidNote => 'Terminé, paiement reçu';

  @override
  String get cancelAppointment => 'Annuler';

  @override
  String get markCompleted => 'Terminé';

  @override
  String get appointmentCancelled => 'Rendez-vous annulé';

  @override
  String get appointmentCancelFailed =>
      'Le rendez-vous n\'a pas pu être annulé';

  @override
  String collectedSummary(String amount, String method) {
    return '$amount ₺ encaissé en $method';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ enregistré comme dette';
  }

  @override
  String get appointmentCompletedMsg => 'Rendez-vous terminé';

  @override
  String get paymentSaveFailed => 'Le paiement n\'a pas pu être enregistré';

  @override
  String get paymentCash => 'Espèces';

  @override
  String get paymentCard => 'Carte';

  @override
  String get paymentTransfer => 'Virement';

  @override
  String get paymentCashLower => 'espèces';

  @override
  String get paymentCardLower => 'carte';

  @override
  String get newAppointment => 'Nouveau rendez-vous';

  @override
  String get businessInfoNotFound =>
      'Informations de l\'entreprise introuvables';

  @override
  String get appointmentCreateFailed => 'Le rendez-vous n\'a pas pu être créé';

  @override
  String get appointmentCreated => 'Rendez-vous créé avec succès';

  @override
  String get customerPhoneRequired => 'Le téléphone du client est requis';

  @override
  String get customerNameRequired => 'Le nom du client est requis';

  @override
  String get customerCreateFailed => 'Le client n\'a pas pu être créé';

  @override
  String get sectionCustomer => 'Client';

  @override
  String get selectCustomer => 'Sélectionner un client';

  @override
  String get addNewCustomerItem => '+ Ajouter un nouveau client';

  @override
  String get customerNameField => 'Nom du client *';

  @override
  String get phoneField => 'Téléphone *';

  @override
  String get phoneRequired => 'Le numéro de téléphone est requis';

  @override
  String get sectionService => 'Service';

  @override
  String get noServicesDefined =>
      'Aucun service défini.\nDéfinissez les services et les prix dans Profil > Services.';

  @override
  String get selectServiceField => 'Sélectionner un service *';

  @override
  String get serviceRequired => 'La sélection du service est requise';

  @override
  String get priceField => 'Prix *';

  @override
  String get priceRequired => 'Le prix est requis';

  @override
  String get priceInvalid => 'Saisissez un prix valide';

  @override
  String get sectionEmployee => 'Employé';

  @override
  String get selectEmployeeField => 'Sélectionner un employé *';

  @override
  String get employeeRequired => 'La sélection de l\'employé est requise';

  @override
  String get sectionDateTime => 'Date et heure';

  @override
  String get dateField => 'Date *';

  @override
  String get timeField => 'Heure *';

  @override
  String get sectionNote => 'Note';

  @override
  String get noteOptional => 'Note (facultative)';

  @override
  String get noteHint => 'Notes sur le rendez-vous...';

  @override
  String get saveAppointment => 'Enregistrer le rendez-vous';

  @override
  String get takePayment => 'Prendre le paiement';

  @override
  String appointmentPriceInfo(String amount) {
    return 'Prix du rendez-vous : $amount ₺';
  }

  @override
  String get amountReceived => 'Montant reçu (₺)';

  @override
  String remainingWillBeDebt(String amount) {
    return 'Les $amount ₺ restants seront enregistrés comme dette';
  }

  @override
  String get paymentMethodLabel => 'Méthode de paiement';

  @override
  String get allAsDebt => 'Tout en dette';

  @override
  String get complete => 'Terminer';

  @override
  String get financeTitle => 'Finances';

  @override
  String get statisticsTooltip => 'Statistiques';

  @override
  String get monthlyBalance => 'Bilan mensuel';

  @override
  String get income => 'Revenu';

  @override
  String get expense => 'Dépense';

  @override
  String get net => 'Net';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String receivablesLabel(int count) {
    return 'Créances ($count)';
  }

  @override
  String get recentTransactions => 'Transactions récentes';

  @override
  String get viewAllShort => 'Tout';

  @override
  String get addIncomeExpense => 'Ajouter revenu/dépense';

  @override
  String get amountField => 'Montant (₺)';

  @override
  String get categoryField => 'Catégorie';

  @override
  String get descriptionField => 'Description';

  @override
  String get enterValidAmount => 'Saisissez un montant valide';

  @override
  String get otherIncome => 'Autre revenu';

  @override
  String get otherExpense => 'Autre dépense';

  @override
  String get allTransactions => 'Toutes les transactions';

  @override
  String get incomes => 'Revenus';

  @override
  String get expenses => 'Dépenses';

  @override
  String get noTransactionsFound => 'Aucune transaction trouvée';

  @override
  String get debtorCustomers => 'Clients endettés';

  @override
  String get noDebtors => 'Aucun client endetté';

  @override
  String get totalReceivable => 'Total des créances';

  @override
  String customersCountShort(int count) {
    return '$count clients';
  }

  @override
  String openDebtCount(int count) {
    return '$count dettes ouvertes';
  }

  @override
  String get remindViaWhatsApp => 'Rappeler via WhatsApp';

  @override
  String reminderSentTo(String name) {
    return 'Rappel envoyé : $name';
  }

  @override
  String get reminderSendFailed =>
      'Le rappel n\'a pas pu être envoyé (vérifiez la connexion WhatsApp)';

  @override
  String get collectPayment => 'Encaisser';

  @override
  String remainingDebtInfo(String amount) {
    return 'Dette restante : $amount ₺';
  }

  @override
  String get collectedAmountField => 'Montant encaissé (₺)';

  @override
  String amountExceedsDebt(String amount) {
    return 'Le montant ne peut pas dépasser la dette restante ($amount ₺)';
  }

  @override
  String remainingTracked(String amount) {
    return 'Les $amount ₺ restants sont suivis comme dette';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '$amount ₺ encaissé, $left ₺ restants';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '$amount ₺ encaissé, dette soldée';
  }

  @override
  String get collectionFailed => 'L\'encaissement n\'a pas pu être enregistré';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ de dette';
  }

  @override
  String get statisticsTitle => 'Statistiques';

  @override
  String get periodWeek => 'Semaine';

  @override
  String get periodMonth => 'Mois';

  @override
  String get periodYear => 'Année';

  @override
  String get employeeFilter => 'Employé';

  @override
  String get noTransactionsInPeriod => 'Aucune transaction sur cette période';

  @override
  String get incomeTrend => 'Tendance des revenus';

  @override
  String get noIncomeRecords => 'Aucun enregistrement de revenu';

  @override
  String get paymentDistribution => 'Répartition par méthode de paiement';

  @override
  String get employeeEarnings => 'Gains des employés';

  @override
  String get unassigned => 'Non attribué';

  @override
  String get topServices => 'Services les plus rentables';

  @override
  String get topCustomers => 'Meilleurs clients';

  @override
  String get expenseItems => 'Postes de dépenses';

  @override
  String get employeeDebtsTitle => 'Dettes par employé';

  @override
  String get generalTitle => 'Général';

  @override
  String get noRecords => 'Aucun enregistrement';

  @override
  String get transactionCount => 'Nombre de transactions';

  @override
  String get avgTransaction => 'Transaction moyenne';

  @override
  String get incomeTransactionCount => 'Nombre de transactions de revenu';

  @override
  String get avgTransactionAmount => 'Montant moyen des transactions';

  @override
  String get appointmentsTotal => 'Rendez-vous (total)';

  @override
  String get completedAppointmentsStat => 'Rendez-vous terminés';

  @override
  String get cancelledAppointmentsStat => 'Rendez-vous annulés';

  @override
  String get cashRatio => 'Part en espèces';

  @override
  String get openDebtTotal => 'Total des dettes ouvertes';

  @override
  String get employeeDebtHint =>
      'Les dettes sont regroupées par l\'employé qui a effectué le travail. Appuyez sur une ligne pour lister les clients débiteurs.';

  @override
  String debtorCountLabel(int count) {
    return '$count clients débiteurs';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — clients débiteurs ($amount ₺)';
  }

  @override
  String get employeesTitle => 'Employés';

  @override
  String get addEmployee => 'Ajouter un employé';

  @override
  String get noEmployeesYet => 'Aucun employé ajouté';

  @override
  String get searchEmployeeHint => 'Rechercher nom, e-mail ou téléphone';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleEmployee => 'Employé';

  @override
  String get noMatchingEmployees => 'Aucun employé correspondant';

  @override
  String get makeEmployee => 'Rétrograder en employé';

  @override
  String get makeAdmin => 'Promouvoir admin';

  @override
  String get deleteEmployeeTitle => 'Supprimer l\'employé';

  @override
  String deleteEmployeeConfirm(String name) {
    return '$name sera supprimé. Cette action est irréversible.';
  }

  @override
  String get employeeDeleted => 'Employé supprimé';

  @override
  String get deleteFailed => 'Échec de la suppression';

  @override
  String get fullNameRequired => 'Le nom complet est requis';

  @override
  String get enterValidEmailInvite =>
      'Saisissez un e-mail valide — l\'employé se connectera avec le compte Google à cette adresse';

  @override
  String get fullNameField => 'Nom complet';

  @override
  String get phoneOnlyField => 'Téléphone';

  @override
  String get emailField => 'E-mail';

  @override
  String get roleField => 'Rôle';

  @override
  String employeeAddedInfo(String name, String email) {
    return '$name ajouté. Il peut se connecter avec le compte Google à $email et choisir l\'option \"Je suis employé\".';
  }

  @override
  String get employeeAddFailed => 'L\'employé n\'a pas pu être ajouté';

  @override
  String get customersTitle => 'Clients';

  @override
  String get addCustomerTooltip => 'Ajouter un client';

  @override
  String get searchCustomerHint => 'Rechercher nom, téléphone ou e-mail';

  @override
  String get filterDebtor => 'Avec dette';

  @override
  String get filterContacts => 'Des contacts';

  @override
  String get filterManual => 'Manuel';

  @override
  String customersCountLabel(int count) {
    return '$count clients';
  }

  @override
  String get noCustomersYet => 'Aucun client ajouté';

  @override
  String get noMatchingCustomers => 'Aucun client correspondant';

  @override
  String get addCustomerTitle => 'Ajouter un client';

  @override
  String get contactPermissionRequired =>
      'Permission d\'accès aux contacts requise';

  @override
  String get noContactsFound => 'Aucun contact trouvé';

  @override
  String get noContactsWithPhone => 'Aucun contact avec numéro de téléphone';

  @override
  String addedFromContacts(int count) {
    return '$count personnes ajoutées depuis les contacts';
  }

  @override
  String contactReadError(String error) {
    return 'Erreur de lecture des contacts : $error';
  }

  @override
  String get businessInfoMissing =>
      'Informations de l\'entreprise manquantes. Veuillez réessayer.';

  @override
  String customerAddedSuccess(String name) {
    return '$name ajouté avec succès';
  }

  @override
  String get customerAddError =>
      'Une erreur est survenue lors de l\'ajout du client';

  @override
  String get pickFromContacts =>
      'Ajouter depuis les contacts (sélection multiple)';

  @override
  String get loadingContacts => 'Chargement des contacts...';

  @override
  String get orEnterManually => 'ou saisir manuellement';

  @override
  String get fullNameStarField => 'Nom complet *';

  @override
  String get noteField => 'Note';

  @override
  String get pickContactTitle => 'Sélectionner dans les contacts';

  @override
  String selectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get searchNameOrPhone => 'Rechercher nom ou téléphone...';

  @override
  String get selectNone => 'Tout désélectionner';

  @override
  String selectAllCount(int count) {
    return 'Tout sélectionner ($count)';
  }

  @override
  String get noMatchingContacts =>
      'Aucun contact ne correspond à votre recherche';

  @override
  String get emptyList => 'La liste est vide';

  @override
  String addNPeople(int count) {
    return 'Ajouter $count personnes';
  }

  @override
  String get defineBusiness => 'Configurer votre entreprise';

  @override
  String get businessInfoTitle => 'Informations de l\'entreprise';

  @override
  String get businessSetupSubtitle =>
      'Configurez votre entreprise pour utiliser Esnaf Takvim';

  @override
  String get businessNameField => 'Nom de l\'entreprise';

  @override
  String get businessNameRequired => 'Le nom de l\'entreprise est requis';

  @override
  String get addressField => 'Adresse';

  @override
  String get emailInvalid => 'Saisissez un e-mail valide';

  @override
  String get workingHoursTitle => 'Heures de travail';

  @override
  String get workingDaysTitle => 'Jours de travail';

  @override
  String get opening => 'Ouverture';

  @override
  String get closing => 'Fermeture';

  @override
  String get saveAndStart => 'Enregistrer et démarrer';

  @override
  String get dayMon => 'Lundi';

  @override
  String get dayTue => 'Mardi';

  @override
  String get dayWed => 'Mercredi';

  @override
  String get dayThu => 'Jeudi';

  @override
  String get dayFri => 'Vendredi';

  @override
  String get daySat => 'Samedi';

  @override
  String get daySun => 'Dimanche';

  @override
  String get businessInfoUpdated =>
      'Informations de l\'entreprise mises à jour';

  @override
  String get updateFailed => 'Échec de la mise à jour';

  @override
  String get onlyOwnerCanEdit =>
      'Seul le propriétaire peut modifier ces informations.';

  @override
  String get workingHoursUpdated => 'Heures de travail mises à jour';

  @override
  String get profileTitle => 'Profil';

  @override
  String get userFallback => 'Utilisateur';

  @override
  String get whatsappSettings => 'Paramètres WhatsApp';

  @override
  String get servicesAndPrices => 'Services et prix';

  @override
  String get incomeExpenseCategories => 'Catégories de revenus/dépenses';

  @override
  String get messageTemplatesTitle => 'Modèles de messages';

  @override
  String get workingHoursMenu => 'Heures de travail';

  @override
  String get backupMenu => 'Sauvegarde';

  @override
  String get restoreMenu => 'Restaurer depuis la sauvegarde';

  @override
  String googleSignInFailed(String error) {
    return 'Échec de la connexion Google : $error';
  }

  @override
  String get backedUp => 'Sauvegardé ✅';

  @override
  String backupFailedMsg(String error) {
    return 'Erreur de sauvegarde : $error';
  }

  @override
  String restoreFailedMsg(String error) {
    return 'Erreur de restauration : $error';
  }

  @override
  String get backupDownloadedTitle => 'Sauvegarde téléchargée';

  @override
  String get backupDownloadedMessage =>
      'L\'application va maintenant se fermer pour terminer la restauration. À la réouverture, vos données seront restaurées depuis la sauvegarde.';

  @override
  String get autoBackupTitle => 'Sauvegarde automatique nocturne';

  @override
  String get autoBackupSubtitle =>
      'Sauvegarde sur Drive chaque nuit entre 02h00 et 03h00';

  @override
  String get aboutApp => 'À propos de l\'application';

  @override
  String get termsOfUse => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get categoriesTitle => 'Catégories de revenus/dépenses';

  @override
  String get incomeCategories => 'Catégories de revenus';

  @override
  String get expenseCategories => 'Catégories de dépenses';

  @override
  String get addIncomeCategory => 'Ajouter une catégorie de revenu';

  @override
  String get addExpenseCategory => 'Ajouter une catégorie de dépense';

  @override
  String get categoryNameField => 'Nom de la catégorie';

  @override
  String get categoryExists => 'Cette catégorie existe déjà';

  @override
  String get categoryAddFailed => 'La catégorie n\'a pas pu être ajoutée';

  @override
  String get deleteCategoryTitle => 'Supprimer la catégorie';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\" sera supprimée. Les transactions passées ne sont pas affectées.';
  }

  @override
  String get noCategories => 'Aucune catégorie';

  @override
  String get availableVariables => 'Variables disponibles';

  @override
  String get templateHelp =>
      'Ces variables sont remplacées par les détails du rendez-vous lors de l\'envoi. Si vous videz complètement un modèle, ce message n\'est jamais envoyé.';

  @override
  String get emptyToDisable => 'Laissez vide pour ne pas envoyer ce message';

  @override
  String get resetToDefault => 'Réinitialiser par défaut';

  @override
  String get templatesSaved => 'Modèles enregistrés';

  @override
  String get templatesSaveFailed =>
      'Les modèles n\'ont pas pu être enregistrés';

  @override
  String get templatesLoadFailed => 'Les modèles n\'ont pas pu être chargés';

  @override
  String get templatesServerNote =>
      'Les modèles sont stockés sur le serveur WhatsApp ; une connexion est requise.';

  @override
  String get debtReminderFrequency => 'Fréquence de rappel de dette';

  @override
  String get debtReminderFrequencyHelp =>
      'Le modèle \"Rappel de dette\" est envoyé automatiquement aux clients endettés à la fréquence choisie (entre 10h00 et 20h00).';

  @override
  String get freqOff => 'Désactivé';

  @override
  String get freqDaily => 'Une fois par jour';

  @override
  String get freqWeekly => 'Une fois par semaine';

  @override
  String get freqMonthly => 'Une fois par mois';

  @override
  String get languageLabel => 'Langue';

  @override
  String get languageSystemDefault => 'Par défaut du système';

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
