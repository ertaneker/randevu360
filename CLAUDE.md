# Randevu 360 — AI Geliştirici Ortağı İçin Proje Bağlamı

## Proje Özeti
Küçük işletmeler (berber, kuaför) için randevu yönetimi. WhatsApp hatırlatma, çalışan yönetimi, finans takibi. Mobil-first, bilgisayar gerekmez.

## Teknoloji
- Flutter 3.38+ (Dart 3.10+) — Mobil uygulama (Android + iOS)
- Firebase Auth (Google Sign-In) — Giriş (TEK Firebase kullanımı)
- Drift (SQLite) — Yerel veritabanı
- Oracle Cloud PostgreSQL — İşletme metadata, çalışan yönetimi, veri senkronu
- Google Drive API — Yedekleme
- Node.js + @whiskeysockets/baileys — WhatsApp servisi
- Docker + Oracle Cloud Free Tier — WhatsApp + API + PostgreSQL

## Proje Yapısı
```
randevu360/
├── CLAUDE.md
├── plan.md
├── oracle_cloud.md         ← Oracle Cloud kurulum rehberi
├── .mcp.json               ← stitch.withgoogle.com MCP server
├── .github/workflows/      ← CI/CD (flutter-ci.yml, whatsapp-ci.yml)
├── mobile/                 ← Flutter uygulaması
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart        ← Provider + routing + route table
│   │   ├── core/           ← Auth (IAuthService), database (Drift), backup, theme, constants
│   │   ├── providers/      ← 7 provider (Auth, Business, Appointment, Employee, Finance, Customer, WhatsApp)
│   │   ├── services/       ← Cloud API, data sync, notifications
│   │   └── screens/
│   │       ├── auth/       ← LoginScreen, RoleSelectionScreen
│   │       ├── home/       ← HomeScreen, DashboardWidget
│   │       ├── appointment/← AppointmentScreen, NewAppointmentScreen
│   │       ├── business/   ← BusinessSetupScreen
│   │       ├── customer/   ← AddCustomerScreen (telefon rehberi)
│   │       ├── employee/   ← EmployeeScreen
│   │       ├── finance/    ← FinanceScreen
│   │       ├── profile/    ← ProfileScreen
│   │       └── whatsapp/   ← WhatsAppConnectScreen
│   ├── test/               ← 27 test (auth 8, appointment 11, business 5, widget 3)
│   └── pubspec.yaml
├── whatsapp-service/       ← Node.js + Baileys (Docker)
│   ├── src/                ← index, client, scheduler, api, db (sql.js)
│   ├── Dockerfile          ← git+SSH→HTTPS fix, ca-certificates, openssh-client
│   └── package.json
└── firebase/               ← Firestore rules + config
```

