// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Randevu 360';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get add => 'Добавить';

  @override
  String get ok => 'ОК';

  @override
  String get retry => 'Повторить';

  @override
  String get all => 'Все';

  @override
  String get errorTitle => 'Ошибка';

  @override
  String get pressBackAgainToExit => 'Нажмите ещё раз для выхода';

  @override
  String get appTagline => 'Управление записями\nдля малого бизнеса';

  @override
  String get signInWithGoogle => 'Войти через Google';

  @override
  String get termsNotice => 'Входя, вы принимаете Условия использования';

  @override
  String welcomeUser(String name) {
    return 'Добро пожаловать,\n$name';
  }

  @override
  String get howToContinue => 'Как хотите продолжить?';

  @override
  String get roleOwnerTitle => 'Я владелец бизнеса';

  @override
  String get roleOwnerSubtitle =>
      'Создать новый бизнес или управлять существующим';

  @override
  String get roleEmployeeTitle => 'Я сотрудник';

  @override
  String get roleEmployeeSubtitle =>
      'Получить доступ к аккаунту по приглашению владельца';

  @override
  String get useDifferentAccount => 'Использовать другой аккаунт';

  @override
  String get notSignedInTitle => 'Не выполнен вход';

  @override
  String get notSignedInMessage =>
      'Пожалуйста, сначала войдите через Google аккаунт.';

  @override
  String get inviteNotFoundTitle => 'Приглашение не найдено';

  @override
  String get inviteNotFoundMessage =>
      'Для этого адреса эл. почты приглашение не найдено.\n\nПопросите владельца бизнеса добавить вас в систему.';

  @override
  String get invalidBusinessInfo => 'Информация о бизнесе недействительна.';

  @override
  String businessRecordFailed(String error) {
    return 'Не удалось создать запись бизнеса: $error';
  }

  @override
  String get connectionErrorTitle => 'Ошибка подключения';

  @override
  String get inviteCheckFailed =>
      'Не удалось проверить приглашение сотрудника. Проверьте подключение к Интернету и попробуйте снова.';

  @override
  String get tabHome => 'Главная';

  @override
  String get tabAppointments => 'Записи';

  @override
  String get tabCustomers => 'Клиенты';

  @override
  String get tabFinance => 'Финансы';

  @override
  String get tabEmployees => 'Сотрудники';

  @override
  String get tabProfile => 'Профиль';

  @override
  String greetingHello(String name) {
    return 'Здравствуйте, $name';
  }

  @override
  String get greetingSubtitle => 'Готовы управлять бизнесом';

  @override
  String get statToday => 'Сегодня';

  @override
  String get statCompleted => 'Выполнено';

  @override
  String get statPending => 'Ожидают';

  @override
  String get statTotalCustomers => 'Всего клиентов';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get quickNewAppointment => 'Новая запись';

  @override
  String get quickAddCustomer => 'Добавить клиента';

  @override
  String get quickBulkMessage => 'Массовая рассылка';

  @override
  String get whatsappConnection => 'Подключение WhatsApp';

  @override
  String get waConnected => 'Подключено';

  @override
  String get waPairing => 'Сопряжение...';

  @override
  String get waNotConnected => 'Ещё не подключено';

  @override
  String get manage => 'Управление';

  @override
  String get connect => 'Подключить';

  @override
  String get todaysAppointments => 'Записи на сегодня';

  @override
  String get noAppointmentsToday => 'На сегодня записей нет';

  @override
  String get customerFallback => 'Клиент';

  @override
  String get statusConfirmed => 'Подтверждено';

  @override
  String get statusCompleted => 'Завершено';

  @override
  String get statusCancelled => 'Отменено';

  @override
  String get statusPending => 'Ожидает';

  @override
  String get statusShortConfirmed => 'Подтв.';

  @override
  String get statusShortCompleted => 'Готово';

  @override
  String get statusShortCancelled => 'Отмен.';

  @override
  String get statusShortPending => 'Ожид.';

  @override
  String get appointmentsTitle => 'Записи';

  @override
  String appointmentCountLabel(int count) {
    return '$count записей';
  }

  @override
  String get allEmployees => 'Все сотрудники';

  @override
  String get noAppointmentsThisDay => 'В этот день записей нет';

  @override
  String get addAppointment => 'Добавить запись';

  @override
  String get appointmentDetail => 'Детали записи';

  @override
  String get customerLabel => 'Клиент';

  @override
  String get dateLabel => 'Дата';

  @override
  String get timeLabel => 'Время';

  @override
  String get serviceLabel => 'Услуга';

  @override
  String get priceLabel => 'Цена';

  @override
  String get noteLabel => 'Заметка';

  @override
  String get completedPaidNote => 'Завершено, оплата получена';

  @override
  String get cancelAppointment => 'Отменить';

  @override
  String get markCompleted => 'Завершено';

  @override
  String get appointmentCancelled => 'Запись отменена';

  @override
  String get appointmentCancelFailed => 'Не удалось отменить запись';

  @override
  String collectedSummary(String amount, String method) {
    return '$amount ₺ получено $method';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ записано как долг';
  }

  @override
  String get appointmentCompletedMsg => 'Запись завершена';

  @override
  String get paymentSaveFailed => 'Не удалось сохранить платёж';

  @override
  String get paymentCash => 'Наличные';

  @override
  String get paymentCard => 'Карта';

  @override
  String get paymentTransfer => 'Перевод';

  @override
  String get paymentCashLower => 'наличные';

  @override
  String get paymentCardLower => 'карта';

  @override
  String get newAppointment => 'Новая запись';

  @override
  String get businessInfoNotFound => 'Информация о бизнесе не найдена';

  @override
  String get appointmentCreateFailed => 'Не удалось создать запись';

  @override
  String get appointmentCreated => 'Запись успешно создана';

  @override
  String get customerPhoneRequired => 'Требуется телефон клиента';

  @override
  String get customerNameRequired => 'Требуется имя клиента';

  @override
  String get customerCreateFailed => 'Не удалось создать клиента';

  @override
  String get sectionCustomer => 'Клиент';

  @override
  String get selectCustomer => 'Выберите клиента';

  @override
  String get addNewCustomerItem => '+ Добавить нового клиента';

  @override
  String get customerNameField => 'Имя клиента *';

  @override
  String get phoneField => 'Телефон *';

  @override
  String get phoneRequired => 'Требуется номер телефона';

  @override
  String get sectionService => 'Услуга';

  @override
  String get noServicesDefined =>
      'Услуги ещё не определены.\nОпределите услуги и цены в Профиль > Услуги.';

  @override
  String get selectServiceField => 'Выберите услугу *';

  @override
  String get serviceRequired => 'Требуется выбор услуги';

  @override
  String get priceField => 'Цена *';

  @override
  String get priceRequired => 'Требуется цена';

  @override
  String get priceInvalid => 'Введите корректную цену';

  @override
  String get sectionEmployee => 'Сотрудник';

  @override
  String get selectEmployeeField => 'Выберите сотрудника *';

  @override
  String get employeeRequired => 'Требуется выбор сотрудника';

  @override
  String get sectionDateTime => 'Дата и время';

  @override
  String get dateField => 'Дата *';

  @override
  String get timeField => 'Время *';

  @override
  String get sectionNote => 'Заметка';

  @override
  String get noteOptional => 'Заметка (необязательно)';

  @override
  String get noteHint => 'Заметки о записи...';

  @override
  String get saveAppointment => 'Сохранить запись';

  @override
  String get takePayment => 'Принять оплату';

  @override
  String appointmentPriceInfo(String amount) {
    return 'Стоимость записи: $amount ₺';
  }

  @override
  String get amountReceived => 'Полученная сумма (₺)';

  @override
  String remainingWillBeDebt(String amount) {
    return 'Остаток $amount ₺ будет записан как долг';
  }

  @override
  String get paymentMethodLabel => 'Способ оплаты';

  @override
  String get allAsDebt => 'Всё в долг';

  @override
  String get complete => 'Завершить';

  @override
  String get financeTitle => 'Финансы';

  @override
  String get statisticsTooltip => 'Статистика';

  @override
  String get monthlyBalance => 'Месячный баланс';

  @override
  String get income => 'Доход';

  @override
  String get expense => 'Расход';

  @override
  String get net => 'Чистый';

  @override
  String get thisWeek => 'Эта неделя';

  @override
  String receivablesLabel(int count) {
    return 'Дебиторы ($count)';
  }

  @override
  String get recentTransactions => 'Последние операции';

  @override
  String get viewAllShort => 'Все';

  @override
  String get addIncomeExpense => 'Добавить доход/расход';

  @override
  String get amountField => 'Сумма (₺)';

  @override
  String get categoryField => 'Категория';

  @override
  String get descriptionField => 'Описание';

  @override
  String get enterValidAmount => 'Введите корректную сумму';

  @override
  String get otherIncome => 'Прочий доход';

  @override
  String get otherExpense => 'Прочий расход';

  @override
  String get allTransactions => 'Все операции';

  @override
  String get incomes => 'Доходы';

  @override
  String get expenses => 'Расходы';

  @override
  String get noTransactionsFound => 'Операции не найдены';

  @override
  String get debtorCustomers => 'Клиенты с долгами';

  @override
  String get noDebtors => 'Нет клиентов с долгами';

  @override
  String get totalReceivable => 'Всего к получению';

  @override
  String customersCountShort(int count) {
    return '$count клиентов';
  }

  @override
  String openDebtCount(int count) {
    return '$count открытых долгов';
  }

  @override
  String get remindViaWhatsApp => 'Напомнить через WhatsApp';

  @override
  String reminderSentTo(String name) {
    return 'Напоминание отправлено: $name';
  }

  @override
  String get reminderSendFailed =>
      'Не удалось отправить напоминание (проверьте подключение WhatsApp)';

  @override
  String get collectPayment => 'Получить';

  @override
  String remainingDebtInfo(String amount) {
    return 'Остаток долга: $amount ₺';
  }

  @override
  String get collectedAmountField => 'Полученная сумма (₺)';

  @override
  String amountExceedsDebt(String amount) {
    return 'Сумма не может превышать остаток долга ($amount ₺)';
  }

  @override
  String remainingTracked(String amount) {
    return 'Остаток $amount ₺ отслеживается как долг';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '$amount ₺ получено, осталось $left ₺';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '$amount ₺ получено, долг погашен';
  }

  @override
  String get collectionFailed => 'Не удалось сохранить получение';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ долг';
  }

  @override
  String get statisticsTitle => 'Статистика';

  @override
  String get periodWeek => 'Неделя';

  @override
  String get periodMonth => 'Месяц';

  @override
  String get periodYear => 'Год';

  @override
  String get employeeFilter => 'Сотрудник';

  @override
  String get noTransactionsInPeriod => 'Нет операций за этот период';

  @override
  String get incomeTrend => 'Динамика доходов';

  @override
  String get noIncomeRecords => 'Нет записей о доходах';

  @override
  String get paymentDistribution => 'Распределение способов оплаты';

  @override
  String get employeeEarnings => 'Заработок сотрудников';

  @override
  String get unassigned => 'Не назначено';

  @override
  String get topServices => 'Самые прибыльные услуги';

  @override
  String get topCustomers => 'Лучшие клиенты';

  @override
  String get expenseItems => 'Статьи расходов';

  @override
  String get employeeDebtsTitle => 'Долги по сотрудникам';

  @override
  String get generalTitle => 'Общее';

  @override
  String get noRecords => 'Нет записей';

  @override
  String get transactionCount => 'Количество операций';

  @override
  String get avgTransaction => 'Средняя операция';

  @override
  String get incomeTransactionCount => 'Количество доходных операций';

  @override
  String get avgTransactionAmount => 'Средняя сумма операции';

  @override
  String get appointmentsTotal => 'Записей (всего)';

  @override
  String get completedAppointmentsStat => 'Завершённых записей';

  @override
  String get cancelledAppointmentsStat => 'Отменённых записей';

  @override
  String get cashRatio => 'Доля наличных';

  @override
  String get openDebtTotal => 'Всего открытых долгов';

  @override
  String get employeeDebtHint =>
      'Долги сгруппированы по сотруднику, выполнившему работу. Нажмите на строку, чтобы увидеть клиентов-должников.';

  @override
  String debtorCountLabel(int count) {
    return '$count клиентов-должников';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — клиенты-должники ($amount ₺)';
  }

  @override
  String get employeesTitle => 'Сотрудники';

  @override
  String get addEmployee => 'Добавить сотрудника';

  @override
  String get noEmployeesYet => 'Сотрудники ещё не добавлены';

  @override
  String get searchEmployeeHint => 'Поиск по имени, эл. почте или телефону';

  @override
  String get roleAdmin => 'Админ';

  @override
  String get roleEmployee => 'Сотрудник';

  @override
  String get noMatchingEmployees => 'Нет подходящих сотрудников';

  @override
  String get makeEmployee => 'Сделать сотрудником';

  @override
  String get makeAdmin => 'Сделать админом';

  @override
  String get deleteEmployeeTitle => 'Удалить сотрудника';

  @override
  String deleteEmployeeConfirm(String name) {
    return '$name будет удалён. Это действие необратимо.';
  }

  @override
  String get employeeDeleted => 'Сотрудник удалён';

  @override
  String get deleteFailed => 'Не удалось удалить';

  @override
  String get fullNameRequired => 'Требуется полное имя';

  @override
  String get enterValidEmailInvite =>
      'Введите корректный эл. адрес — сотрудник войдёт через Google аккаунт с этим адресом';

  @override
  String get fullNameField => 'Полное имя';

  @override
  String get phoneOnlyField => 'Телефон';

  @override
  String get emailField => 'Эл. почта';

  @override
  String get roleField => 'Роль';

  @override
  String employeeAddedInfo(String name, String email) {
    return '$name добавлен. Может войти через Google аккаунт $email и выбрать опцию «Я сотрудник».';
  }

  @override
  String get employeeAddFailed => 'Не удалось добавить сотрудника';

  @override
  String get customersTitle => 'Клиенты';

  @override
  String get addCustomerTooltip => 'Добавить клиента';

  @override
  String get searchCustomerHint => 'Поиск по имени, телефону или эл. почте';

  @override
  String get filterDebtor => 'С долгом';

  @override
  String get filterContacts => 'Из контактов';

  @override
  String get filterManual => 'Вручную';

  @override
  String customersCountLabel(int count) {
    return '$count клиентов';
  }

  @override
  String get noCustomersYet => 'Клиенты ещё не добавлены';

  @override
  String get noMatchingCustomers => 'Нет подходящих клиентов';

  @override
  String get addCustomerTitle => 'Добавить клиента';

  @override
  String get contactPermissionRequired =>
      'Требуется разрешение на доступ к контактам';

  @override
  String get noContactsFound => 'Контакты не найдены';

  @override
  String get noContactsWithPhone => 'Нет контактов с номером телефона';

  @override
  String addedFromContacts(int count) {
    return '$count человек добавлено из контактов';
  }

  @override
  String contactReadError(String error) {
    return 'Ошибка чтения контактов: $error';
  }

  @override
  String get businessInfoMissing =>
      'Информация о бизнесе отсутствует. Пожалуйста, попробуйте снова.';

  @override
  String customerAddedSuccess(String name) {
    return '$name успешно добавлен';
  }

  @override
  String get customerAddError => 'Произошла ошибка при добавлении клиента';

  @override
  String get pickFromContacts => 'Добавить из контактов (множественный выбор)';

  @override
  String get loadingContacts => 'Загрузка контактов...';

  @override
  String get orEnterManually => 'или введите вручную';

  @override
  String get fullNameStarField => 'Полное имя *';

  @override
  String get noteField => 'Заметка';

  @override
  String get pickContactTitle => 'Выбрать из контактов';

  @override
  String selectedCount(int count) {
    return '$count выбрано';
  }

  @override
  String get searchNameOrPhone => 'Поиск по имени или телефону...';

  @override
  String get selectNone => 'Снять всё';

  @override
  String selectAllCount(int count) {
    return 'Выбрать всё ($count)';
  }

  @override
  String get noMatchingContacts => 'Нет контактов, соответствующих поиску';

  @override
  String get emptyList => 'Список пуст';

  @override
  String addNPeople(int count) {
    return 'Добавить $count чел.';
  }

  @override
  String get defineBusiness => 'Настройте ваш бизнес';

  @override
  String get businessInfoTitle => 'Информация о бизнесе';

  @override
  String get businessSetupSubtitle =>
      'Настройте ваш бизнес для использования Randevu 360';

  @override
  String get businessNameField => 'Название бизнеса';

  @override
  String get businessNameRequired => 'Требуется название бизнеса';

  @override
  String get addressField => 'Адрес';

  @override
  String get emailInvalid => 'Введите корректный эл. адрес';

  @override
  String get workingHoursTitle => 'Часы работы';

  @override
  String get workingDaysTitle => 'Рабочие дни';

  @override
  String get opening => 'Открытие';

  @override
  String get closing => 'Закрытие';

  @override
  String get saveAndStart => 'Сохранить и начать';

  @override
  String get dayMon => 'Понедельник';

  @override
  String get dayTue => 'Вторник';

  @override
  String get dayWed => 'Среда';

  @override
  String get dayThu => 'Четверг';

  @override
  String get dayFri => 'Пятница';

  @override
  String get daySat => 'Суббота';

  @override
  String get daySun => 'Воскресенье';

  @override
  String get businessInfoUpdated => 'Информация о бизнесе обновлена';

  @override
  String get updateFailed => 'Не удалось обновить';

  @override
  String get onlyOwnerCanEdit =>
      'Только владелец бизнеса может изменять эту информацию.';

  @override
  String get workingHoursUpdated => 'Часы работы обновлены';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get userFallback => 'Пользователь';

  @override
  String get whatsappSettings => 'Настройки WhatsApp';

  @override
  String get servicesAndPrices => 'Услуги и цены';

  @override
  String get incomeExpenseCategories => 'Категории доходов/расходов';

  @override
  String get messageTemplatesTitle => 'Шаблоны сообщений';

  @override
  String get workingHoursMenu => 'Часы работы';

  @override
  String get backupMenu => 'Резервная копия';

  @override
  String get restoreMenu => 'Восстановить из копии';

  @override
  String googleSignInFailed(String error) {
    return 'Вход через Google не удался: $error';
  }

  @override
  String get backedUp => 'Сохранено ✅';

  @override
  String backupFailedMsg(String error) {
    return 'Ошибка резервного копирования: $error';
  }

  @override
  String restoreFailedMsg(String error) {
    return 'Ошибка восстановления: $error';
  }

  @override
  String get backupDownloadedTitle => 'Резервная копия загружена';

  @override
  String get backupDownloadedMessage =>
      'Приложение сейчас закроется для завершения восстановления. При повторном открытии ваши данные будут восстановлены из резервной копии.';

  @override
  String get autoBackupTitle => 'Автоматическое ночное резервное копирование';

  @override
  String get autoBackupSubtitle =>
      'Создаёт резервную копию на Drive каждую ночь с 02:00 до 03:00';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get signOut => 'Выйти';

  @override
  String get categoriesTitle => 'Категории доходов/расходов';

  @override
  String get incomeCategories => 'Категории доходов';

  @override
  String get expenseCategories => 'Категории расходов';

  @override
  String get addIncomeCategory => 'Добавить категорию дохода';

  @override
  String get addExpenseCategory => 'Добавить категорию расхода';

  @override
  String get categoryNameField => 'Название категории';

  @override
  String get categoryExists => 'Эта категория уже существует';

  @override
  String get categoryAddFailed => 'Не удалось добавить категорию';

  @override
  String get deleteCategoryTitle => 'Удалить категорию';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\" будет удалена. Прошлые операции не затрагиваются.';
  }

  @override
  String get noCategories => 'Нет категорий';

  @override
  String get availableVariables => 'Доступные переменные';

  @override
  String get templateHelp =>
      'Эти переменные заменяются деталями записи при отправке. Если вы полностью очистите шаблон, это сообщение никогда не будет отправлено.';

  @override
  String get emptyToDisable =>
      'Оставьте пустым, чтобы не отправлять это сообщение';

  @override
  String get resetToDefault => 'Сбросить по умолчанию';

  @override
  String get templatesSaved => 'Шаблоны сохранены';

  @override
  String get templatesSaveFailed => 'Не удалось сохранить шаблоны';

  @override
  String get templatesLoadFailed => 'Не удалось загрузить шаблоны';

  @override
  String get templatesServerNote =>
      'Шаблоны хранятся на сервере WhatsApp; требуется подключение.';

  @override
  String get debtReminderFrequency => 'Частота напоминаний о долге';

  @override
  String get debtReminderFrequencyHelp =>
      'Шаблон «Напоминание о долге» отправляется автоматически клиентам с долгами с выбранной частотой (с 10:00 до 20:00).';

  @override
  String get freqOff => 'Выкл';

  @override
  String get freqDaily => 'Раз в день';

  @override
  String get freqWeekly => 'Раз в неделю';

  @override
  String get freqMonthly => 'Раз в месяц';

  @override
  String get languageLabel => 'Язык';

  @override
  String get languageSystemDefault => 'Язык системы';
}
