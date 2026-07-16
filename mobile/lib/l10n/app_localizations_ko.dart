// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Randevu 360';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get add => '추가';

  @override
  String get ok => '확인';

  @override
  String get retry => '다시 시도';

  @override
  String get all => '전체';

  @override
  String get errorTitle => '오류';

  @override
  String get pressBackAgainToExit => '한 번 더 누르면 종료됩니다';

  @override
  String get appTagline => '소규모 비즈니스를 위한\n예약 관리';

  @override
  String get signInWithGoogle => 'Google로 로그인';

  @override
  String get termsNotice => '로그인하면 이용약관에 동의하는 것으로 간주됩니다';

  @override
  String welcomeUser(String name) {
    return '환영합니다,\n$name';
  }

  @override
  String get howToContinue => '어떻게 진행하시겠습니까?';

  @override
  String get roleOwnerTitle => '사업주입니다';

  @override
  String get roleOwnerSubtitle => '새 비즈니스를 만들거나 기존 비즈니스를 관리합니다';

  @override
  String get roleEmployeeTitle => '직원입니다';

  @override
  String get roleEmployeeSubtitle => '사업주의 초대로 내 계정에 접근합니다';

  @override
  String get useDifferentAccount => '다른 계정 사용';

  @override
  String get notSignedInTitle => '로그인되지 않음';

  @override
  String get notSignedInMessage => '먼저 Google 계정으로 로그인하세요.';

  @override
  String get inviteNotFoundTitle => '초대를 찾을 수 없음';

  @override
  String get inviteNotFoundMessage =>
      '이 이메일 주소에 대한 초대를 찾을 수 없습니다.\n\n사업주에게 시스템에 추가해 달라고 요청하세요.';

  @override
  String get invalidBusinessInfo => '비즈니스 정보가 유효하지 않습니다.';

  @override
  String businessRecordFailed(String error) {
    return '비즈니스 기록을 생성할 수 없습니다: $error';
  }

  @override
  String get connectionErrorTitle => '연결 오류';

  @override
  String get inviteCheckFailed => '직원 초대를 확인할 수 없습니다. 인터넷 연결을 확인하고 다시 시도하세요.';

  @override
  String get tabHome => '홈';

  @override
  String get tabAppointments => '예약';

  @override
  String get tabCustomers => '고객';

  @override
  String get tabFinance => '재무';

  @override
  String get tabEmployees => '직원';

  @override
  String get tabProfile => '프로필';

  @override
  String greetingHello(String name) {
    return '안녕하세요 $name';
  }

  @override
  String get greetingSubtitle => '비즈니스 관리 준비 완료';

  @override
  String get statToday => '오늘';

  @override
  String get statCompleted => '완료됨';

  @override
  String get statPending => '대기 중';

  @override
  String get statTotalCustomers => '전체 고객';

  @override
  String get quickActions => '빠른 작업';

  @override
  String get quickNewAppointment => '새 예약';

  @override
  String get quickAddCustomer => '고객 추가';

  @override
  String get quickBulkMessage => '단체 메시지';

  @override
  String get whatsappConnection => 'WhatsApp 연결';

  @override
  String get waConnected => '연결됨';

  @override
  String get waPairing => '페어링 중...';

  @override
  String get waNotConnected => '아직 연결 안 됨';

  @override
  String get manage => '관리';

  @override
  String get connect => '연결';

  @override
  String get todaysAppointments => '오늘의 예약';

  @override
  String get noAppointmentsToday => '오늘 예약 없음';

  @override
  String get customerFallback => '고객';

  @override
  String get statusConfirmed => '확정됨';

  @override
  String get statusCompleted => '완료됨';

  @override
  String get statusCancelled => '취소됨';

  @override
  String get statusPending => '대기 중';

  @override
  String get statusShortConfirmed => '확정';

  @override
  String get statusShortCompleted => '완료';

  @override
  String get statusShortCancelled => '취소';

  @override
  String get statusShortPending => '대기';

  @override
  String get appointmentsTitle => '예약';

  @override
  String appointmentCountLabel(int count) {
    return '$count개 예약';
  }

  @override
  String get allEmployees => '전체 직원';

  @override
  String get noAppointmentsThisDay => '이 날짜에 예약 없음';

  @override
  String get addAppointment => '예약 추가';

  @override
  String get appointmentDetail => '예약 상세';

  @override
  String get customerLabel => '고객';

  @override
  String get dateLabel => '날짜';

  @override
  String get timeLabel => '시간';

  @override
  String get serviceLabel => '서비스';

  @override
  String get priceLabel => '가격';

  @override
  String get noteLabel => '메모';

  @override
  String get completedPaidNote => '완료됨, 결제 수령 완료';

  @override
  String get cancelAppointment => '취소';

  @override
  String get markCompleted => '완료됨';

  @override
  String get appointmentCancelled => '예약이 취소되었습니다';

  @override
  String get appointmentCancelFailed => '예약을 취소할 수 없습니다';

  @override
  String collectedSummary(String amount, String method) {
    return '$amount ₺ 수금 완료 ($method)';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ 부채로 기록됨';
  }

  @override
  String get appointmentCompletedMsg => '예약 완료됨';

  @override
  String get paymentSaveFailed => '결제를 저장할 수 없습니다';

  @override
  String get paymentCash => '현금';

  @override
  String get paymentCard => '카드';

  @override
  String get paymentTransfer => '이체';

  @override
  String get paymentCashLower => '현금';

  @override
  String get paymentCardLower => '카드';

  @override
  String get newAppointment => '새 예약';

  @override
  String get businessInfoNotFound => '비즈니스 정보를 찾을 수 없음';

  @override
  String get appointmentCreateFailed => '예약을 생성할 수 없습니다';

  @override
  String get appointmentCreated => '예약이 생성되었습니다';

  @override
  String get customerPhoneRequired => '고객 전화번호가 필요합니다';

  @override
  String get customerNameRequired => '고객 이름이 필요합니다';

  @override
  String get customerCreateFailed => '고객을 생성할 수 없습니다';

  @override
  String get sectionCustomer => '고객';

  @override
  String get selectCustomer => '고객 선택';

  @override
  String get addNewCustomerItem => '+ 새 고객 추가';

  @override
  String get customerNameField => '고객 이름 *';

  @override
  String get phoneField => '전화번호 *';

  @override
  String get phoneRequired => '전화번호가 필요합니다';

  @override
  String get sectionService => '서비스';

  @override
  String get noServicesDefined => '정의된 서비스가 없습니다.\n프로필 > 서비스에서 서비스와 가격을 정의하세요.';

  @override
  String get selectServiceField => '서비스 선택 *';

  @override
  String get serviceRequired => '서비스 선택이 필요합니다';

  @override
  String get priceField => '가격 *';

  @override
  String get priceRequired => '가격이 필요합니다';

  @override
  String get priceInvalid => '유효한 가격을 입력하세요';

  @override
  String get sectionEmployee => '직원';

  @override
  String get selectEmployeeField => '직원 선택 *';

  @override
  String get employeeRequired => '직원 선택이 필요합니다';

  @override
  String get sectionDateTime => '날짜 및 시간';

  @override
  String get dateField => '날짜 *';

  @override
  String get timeField => '시간 *';

  @override
  String get sectionNote => '메모';

  @override
  String get noteOptional => '메모 (선택사항)';

  @override
  String get noteHint => '예약 관련 메모...';

  @override
  String get saveAppointment => '예약 저장';

  @override
  String get takePayment => '결제 수령';

  @override
  String appointmentPriceInfo(String amount) {
    return '예약 가격: $amount ₺';
  }

  @override
  String get amountReceived => '수령 금액 (₺)';

  @override
  String remainingWillBeDebt(String amount) {
    return '남은 $amount ₺ 부채로 기록됨';
  }

  @override
  String get paymentMethodLabel => '결제 방법';

  @override
  String get allAsDebt => '전체 부채 처리';

  @override
  String get complete => '완료';

  @override
  String get financeTitle => '재무';

  @override
  String get statisticsTooltip => '통계';

  @override
  String get monthlyBalance => '월간 잔고';

  @override
  String get income => '수입';

  @override
  String get expense => '지출';

  @override
  String get net => '순이익';

  @override
  String get thisWeek => '이번 주';

  @override
  String receivablesLabel(int count) {
    return '미수금 ($count)';
  }

  @override
  String get recentTransactions => '최근 거래';

  @override
  String get viewAllShort => '전체';

  @override
  String get addIncomeExpense => '수입/지출 추가';

  @override
  String get amountField => '금액 (₺)';

  @override
  String get categoryField => '카테고리';

  @override
  String get descriptionField => '설명';

  @override
  String get enterValidAmount => '유효한 금액을 입력하세요';

  @override
  String get otherIncome => '기타 수입';

  @override
  String get otherExpense => '기타 지출';

  @override
  String get allTransactions => '전체 거래';

  @override
  String get incomes => '수입';

  @override
  String get expenses => '지출';

  @override
  String get noTransactionsFound => '거래를 찾을 수 없음';

  @override
  String get debtorCustomers => '부채 고객';

  @override
  String get noDebtors => '부채 고객 없음';

  @override
  String get totalReceivable => '총 미수금';

  @override
  String customersCountShort(int count) {
    return '$count명 고객';
  }

  @override
  String openDebtCount(int count) {
    return '$count건 미결 부채';
  }

  @override
  String get remindViaWhatsApp => 'WhatsApp으로 알림';

  @override
  String reminderSentTo(String name) {
    return '알림 전송 완료: $name';
  }

  @override
  String get reminderSendFailed => '알림을 보낼 수 없습니다 (WhatsApp 연결 확인)';

  @override
  String get collectPayment => '수금';

  @override
  String remainingDebtInfo(String amount) {
    return '남은 부채: $amount ₺';
  }

  @override
  String get collectedAmountField => '수금 금액 (₺)';

  @override
  String amountExceedsDebt(String amount) {
    return '금액이 남은 부채를 초과할 수 없습니다 ($amount ₺)';
  }

  @override
  String remainingTracked(String amount) {
    return '남은 $amount ₺ 부채로 추적됨';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '$amount ₺ 수금, $left ₺ 남음';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '$amount ₺ 수금, 부채 완납';
  }

  @override
  String get collectionFailed => '수금을 저장할 수 없습니다';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ 부채';
  }

  @override
  String get statisticsTitle => '통계';

  @override
  String get periodWeek => '주';

  @override
  String get periodMonth => '월';

  @override
  String get periodYear => '년';

  @override
  String get employeeFilter => '직원';

  @override
  String get noTransactionsInPeriod => '이 기간에 거래 없음';

  @override
  String get incomeTrend => '수입 추세';

  @override
  String get noIncomeRecords => '수입 기록 없음';

  @override
  String get paymentDistribution => '결제 방법 분포';

  @override
  String get employeeEarnings => '직원 수익';

  @override
  String get unassigned => '미지정';

  @override
  String get topServices => '최고 수익 서비스';

  @override
  String get topCustomers => '최우수 고객';

  @override
  String get expenseItems => '지출 항목';

  @override
  String get employeeDebtsTitle => '직원별 부채';

  @override
  String get generalTitle => '일반';

  @override
  String get noRecords => '기록 없음';

  @override
  String get transactionCount => '거래 건수';

  @override
  String get avgTransaction => '평균 거래';

  @override
  String get incomeTransactionCount => '수입 거래 건수';

  @override
  String get avgTransactionAmount => '평균 거래 금액';

  @override
  String get appointmentsTotal => '예약 (전체)';

  @override
  String get completedAppointmentsStat => '완료된 예약';

  @override
  String get cancelledAppointmentsStat => '취소된 예약';

  @override
  String get cashRatio => '현금 비율';

  @override
  String get openDebtTotal => '미결 부채 총액';

  @override
  String get employeeDebtHint =>
      '부채는 작업을 수행한 직원별로 그룹화됩니다. 행을 탭하면 부채 고객이 나열됩니다.';

  @override
  String debtorCountLabel(int count) {
    return '$count명 부채 고객';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — 부채 고객 ($amount ₺)';
  }

  @override
  String get employeesTitle => '직원';

  @override
  String get addEmployee => '직원 추가';

  @override
  String get noEmployeesYet => '아직 추가된 직원 없음';

  @override
  String get searchEmployeeHint => '이름, 이메일 또는 전화번호 검색';

  @override
  String get roleAdmin => '관리자';

  @override
  String get roleEmployee => '직원';

  @override
  String get noMatchingEmployees => '일치하는 직원 없음';

  @override
  String get makeEmployee => '직원으로 변경';

  @override
  String get makeAdmin => '관리자로 변경';

  @override
  String get deleteEmployeeTitle => '직원 삭제';

  @override
  String deleteEmployeeConfirm(String name) {
    return '$name님이 삭제됩니다. 이 작업은 취소할 수 없습니다.';
  }

  @override
  String get employeeDeleted => '직원이 삭제되었습니다';

  @override
  String get deleteFailed => '삭제 실패';

  @override
  String get fullNameRequired => '전체 이름이 필요합니다';

  @override
  String get enterValidEmailInvite =>
      '유효한 이메일을 입력하세요 — 직원은 이 주소의 Google 계정으로 로그인합니다';

  @override
  String get fullNameField => '전체 이름';

  @override
  String get phoneOnlyField => '전화번호';

  @override
  String get emailField => '이메일';

  @override
  String get roleField => '역할';

  @override
  String employeeAddedInfo(String name, String email) {
    return '$name님이 추가되었습니다. $email의 Google 계정으로 로그인하여 \"직원입니다\" 옵션을 선택할 수 있습니다.';
  }

  @override
  String get employeeAddFailed => '직원을 추가할 수 없습니다';

  @override
  String get customersTitle => '고객';

  @override
  String get addCustomerTooltip => '고객 추가';

  @override
  String get searchCustomerHint => '이름, 전화번호 또는 이메일 검색';

  @override
  String get filterDebtor => '부채 있음';

  @override
  String get filterContacts => '연락처에서';

  @override
  String get filterManual => '수동';

  @override
  String customersCountLabel(int count) {
    return '$count명 고객';
  }

  @override
  String get noCustomersYet => '아직 추가된 고객 없음';

  @override
  String get noMatchingCustomers => '일치하는 고객 없음';

  @override
  String get addCustomerTitle => '고객 추가';

  @override
  String get contactPermissionRequired => '연락처 접근 권한이 필요합니다';

  @override
  String get noContactsFound => '연락처를 찾을 수 없음';

  @override
  String get noContactsWithPhone => '전화번호가 있는 연락처 없음';

  @override
  String addedFromContacts(int count) {
    return '$count명이 연락처에서 추가됨';
  }

  @override
  String contactReadError(String error) {
    return '연락처 읽기 오류: $error';
  }

  @override
  String get businessInfoMissing => '비즈니스 정보가 없습니다. 다시 시도하세요.';

  @override
  String customerAddedSuccess(String name) {
    return '$name님이 성공적으로 추가됨';
  }

  @override
  String get customerAddError => '고객 추가 중 오류 발생';

  @override
  String get pickFromContacts => '연락처에서 추가 (다중 선택)';

  @override
  String get loadingContacts => '연락처 로딩 중...';

  @override
  String get orEnterManually => '또는 직접 입력';

  @override
  String get fullNameStarField => '전체 이름 *';

  @override
  String get noteField => '메모';

  @override
  String get pickContactTitle => '연락처에서 선택';

  @override
  String selectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get searchNameOrPhone => '이름 또는 전화번호 검색...';

  @override
  String get selectNone => '전체 해제';

  @override
  String selectAllCount(int count) {
    return '전체 선택 ($count)';
  }

  @override
  String get noMatchingContacts => '검색과 일치하는 연락처 없음';

  @override
  String get emptyList => '목록이 비어 있음';

  @override
  String addNPeople(int count) {
    return '$count명 추가';
  }

  @override
  String get defineBusiness => '비즈니스 설정';

  @override
  String get businessInfoTitle => '비즈니스 정보';

  @override
  String get businessSetupSubtitle => 'Randevu 360을 사용하려면 비즈니스를 설정하세요';

  @override
  String get businessNameField => '비즈니스 이름';

  @override
  String get businessNameRequired => '비즈니스 이름이 필요합니다';

  @override
  String get addressField => '주소';

  @override
  String get emailInvalid => '유효한 이메일을 입력하세요';

  @override
  String get workingHoursTitle => '근무 시간';

  @override
  String get workingDaysTitle => '근무 요일';

  @override
  String get opening => '시작';

  @override
  String get closing => '종료';

  @override
  String get saveAndStart => '저장 후 시작';

  @override
  String get dayMon => '월요일';

  @override
  String get dayTue => '화요일';

  @override
  String get dayWed => '수요일';

  @override
  String get dayThu => '목요일';

  @override
  String get dayFri => '금요일';

  @override
  String get daySat => '토요일';

  @override
  String get daySun => '일요일';

  @override
  String get businessInfoUpdated => '비즈니스 정보가 업데이트됨';

  @override
  String get updateFailed => '업데이트 실패';

  @override
  String get onlyOwnerCanEdit => '사업주만 이 정보를 변경할 수 있습니다.';

  @override
  String get workingHoursUpdated => '근무 시간이 업데이트됨';

  @override
  String get profileTitle => '프로필';

  @override
  String get userFallback => '사용자';

  @override
  String get whatsappSettings => 'WhatsApp 설정';

  @override
  String get servicesAndPrices => '서비스 및 가격';

  @override
  String get incomeExpenseCategories => '수입/지출 카테고리';

  @override
  String get messageTemplatesTitle => '메시지 템플릿';

  @override
  String get workingHoursMenu => '근무 시간';

  @override
  String get backupMenu => '백업';

  @override
  String get restoreMenu => '백업에서 복원';

  @override
  String googleSignInFailed(String error) {
    return 'Google 로그인 실패: $error';
  }

  @override
  String get backedUp => '백업 완료 ✅';

  @override
  String backupFailedMsg(String error) {
    return '백업 오류: $error';
  }

  @override
  String restoreFailedMsg(String error) {
    return '복원 오류: $error';
  }

  @override
  String get backupDownloadedTitle => '백업 다운로드 완료';

  @override
  String get backupDownloadedMessage =>
      '복원을 완료하기 위해 앱이 종료됩니다. 다시 열면 백업에서 데이터가 복원됩니다.';

  @override
  String get autoBackupTitle => '자동 야간 백업';

  @override
  String get autoBackupSubtitle => '매일 밤 02:00-03:00 사이에 Drive에 백업';

  @override
  String get aboutApp => '앱 정보';

  @override
  String get termsOfUse => '이용약관';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get signOut => '로그아웃';

  @override
  String get categoriesTitle => '수입/지출 카테고리';

  @override
  String get incomeCategories => '수입 카테고리';

  @override
  String get expenseCategories => '지출 카테고리';

  @override
  String get addIncomeCategory => '수입 카테고리 추가';

  @override
  String get addExpenseCategory => '지출 카테고리 추가';

  @override
  String get categoryNameField => '카테고리 이름';

  @override
  String get categoryExists => '이 카테고리는 이미 존재합니다';

  @override
  String get categoryAddFailed => '카테고리를 추가할 수 없습니다';

  @override
  String get deleteCategoryTitle => '카테고리 삭제';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\"이(가) 삭제됩니다. 과거 거래는 영향받지 않습니다.';
  }

  @override
  String get noCategories => '카테고리 없음';

  @override
  String get availableVariables => '사용 가능한 변수';

  @override
  String get templateHelp =>
      '이 변수들은 메시지 전송 시 예약 세부정보로 대체됩니다. 템플릿을 완전히 비우면 해당 메시지는 전송되지 않습니다.';

  @override
  String get emptyToDisable => '이 메시지를 보내지 않으려면 비워 두세요';

  @override
  String get resetToDefault => '기본값으로 초기화';

  @override
  String get templatesSaved => '템플릿 저장됨';

  @override
  String get templatesSaveFailed => '템플릿을 저장할 수 없습니다';

  @override
  String get templatesLoadFailed => '템플릿을 불러올 수 없습니다';

  @override
  String get templatesServerNote => '템플릿은 WhatsApp 서버에 저장되며 연결이 필요합니다.';

  @override
  String get debtReminderFrequency => '부채 알림 주기';

  @override
  String get debtReminderFrequencyHelp =>
      '\"부채 알림\" 템플릿이 선택한 주기로 부채 고객에게 자동 전송됩니다 (10:00-20:00 사이).';

  @override
  String get freqOff => '끄기';

  @override
  String get freqDaily => '매일 한 번';

  @override
  String get freqWeekly => '매주 한 번';

  @override
  String get freqMonthly => '매월 한 번';

  @override
  String get languageLabel => '언어';

  @override
  String get languageSystemDefault => '시스템 기본값';
}