## Firebase
- **Proje ID:** `randevu360-cef66`
- **Android package:** `com.sincera.randevu360`
- **iOS bundle:** `com.sincera.randevu360`
- **Auth:** Google Sign-In ✅ (aktif — TEK kullanım)
- **Firestore:** KAPALI (tüm veri Oracle Cloud PostgreSQL'de)
- **Config:** google-services.json ✅, GoogleService-Info.plist ✅

## Oracle Cloud (WhatsApp + API + PostgreSQL) ✅
- **Sunucu IP:** `140.86.209.80`
- **Port:** `3000` (WhatsApp + API, aynı Express sunucusu)
- **API Key:** `c8c3bc9f148cbf64e98b10151a189b1e06bf1e31a61a7a9eedb227783428c3c5`
- **Health:** `curl http://140.86.209.80:3000/api/health` → `{"status":"ok"}`
- **SSH:** `ssh oracle-randevu360` (key: `C:\Users\ertan\.ssh\oracle_randevu360`)
- **Container'lar:** `randevu360-whatsapp`, `randevu360-postgres` (docker-compose)
- **PostgreSQL:** `postgresql://randevu360:randevu360@postgres:5432/randevu360` (iç ağ)
- **Region:** eu-zurich-1
- **Kurulum dökümanı:** `oracle_cloud.md`

## Yapılanlar (TAM DURUM — 2026-07-09)

### 2026-07-16 üçüncü geçiş — FIRESTORE → ORACLE CLOUD POSTGRESQL (yapıldı, deploy edilmedi)
- **Firestore tamamen kaldırıldı.** Firebase sadece Auth (Google Sign-In) için kullanılıyor.
- **Oracle Cloud PostgreSQL:** İşletme metadata, çalışan yönetimi, izinler, WhatsApp oturumu, veri senkronu (rows) artık PostgreSQL'de.
- **Yeni tablolar:** `businesses`, `business_employees`, `whatsapp_sessions`, `sync_rows`.
- **Yeni API endpoint'leri:** `/api/business/:id` (GET/PUT), `/api/business/:id/settings` (PUT), `/api/business/:id/employees` (POST/GET), `/api/business/:id/employees/:email` (DELETE/PUT), `/api/employees/lookup` (GET), `/api/business/:id/employees/:email/permissions` (GET), `/api/business/:id/whatsapp-session` (GET/PUT), `/api/sync/:businessId/pull` (POST), `/api/sync/:businessId/push` (POST).
- **Flutter:** `FirestoreSyncService` → `CloudApiService` (http tabanlı). `DataSyncService` periyodik polling yok — manuel tetikleme (açılış + nudge + kullanıcı).
- **docker-compose:** PostgreSQL 16 Alpine container eklendi (randevu360-postgres, iç ağ, port dışa açık değil).
- **Firestore rules:** Tüm koleksiyonlar kapalı (deny all).
- **Maliyet:** Firestore $713/ay → PostgreSQL $0/ay (Oracle Cloud Free Tier içinde).
- **Deploy edilmedi.** Sunucuya göndermek için: `scp src/*.js` → `docker-compose build` → `docker-compose up -d`.

### Altyapı
- [x] Firebase Console: proje + Auth (Firestore KAPALI, sadece Auth aktif)
- [x] Drift veritabanı şeması (10 tablo, @DataClassName anotasyonlu)
- [x] Drift code generation (116 outputs, 0 hata)
- [x] Android google-services plugin + iOS Podfile
- [x] Android desugaring (build.gradle.kts: isCoreLibraryDesugaringEnabled + desugar_jdk_libs)
- [x] stitch.withgoogle.com MCP server (.mcp.json)

### Flutter App — Ekranlar & Provider'lar
- [x] 7 provider (tümü DatabaseService injection alıyor)
- [x] 9 ekran + RoleSelectionScreen
- [x] Auth flow: Loading → LoginScreen → RoleSelectionScreen → BusinessSetup/HomeScreen
- [x] Google Sign-In → Rol seçimi (İşletme Sahibi / Çalışan)
- [x] İşletme kurulum → DB kayıt → pop → role check → HomeScreen
- [x] Dashboard: AppointmentProvider ile canlı istatistik (initState'te loadAppointments)
- [x] Randevu takvimi: TableCalendar + günlük liste + çalışan filtresi
- [x] Yeni Randevu ekranı: Müşteri dropdown, hizmet, çalışan, tarih/saat, fiyat, not
- [x] Finans ekranı: Bilanço, gelir/gider listesi, işlem ekleme
- [x] Çalışan ekranı: Liste, ekleme, rol güncelleme
- [x] Profil ekranı: Kullanıcı bilgisi, yedekleme, WhatsApp ayarları, çıkış
- [x] WhatsApp bağlantı ekranı: Telefon → uluslararası format → pairing code
- [x] Müşteri ekleme: Manuel form + telefon rehberi (flutter_contacts)
- [x] Tüm ekranlar initState'te veri yüklüyor (addPostFrameCallback)

### WhatsApp Servisi
- [x] Node.js + Baileys + sql.js (native build gerekmez)
- [x] Dockerfile: git, openssh-client, ca-certificates, HTTPS redirect
- [x] Oracle Cloud deploy: 140.86.209.80:3000, container çalışıyor
- [x] Health check: `{"status":"ok"}`
- [x] Pairing code API: POST /api/pairing/request
- [x] Otomatik hatırlatma zamanlayıcı (60s interval, 24h/5h/1h)
- [x] Telefon formatı: `client.js` `normalizePhone()` — 05XX/5XX → 905XXXXXXXXX (2026-07-13'e kadar YOKTU; yerel formatlı numarada Baileys sonsuza kadar bekliyor, gönderim asılı kalıyordu)
- [x] Gönderim timeout'u: 25sn (Baileys asılı kalırsa istek süresiz kilitlenmesin)
- [x] Gerçek business ID kullanılıyor (hardcoded placeholder kaldırıldı)

### Kalite
- [x] Flutter analyze: 0 hata, 0 warning, 0 info (2026-07-13)
- [x] 47 test geçiyor (auth, appointment, business, finance, whatsapp, widget)
- [x] CI/CD: GitHub Actions (Flutter CI, WhatsApp CI, Dependabot)
- [x] IAuthService interface (test edilebilir auth)

## Bilinen Sorunlar / Test Edilmesi Gerekenler

1. **WhatsApp pairing:** Kod alınıyor ama "cihaz bağlanamadı" hatası olabilir. Telefon numarası 90 ile başlamalı, WhatsApp aynı numarada olmalı. Baileys pairing code ~60sn geçerli.
2. **Çalışan girişi:** Davet akışı kodda var; Firestore kural hatası (aşağıda) düzeltildi ama uçtan uca cihazda hâlâ test edilmedi.
1. **iOS build:** Yapılandırma tamam (2026-07-16). macOS gerektirir, build edilmedi.
4. **Google Drive yedekleme:** BackupService var ama test edilmedi.
5. **Hatırlatma akışı cihazda doğrulanmadı:** Sunucu altyapısı deploy edildi (aşağıda) ama gerçek bir randevu ile uçtan uca WhatsApp mesajı gelmesi izlenmedi.

### 2026-07-13 ikinci geçiş — hizmetler, tahsilat, şablonlar (yapıldı, deploy edildi)
- **Firestore kuralı düzeltildi + deploy edildi:** `businesses/{id}` okuma kuralı `resource.data.ownerUid` kontrol ediyordu; doküman yokken `resource` null olduğu için `PERMISSION_DENIED` dönüyordu. `getEmployeeData()` ilk satırda buna takılıp `catch` ile yutuluyor, çalışan daveti araması hiç çalışmıyordu. Kurala `businessId == request.auth.uid` şartı eklendi.
- **Hizmetler artık gerçek tabloda:** Eskiden `new_appointment_screen` içinde hardcoded map vardı, `serviceId` sahte (`index+1`) yazılıyordu; `Services` tablosu boştu, randevu listesinde hizmet adı gelmiyordu. Artık `ServiceProvider` + Profil > "Hizmetler ve Fiyatlar" (arama, ekle/düzenle, pasifleştir, yüzde/tutar toplu zam). Silme soft-delete (`status='inactive'`) — geçmiş randevular serviceId ile bağlı.
- **Randevu tamamlama → tahsilat:** `PaymentDialog` (tutar ön-dolu + Nakit/Kart) → `Transactions`'a gelir (`appointmentId`, `customerId`, `paymentMethod` dolu). Tamamlanmış randevuda buton gizli, çift gelir yazılamıyor.
- **Çalışan kısıtlaması:** Profilde sadece İşletme Bilgileri + WhatsApp + Çıkış. `BusinessInfoScreen` salt-okunur, `WhatsAppConnectScreen`'de bağlantı kontrolleri gizli (`auth.isAdmin`).
- **Hatırlatmalar artık gerçekten çalışıyor:** `db.getPendingAppointments()` boş dizi döndüren stub'dı ve `index.js` randevuları `FLUTTER_API_URL` ile *telefondan* çekmeye çalışıyordu (uygulama kapalıyken imkânsız). Artık randevular telefondan `POST /api/appointments/sync` ile sunucuya yazılıyor, zamanlayıcı kendi DB'sinden okuyor. Yeni tablolar: `appointments`, `message_templates`.
- **Mesaj şablonları:** Profil > "Mesaj Şablonları" — 6 tip (24s/5s/1s hatırlatma, oluşturuldu, tamamlandı, iptal). Değişkenler `{musteri} {isletme} {tarih} {saat} {hizmet} {tutar}`. Şablon boş bırakılırsa o mesaj gönderilmez. Sunucuda tutulur (`GET/PUT /api/templates/:businessId`).
- **Hatırlatma pencereleri genişletildi:** 24-23 saat gibi dar aralıklar servis kısa süre kapalıyken hatırlatmayı tamamen kaçırıyordu. Şimdi bitişik: 24→5, 5→1, 1→0.
- **TZ=Europe/Istanbul:** Konteyner UTC ile açılıyordu, randevu saatleri 3 saat kayardı. `index.js` + container env.
- Deploy: `scp src/*.js` → `docker build` → container yeniden kuruldu. `auth/` ve `data/` bind-mount olduğu için WhatsApp oturumu korundu.

### 2026-07-13 bakım geçişi (yapıldı)
- Flutter analyze 76 → 0 issue (withOpacity→withValues, DropdownButtonFormField value→initialValue, Switch activeColor→activeThumbColor, async-gap mounted kontrolleri, unused import/field temizliği, const/final düzeltmeleri).
- Randevu listesi müşteri adı sorunu zaten çözülmüştü (watchAppointmentsWithDetails join'i kullanılıyor) — eski not kaldırıldı.
- whatsapp-service düzeltmeleri: `/api/logs/:businessId` artık istatistik değil Flutter'ın beklediği camelCase mesaj listesi dönüyor (yeni `db.getMessageLogs`, `limit` destekli); `/api/send-template` `variables` eksikken 500 yerine 400 dönüyor; `/api/incoming` bozuk `stmt.run` yerine `db.logMessage` kullanıyor (artık diske kaydediliyor); scheduler polling DB init sonrasına taşındı.

### 2026-07-16 ikinci geçiş — EKİP ORTAK VERİ SENKRONU (yapıldı, cihazda TEST EDİLMEDİ)
Mimari karar ADR-001'de (codebase-memory `manage_adr`): P2P/WebRTC reddedildi, **Firestore satır günlüğü** seçildi.
- **Şema v5:** `SyncColumns` mixin → employees, customers, services, transaction_categories, appointments, transactions, debts. Kolonlar (nullable): `row_uid` (UUID, clientDefault `newRowUid()`), `sync_updated_at` (UTC ISO, LWW), `deleted_at` (tombstone), `last_synced_at`. `beforeOpen`'da idempotent altyapı: UUID backfill, `row_uid` unique index, **UPDATE trigger'ları** (`trg_{tablo}_sync_touch`) — app kodundaki her UPDATE `sync_updated_at`'i otomatik bumplar; koşul senkron motorunun kendi yazımlarını dışlar (pull-apply `sync_updated_at`, push-mark `last_synced_at` değiştirir → trigger sussun, sonsuz döngü olmasın).
- **Motor:** `lib/services/data_sync_service.dart` (singleton). Sıra pull→push (yeni cihaz ikizini birleştirmeden push etmesin). Doküman: `businesses/{remoteId}/rows/{rowUid}` = `{table, updatedAt, deletedAt, deviceId, serverAt: serverTimestamp, data{...FK'ler '{kolon}_uid' olarak rowUid}}`. Pull imleci prefs `sync_cursor_{remoteId}` (serverAt micros). Kirli satır: `last_synced_at IS NULL OR sync_updated_at > last_synced_at`. Çakışma LWW string karşılaştırma. Dedupe: employees e-posta, customers telefon (yalnız hiç senkronlanmamış yerel satır). Kendi deviceId dokümanları atlanır (echo yok).
- **Soft delete:** deleteEmployee/deleteService/deleteCategory artık tombstone (`softDeleteRow`); tüm liste/istatistik sorgularına `deleted_at IS NULL` eklendi. `deleteEmployeeByEmail` kasıtlı hard (yerel oturum temizliği, senkrona yayılmamalı).
- **Tetikleme:** StartupGate adım 3 "Veriler senkronize ediliyor..." → `DataSyncService.start` + ilk `syncNow` (30 sn timeout); sonra 60 sn periyodik + provider'lardan `nudge()` (4 sn debounce): randevu, müşteri, hizmet, çalışan, gelir/gider, borç.
- **Rules deploy edildi:** `businesses/{id}/rows/{rowUid}` — owner + çalışanlar okur/yazar.
- **Wipe entegrasyonu:** rol seçimindeki veri temizliği `DataSyncService.stop()` + `clearLocalState()` (imleçler) da yapar.
- Senkron DIŞI: businesses (kendi akışı), working_hours, appointment_logs, message_logs (sunucu), employee_permissions (zaten Firestore).
- Bilinen sınırlar: LWW istemci saati; senkron ilk kez tek (veri sahibi) cihazda açılmalı; FCM anlık tetikleme yok (sonraki faz — şimdilik 60 sn polling).
- 47/47 test, analyze 0 issue. Cihazda çok-cihaz senaryosu TEST EDİLMEDİ.

### 2026-07-16 geçişi — çalışan yaşam döngüsü, izinler, açılış senkronu (yapıldı, cihazda TEST EDİLMEDİ)
- **Silinen çalışan girişte doğrulanır:** Yerel rol çalışan üzerinden çözüldüyse (`viaEmployee`) Firestore'dan davet hâlâ var mı bakılır; silinmişse yerel employee satırı temizlenir → RoleSelectionScreen. Çevrimdışıysa yerel oturum korunur.
- **Rol seçimi yabancı veri temizliği:** Cihazdaki business başkasına aitse (ownerFbUid ≠ uid) "İşletme Sahibi" seçiminde onaylı `wipeAllData()` + BusinessSetupScreen; "Çalışan" seçiminde farklı remoteId'li işletmeye geçerken de aynı onaylı temizlik. `BusinessProvider.loadBusiness()` satır yoksa `_business=null` yapar (eskiden bayat kalıyordu).
- **Çalışan izinleri Firestore'da:** İzinler yönetici cihazının SQLite'ında kalıyordu — çalışan cihazına hiç ulaşmıyordu, kontroller hep varsayılana düşüyordu. Artık `businesses/{remoteId}/employees/{email}.permissions`'a yazılır (`updateEmployeePermissions`), çalışan cihazı kontrol anında okuyup yerel tabloya önbellekler. Tek giriş noktası `PermissionService.can(context, key)` — bireysel gönderim (müşteri detay + borçlu anlık hatırlatma), toplu mesaj, finans ekranı bunu kullanır. `saveEmployeePermissions` artık employeeId'ye göre upsert (PK upsert her kayıtta duplike satır açıp `getSingleOrNull`'u patlatacaktı).
- **Ortak WhatsApp hattı:** `Businesses.sharedWhatsapp` default **true** (mevcut davranış). Kapalıyken çalışan WhatsAppConnectScreen'den kendi hattını bağlar; oturum anahtarı `resolveWhatsAppSessionKey()` → yönetici/ortak: `{bizId}`, çalışan: `{bizId}_emp{empId}`. Sunucu anahtarı opak kullandığı için sunucu değişikliği gerekmedi. Profildeki toggle kaydettikten sonra provider'ı tazeler.
- **Gerçek açılış kontrolü:** `StartupGate` (app.dart → HomeScreen sarmalı, uygulama ömrü başına 1 kez): WhatsApp durum kontrolü + Drive yedek senkronu, progress bar + adım metni. Sahte timer'lı loading ekranı kaldırıldı.
- **Drive marker senkronu:** prefs `drive_backup_marker` = bu cihazın bildiği son yedeğin `modifiedTime`'ı. `backup()` (fields=modifiedTime) ve `restore()` marker yazar; açılışta uzak değer farklıysa `restore()` → "yeniden başlat" ekranı (restore_pending.db mekanizması). Marker yokken yerel veri varsa üzerine yazmaz, uzak sürümü benimser. Randevu ekleme/tamamlama sonrası otomatik yedek `authenticateSilently()` kullanır (izin ekranı açılmaz; Drive izni bir kez Profil > Yedekle'den verilmeli).
- **Sınır:** Drive senkronu aynı Google hesabının cihazları içindir. Çalışanlar farklı hesap olduğundan işletme sahibinin yedeğine erişemez — çalışan/işveren ortak verisi Drive ile taşınamaz (Firestore + sunucu appointment sync ile kısmi; tam çözüm ayrı iş).
- widget_test l10n delegate eksikliği düzeltildi (LoginScreen l10n'e geçtiğinden beri kırıktı). 47 test yeşil, analyze 0 issue.
- Not: build_runner "type 'Null' is not a subtype of type 'InterfaceElement'" ile çakılırsa: `dart run build_runner clean` + `.dart_tool\build` sil, tekrar build.

### 2026-07-14 geçişi — finans düzeltmeleri, yedekleme, borç sistemi (yapıldı, deploy edildi)
- **Aylık bilanço düzeltildi:** `getTotalIncome/Expense` SQL'i çift tırnaklı literal kullanıyordu (`type = "income"`); cihaz SQLite'ı `SQLITE_DQS=0` ile derli olduğundan sorgu "no such column" ile patlıyor, toplamlar 0 kalıyordu. Tek tırnak + `(as num).toDouble()`.
- **Gider ekleme çökmesi:** controller'lar `showModalBottomSheet(...).then()` içinde dispose ediliyordu (`_dependents.isEmpty` assertion). Sheet `_AddTransactionSheet` StatefulWidget'ına taşındı.
- **Drive yedekleme baştan yazıldı:** `requestScopes` (scope hiç istenmiyordu → 403), `VACUUM INTO` snapshot, mevcut yedeği güncelleme (PATCH media, duplike yok), Drive sorgusu tek tırnak + `Uri.https`. Restore `restore_pending.db`'ye iner; `DatabaseService._openConnection` açılışta WAL/SHM silip devreye alır (açık DB üzerine yazılmaz), uygulama `exit(0)` ile kapatılıp yeniden açılır. Hatalar `lastError` ile snackbar'da.
- **Borç sistemi:** Randevu tamamlarken eksik ödeme borç yazılır (PaymentDialog "Tümü Borç" + kısmi). Finans > Alacaklar kartı → `DebtorsScreen`: borçlu listesi, kısmi/tam tahsilat (nakit/kart/havale, en eski borçtan düşer, gelir 'Borç Tahsilatı'), anlık WhatsApp hatırlat butonu. Borçlular sunucuya senkron (`POST /api/debts/sync`, tam durum, `lib/services/debt_sync.dart`). Sunucuda `debt-reminder` şablonu (`{borc}`) + sıklık ayarı (`GET/PUT /api/debt-settings/:id`, off/daily/weekly/monthly, Mesaj Şablonları ekranından). Scheduler 5 dk'da bir tarar, 10:00-20:00 arası gönderir, `last_reminded_at` ile aralık korunur.
- **Makas ikonu kaldırıldı:** `Icons.content_cut` → `Icons.design_services` (4 yer) — uygulama sektör-bağımsız.
- Deploy: `scp src/*.js` → `docker build` → `docker run --env-file .env -e TZ=Europe/Istanbul` (bind-mount'lar korunur). `/api/debt-settings/1` doğrulandı.

## Önemli Kararlar
- **Local-first:** Tüm veri SQLite telefonda, Oracle Cloud PostgreSQL ile senkron
- **WhatsApp:** Baileys + Pairing Code (QR yok, tek cihaz)
- **Çalışan yetkisi:** API middleware ile, admin/employee rolü
- **Yedek:** Google Drive (kullanıcının kendi bulutu)
- **Sunucu:** Oracle Cloud Free Tier (Docker: WhatsApp + API + PostgreSQL)
- **DB:** sql.js (WhatsApp oturumu/hatırlatma), PostgreSQL (işletme/çalışan/senkron)
- **Firebase:** SADECE Auth (Google Sign-In). Firestore tamamen kaldırıldı (2026-07-16)

## SSH & Sunucu Hızlı Referans
```bash
ssh oracle-randevu360                                    # Bağlan
ssh oracle-randevu360 "docker logs randevu360-whatsapp"  # Log
ssh oracle-randevu360 "docker restart randevu360-whatsapp" # Restart
curl http://140.86.209.80:3000/api/health                # Health check
```

## Telefona Yükleme
```bash
cd D:\dosyalar\projeler\KolayRandevu\randevu360\mobile

# Android
flutter devices                    # Cihazı gör
flutter run -d cf9208e1           # Android'e yükle (M2007J20CG)

# iOS (macOS gerekir)
cd ios && pod install && cd ..    # Pod'ları kur (ilk build veya pubspec değişince)
flutter run -d <ios-device-id>    # iOS cihaz/simülatör
```

### iOS Yapılandırması (2026-07-16)
- **Bundle ID:** `com.sincera.randevu360`
- **Deployment Target:** iOS 13.0
- **Google Sign-In:** `CFBundleURLTypes` + `GoogleService-Info.plist` ✅
- **ATS Exception:** Oracle Cloud IP (`140.86.209.80`) HTTP izni var
- **Arka plan:** `fetch` + `remote-notification` (WorkManager + FCM)
- **Rehber:** `NSContactsUsageDescription` (flutter_contacts)
- **Kullanılmayan:** `FirebaseFirestore` pod'u Podfile'dan kaldırıldı; `cloud_firestore` pubspec'ten kaldırıldı
- **Not:** iOS build sadece macOS'te yapılabilir. İlk build öncesi `pod install` gerekir.

## Detaylı Bağlam
**plan.md** — tüm mimari, veritabanı şeması, API endpoint'leri, faz planı.
**oracle_cloud.md** — Oracle Cloud adım adım kurulum.
