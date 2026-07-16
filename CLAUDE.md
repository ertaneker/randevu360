# Randevu 360 — AI Geliştirici Ortağı İçin Proje Bağlamı

## Proje Özeti
Küçük işletmeler (berber, kuaför) için randevu yönetimi. WhatsApp hatırlatma, çalışan yönetimi, finans takibi. Mobil-first, bilgisayar gerekmez.

## Teknoloji
- Flutter 3.38+ (Dart 3.10+) — Mobil uygulama
- Firebase Auth (Google Sign-In) — Giriş
- Drift (SQLite) — Yerel veritabanı
- Cloud Firestore — Çalışan senkronizasyonu
- Google Drive API — Yedekleme
- Node.js + @whiskeysockets/baileys — WhatsApp servisi
- Docker + Oracle Cloud Free Tier — WhatsApp sunucu

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
│   │   ├── services/       ← Firestore sync, notifications
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
- **Auth:** Google Sign-In ✅ (aktif)
- **Firestore:** ✅ (aktif, kurallar deploy edildi)
- **Config:** google-services.json ✅, GoogleService-Info.plist ✅

## Oracle Cloud (WhatsApp Servisi) ✅
- **Sunucu IP:** `140.86.209.80`
- **Port:** `3000`
- **API Key:** `c8c3bc9f148cbf64e98b10151a189b1e06bf1e31a61a7a9eedb227783428c3c5`
- **Health:** `curl http://140.86.209.80:3000/api/health` → `{"status":"ok"}`
- **SSH:** `ssh oracle-randevu360` (key: `C:\Users\ertan\.ssh\oracle_randevu360`)
- **Container:** `randevu360-whatsapp` (--restart unless-stopped)
- **Region:** eu-zurich-1
- **Kurulum dökümanı:** `oracle_cloud.md`

## Yapılanlar (TAM DURUM — 2026-07-09)

### Altyapı
- [x] Firebase Console: proje + Auth + Firestore + kurallar deploy
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
3. **iOS build:** macOS gerektirir, yapılmadı.
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

### 2026-07-14 geçişi — finans düzeltmeleri, yedekleme, borç sistemi (yapıldı, deploy edildi)
- **Aylık bilanço düzeltildi:** `getTotalIncome/Expense` SQL'i çift tırnaklı literal kullanıyordu (`type = "income"`); cihaz SQLite'ı `SQLITE_DQS=0` ile derli olduğundan sorgu "no such column" ile patlıyor, toplamlar 0 kalıyordu. Tek tırnak + `(as num).toDouble()`.
- **Gider ekleme çökmesi:** controller'lar `showModalBottomSheet(...).then()` içinde dispose ediliyordu (`_dependents.isEmpty` assertion). Sheet `_AddTransactionSheet` StatefulWidget'ına taşındı.
- **Drive yedekleme baştan yazıldı:** `requestScopes` (scope hiç istenmiyordu → 403), `VACUUM INTO` snapshot, mevcut yedeği güncelleme (PATCH media, duplike yok), Drive sorgusu tek tırnak + `Uri.https`. Restore `restore_pending.db`'ye iner; `DatabaseService._openConnection` açılışta WAL/SHM silip devreye alır (açık DB üzerine yazılmaz), uygulama `exit(0)` ile kapatılıp yeniden açılır. Hatalar `lastError` ile snackbar'da.
- **Borç sistemi:** Randevu tamamlarken eksik ödeme borç yazılır (PaymentDialog "Tümü Borç" + kısmi). Finans > Alacaklar kartı → `DebtorsScreen`: borçlu listesi, kısmi/tam tahsilat (nakit/kart/havale, en eski borçtan düşer, gelir 'Borç Tahsilatı'), anlık WhatsApp hatırlat butonu. Borçlular sunucuya senkron (`POST /api/debts/sync`, tam durum, `lib/services/debt_sync.dart`). Sunucuda `debt-reminder` şablonu (`{borc}`) + sıklık ayarı (`GET/PUT /api/debt-settings/:id`, off/daily/weekly/monthly, Mesaj Şablonları ekranından). Scheduler 5 dk'da bir tarar, 10:00-20:00 arası gönderir, `last_reminded_at` ile aralık korunur.
- **Makas ikonu kaldırıldı:** `Icons.content_cut` → `Icons.design_services` (4 yer) — uygulama sektör-bağımsız.
- Deploy: `scp src/*.js` → `docker build` → `docker run --env-file .env -e TZ=Europe/Istanbul` (bind-mount'lar korunur). `/api/debt-settings/1` doğrulandı.

## Önemli Kararlar
- **Local-first:** Tüm veri SQLite telefonda, Firebase minimal senkron
- **WhatsApp:** Baileys + Pairing Code (QR yok, tek cihaz)
- **Çalışan yetkisi:** Firestore rules ile, admin/employee rolü
- **Yedek:** Google Drive (kullanıcının kendi bulutu)
- **Sunucu:** Oracle Cloud Free Tier (Docker)
- **DB:** sql.js (better-sqlite3 Node 24'te native build sorunu nedeniyle)

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
flutter devices                    # Cihazı gör
flutter run -d cf9208e1           # Android'e yükle (M2007J20CG)
```

## Detaylı Bağlam
**plan.md** — tüm mimari, veritabanı şeması, API endpoint'leri, faz planı.
**oracle_cloud.md** — Oracle Cloud adım adım kurulum.
