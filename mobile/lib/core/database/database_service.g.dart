// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_service.dart';

// ignore_for_file: type=lint
class $BusinessesTable extends Businesses
    with TableInfo<$BusinessesTable, Business> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ownerNameMeta =
      const VerificationMeta('ownerName');
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
      'owner_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerFbUidMeta =
      const VerificationMeta('ownerFbUid');
  @override
  late final GeneratedColumn<String> ownerFbUid = GeneratedColumn<String>(
      'owner_fb_uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workingDaysMeta =
      const VerificationMeta('workingDays');
  @override
  late final GeneratedColumn<String> workingDays = GeneratedColumn<String>(
      'working_days', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workingHoursMeta =
      const VerificationMeta('workingHours');
  @override
  late final GeneratedColumn<String> workingHours = GeneratedColumn<String>(
      'working_hours', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        name,
        phone,
        address,
        email,
        ownerName,
        ownerFbUid,
        workingDays,
        workingHours,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'businesses';
  @override
  VerificationContext validateIntegrity(Insertable<Business> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('owner_name')) {
      context.handle(_ownerNameMeta,
          ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta));
    } else if (isInserting) {
      context.missing(_ownerNameMeta);
    }
    if (data.containsKey('owner_fb_uid')) {
      context.handle(
          _ownerFbUidMeta,
          ownerFbUid.isAcceptableOrUnknown(
              data['owner_fb_uid']!, _ownerFbUidMeta));
    } else if (isInserting) {
      context.missing(_ownerFbUidMeta);
    }
    if (data.containsKey('working_days')) {
      context.handle(
          _workingDaysMeta,
          workingDays.isAcceptableOrUnknown(
              data['working_days']!, _workingDaysMeta));
    } else if (isInserting) {
      context.missing(_workingDaysMeta);
    }
    if (data.containsKey('working_hours')) {
      context.handle(
          _workingHoursMeta,
          workingHours.isAcceptableOrUnknown(
              data['working_hours']!, _workingHoursMeta));
    } else if (isInserting) {
      context.missing(_workingHoursMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Business map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Business(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      ownerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_name'])!,
      ownerFbUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_fb_uid'])!,
      workingDays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}working_days'])!,
      workingHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}working_hours'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BusinessesTable createAlias(String alias) {
    return $BusinessesTable(attachedDatabase, alias);
  }
}

class Business extends DataClass implements Insertable<Business> {
  final int id;
  final String? remoteId;
  final String name;
  final String phone;
  final String address;
  final String? email;
  final String ownerName;
  final String ownerFbUid;
  final String workingDays;
  final String workingHours;
  final String status;
  final String createdAt;
  final String updatedAt;
  const Business(
      {required this.id,
      this.remoteId,
      required this.name,
      required this.phone,
      required this.address,
      this.email,
      required this.ownerName,
      required this.ownerFbUid,
      required this.workingDays,
      required this.workingHours,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['owner_name'] = Variable<String>(ownerName);
    map['owner_fb_uid'] = Variable<String>(ownerFbUid);
    map['working_days'] = Variable<String>(workingDays);
    map['working_hours'] = Variable<String>(workingHours);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  BusinessesCompanion toCompanion(bool nullToAbsent) {
    return BusinessesCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      ownerName: Value(ownerName),
      ownerFbUid: Value(ownerFbUid),
      workingDays: Value(workingDays),
      workingHours: Value(workingHours),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Business.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Business(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      email: serializer.fromJson<String?>(json['email']),
      ownerName: serializer.fromJson<String>(json['ownerName']),
      ownerFbUid: serializer.fromJson<String>(json['ownerFbUid']),
      workingDays: serializer.fromJson<String>(json['workingDays']),
      workingHours: serializer.fromJson<String>(json['workingHours']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'email': serializer.toJson<String?>(email),
      'ownerName': serializer.toJson<String>(ownerName),
      'ownerFbUid': serializer.toJson<String>(ownerFbUid),
      'workingDays': serializer.toJson<String>(workingDays),
      'workingHours': serializer.toJson<String>(workingHours),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Business copyWith(
          {int? id,
          Value<String?> remoteId = const Value.absent(),
          String? name,
          String? phone,
          String? address,
          Value<String?> email = const Value.absent(),
          String? ownerName,
          String? ownerFbUid,
          String? workingDays,
          String? workingHours,
          String? status,
          String? createdAt,
          String? updatedAt}) =>
      Business(
        id: id ?? this.id,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        email: email.present ? email.value : this.email,
        ownerName: ownerName ?? this.ownerName,
        ownerFbUid: ownerFbUid ?? this.ownerFbUid,
        workingDays: workingDays ?? this.workingDays,
        workingHours: workingHours ?? this.workingHours,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Business(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('email: $email, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerFbUid: $ownerFbUid, ')
          ..write('workingDays: $workingDays, ')
          ..write('workingHours: $workingHours, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      remoteId,
      name,
      phone,
      address,
      email,
      ownerName,
      ownerFbUid,
      workingDays,
      workingHours,
      status,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Business &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.email == this.email &&
          other.ownerName == this.ownerName &&
          other.ownerFbUid == this.ownerFbUid &&
          other.workingDays == this.workingDays &&
          other.workingHours == this.workingHours &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BusinessesCompanion extends UpdateCompanion<Business> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> address;
  final Value<String?> email;
  final Value<String> ownerName;
  final Value<String> ownerFbUid;
  final Value<String> workingDays;
  final Value<String> workingHours;
  final Value<String> status;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const BusinessesCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.email = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.ownerFbUid = const Value.absent(),
    this.workingDays = const Value.absent(),
    this.workingHours = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BusinessesCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String name,
    required String phone,
    required String address,
    this.email = const Value.absent(),
    required String ownerName,
    required String ownerFbUid,
    required String workingDays,
    required String workingHours,
    this.status = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  })  : name = Value(name),
        phone = Value(phone),
        address = Value(address),
        ownerName = Value(ownerName),
        ownerFbUid = Value(ownerFbUid),
        workingDays = Value(workingDays),
        workingHours = Value(workingHours),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Business> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? email,
    Expression<String>? ownerName,
    Expression<String>? ownerFbUid,
    Expression<String>? workingDays,
    Expression<String>? workingHours,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (email != null) 'email': email,
      if (ownerName != null) 'owner_name': ownerName,
      if (ownerFbUid != null) 'owner_fb_uid': ownerFbUid,
      if (workingDays != null) 'working_days': workingDays,
      if (workingHours != null) 'working_hours': workingHours,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BusinessesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? remoteId,
      Value<String>? name,
      Value<String>? phone,
      Value<String>? address,
      Value<String?>? email,
      Value<String>? ownerName,
      Value<String>? ownerFbUid,
      Value<String>? workingDays,
      Value<String>? workingHours,
      Value<String>? status,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return BusinessesCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
      ownerName: ownerName ?? this.ownerName,
      ownerFbUid: ownerFbUid ?? this.ownerFbUid,
      workingDays: workingDays ?? this.workingDays,
      workingHours: workingHours ?? this.workingHours,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (ownerFbUid.present) {
      map['owner_fb_uid'] = Variable<String>(ownerFbUid.value);
    }
    if (workingDays.present) {
      map['working_days'] = Variable<String>(workingDays.value);
    }
    if (workingHours.present) {
      map['working_hours'] = Variable<String>(workingHours.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessesCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('email: $email, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerFbUid: $ownerFbUid, ')
          ..write('workingDays: $workingDays, ')
          ..write('workingHours: $workingHours, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES businesses (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('employee'));
  static const VerificationMeta _fbUidMeta = const VerificationMeta('fbUid');
  @override
  late final GeneratedColumn<String> fbUid = GeneratedColumn<String>(
      'fb_uid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        name,
        phone,
        email,
        role,
        fbUid,
        color,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(Insertable<Employee> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('fb_uid')) {
      context.handle(
          _fbUidMeta, fbUid.isAcceptableOrUnknown(data['fb_uid']!, _fbUidMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      fbUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fb_uid']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final int id;
  final int businessId;
  final String name;
  final String phone;
  final String email;
  final String role;
  final String? fbUid;
  final String? color;
  final String status;
  final String createdAt;
  const Employee(
      {required this.id,
      required this.businessId,
      required this.name,
      required this.phone,
      required this.email,
      required this.role,
      this.fbUid,
      this.color,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_id'] = Variable<int>(businessId);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || fbUid != null) {
      map['fb_uid'] = Variable<String>(fbUid);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      businessId: Value(businessId),
      name: Value(name),
      phone: Value(phone),
      email: Value(email),
      role: Value(role),
      fbUid:
          fbUid == null && nullToAbsent ? const Value.absent() : Value(fbUid),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Employee.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<int>(json['id']),
      businessId: serializer.fromJson<int>(json['businessId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      fbUid: serializer.fromJson<String?>(json['fbUid']),
      color: serializer.fromJson<String?>(json['color']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessId': serializer.toJson<int>(businessId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'fbUid': serializer.toJson<String?>(fbUid),
      'color': serializer.toJson<String?>(color),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Employee copyWith(
          {int? id,
          int? businessId,
          String? name,
          String? phone,
          String? email,
          String? role,
          Value<String?> fbUid = const Value.absent(),
          Value<String?> color = const Value.absent(),
          String? status,
          String? createdAt}) =>
      Employee(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        role: role ?? this.role,
        fbUid: fbUid.present ? fbUid.value : this.fbUid,
        color: color.present ? color.value : this.color,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('fbUid: $fbUid, ')
          ..write('color: $color, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, name, phone, email, role,
      fbUid, color, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.role == this.role &&
          other.fbUid == this.fbUid &&
          other.color == this.color &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<int> id;
  final Value<int> businessId;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> role;
  final Value<String?> fbUid;
  final Value<String?> color;
  final Value<String> status;
  final Value<String> createdAt;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.fbUid = const Value.absent(),
    this.color = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EmployeesCompanion.insert({
    this.id = const Value.absent(),
    required int businessId,
    required String name,
    required String phone,
    required String email,
    this.role = const Value.absent(),
    this.fbUid = const Value.absent(),
    this.color = const Value.absent(),
    this.status = const Value.absent(),
    required String createdAt,
  })  : businessId = Value(businessId),
        name = Value(name),
        phone = Value(phone),
        email = Value(email),
        createdAt = Value(createdAt);
  static Insertable<Employee> custom({
    Expression<int>? id,
    Expression<int>? businessId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? role,
    Expression<String>? fbUid,
    Expression<String>? color,
    Expression<String>? status,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (fbUid != null) 'fb_uid': fbUid,
      if (color != null) 'color': color,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EmployeesCompanion copyWith(
      {Value<int>? id,
      Value<int>? businessId,
      Value<String>? name,
      Value<String>? phone,
      Value<String>? email,
      Value<String>? role,
      Value<String?>? fbUid,
      Value<String?>? color,
      Value<String>? status,
      Value<String>? createdAt}) {
    return EmployeesCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      fbUid: fbUid ?? this.fbUid,
      color: color ?? this.color,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (fbUid.present) {
      map['fb_uid'] = Variable<String>(fbUid.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('fbUid: $fbUid, ')
          ..write('color: $color, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES businesses (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('manual'));
  static const VerificationMeta _totalDebtMeta =
      const VerificationMeta('totalDebt');
  @override
  late final GeneratedColumn<double> totalDebt = GeneratedColumn<double>(
      'total_debt', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, businessId, name, phone, email, note, source, totalDebt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('total_debt')) {
      context.handle(_totalDebtMeta,
          totalDebt.isAcceptableOrUnknown(data['total_debt']!, _totalDebtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      totalDebt: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_debt'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final int businessId;
  final String name;
  final String phone;
  final String? email;
  final String? note;
  final String source;
  final double totalDebt;
  final String createdAt;
  const Customer(
      {required this.id,
      required this.businessId,
      required this.name,
      required this.phone,
      this.email,
      this.note,
      required this.source,
      required this.totalDebt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_id'] = Variable<int>(businessId);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['source'] = Variable<String>(source);
    map['total_debt'] = Variable<double>(totalDebt);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      businessId: Value(businessId),
      name: Value(name),
      phone: Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      source: Value(source),
      totalDebt: Value(totalDebt),
      createdAt: Value(createdAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      businessId: serializer.fromJson<int>(json['businessId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      note: serializer.fromJson<String?>(json['note']),
      source: serializer.fromJson<String>(json['source']),
      totalDebt: serializer.fromJson<double>(json['totalDebt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessId': serializer.toJson<int>(businessId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String?>(email),
      'note': serializer.toJson<String?>(note),
      'source': serializer.toJson<String>(source),
      'totalDebt': serializer.toJson<double>(totalDebt),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Customer copyWith(
          {int? id,
          int? businessId,
          String? name,
          String? phone,
          Value<String?> email = const Value.absent(),
          Value<String?> note = const Value.absent(),
          String? source,
          double? totalDebt,
          String? createdAt}) =>
      Customer(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email.present ? email.value : this.email,
        note: note.present ? note.value : this.note,
        source: source ?? this.source,
        totalDebt: totalDebt ?? this.totalDebt,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('totalDebt: $totalDebt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, businessId, name, phone, email, note, source, totalDebt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.note == this.note &&
          other.source == this.source &&
          other.totalDebt == this.totalDebt &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<int> businessId;
  final Value<String> name;
  final Value<String> phone;
  final Value<String?> email;
  final Value<String?> note;
  final Value<String> source;
  final Value<double> totalDebt;
  final Value<String> createdAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.totalDebt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required int businessId,
    required String name,
    required String phone,
    this.email = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.totalDebt = const Value.absent(),
    required String createdAt,
  })  : businessId = Value(businessId),
        name = Value(name),
        phone = Value(phone),
        createdAt = Value(createdAt);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<int>? businessId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? note,
    Expression<String>? source,
    Expression<double>? totalDebt,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
      if (totalDebt != null) 'total_debt': totalDebt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<int>? businessId,
      Value<String>? name,
      Value<String>? phone,
      Value<String?>? email,
      Value<String?>? note,
      Value<String>? source,
      Value<double>? totalDebt,
      Value<String>? createdAt}) {
    return CustomersCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      note: note ?? this.note,
      source: source ?? this.source,
      totalDebt: totalDebt ?? this.totalDebt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (totalDebt.present) {
      map['total_debt'] = Variable<double>(totalDebt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('totalDebt: $totalDebt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES businesses (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, businessId, name, description, duration, price, category, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(Insertable<Service> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }
}

class Service extends DataClass implements Insertable<Service> {
  final int id;
  final int businessId;
  final String name;
  final String? description;
  final int duration;
  final double price;
  final String? category;
  final String status;
  const Service(
      {required this.id,
      required this.businessId,
      required this.name,
      this.description,
      required this.duration,
      required this.price,
      this.category,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_id'] = Variable<int>(businessId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['duration'] = Variable<int>(duration);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      businessId: Value(businessId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      duration: Value(duration),
      price: Value(price),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      status: Value(status),
    );
  }

  factory Service.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Service(
      id: serializer.fromJson<int>(json['id']),
      businessId: serializer.fromJson<int>(json['businessId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      duration: serializer.fromJson<int>(json['duration']),
      price: serializer.fromJson<double>(json['price']),
      category: serializer.fromJson<String?>(json['category']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessId': serializer.toJson<int>(businessId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'duration': serializer.toJson<int>(duration),
      'price': serializer.toJson<double>(price),
      'category': serializer.toJson<String?>(category),
      'status': serializer.toJson<String>(status),
    };
  }

  Service copyWith(
          {int? id,
          int? businessId,
          String? name,
          Value<String?> description = const Value.absent(),
          int? duration,
          double? price,
          Value<String?> category = const Value.absent(),
          String? status}) =>
      Service(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        duration: duration ?? this.duration,
        price: price ?? this.price,
        category: category.present ? category.value : this.category,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('Service(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('duration: $duration, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, businessId, name, description, duration, price, category, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Service &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.name == this.name &&
          other.description == this.description &&
          other.duration == this.duration &&
          other.price == this.price &&
          other.category == this.category &&
          other.status == this.status);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<int> id;
  final Value<int> businessId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> duration;
  final Value<double> price;
  final Value<String?> category;
  final Value<String> status;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.duration = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required int businessId,
    required String name,
    this.description = const Value.absent(),
    required int duration,
    required double price,
    this.category = const Value.absent(),
    this.status = const Value.absent(),
  })  : businessId = Value(businessId),
        name = Value(name),
        duration = Value(duration),
        price = Value(price);
  static Insertable<Service> custom({
    Expression<int>? id,
    Expression<int>? businessId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? duration,
    Expression<double>? price,
    Expression<String>? category,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (duration != null) 'duration': duration,
      if (price != null) 'price': price,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
    });
  }

  ServicesCompanion copyWith(
      {Value<int>? id,
      Value<int>? businessId,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? duration,
      Value<double>? price,
      Value<String?>? category,
      Value<String>? status}) {
    return ServicesCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('duration: $duration, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, Appointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES businesses (id)'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
      'employee_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES employees (id)'));
  static const VerificationMeta _serviceIdMeta =
      const VerificationMeta('serviceId');
  @override
  late final GeneratedColumn<int> serviceId = GeneratedColumn<int>(
      'service_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES services (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notified24hMeta =
      const VerificationMeta('notified24h');
  @override
  late final GeneratedColumn<bool> notified24h = GeneratedColumn<bool>(
      'notified24h', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("notified24h" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notified5hMeta =
      const VerificationMeta('notified5h');
  @override
  late final GeneratedColumn<bool> notified5h = GeneratedColumn<bool>(
      'notified5h', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("notified5h" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notified1hMeta =
      const VerificationMeta('notified1h');
  @override
  late final GeneratedColumn<bool> notified1h = GeneratedColumn<bool>(
      'notified1h', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("notified1h" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        customerId,
        employeeId,
        serviceId,
        date,
        time,
        price,
        status,
        note,
        createdBy,
        createdAt,
        updatedAt,
        notified24h,
        notified5h,
        notified1h
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(Insertable<Appointment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    }
    if (data.containsKey('service_id')) {
      context.handle(_serviceIdMeta,
          serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('notified24h')) {
      context.handle(
          _notified24hMeta,
          notified24h.isAcceptableOrUnknown(
              data['notified24h']!, _notified24hMeta));
    }
    if (data.containsKey('notified5h')) {
      context.handle(
          _notified5hMeta,
          notified5h.isAcceptableOrUnknown(
              data['notified5h']!, _notified5hMeta));
    }
    if (data.containsKey('notified1h')) {
      context.handle(
          _notified1hMeta,
          notified1h.isAcceptableOrUnknown(
              data['notified1h']!, _notified1hMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Appointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Appointment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}employee_id']),
      serviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}service_id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      notified24h: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}notified24h'])!,
      notified5h: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}notified5h'])!,
      notified1h: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}notified1h'])!,
    );
  }

  @override
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }
}

class Appointment extends DataClass implements Insertable<Appointment> {
  final int id;
  final int businessId;
  final int customerId;
  final int? employeeId;
  final int? serviceId;
  final String date;
  final String time;
  final double? price;
  final String status;
  final String? note;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final bool notified24h;
  final bool notified5h;
  final bool notified1h;
  const Appointment(
      {required this.id,
      required this.businessId,
      required this.customerId,
      this.employeeId,
      this.serviceId,
      required this.date,
      required this.time,
      this.price,
      required this.status,
      this.note,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt,
      required this.notified24h,
      required this.notified5h,
      required this.notified1h});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_id'] = Variable<int>(businessId);
    map['customer_id'] = Variable<int>(customerId);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<int>(employeeId);
    }
    if (!nullToAbsent || serviceId != null) {
      map['service_id'] = Variable<int>(serviceId);
    }
    map['date'] = Variable<String>(date);
    map['time'] = Variable<String>(time);
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['notified24h'] = Variable<bool>(notified24h);
    map['notified5h'] = Variable<bool>(notified5h);
    map['notified1h'] = Variable<bool>(notified1h);
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      customerId: Value(customerId),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      serviceId: serviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceId),
      date: Value(date),
      time: Value(time),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      notified24h: Value(notified24h),
      notified5h: Value(notified5h),
      notified1h: Value(notified1h),
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Appointment(
      id: serializer.fromJson<int>(json['id']),
      businessId: serializer.fromJson<int>(json['businessId']),
      customerId: serializer.fromJson<int>(json['customerId']),
      employeeId: serializer.fromJson<int?>(json['employeeId']),
      serviceId: serializer.fromJson<int?>(json['serviceId']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<String>(json['time']),
      price: serializer.fromJson<double?>(json['price']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      notified24h: serializer.fromJson<bool>(json['notified24h']),
      notified5h: serializer.fromJson<bool>(json['notified5h']),
      notified1h: serializer.fromJson<bool>(json['notified1h']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessId': serializer.toJson<int>(businessId),
      'customerId': serializer.toJson<int>(customerId),
      'employeeId': serializer.toJson<int?>(employeeId),
      'serviceId': serializer.toJson<int?>(serviceId),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<String>(time),
      'price': serializer.toJson<double?>(price),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'notified24h': serializer.toJson<bool>(notified24h),
      'notified5h': serializer.toJson<bool>(notified5h),
      'notified1h': serializer.toJson<bool>(notified1h),
    };
  }

  Appointment copyWith(
          {int? id,
          int? businessId,
          int? customerId,
          Value<int?> employeeId = const Value.absent(),
          Value<int?> serviceId = const Value.absent(),
          String? date,
          String? time,
          Value<double?> price = const Value.absent(),
          String? status,
          Value<String?> note = const Value.absent(),
          String? createdBy,
          String? createdAt,
          String? updatedAt,
          bool? notified24h,
          bool? notified5h,
          bool? notified1h}) =>
      Appointment(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        customerId: customerId ?? this.customerId,
        employeeId: employeeId.present ? employeeId.value : this.employeeId,
        serviceId: serviceId.present ? serviceId.value : this.serviceId,
        date: date ?? this.date,
        time: time ?? this.time,
        price: price.present ? price.value : this.price,
        status: status ?? this.status,
        note: note.present ? note.value : this.note,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        notified24h: notified24h ?? this.notified24h,
        notified5h: notified5h ?? this.notified5h,
        notified1h: notified1h ?? this.notified1h,
      );
  @override
  String toString() {
    return (StringBuffer('Appointment(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('customerId: $customerId, ')
          ..write('employeeId: $employeeId, ')
          ..write('serviceId: $serviceId, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('price: $price, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('notified24h: $notified24h, ')
          ..write('notified5h: $notified5h, ')
          ..write('notified1h: $notified1h')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessId,
      customerId,
      employeeId,
      serviceId,
      date,
      time,
      price,
      status,
      note,
      createdBy,
      createdAt,
      updatedAt,
      notified24h,
      notified5h,
      notified1h);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Appointment &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.customerId == this.customerId &&
          other.employeeId == this.employeeId &&
          other.serviceId == this.serviceId &&
          other.date == this.date &&
          other.time == this.time &&
          other.price == this.price &&
          other.status == this.status &&
          other.note == this.note &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.notified24h == this.notified24h &&
          other.notified5h == this.notified5h &&
          other.notified1h == this.notified1h);
}

class AppointmentsCompanion extends UpdateCompanion<Appointment> {
  final Value<int> id;
  final Value<int> businessId;
  final Value<int> customerId;
  final Value<int?> employeeId;
  final Value<int?> serviceId;
  final Value<String> date;
  final Value<String> time;
  final Value<double?> price;
  final Value<String> status;
  final Value<String?> note;
  final Value<String> createdBy;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<bool> notified24h;
  final Value<bool> notified5h;
  final Value<bool> notified1h;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.price = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.notified24h = const Value.absent(),
    this.notified5h = const Value.absent(),
    this.notified1h = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    this.id = const Value.absent(),
    required int businessId,
    required int customerId,
    this.employeeId = const Value.absent(),
    this.serviceId = const Value.absent(),
    required String date,
    required String time,
    this.price = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    required String createdBy,
    required String createdAt,
    required String updatedAt,
    this.notified24h = const Value.absent(),
    this.notified5h = const Value.absent(),
    this.notified1h = const Value.absent(),
  })  : businessId = Value(businessId),
        customerId = Value(customerId),
        date = Value(date),
        time = Value(time),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Appointment> custom({
    Expression<int>? id,
    Expression<int>? businessId,
    Expression<int>? customerId,
    Expression<int>? employeeId,
    Expression<int>? serviceId,
    Expression<String>? date,
    Expression<String>? time,
    Expression<double>? price,
    Expression<String>? status,
    Expression<String>? note,
    Expression<String>? createdBy,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<bool>? notified24h,
    Expression<bool>? notified5h,
    Expression<bool>? notified1h,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (customerId != null) 'customer_id': customerId,
      if (employeeId != null) 'employee_id': employeeId,
      if (serviceId != null) 'service_id': serviceId,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (price != null) 'price': price,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (notified24h != null) 'notified24h': notified24h,
      if (notified5h != null) 'notified5h': notified5h,
      if (notified1h != null) 'notified1h': notified1h,
    });
  }

  AppointmentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? businessId,
      Value<int>? customerId,
      Value<int?>? employeeId,
      Value<int?>? serviceId,
      Value<String>? date,
      Value<String>? time,
      Value<double?>? price,
      Value<String>? status,
      Value<String?>? note,
      Value<String>? createdBy,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<bool>? notified24h,
      Value<bool>? notified5h,
      Value<bool>? notified1h}) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      customerId: customerId ?? this.customerId,
      employeeId: employeeId ?? this.employeeId,
      serviceId: serviceId ?? this.serviceId,
      date: date ?? this.date,
      time: time ?? this.time,
      price: price ?? this.price,
      status: status ?? this.status,
      note: note ?? this.note,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notified24h: notified24h ?? this.notified24h,
      notified5h: notified5h ?? this.notified5h,
      notified1h: notified1h ?? this.notified1h,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<int>(serviceId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (notified24h.present) {
      map['notified24h'] = Variable<bool>(notified24h.value);
    }
    if (notified5h.present) {
      map['notified5h'] = Variable<bool>(notified5h.value);
    }
    if (notified1h.present) {
      map['notified1h'] = Variable<bool>(notified1h.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('customerId: $customerId, ')
          ..write('employeeId: $employeeId, ')
          ..write('serviceId: $serviceId, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('price: $price, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('notified24h: $notified24h, ')
          ..write('notified5h: $notified5h, ')
          ..write('notified1h: $notified1h')
          ..write(')'))
        .toString();
  }
}

class $AppointmentLogsTable extends AppointmentLogs
    with TableInfo<$AppointmentLogsTable, AppointmentLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _appointmentIdMeta =
      const VerificationMeta('appointmentId');
  @override
  late final GeneratedColumn<int> appointmentId = GeneratedColumn<int>(
      'appointment_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES appointments (id)'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _performedByMeta =
      const VerificationMeta('performedBy');
  @override
  late final GeneratedColumn<String> performedBy = GeneratedColumn<String>(
      'performed_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, appointmentId, action, performedBy, details, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointment_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AppointmentLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
          _appointmentIdMeta,
          appointmentId.isAcceptableOrUnknown(
              data['appointment_id']!, _appointmentIdMeta));
    } else if (isInserting) {
      context.missing(_appointmentIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('performed_by')) {
      context.handle(
          _performedByMeta,
          performedBy.isAcceptableOrUnknown(
              data['performed_by']!, _performedByMeta));
    } else if (isInserting) {
      context.missing(_performedByMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppointmentLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppointmentLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      appointmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}appointment_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      performedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}performed_by'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AppointmentLogsTable createAlias(String alias) {
    return $AppointmentLogsTable(attachedDatabase, alias);
  }
}

class AppointmentLog extends DataClass implements Insertable<AppointmentLog> {
  final int id;
  final int appointmentId;
  final String action;
  final String performedBy;
  final String? details;
  final String createdAt;
  const AppointmentLog(
      {required this.id,
      required this.appointmentId,
      required this.action,
      required this.performedBy,
      this.details,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['appointment_id'] = Variable<int>(appointmentId);
    map['action'] = Variable<String>(action);
    map['performed_by'] = Variable<String>(performedBy);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  AppointmentLogsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentLogsCompanion(
      id: Value(id),
      appointmentId: Value(appointmentId),
      action: Value(action),
      performedBy: Value(performedBy),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdAt: Value(createdAt),
    );
  }

  factory AppointmentLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppointmentLog(
      id: serializer.fromJson<int>(json['id']),
      appointmentId: serializer.fromJson<int>(json['appointmentId']),
      action: serializer.fromJson<String>(json['action']),
      performedBy: serializer.fromJson<String>(json['performedBy']),
      details: serializer.fromJson<String?>(json['details']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'appointmentId': serializer.toJson<int>(appointmentId),
      'action': serializer.toJson<String>(action),
      'performedBy': serializer.toJson<String>(performedBy),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  AppointmentLog copyWith(
          {int? id,
          int? appointmentId,
          String? action,
          String? performedBy,
          Value<String?> details = const Value.absent(),
          String? createdAt}) =>
      AppointmentLog(
        id: id ?? this.id,
        appointmentId: appointmentId ?? this.appointmentId,
        action: action ?? this.action,
        performedBy: performedBy ?? this.performedBy,
        details: details.present ? details.value : this.details,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('AppointmentLog(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('action: $action, ')
          ..write('performedBy: $performedBy, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, appointmentId, action, performedBy, details, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentLog &&
          other.id == this.id &&
          other.appointmentId == this.appointmentId &&
          other.action == this.action &&
          other.performedBy == this.performedBy &&
          other.details == this.details &&
          other.createdAt == this.createdAt);
}

class AppointmentLogsCompanion extends UpdateCompanion<AppointmentLog> {
  final Value<int> id;
  final Value<int> appointmentId;
  final Value<String> action;
  final Value<String> performedBy;
  final Value<String?> details;
  final Value<String> createdAt;
  const AppointmentLogsCompanion({
    this.id = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.action = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppointmentLogsCompanion.insert({
    this.id = const Value.absent(),
    required int appointmentId,
    required String action,
    required String performedBy,
    this.details = const Value.absent(),
    required String createdAt,
  })  : appointmentId = Value(appointmentId),
        action = Value(action),
        performedBy = Value(performedBy),
        createdAt = Value(createdAt);
  static Insertable<AppointmentLog> custom({
    Expression<int>? id,
    Expression<int>? appointmentId,
    Expression<String>? action,
    Expression<String>? performedBy,
    Expression<String>? details,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (action != null) 'action': action,
      if (performedBy != null) 'performed_by': performedBy,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppointmentLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? appointmentId,
      Value<String>? action,
      Value<String>? performedBy,
      Value<String?>? details,
      Value<String>? createdAt}) {
    return AppointmentLogsCompanion(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      action: action ?? this.action,
      performedBy: performedBy ?? this.performedBy,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<int>(appointmentId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (performedBy.present) {
      map['performed_by'] = Variable<String>(performedBy.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentLogsCompanion(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('action: $action, ')
          ..write('performedBy: $performedBy, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES businesses (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _appointmentIdMeta =
      const VerificationMeta('appointmentId');
  @override
  late final GeneratedColumn<int> appointmentId = GeneratedColumn<int>(
      'appointment_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES appointments (id)'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        type,
        amount,
        category,
        description,
        paymentMethod,
        appointmentId,
        customerId,
        date,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
          _appointmentIdMeta,
          appointmentId.isAcceptableOrUnknown(
              data['appointment_id']!, _appointmentIdMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      appointmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}appointment_id']),
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int businessId;
  final String type;
  final double amount;
  final String category;
  final String? description;
  final String paymentMethod;
  final int? appointmentId;
  final int? customerId;
  final String date;
  final String createdAt;
  const Transaction(
      {required this.id,
      required this.businessId,
      required this.type,
      required this.amount,
      required this.category,
      this.description,
      required this.paymentMethod,
      this.appointmentId,
      this.customerId,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_id'] = Variable<int>(businessId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || appointmentId != null) {
      map['appointment_id'] = Variable<int>(appointmentId);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['date'] = Variable<String>(date);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      type: Value(type),
      amount: Value(amount),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      paymentMethod: Value(paymentMethod),
      appointmentId: appointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      businessId: serializer.fromJson<int>(json['businessId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      appointmentId: serializer.fromJson<int?>(json['appointmentId']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      date: serializer.fromJson<String>(json['date']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessId': serializer.toJson<int>(businessId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'appointmentId': serializer.toJson<int?>(appointmentId),
      'customerId': serializer.toJson<int?>(customerId),
      'date': serializer.toJson<String>(date),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Transaction copyWith(
          {int? id,
          int? businessId,
          String? type,
          double? amount,
          String? category,
          Value<String?> description = const Value.absent(),
          String? paymentMethod,
          Value<int?> appointmentId = const Value.absent(),
          Value<int?> customerId = const Value.absent(),
          String? date,
          String? createdAt}) =>
      Transaction(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        description: description.present ? description.value : this.description,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        appointmentId:
            appointmentId.present ? appointmentId.value : this.appointmentId,
        customerId: customerId.present ? customerId.value : this.customerId,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('customerId: $customerId, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, type, amount, category,
      description, paymentMethod, appointmentId, customerId, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.description == this.description &&
          other.paymentMethod == this.paymentMethod &&
          other.appointmentId == this.appointmentId &&
          other.customerId == this.customerId &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> businessId;
  final Value<String> type;
  final Value<double> amount;
  final Value<String> category;
  final Value<String?> description;
  final Value<String> paymentMethod;
  final Value<int?> appointmentId;
  final Value<int?> customerId;
  final Value<String> date;
  final Value<String> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int businessId,
    required String type,
    required double amount,
    required String category,
    this.description = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.customerId = const Value.absent(),
    required String date,
    required String createdAt,
  })  : businessId = Value(businessId),
        type = Value(type),
        amount = Value(amount),
        category = Value(category),
        date = Value(date),
        createdAt = Value(createdAt);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? businessId,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? paymentMethod,
    Expression<int>? appointmentId,
    Expression<int>? customerId,
    Expression<String>? date,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (customerId != null) 'customer_id': customerId,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? businessId,
      Value<String>? type,
      Value<double>? amount,
      Value<String>? category,
      Value<String?>? description,
      Value<String>? paymentMethod,
      Value<int?>? appointmentId,
      Value<int?>? customerId,
      Value<String>? date,
      Value<String>? createdAt}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      appointmentId: appointmentId ?? this.appointmentId,
      customerId: customerId ?? this.customerId,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<int>(appointmentId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('customerId: $customerId, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES businesses (id)'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _appointmentIdMeta =
      const VerificationMeta('appointmentId');
  @override
  late final GeneratedColumn<int> appointmentId = GeneratedColumn<int>(
      'appointment_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES appointments (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
      'due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        customerId,
        appointmentId,
        amount,
        paidAmount,
        description,
        status,
        dueDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(Insertable<Debt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
          _appointmentIdMeta,
          appointmentId.isAcceptableOrUnknown(
              data['appointment_id']!, _appointmentIdMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      appointmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}appointment_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}paid_amount'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class Debt extends DataClass implements Insertable<Debt> {
  final int id;
  final int businessId;
  final int customerId;
  final int? appointmentId;
  final double amount;
  final double paidAmount;
  final String? description;
  final String status;
  final String? dueDate;
  final String createdAt;
  const Debt(
      {required this.id,
      required this.businessId,
      required this.customerId,
      this.appointmentId,
      required this.amount,
      required this.paidAmount,
      this.description,
      required this.status,
      this.dueDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_id'] = Variable<int>(businessId);
    map['customer_id'] = Variable<int>(customerId);
    if (!nullToAbsent || appointmentId != null) {
      map['appointment_id'] = Variable<int>(appointmentId);
    }
    map['amount'] = Variable<double>(amount);
    map['paid_amount'] = Variable<double>(paidAmount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      customerId: Value(customerId),
      appointmentId: appointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentId),
      amount: Value(amount),
      paidAmount: Value(paidAmount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      createdAt: Value(createdAt),
    );
  }

  factory Debt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      id: serializer.fromJson<int>(json['id']),
      businessId: serializer.fromJson<int>(json['businessId']),
      customerId: serializer.fromJson<int>(json['customerId']),
      appointmentId: serializer.fromJson<int?>(json['appointmentId']),
      amount: serializer.fromJson<double>(json['amount']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessId': serializer.toJson<int>(businessId),
      'customerId': serializer.toJson<int>(customerId),
      'appointmentId': serializer.toJson<int?>(appointmentId),
      'amount': serializer.toJson<double>(amount),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'dueDate': serializer.toJson<String?>(dueDate),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Debt copyWith(
          {int? id,
          int? businessId,
          int? customerId,
          Value<int?> appointmentId = const Value.absent(),
          double? amount,
          double? paidAmount,
          Value<String?> description = const Value.absent(),
          String? status,
          Value<String?> dueDate = const Value.absent(),
          String? createdAt}) =>
      Debt(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        customerId: customerId ?? this.customerId,
        appointmentId:
            appointmentId.present ? appointmentId.value : this.appointmentId,
        amount: amount ?? this.amount,
        paidAmount: paidAmount ?? this.paidAmount,
        description: description.present ? description.value : this.description,
        status: status ?? this.status,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('customerId: $customerId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('amount: $amount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, customerId, appointmentId,
      amount, paidAmount, description, status, dueDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.customerId == this.customerId &&
          other.appointmentId == this.appointmentId &&
          other.amount == this.amount &&
          other.paidAmount == this.paidAmount &&
          other.description == this.description &&
          other.status == this.status &&
          other.dueDate == this.dueDate &&
          other.createdAt == this.createdAt);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<int> id;
  final Value<int> businessId;
  final Value<int> customerId;
  final Value<int?> appointmentId;
  final Value<double> amount;
  final Value<double> paidAmount;
  final Value<String?> description;
  final Value<String> status;
  final Value<String?> dueDate;
  final Value<String> createdAt;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.id = const Value.absent(),
    required int businessId,
    required int customerId,
    this.appointmentId = const Value.absent(),
    required double amount,
    this.paidAmount = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDate = const Value.absent(),
    required String createdAt,
  })  : businessId = Value(businessId),
        customerId = Value(customerId),
        amount = Value(amount),
        createdAt = Value(createdAt);
  static Insertable<Debt> custom({
    Expression<int>? id,
    Expression<int>? businessId,
    Expression<int>? customerId,
    Expression<int>? appointmentId,
    Expression<double>? amount,
    Expression<double>? paidAmount,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? dueDate,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (customerId != null) 'customer_id': customerId,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (amount != null) 'amount': amount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (dueDate != null) 'due_date': dueDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DebtsCompanion copyWith(
      {Value<int>? id,
      Value<int>? businessId,
      Value<int>? customerId,
      Value<int?>? appointmentId,
      Value<double>? amount,
      Value<double>? paidAmount,
      Value<String?>? description,
      Value<String>? status,
      Value<String?>? dueDate,
      Value<String>? createdAt}) {
    return DebtsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      customerId: customerId ?? this.customerId,
      appointmentId: appointmentId ?? this.appointmentId,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<int>(appointmentId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('customerId: $customerId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('amount: $amount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MessageLogsTable extends MessageLogs
    with TableInfo<$MessageLogsTable, MessageLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES businesses (id)'));
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageTypeMeta =
      const VerificationMeta('messageType');
  @override
  late final GeneratedColumn<String> messageType = GeneratedColumn<String>(
      'message_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _directionMeta =
      const VerificationMeta('direction');
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
      'direction', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('outgoing'));
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
      'error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<String> sentAt = GeneratedColumn<String>(
      'sent_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageId,
        businessId,
        customerPhone,
        messageType,
        message,
        status,
        direction,
        error,
        sentAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_logs';
  @override
  VerificationContext validateIntegrity(Insertable<MessageLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    } else if (isInserting) {
      context.missing(_customerPhoneMeta);
    }
    if (data.containsKey('message_type')) {
      context.handle(
          _messageTypeMeta,
          messageType.isAcceptableOrUnknown(
              data['message_type']!, _messageTypeMeta));
    } else if (isInserting) {
      context.missing(_messageTypeMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    }
    if (data.containsKey('error')) {
      context.handle(
          _errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sentAtMeta,
          sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta));
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone'])!,
      messageType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_type'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      direction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direction'])!,
      error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error']),
      sentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sent_at'])!,
    );
  }

  @override
  $MessageLogsTable createAlias(String alias) {
    return $MessageLogsTable(attachedDatabase, alias);
  }
}

class MessageLog extends DataClass implements Insertable<MessageLog> {
  final int id;
  final String messageId;
  final int businessId;
  final String customerPhone;
  final String messageType;
  final String message;
  final String status;
  final String direction;
  final String? error;
  final String sentAt;
  const MessageLog(
      {required this.id,
      required this.messageId,
      required this.businessId,
      required this.customerPhone,
      required this.messageType,
      required this.message,
      required this.status,
      required this.direction,
      this.error,
      required this.sentAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message_id'] = Variable<String>(messageId);
    map['business_id'] = Variable<int>(businessId);
    map['customer_phone'] = Variable<String>(customerPhone);
    map['message_type'] = Variable<String>(messageType);
    map['message'] = Variable<String>(message);
    map['status'] = Variable<String>(status);
    map['direction'] = Variable<String>(direction);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['sent_at'] = Variable<String>(sentAt);
    return map;
  }

  MessageLogsCompanion toCompanion(bool nullToAbsent) {
    return MessageLogsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      businessId: Value(businessId),
      customerPhone: Value(customerPhone),
      messageType: Value(messageType),
      message: Value(message),
      status: Value(status),
      direction: Value(direction),
      error:
          error == null && nullToAbsent ? const Value.absent() : Value(error),
      sentAt: Value(sentAt),
    );
  }

  factory MessageLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageLog(
      id: serializer.fromJson<int>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      businessId: serializer.fromJson<int>(json['businessId']),
      customerPhone: serializer.fromJson<String>(json['customerPhone']),
      messageType: serializer.fromJson<String>(json['messageType']),
      message: serializer.fromJson<String>(json['message']),
      status: serializer.fromJson<String>(json['status']),
      direction: serializer.fromJson<String>(json['direction']),
      error: serializer.fromJson<String?>(json['error']),
      sentAt: serializer.fromJson<String>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'messageId': serializer.toJson<String>(messageId),
      'businessId': serializer.toJson<int>(businessId),
      'customerPhone': serializer.toJson<String>(customerPhone),
      'messageType': serializer.toJson<String>(messageType),
      'message': serializer.toJson<String>(message),
      'status': serializer.toJson<String>(status),
      'direction': serializer.toJson<String>(direction),
      'error': serializer.toJson<String?>(error),
      'sentAt': serializer.toJson<String>(sentAt),
    };
  }

  MessageLog copyWith(
          {int? id,
          String? messageId,
          int? businessId,
          String? customerPhone,
          String? messageType,
          String? message,
          String? status,
          String? direction,
          Value<String?> error = const Value.absent(),
          String? sentAt}) =>
      MessageLog(
        id: id ?? this.id,
        messageId: messageId ?? this.messageId,
        businessId: businessId ?? this.businessId,
        customerPhone: customerPhone ?? this.customerPhone,
        messageType: messageType ?? this.messageType,
        message: message ?? this.message,
        status: status ?? this.status,
        direction: direction ?? this.direction,
        error: error.present ? error.value : this.error,
        sentAt: sentAt ?? this.sentAt,
      );
  @override
  String toString() {
    return (StringBuffer('MessageLog(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('businessId: $businessId, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('messageType: $messageType, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('direction: $direction, ')
          ..write('error: $error, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, messageId, businessId, customerPhone,
      messageType, message, status, direction, error, sentAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageLog &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.businessId == this.businessId &&
          other.customerPhone == this.customerPhone &&
          other.messageType == this.messageType &&
          other.message == this.message &&
          other.status == this.status &&
          other.direction == this.direction &&
          other.error == this.error &&
          other.sentAt == this.sentAt);
}

class MessageLogsCompanion extends UpdateCompanion<MessageLog> {
  final Value<int> id;
  final Value<String> messageId;
  final Value<int> businessId;
  final Value<String> customerPhone;
  final Value<String> messageType;
  final Value<String> message;
  final Value<String> status;
  final Value<String> direction;
  final Value<String?> error;
  final Value<String> sentAt;
  const MessageLogsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.businessId = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.messageType = const Value.absent(),
    this.message = const Value.absent(),
    this.status = const Value.absent(),
    this.direction = const Value.absent(),
    this.error = const Value.absent(),
    this.sentAt = const Value.absent(),
  });
  MessageLogsCompanion.insert({
    this.id = const Value.absent(),
    required String messageId,
    required int businessId,
    required String customerPhone,
    required String messageType,
    required String message,
    required String status,
    this.direction = const Value.absent(),
    this.error = const Value.absent(),
    required String sentAt,
  })  : messageId = Value(messageId),
        businessId = Value(businessId),
        customerPhone = Value(customerPhone),
        messageType = Value(messageType),
        message = Value(message),
        status = Value(status),
        sentAt = Value(sentAt);
  static Insertable<MessageLog> custom({
    Expression<int>? id,
    Expression<String>? messageId,
    Expression<int>? businessId,
    Expression<String>? customerPhone,
    Expression<String>? messageType,
    Expression<String>? message,
    Expression<String>? status,
    Expression<String>? direction,
    Expression<String>? error,
    Expression<String>? sentAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (businessId != null) 'business_id': businessId,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (messageType != null) 'message_type': messageType,
      if (message != null) 'message': message,
      if (status != null) 'status': status,
      if (direction != null) 'direction': direction,
      if (error != null) 'error': error,
      if (sentAt != null) 'sent_at': sentAt,
    });
  }

  MessageLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? messageId,
      Value<int>? businessId,
      Value<String>? customerPhone,
      Value<String>? messageType,
      Value<String>? message,
      Value<String>? status,
      Value<String>? direction,
      Value<String?>? error,
      Value<String>? sentAt}) {
    return MessageLogsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      businessId: businessId ?? this.businessId,
      customerPhone: customerPhone ?? this.customerPhone,
      messageType: messageType ?? this.messageType,
      message: message ?? this.message,
      status: status ?? this.status,
      direction: direction ?? this.direction,
      error: error ?? this.error,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (messageType.present) {
      map['message_type'] = Variable<String>(messageType.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<String>(sentAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageLogsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('businessId: $businessId, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('messageType: $messageType, ')
          ..write('message: $message, ')
          ..write('status: $status, ')
          ..write('direction: $direction, ')
          ..write('error: $error, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }
}

class $WorkingHoursTable extends WorkingHours
    with TableInfo<$WorkingHoursTable, WorkingHour> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkingHoursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
      'employee_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES employees (id)'));
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES businesses (id)'));
  static const VerificationMeta _dayOfWeekMeta =
      const VerificationMeta('dayOfWeek');
  @override
  late final GeneratedColumn<String> dayOfWeek = GeneratedColumn<String>(
      'day_of_week', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
      'start_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
      'end_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, employeeId, businessId, dayOfWeek, startTime, endTime, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'working_hours';
  @override
  VerificationContext validateIntegrity(Insertable<WorkingHour> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
          _dayOfWeekMeta,
          dayOfWeek.isAcceptableOrUnknown(
              data['day_of_week']!, _dayOfWeekMeta));
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkingHour map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkingHour(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}employee_id']),
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      dayOfWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day_of_week'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_time'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $WorkingHoursTable createAlias(String alias) {
    return $WorkingHoursTable(attachedDatabase, alias);
  }
}

class WorkingHour extends DataClass implements Insertable<WorkingHour> {
  final int id;
  final int? employeeId;
  final int businessId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;
  const WorkingHour(
      {required this.id,
      this.employeeId,
      required this.businessId,
      required this.dayOfWeek,
      required this.startTime,
      required this.endTime,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<int>(employeeId);
    }
    map['business_id'] = Variable<int>(businessId);
    map['day_of_week'] = Variable<String>(dayOfWeek);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  WorkingHoursCompanion toCompanion(bool nullToAbsent) {
    return WorkingHoursCompanion(
      id: Value(id),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      businessId: Value(businessId),
      dayOfWeek: Value(dayOfWeek),
      startTime: Value(startTime),
      endTime: Value(endTime),
      isActive: Value(isActive),
    );
  }

  factory WorkingHour.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkingHour(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<int?>(json['employeeId']),
      businessId: serializer.fromJson<int>(json['businessId']),
      dayOfWeek: serializer.fromJson<String>(json['dayOfWeek']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<int?>(employeeId),
      'businessId': serializer.toJson<int>(businessId),
      'dayOfWeek': serializer.toJson<String>(dayOfWeek),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  WorkingHour copyWith(
          {int? id,
          Value<int?> employeeId = const Value.absent(),
          int? businessId,
          String? dayOfWeek,
          String? startTime,
          String? endTime,
          bool? isActive}) =>
      WorkingHour(
        id: id ?? this.id,
        employeeId: employeeId.present ? employeeId.value : this.employeeId,
        businessId: businessId ?? this.businessId,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        isActive: isActive ?? this.isActive,
      );
  @override
  String toString() {
    return (StringBuffer('WorkingHour(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('businessId: $businessId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, employeeId, businessId, dayOfWeek, startTime, endTime, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkingHour &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.businessId == this.businessId &&
          other.dayOfWeek == this.dayOfWeek &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.isActive == this.isActive);
}

class WorkingHoursCompanion extends UpdateCompanion<WorkingHour> {
  final Value<int> id;
  final Value<int?> employeeId;
  final Value<int> businessId;
  final Value<String> dayOfWeek;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<bool> isActive;
  const WorkingHoursCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.businessId = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  WorkingHoursCompanion.insert({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    required int businessId,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    this.isActive = const Value.absent(),
  })  : businessId = Value(businessId),
        dayOfWeek = Value(dayOfWeek),
        startTime = Value(startTime),
        endTime = Value(endTime);
  static Insertable<WorkingHour> custom({
    Expression<int>? id,
    Expression<int>? employeeId,
    Expression<int>? businessId,
    Expression<String>? dayOfWeek,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (businessId != null) 'business_id': businessId,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (isActive != null) 'is_active': isActive,
    });
  }

  WorkingHoursCompanion copyWith(
      {Value<int>? id,
      Value<int?>? employeeId,
      Value<int>? businessId,
      Value<String>? dayOfWeek,
      Value<String>? startTime,
      Value<String>? endTime,
      Value<bool>? isActive}) {
    return WorkingHoursCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      businessId: businessId ?? this.businessId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<String>(dayOfWeek.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkingHoursCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('businessId: $businessId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $TransactionCategoriesTable extends TransactionCategories
    with TableInfo<$TransactionCategoriesTable, TransactionCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES businesses (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, businessId, name, type, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_categories';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TransactionCategoriesTable createAlias(String alias) {
    return $TransactionCategoriesTable(attachedDatabase, alias);
  }
}

class TransactionCategory extends DataClass
    implements Insertable<TransactionCategory> {
  final int id;
  final int businessId;
  final String name;
  final String type;
  final String createdAt;
  const TransactionCategory(
      {required this.id,
      required this.businessId,
      required this.name,
      required this.type,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_id'] = Variable<int>(businessId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  TransactionCategoriesCompanion toCompanion(bool nullToAbsent) {
    return TransactionCategoriesCompanion(
      id: Value(id),
      businessId: Value(businessId),
      name: Value(name),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionCategory(
      id: serializer.fromJson<int>(json['id']),
      businessId: serializer.fromJson<int>(json['businessId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessId': serializer.toJson<int>(businessId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  TransactionCategory copyWith(
          {int? id,
          int? businessId,
          String? name,
          String? type,
          String? createdAt}) =>
      TransactionCategory(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        name: name ?? this.name,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('TransactionCategory(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, name, type, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionCategory &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.name == this.name &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class TransactionCategoriesCompanion
    extends UpdateCompanion<TransactionCategory> {
  final Value<int> id;
  final Value<int> businessId;
  final Value<String> name;
  final Value<String> type;
  final Value<String> createdAt;
  const TransactionCategoriesCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int businessId,
    required String name,
    required String type,
    required String createdAt,
  })  : businessId = Value(businessId),
        name = Value(name),
        type = Value(type),
        createdAt = Value(createdAt);
  static Insertable<TransactionCategory> custom({
    Expression<int>? id,
    Expression<int>? businessId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? businessId,
      Value<String>? name,
      Value<String>? type,
      Value<String>? createdAt}) {
    return TransactionCategoriesCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$DatabaseService extends GeneratedDatabase {
  _$DatabaseService(QueryExecutor e) : super(e);
  late final $BusinessesTable businesses = $BusinessesTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $AppointmentLogsTable appointmentLogs =
      $AppointmentLogsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $MessageLogsTable messageLogs = $MessageLogsTable(this);
  late final $WorkingHoursTable workingHours = $WorkingHoursTable(this);
  late final $TransactionCategoriesTable transactionCategories =
      $TransactionCategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        businesses,
        employees,
        customers,
        services,
        appointments,
        appointmentLogs,
        transactions,
        debts,
        messageLogs,
        workingHours,
        transactionCategories
      ];
}
