// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Randevu 360';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get add => '添加';

  @override
  String get ok => '确定';

  @override
  String get retry => '重试';

  @override
  String get all => '全部';

  @override
  String get errorTitle => '错误';

  @override
  String get pressBackAgainToExit => '再按一次退出';

  @override
  String get appTagline => '小型企业的\n预约管理';

  @override
  String get signInWithGoogle => '使用 Google 登录';

  @override
  String get termsNotice => '登录即表示您接受使用条款';

  @override
  String welcomeUser(String name) {
    return '欢迎，\n$name';
  }

  @override
  String get howToContinue => '您想如何继续？';

  @override
  String get roleOwnerTitle => '我是企业主';

  @override
  String get roleOwnerSubtitle => '创建新企业或管理现有企业';

  @override
  String get roleEmployeeTitle => '我是员工';

  @override
  String get roleEmployeeSubtitle => '通过企业主的邀请访问我的账户';

  @override
  String get useDifferentAccount => '使用其他账户';

  @override
  String get notSignedInTitle => '未登录';

  @override
  String get notSignedInMessage => '请先使用 Google 账户登录。';

  @override
  String get inviteNotFoundTitle => '未找到邀请';

  @override
  String get inviteNotFoundMessage => '未找到此电子邮件地址的邀请。\n\n请企业主将您添加到系统中。';

  @override
  String get invalidBusinessInfo => '企业信息无效。';

  @override
  String businessRecordFailed(String error) {
    return '无法创建企业记录：$error';
  }

  @override
  String get connectionErrorTitle => '连接错误';

  @override
  String get inviteCheckFailed => '无法检查员工邀请。请检查互联网连接并重试。';

  @override
  String get tabHome => '首页';

  @override
  String get tabAppointments => '预约';

  @override
  String get tabCustomers => '客户';

  @override
  String get tabFinance => '财务';

  @override
  String get tabEmployees => '员工';

  @override
  String get tabProfile => '个人资料';

  @override
  String greetingHello(String name) {
    return '您好 $name';
  }

  @override
  String get greetingSubtitle => '准备管理您的企业';

  @override
  String get statToday => '今天';

  @override
  String get statCompleted => '已完成';

  @override
  String get statPending => '待处理';

  @override
  String get statTotalCustomers => '客户总数';

  @override
  String get quickActions => '快捷操作';

  @override
  String get quickNewAppointment => '新建预约';

  @override
  String get quickAddCustomer => '添加客户';

  @override
  String get quickBulkMessage => '群发消息';

  @override
  String get whatsappConnection => 'WhatsApp 连接';

  @override
  String get waConnected => '已连接';

  @override
  String get waPairing => '配对中...';

  @override
  String get waNotConnected => '尚未连接';

  @override
  String get manage => '管理';

  @override
  String get connect => '连接';

  @override
  String get todaysAppointments => '今日预约';

  @override
  String get noAppointmentsToday => '今天没有预约';

  @override
  String get customerFallback => '客户';

  @override
  String get statusConfirmed => '已确认';

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusCancelled => '已取消';

  @override
  String get statusPending => '待处理';

  @override
  String get statusShortConfirmed => '已确认';

  @override
  String get statusShortCompleted => '完成';

  @override
  String get statusShortCancelled => '取消';

  @override
  String get statusShortPending => '待定';

  @override
  String get appointmentsTitle => '预约';

  @override
  String appointmentCountLabel(int count) {
    return '$count 个预约';
  }

  @override
  String get allEmployees => '所有员工';

  @override
  String get noAppointmentsThisDay => '这一天没有预约';

  @override
  String get addAppointment => '添加预约';

  @override
  String get appointmentDetail => '预约详情';

  @override
  String get customerLabel => '客户';

  @override
  String get dateLabel => '日期';

  @override
  String get timeLabel => '时间';

  @override
  String get serviceLabel => '服务';

  @override
  String get priceLabel => '价格';

  @override
  String get noteLabel => '备注';

  @override
  String get completedPaidNote => '已完成，已收款';

  @override
  String get cancelAppointment => '取消';

  @override
  String get markCompleted => '已完成';

  @override
  String get appointmentCancelled => '预约已取消';

  @override
  String get appointmentCancelFailed => '无法取消预约';

  @override
  String collectedSummary(String amount, String method) {
    return '已收 $amount ₺（$method）';
  }

  @override
  String debtRecordedSummary(String amount) {
    return '$amount ₺ 记为欠款';
  }

  @override
  String get appointmentCompletedMsg => '预约已完成';

  @override
  String get paymentSaveFailed => '无法保存付款';

  @override
  String get paymentCash => '现金';

  @override
  String get paymentCard => '银行卡';

  @override
  String get paymentTransfer => '转账';

  @override
  String get paymentCashLower => '现金';

  @override
  String get paymentCardLower => '银行卡';

  @override
  String get newAppointment => '新建预约';

  @override
  String get businessInfoNotFound => '未找到企业信息';

  @override
  String get appointmentCreateFailed => '无法创建预约';

  @override
  String get appointmentCreated => '预约创建成功';

  @override
  String get customerPhoneRequired => '需要客户电话';

  @override
  String get customerNameRequired => '需要客户姓名';

  @override
  String get customerCreateFailed => '无法创建客户';

  @override
  String get sectionCustomer => '客户';

  @override
  String get selectCustomer => '选择客户';

  @override
  String get addNewCustomerItem => '+ 添加新客户';

  @override
  String get customerNameField => '客户姓名 *';

  @override
  String get phoneField => '电话 *';

  @override
  String get phoneRequired => '需要电话号码';

  @override
  String get sectionService => '服务';

  @override
  String get noServicesDefined => '尚未定义服务。\n请在 个人资料 > 服务 中定义服务和价格。';

  @override
  String get selectServiceField => '选择服务 *';

  @override
  String get serviceRequired => '需要选择服务';

  @override
  String get priceField => '价格 *';

  @override
  String get priceRequired => '需要价格';

  @override
  String get priceInvalid => '请输入有效价格';

  @override
  String get sectionEmployee => '员工';

  @override
  String get selectEmployeeField => '选择员工 *';

  @override
  String get employeeRequired => '需要选择员工';

  @override
  String get sectionDateTime => '日期和时间';

  @override
  String get dateField => '日期 *';

  @override
  String get timeField => '时间 *';

  @override
  String get sectionNote => '备注';

  @override
  String get noteOptional => '备注（可选）';

  @override
  String get noteHint => '关于预约的备注...';

  @override
  String get saveAppointment => '保存预约';

  @override
  String get takePayment => '收款';

  @override
  String appointmentPriceInfo(String amount) {
    return '预约价格：$amount ₺';
  }

  @override
  String get amountReceived => '已收金额（₺）';

  @override
  String remainingWillBeDebt(String amount) {
    return '剩余 $amount ₺ 将记为欠款';
  }

  @override
  String get paymentMethodLabel => '付款方式';

  @override
  String get allAsDebt => '全部记为欠款';

  @override
  String get complete => '完成';

  @override
  String get financeTitle => '财务';

  @override
  String get statisticsTooltip => '统计';

  @override
  String get monthlyBalance => '月度结余';

  @override
  String get income => '收入';

  @override
  String get expense => '支出';

  @override
  String get net => '净额';

  @override
  String get thisWeek => '本周';

  @override
  String receivablesLabel(int count) {
    return '应收款（$count）';
  }

  @override
  String get recentTransactions => '最近交易';

  @override
  String get viewAllShort => '全部';

  @override
  String get addIncomeExpense => '添加收入/支出';

  @override
  String get amountField => '金额（₺）';

  @override
  String get categoryField => '类别';

  @override
  String get descriptionField => '描述';

  @override
  String get enterValidAmount => '请输入有效金额';

  @override
  String get otherIncome => '其他收入';

  @override
  String get otherExpense => '其他支出';

  @override
  String get allTransactions => '所有交易';

  @override
  String get incomes => '收入';

  @override
  String get expenses => '支出';

  @override
  String get noTransactionsFound => '未找到交易';

  @override
  String get debtorCustomers => '欠款客户';

  @override
  String get noDebtors => '没有欠款客户';

  @override
  String get totalReceivable => '应收总额';

  @override
  String customersCountShort(int count) {
    return '$count 位客户';
  }

  @override
  String openDebtCount(int count) {
    return '$count 笔未清欠款';
  }

  @override
  String get remindViaWhatsApp => '通过 WhatsApp 提醒';

  @override
  String reminderSentTo(String name) {
    return '提醒已发送：$name';
  }

  @override
  String get reminderSendFailed => '无法发送提醒（请检查 WhatsApp 连接）';

  @override
  String get collectPayment => '收款';

  @override
  String remainingDebtInfo(String amount) {
    return '剩余欠款：$amount ₺';
  }

  @override
  String get collectedAmountField => '收款金额（₺）';

  @override
  String amountExceedsDebt(String amount) {
    return '金额不能超过剩余欠款（$amount ₺）';
  }

  @override
  String remainingTracked(String amount) {
    return '剩余 $amount ₺ 追踪为欠款';
  }

  @override
  String collectedWithRemaining(String amount, String left) {
    return '已收 $amount ₺，剩余 $left ₺';
  }

  @override
  String collectedDebtClosed(String amount) {
    return '已收 $amount ₺，欠款结清';
  }

  @override
  String get collectionFailed => '无法保存收款';

  @override
  String debtBadge(String amount) {
    return '$amount ₺ 欠款';
  }

  @override
  String get statisticsTitle => '统计';

  @override
  String get periodWeek => '周';

  @override
  String get periodMonth => '月';

  @override
  String get periodYear => '年';

  @override
  String get employeeFilter => '员工';

  @override
  String get noTransactionsInPeriod => '此期间无交易';

  @override
  String get incomeTrend => '收入趋势';

  @override
  String get noIncomeRecords => '无收入记录';

  @override
  String get paymentDistribution => '付款方式分布';

  @override
  String get employeeEarnings => '员工收入';

  @override
  String get unassigned => '未分配';

  @override
  String get topServices => '最高收入服务';

  @override
  String get topCustomers => '最佳客户';

  @override
  String get expenseItems => '支出项目';

  @override
  String get employeeDebtsTitle => '员工欠款';

  @override
  String get generalTitle => '概况';

  @override
  String get noRecords => '无记录';

  @override
  String get transactionCount => '交易笔数';

  @override
  String get avgTransaction => '平均交易';

  @override
  String get incomeTransactionCount => '收入交易笔数';

  @override
  String get avgTransactionAmount => '平均交易金额';

  @override
  String get appointmentsTotal => '预约（总计）';

  @override
  String get completedAppointmentsStat => '已完成预约';

  @override
  String get cancelledAppointmentsStat => '已取消预约';

  @override
  String get cashRatio => '现金占比';

  @override
  String get openDebtTotal => '未清欠款总额';

  @override
  String get employeeDebtHint => '欠款按完成工作的员工分组。点击行可列出欠款客户。';

  @override
  String debtorCountLabel(int count) {
    return '$count 位欠款客户';
  }

  @override
  String employeeDebtorsSheet(String name, String amount) {
    return '$name — 欠款客户（$amount ₺）';
  }

  @override
  String get employeesTitle => '员工';

  @override
  String get addEmployee => '添加员工';

  @override
  String get noEmployeesYet => '尚未添加员工';

  @override
  String get searchEmployeeHint => '搜索姓名、电子邮件或电话';

  @override
  String get roleAdmin => '管理员';

  @override
  String get roleEmployee => '员工';

  @override
  String get noMatchingEmployees => '没有匹配的员工';

  @override
  String get makeEmployee => '设为员工';

  @override
  String get makeAdmin => '设为管理员';

  @override
  String get deleteEmployeeTitle => '删除员工';

  @override
  String deleteEmployeeConfirm(String name) {
    return '$name 将被删除。此操作无法撤消。';
  }

  @override
  String get employeeDeleted => '员工已删除';

  @override
  String get deleteFailed => '删除失败';

  @override
  String get fullNameRequired => '需要完整姓名';

  @override
  String get enterValidEmailInvite => '请输入有效的电子邮件 — 员工将使用此地址的 Google 账户登录';

  @override
  String get fullNameField => '完整姓名';

  @override
  String get phoneOnlyField => '电话';

  @override
  String get emailField => '电子邮件';

  @override
  String get roleField => '角色';

  @override
  String employeeAddedInfo(String name, String email) {
    return '$name 已添加。可以使用 $email 的 Google 账户登录并选择\"我是员工\"选项。';
  }

  @override
  String get employeeAddFailed => '无法添加员工';

  @override
  String get customersTitle => '客户';

  @override
  String get addCustomerTooltip => '添加客户';

  @override
  String get searchCustomerHint => '搜索姓名、电话或电子邮件';

  @override
  String get filterDebtor => '有欠款';

  @override
  String get filterContacts => '来自通讯录';

  @override
  String get filterManual => '手动';

  @override
  String customersCountLabel(int count) {
    return '$count 位客户';
  }

  @override
  String get noCustomersYet => '尚未添加客户';

  @override
  String get noMatchingCustomers => '没有匹配的客户';

  @override
  String get addCustomerTitle => '添加客户';

  @override
  String get contactPermissionRequired => '需要通讯录权限';

  @override
  String get noContactsFound => '未找到联系人';

  @override
  String get noContactsWithPhone => '没有带电话号码的联系人';

  @override
  String addedFromContacts(int count) {
    return '已从通讯录添加 $count 人';
  }

  @override
  String contactReadError(String error) {
    return '读取联系人时出错：$error';
  }

  @override
  String get businessInfoMissing => '缺少企业信息。请重试。';

  @override
  String customerAddedSuccess(String name) {
    return '$name 添加成功';
  }

  @override
  String get customerAddError => '添加客户时发生错误';

  @override
  String get pickFromContacts => '从通讯录添加（多选）';

  @override
  String get loadingContacts => '正在加载联系人...';

  @override
  String get orEnterManually => '或手动输入';

  @override
  String get fullNameStarField => '完整姓名 *';

  @override
  String get noteField => '备注';

  @override
  String get pickContactTitle => '从通讯录选择';

  @override
  String selectedCount(int count) {
    return '已选 $count 个';
  }

  @override
  String get searchNameOrPhone => '搜索姓名或电话...';

  @override
  String get selectNone => '全部取消';

  @override
  String selectAllCount(int count) {
    return '全选（$count）';
  }

  @override
  String get noMatchingContacts => '没有匹配的联系人';

  @override
  String get emptyList => '列表为空';

  @override
  String addNPeople(int count) {
    return '添加 $count 人';
  }

  @override
  String get defineBusiness => '设置您的企业';

  @override
  String get businessInfoTitle => '企业信息';

  @override
  String get businessSetupSubtitle => '设置您的企业以开始使用 Randevu 360';

  @override
  String get businessNameField => '企业名称';

  @override
  String get businessNameRequired => '需要企业名称';

  @override
  String get addressField => '地址';

  @override
  String get emailInvalid => '请输入有效的电子邮件';

  @override
  String get workingHoursTitle => '工作时间';

  @override
  String get workingDaysTitle => '工作日';

  @override
  String get opening => '开业';

  @override
  String get closing => '关门';

  @override
  String get saveAndStart => '保存并开始';

  @override
  String get dayMon => '星期一';

  @override
  String get dayTue => '星期二';

  @override
  String get dayWed => '星期三';

  @override
  String get dayThu => '星期四';

  @override
  String get dayFri => '星期五';

  @override
  String get daySat => '星期六';

  @override
  String get daySun => '星期日';

  @override
  String get businessInfoUpdated => '企业信息已更新';

  @override
  String get updateFailed => '更新失败';

  @override
  String get onlyOwnerCanEdit => '只有企业主可以更改此信息。';

  @override
  String get workingHoursUpdated => '工作时间已更新';

  @override
  String get profileTitle => '个人资料';

  @override
  String get userFallback => '用户';

  @override
  String get whatsappSettings => 'WhatsApp 设置';

  @override
  String get servicesAndPrices => '服务和价格';

  @override
  String get incomeExpenseCategories => '收入/支出类别';

  @override
  String get messageTemplatesTitle => '消息模板';

  @override
  String get workingHoursMenu => '工作时间';

  @override
  String get backupMenu => '备份';

  @override
  String get restoreMenu => '从备份恢复';

  @override
  String googleSignInFailed(String error) {
    return 'Google 登录失败：$error';
  }

  @override
  String get backedUp => '已备份 ✅';

  @override
  String backupFailedMsg(String error) {
    return '备份错误：$error';
  }

  @override
  String restoreFailedMsg(String error) {
    return '恢复错误：$error';
  }

  @override
  String get backupDownloadedTitle => '备份已下载';

  @override
  String get backupDownloadedMessage => '应用将关闭以完成恢复。重新打开后，您的数据将从备份中恢复。';

  @override
  String get autoBackupTitle => '自动夜间备份';

  @override
  String get autoBackupSubtitle => '每晚 02:00-03:00 之间备份到云端硬盘';

  @override
  String get aboutApp => '关于应用';

  @override
  String get termsOfUse => '使用条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get signOut => '退出登录';

  @override
  String get categoriesTitle => '收入/支出类别';

  @override
  String get incomeCategories => '收入类别';

  @override
  String get expenseCategories => '支出类别';

  @override
  String get addIncomeCategory => '添加收入类别';

  @override
  String get addExpenseCategory => '添加支出类别';

  @override
  String get categoryNameField => '类别名称';

  @override
  String get categoryExists => '此类别已存在';

  @override
  String get categoryAddFailed => '无法添加类别';

  @override
  String get deleteCategoryTitle => '删除类别';

  @override
  String deleteCategoryConfirm(String name) {
    return '\"$name\" 将被删除。过去的交易不受影响。';
  }

  @override
  String get noCategories => '无类别';

  @override
  String get availableVariables => '可用变量';

  @override
  String get templateHelp => '发送消息时，这些变量将替换为预约详情。如果完全清空模板，该消息将不会发送。';

  @override
  String get emptyToDisable => '留空则不发送此消息';

  @override
  String get resetToDefault => '恢复默认';

  @override
  String get templatesSaved => '模板已保存';

  @override
  String get templatesSaveFailed => '无法保存模板';

  @override
  String get templatesLoadFailed => '无法加载模板';

  @override
  String get templatesServerNote => '模板存储在 WhatsApp 服务器上；需要连接。';

  @override
  String get debtReminderFrequency => '欠款提醒频率';

  @override
  String get debtReminderFrequencyHelp =>
      '\"欠款提醒\"模板将按所选频率自动发送给欠款客户（10:00-20:00 之间）。';

  @override
  String get freqOff => '关闭';

  @override
  String get freqDaily => '每天一次';

  @override
  String get freqWeekly => '每周一次';

  @override
  String get freqMonthly => '每月一次';

  @override
  String get languageLabel => '语言';

  @override
  String get languageSystemDefault => '跟随系统';
}
