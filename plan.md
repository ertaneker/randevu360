# Randevu 360 — Proje Planı

> **Proje ID:** `randevu360-cef66` (Firebase)
> **Package:** `com.sincera.randevu360`
> **Son güncelleme:** 2026-07-09

> Küçük işletmeler (berber, kuaför, güzellik salonu vb.) için randevu yönetim uygulaması.
> WhatsApp entegrasyonu ile otomatik hatırlatma, çalışan yönetimi, finans takibi.
> Tamamen mobil-first, bilgisayar gerektirmez.

---

## 1. MİMARİ GENEL BAKIŞ

```
┌──────────────────────────────────────────────────────────┐
│                    FLUTTER APP (Mobil)                    │
│  ┌──────────────────────┐  ┌───────────────────────────┐ │
│  │  SQLite (Drift)      │  │  Firebase Auth            │ │
│  │  • Tüm işletme verisi│  │  • Google Sign-In         │ │
│  │  • Müşteriler        │  │  • Çalışan giriş          │ │
│  │  • Randevular        │  │                           │ │
│  │  • Finans/Gelir-Gider│  │  Firebase Firestore       │ │
│  │  • Mesaj logları     │  │  • Çalışan listesi+roller │ │
│  │  • Google Drive yedek│  │  • Cross-device senkron   │ │
│  └──────────────────────┘  └───────────────────────────┘ │
└────────────────────────┬─────────────────────────────────┘
                         │ (HTTP REST — özel API anahtarı)
                         ▼
┌──────────────────────────────────────────────────────────┐
│           WHATSAPP SERVİSİ (Node.js + Baileys)           │
│                                                          │
│  • Oracle Cloud Free Tier'da Docker container            │
│  • Her işletme kendi Baileys instance'ı (izole)         │
│  • Pairing Code ile bağlanma (QR yok)                   │
│  • Otomatik hatırlatma zamanlayıcısı (24h/5h/1h)        │
│  • Çift yönlü mesajlaşma (müşteri cevap yazabilir)      │
│  • Gelen mesaj loglama                                   │
│  • AI bot altyapısına hazır                              │
└──────────────────────────────────────────────────────────┘
```

### Neden Bu Mimari?

| Karar | Gerekçe |
|-------|---------|
| **SQLite local-first** | Kullanıcı verisi kullanıcıda kalır, gizlilik. Sunucu maliyeti yok |
| **Firestore sadece çalışan senkron** | Cross-device için minimal veri. Tüm detay SQLite'da |
| **Firebase Auth** | Google Sign-In ücretsiz, şifre yönetimi yok, güvenilir |
| **Google Drive yedek** | 15GB ücretsiz, kullanıcı kendi bulutunda yedekler |
| **Baileys (Web WhatsApp)** | İşletmenin kendi numarası, ek ücret yok, çift yönlü |
| **Oracle Cloud Free** | 4 vCPU, 24GB RAM — 500+ container ücretsiz |

---

## 2. TEKNOLOJİ YIĞINI

| Katman | Teknoloji | Sürüm | Maliyet |
|--------|-----------|-------|---------|
| Mobil UI | Flutter | 3.38+ | Ücretsiz |
| Mobil Dil | Dart | 3.10+ | Ücretsiz |
| Auth | Firebase Auth + Google Sign-In | — | Ücretsiz |
| Local DB | Drift (SQLite) | ^2.15 | Ücretsiz |
| Cloud DB | Cloud Firestore | — | Ücretsiz (10GB/ay) |
| Push | Firebase Cloud Messaging | — | Ücretsiz |
| Yedek | Google Drive API | — | Ücretsiz (15GB) |
| WhatsApp | Node.js + @whiskeysockets/baileys | ^6.7 | Ücretsiz |
| Sunucu | Oracle Cloud Free Tier | — | Ücretsiz |
| Container | Docker + Docker Compose | — | Ücretsiz |
| Durum Yönetimi | Provider | ^6.1 | Ücretsiz |

---

## 3. VERİTABANI ŞEMASI (SQLite — Drift ORM)

### Tablolar (10 adet)

```
businesses
├── id (PK), name, phone, address, email
├── owner_name, owner_fb_uid (Firebase UID)
├── working_days (JSON: ["mon","tue",...])
├── working_hours (JSON: {"start":"09:00","end":"19:00"})
├── status, created_at, updated_at

employees
├── id (PK), business_id (FK→businesses)
├── name, phone, email, fb_uid (nullable)
├── role ("admin"|"employee"), color, status, created_at

customers
├── id (PK), business_id (FK→businesses)
├── name, phone, email, note
├── source ("manual"|"contacts"|"whatsapp")
├── total_debt, created_at

services
├── id (PK), business_id (FK→businesses)
├── name, description, duration (dk), price, category, status

appointments
├── id (PK), business_id, customer_id, employee_id, service_id
├── date (YYYY-MM-DD), time (HH:MM), price
├── status ("pending"|"confirmed"|"completed"|"cancelled")
├── note, created_by, created_at, updated_at
├── notified_24h, notified_5h, notified_1h (boolean)

appointment_logs
├── id (PK), appointment_id (FK→appointments)
├── action, performed_by, details, created_at

transactions (gelir/gider)
├── id (PK), business_id
├── type ("income"|"expense"), amount, category
├── description, payment_method ("cash"|"card"|"transfer")
├── appointment_id, customer_id, date, created_at

debts (müşteri borç)
├── id (PK), business_id, customer_id, appointment_id
├── amount, paid_amount, description
├── status ("pending"|"partial"|"paid"), due_date, created_at

message_logs (whatsapp)
├── id (PK), message_id (UUID)
├── business_id, customer_phone
├── message_type ("reminder-24h"|"reminder-5h"|"reminder-1h"|"direct"|"incoming")
├── message, status ("sent"|"failed"|"received")
├── direction ("outgoing"|"incoming"), error, sent_at

working_hours (çalışan bazlı özel saatler)
├── id (PK), employee_id, business_id
├── day_of_week ("mon"..."sun")
├── start_time, end_time, is_active
```

---

## 4. FIREBASE YAPILANDIRMASI

### Yapılanlar
- [x] Firebase Console'da proje oluşturuldu: `randevu360`
- [x] Android uygulaması kaydedildi: `com.sincera.randevu360`
- [x] iOS uygulaması kaydedildi: `com.sincera.randevu360`
- [x] Firebase CLI kuruldu
- [x] Flutter Firebase paketleri eklendi (`pubspec.yaml`)
- [x] Android google-services plugin eklendi (`build.gradle.kts`)
- [x] iOS Podfile oluşturuldu (Firebase pod'ları ile)
- [x] Firestore güvenlik kuralları yazıldı (`firebase/firestore.rules`)

### Yapılması Gerekenler
- [ ] **Google Sign-In aktifleştir** → Firebase Console > Authentication > Sign-in method > Google > Enable
- [ ] **Firestore oluştur** → Firebase Console > Firestore Database > Create database (eur3, test mode)
- [ ] **google-services.json indir** → Firebase Console > Project Settings > Android app > Download → `mobile/android/app/google-services.json`
- [ ] **GoogleService-Info.plist indir** → Firebase Console > Project Settings > iOS app > Download → `mobile/ios/Runner/`
- [ ] **Firestore kurallarını deploy et**:
  ```bash
  cd randevu360/firebase
  firebase deploy --only firestore:rules
  ```
- [ ] **Firebase init** proje kökünde:
  ```bash
  firebase init
  # Hosting: Hayır
  # Firestore: Evet (mevcut rules kullan)
  # Authentication: Evet
  ```
- [ ] **iOS CocoaPods yükle** (macOS gerektirir):
  ```bash
  cd mobile/ios
  pod install --repo-update
  ```

### Firestore Koleksiyon Yapısı

```
/businesses/{businessId}
  ├── name, ownerUid, ownerEmail, ownerName, employees[], admins[]
  ├── activeEmployees, createdAt, updatedAt
  │
  ├── /employees/{email}
  │     ├── name, email, role ("admin"|"employee"), status, createdAt
  │
  ├── /appointments/{appointmentId}
  │     ├── customerName, date, time, employeeId, status
  │
  └── /whatsapp/{sessionId}
        └── status, phone, connectedAt
```

---

## 5. WHATSAPP SERVİS MİMARİSİ (Node.js + Baileys)

### Pairing Code Akışı (QR'siz Bağlantı)

```
Kullanıcı                               Flutter App                     WhatsApp Servisi
   │                                        │                                │
   │  "WhatsApp'ı Bağla" tıklar             │                                │
   │───────────────────────────────────────>│                                │
   │                                        │  POST /api/pairing/request     │
   │                                        │  {businessId, phoneNumber}     │
   │                                        │───────────────────────────────>│
   │                                        │                                │  Baileys
   │                                        │                                │  requestPairingCode(phone)
   │                                        │                                │  └── 8 haneli kod üret
   │                                        │ <── {pairingCode: "AB12-CD34"}│
   │  Kod ekranda gösterilir                │                                │
   │<───────────────────────────────────────│                                │
   │                                        │                                │
   │  WhatsApp'ı açar                       │                                │
   │  ⋮ > Bağlı Cihazlar                   │                                │
   │  "Telefon numarası kullanarak bağlan"  │                                │
   │  8 haneli kodu girer                   │                                │
   │                                        │                                │
   │  Bağlantı kurulur                      │◄──── WebSocket bağlantısı ─────│
   │                                        │                                │
```

### API Endpoint'leri

| HTTP | Endpoint | Açıklama |
|------|----------|----------|
| GET | `/api/health` | Sağlık kontrolü |
| POST | `/api/pairing/request` | Pairing code al |
| GET | `/api/status/:businessId` | Bağlantı durumu |
| POST | `/api/disconnect/:businessId` | Bağlantı kes |
| DELETE | `/api/client/:businessId` | Hesabı tamamen kaldır |
| POST | `/api/send` | Direkt mesaj gönder |
| POST | `/api/send-bulk` | Toplu mesaj gönder |
| POST | `/api/send-template` | Şablon mesaj gönder (randevu hatırlatma) |
| GET | `/api/logs/:businessId` | Mesaj geçmişi |
| POST | `/api/incoming` | Gelen mesaj callback |

### Otomatik Hatırlatma Zamanlayıcı

```
Her 60 saniyede bir çalışır (setInterval)
    │
    ├── Yaklaşan randevuları kontrol et
    │
    ├── 24 saat kala → "reminder-24h" mesajı
    │   └── notified_24h = true işaretle
    │
    ├── 5 saat kala → "reminder-5h" mesajı
    │   └── notified_5h = true işaretle
    │
    └── 1 saat kala → "reminder-1h" mesajı
        └── notified_1h = true işaretle
```

### Docker Yapılandırması

```yaml
services:
  whatsapp-service:
    build: .
    ports: ["3000:3000"]
    volumes:
      - ./auth:/app/auth       # Baileys oturum dosyaları
      - ./data:/app/data       # SQLite mesaj log
    environment:
      - API_KEY=change-this
      - FLUTTER_API_URL=http://flutter-app:8080
    restart: unless-stopped
    mem_limit: 256m
```

---

## 6. ORACLE CLOUD KURULUMU

### Free Tier Özellikleri
- 4 ARM vCPU (Ampere A1)
- 24 GB RAM
- 200 GB disk
- 10 TB/ay çıkış trafiği
- **Süresiz ücretsiz**

### Kurulum Adımları

```bash
# 1. Oracle Cloud hesabı aç (cloud.oracle.com)
# 2. VM.Standard.A1.Flex instance oluştur (Ubuntu 22.04)
# 3. SSH bağlan

# 4. Docker kur
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# 5. Git clone
git clone https://github.com/your/randevu360.git
cd randevu360/whatsapp-service

# 6. API_KEY değiştir (docker-compose.yml içinde)
# 7. Container'ı başlat
docker-compose up -d

# 8. Log kontrol
docker logs -f randevu360-whatsapp

# 9. Firewall aç (Opsiyonel)
sudo ufw allow 3000/tcp
```

### Ölçeklenebilirlik

```
1-50 işletme   → Oracle Free Tier (24GB RAM)    → $0/ay
50-500 işletme → Hetzner CX22 (8GB RAM)         → €4/ay
500+ işletme   → Kubernetes cluster              → €20-50/ay
```

Her işletme kendi container'ında izole çalışır. Bir container çökerse sadece o restart yer.

---

## 7. UYGULAMA AKIŞI / SCREEN'LER

### Ekran Haritası

```
LoginScreen (Google Sign-In)
    │
    ├── İlk giriş → BusinessSetupScreen
    │                 ├── İşletme adı, telefon, adres
    │                 ├── Çalışma saatleri
    │                 └── Çalışma günleri
    │
    └── Sonraki girişler → HomeScreen
                            │
                            ├── Tab 0: Dashboard
                            │     ├── Hoşgeldin kartı
                            │     ├── Günlük istatistikler
                            │     ├── Hızlı işlemler (yeni randevu, müşteri ekle, toplu mesaj)
                            │     ├── WhatsApp bağlantı durumu
                            │     └── Bugünkü randevular
                            │
                            ├── Tab 1: AppointmentScreen
                            │     ├── Takvim (table_calendar)
                            │     ├── Gün bazlı randevu listesi
                            │     └── Çalışan filtresi
                            │
                            ├── Tab 2: FinanceScreen
                            │     ├── Aylık bilanço (gelir/gider)
                            │     ├── İstatistik kartları
                            │     └── İşlem listesi
                            │
                            ├── Tab 3: EmployeeScreen
                            │     ├── Çalışan listesi (isim, email, rol)
                            │     └── Yönetici: ekleme/çıkarma/yetki değiştirme
                            │
                            └── Tab 4: ProfileScreen
                                  ├── Kullanıcı bilgileri
                                  ├── İşletme ayarları
                                  ├── WhatsApp bağlantı yönetimi
                                  ├── Google Drive yedekleme
                                  └── Çıkış
```

---

## 8. GELİŞTİRME FAZLARI

### FAZ 0 — Ortam Kurulumu ✅ (Tamamlandı)
- [x] Firebase Console: randevu360-cef66 projesi oluşturuldu
- [x] Google Sign-In aktifleştirildi
- [x] Firestore Database oluşturuldu (eur3, test mode)
- [x] google-services.json indirildi → `mobile/android/app/` koyuldu
- [x] GoogleService-Info.plist indirildi → `mobile/ios/Runner/` koyuldu
- [x] Firestore güvenlik kuralları deploy edildi
- [x] Android google-services plugin eklendi
- [x] iOS Podfile oluşturuldu
- [x] Flutter bağımlılıkları yüklendi: `flutter pub get`
- [x] Flutter analyze: 0 hata
- [ ] WhatsApp servisini local'de test et: `cd whatsapp-service && npm install && npm run dev`
- [ ] Oracle Cloud'a Docker deploy yap

### FAZ 1 — Temel Özellikler (MVP) (2-3 hafta)
- [ ] Google Sign-In + Firebase Auth
- [ ] İşletme kurulum ekranı (BusinessSetupScreen)
- [ ] SQLite veritabanı + Drift tabloları
- [ ] Ana sayfa dashboard
- [ ] Randevu takvimi (table_calendar + CRUD)
- [ ] Müşteri ekleme (manuel + telefon rehberi)
- [ ] Hizmet kataloğu
- [ ] Çalışan ekleme/yönetme

### FAZ 2 — WhatsApp Entegrasyonu (1-2 hafta)
- [ ] WhatsApp servisi Docker kurulumu
- [ ] Pairing code ile bağlanma
- [ ] Otomatik randevu hatırlatma (24h/5h/1h)
- [ ] Rehberden mesaj gönderme
- [ ] Gelen mesajları görüntüleme
- [ ] Mesaj geçmişi log

### FAZ 3 — Finans (1 hafta)
- [ ] Gelir/gider ekleme
- [ ] Aylık bilanço hesaplama
- [ ] Müşteri borç takibi
- [ ] Kategori bazlı raporlar
- [ ] Basit grafikler (fl_chart)

### FAZ 4 — İleri Özellikler (2-3 hafta)
- [ ] Firestore senkronizasyon (çalışanlar arası)
- [ ] Google Drive yedekleme
- [ ] Çalışan içi mesajlaşma
- [ ] Background service ile WhatsApp otomasyonu
- [ ] Push notification (bildirim)
- [ ] Randevu geçmişi log

### FAZ 5 — AI ve Büyüme (Sürekli)
- [ ] Gelen WhatsApp mesajlarında NLP intent detection
- [ ] AI randevu asistanı: "Cuma 15:00'a alabilir miyim?" → otomatik işlem
- [ ] Müşteri sadakat puanı
- [ ] Online randevu alma (müşteri kendi alır)
- [ ] Çoklu şube desteği
- [ ] Veri export/analytics

---

## 9. PROJE KLASÖR YAPISI (MEVCUT)

```
D:\dosyalar\projeler\KolayRandevu\randevu360\
│
├── .gitignore
├── plan.md                          ← Bu dosya (tüm proje dokümantasyonu)
├── CLAUDE.md                        ← AI geliştirici ortağı için bağlam dosyası
├── README.md                        ← Genel bilgi + hızlı kurulum
│
├── mobile/                          ← Flutter uygulaması
│   ├── android/                     ← Android native proje (package: com.sincera.randevu360)
│   │   ├── app/
│   │   │   ├── build.gradle.kts     ← google-services plugin eklendi
│   │   │   └── google-services.json ← [KULLANICI İNDİRMELİ]
│   │   └── settings.gradle.kts
│   │
│   ├── ios/                         ← iOS native proje
│   │   ├── Podfile                  ← Firebase pod'ları eklendi
│   │   ├── Runner/
│   │   │   └── GoogleService-Info.plist ← [KULLANICI İNDİRMELİ]
│   │   └── ...
│   │
│   ├── lib/                         ← Uygulama kodu
│   │   ├── main.dart                ← Giriş noktası, Firebase init, background service
│   │   ├── app.dart                 ← Provider kurulumu, routing
│   │   │
│   │   ├── core/                    ← Temel servisler
│   │   │   ├── auth/auth_service.dart           ← Firebase Auth + Google Sign-In
│   │   │   ├── database/database_service.dart    ← Drift ORM, tüm sorgular
│   │   │   ├── database/tables.dart              ← 10 SQLite tablosu
│   │   │   ├── backup/backup_service.dart        ← Google Drive yedekleme
│   │   │   ├── constants/app_constants.dart      ← Sabitler, kategoriler
│   │   │   └── theme/app_theme.dart              ← Tema renkleri, stiller
│   │   │
│   │   ├── providers/               ← State management (Provider)
│   │   │   ├── auth_provider.dart               ← Auth durumu, giriş/çıkış
│   │   │   ├── business_provider.dart           ← İşletme bilgileri
│   │   │   ├── appointment_provider.dart        ← Randevu CRUD, takvim
│   │   │   ├── employee_provider.dart           ← Çalışan yönetimi
│   │   │   ├── finance_provider.dart            ← Gelir/gider, borç
│   │   │   └── whatsapp_provider.dart           ← WhatsApp servisi iletişimi
│   │   │
│   │   ├── services/                ← Servis katmanı
│   │   │   ├── firestore_sync_service.dart      ← Firestore senkronizasyon
│   │   │   └── notification_service.dart        ← FCM + local notification
│   │   │
│   │   └── screens/                 ← Ekranlar
│   │       ├── auth/login_screen.dart           ← Google Sign-In ekranı
│   │       ├── business/business_setup_screen.dart ← İşletme kurulum
│   │       ├── home/home_screen.dart            ← Bottom navigation
│   │       ├── home/dashboard_widget.dart       ← Ana sayfa içeriği
│   │       ├── appointment/appointment_screen.dart ← Takvim + randevu listesi
│   │       ├── finance/finance_screen.dart      ← Finans takibi
│   │       ├── employee/employee_screen.dart    ← Çalışan yönetimi
│   │       ├── profile/profile_screen.dart      ← Profil + ayarlar
│   │       └── whatsapp/whatsapp_connect_screen.dart ← WhatsApp bağlantısı
│   │
│   ├── assets/
│   │   ├── images/                  ← Uygulama görselleri
│   │   └── icons/                   ← Özel ikonlar
│   │
│   └── pubspec.yaml                 ← Bağımlılıklar (Firebase, Drift, Provider vs.)
│
├── whatsapp-service/                ← Node.js + Baileys WhatsApp servisi
│   ├── src/
│   │   ├── index.js                 ← Express sunucu + başlatma
│   │   ├── client.js                ← Baileys client yönetimi (pairing code, reconnect)
│   │   ├── scheduler.js             ← Randevu zamanlayıcı (24h/5h/1h)
│   │   ├── api.js                   ← REST API endpoint'leri
│   │   ├── db.js                    ← Mesaj log (SQLite)
│   │   └── logger.js                ← Pino log
│   ├── auth/                        ← Baileys oturum dosyaları (gitignore)
│   ├── data/                        ← SQLite dosyaları (gitignore)
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── package.json
│   └── .env.example
│
└── firebase/
    ├── firestore.rules              ← Firestore güvenlik kuralları
    └── firebase.json                ← Firebase CLI yapılandırması
```

---

## 10. MEVCUT DURUM (YAPILANLAR)

### ✅ Tamamlananlar

- [x] Firebase Console projesi oluşturma
- [x] Android + iOS uygulama kaydı
- [x] Flutter proje skeleton (25+ dosya)
- [x] SQLite veritabanı şeması (10 tablo, Drift ORM)
- [x] Tüm provider'lar (Auth, Business, Appointment, Employee, Finance, WhatsApp)
- [x] Firestore servisi (çalışan senkronizasyonu)
- [x] Bildirim servisi (FCM + local notification)
- [x] Google Drive yedekleme servisi
- [x] WhatsApp servisi (Node.js + Baileys)
- [x] Pairing code ile bağlantı (QR yok)
- [x] Otomatik hatırlatma zamanlayıcı
- [x] 8 ekran (Login, Dashboard, Takvim, Finans, Çalışan, Profil, WhatsApp, İşletmeKurulum)
- [x] Tema sistemi
- [x] Firestore güvenlik kuralları
- [x] Docker yapılandırması
- [x] Firebase bağımlılıkları (pubspec.yaml)
- [x] Android google-services plugin
- [x] iOS Podfile (Firebase pod'ları)
- [x] Google Sign-In aktifleştirildi
- [x] Firestore oluşturuldu (randevu360-cef66, eur3)
- [x] google-services.json indirildi ve yerleştirildi
- [x] GoogleService-Info.plist indirildi ve yerleştirildi
- [x] Firestore kuralları deploy edildi
- [x] Flutter analyze: 0 hata (geçildi)

### ❌ Kullanıcının Yapması Gerekenler

- [x] WhatsApp servisini Oracle Cloud'a kur (140.86.209.80:3000, container çalışıyor)
- [ ] iOS build (macOS gerektirir)

### 🔧 Yapılacak İşler

- [x] Drift code generation: `flutter pub run build_runner build` (116 outputs, 0 hata)
- [x] Flutter analyze: 0 hata, 0 warning (deprecation/style only)
- [x] WhatsApp servisi: sql.js'e geçildi, Docker build + deploy başarılı
- [x] @DataClassName anotasyonları eklendi (10 tablo)
- [x] AuthStatus çakışması çözüldü, IAuthService interface eklendi
- [x] Provider'lar DatabaseService injection ile çalışıyor (7 provider)
- [x] Icons.whatsapp → Icons.chat değiştirildi
- [x] CardTheme → CardThemeData (Flutter 3.38+)
- [x] stitch.withgoogle.com MCP server .mcp.json'a eklendi
- [x] Auth flow: Login → RoleSelection → BusinessSetup/HomeScreen
- [x] Ekranlar Firebase auth + SQLite verisine bağlandı
- [x] Tüm ekranlar initState'te veri yüklüyor
- [x] Hata durumları ve loading state'leri (tüm provider + screen'lerde)
- [x] Telefon rehberi entegrasyonu (flutter_contacts, CustomerProvider)
- [x] Yeni Randevu ekranı (müşteri, hizmet, çalışan, tarih/saat)
- [x] Android desugaring fix (build.gradle.kts)
- [x] Route table + onUnknownRoute
- [x] 27 test yazıldı (auth, appointment, business, widget)
- [x] CI/CD: GitHub Actions (Flutter CI, WhatsApp CI, Dependabot)
- [x] oracle_cloud.md kurulum rehberi
- [x] WhatsApp telefon formatı: otomatik 05XX → 905XXXXXXXXX
- [x] Dockerfile fix: git, openssh-client, ca-certificates, HTTPS git redirect

---

## 11. HIZLI KURULUM KOMUTLARI

```bash
# Flutter — bağımlılıkları yükle
cd randevu360/mobile
flutter pub get

# Drift code generation
flutter pub run build_runner build

# Android'de çalıştır
flutter run

# WhatsApp servisi — local geliştirme
cd randevu360/whatsapp-service
cp .env.example .env
# .env içinde API_KEY değiştir
npm install
npm run dev

# WhatsApp servisi — Docker
docker-compose up -d

# Firebase CLI
firebase login
firebase deploy --only firestore:rules

# Oracle Cloud
ssh opc@your-instance
git clone https://github.com/your/randevu360.git
cd randevu360/whatsapp-service
docker-compose up -d
```

---

## 12. ÖNEMLİ KARARLAR VE GEREKÇELERİ

| # | Karar | Alternatif | Neden Bu Seçim |
|---|-------|-----------|----------------|
| 1 | **Local-first (SQLite)** | Full server API | Veri gizliliği, sunucu maliyeti yok, çevrimdışı çalışma |
| 2 | **Firebase Auth** | Custom JWT | Ücretsiz, güvenli, sosyal login hazır |
| 3 | **Firestore (minimal)** | PostgreSQL | Sadece çalışan senkronizasyonu için, az veri, serverless |
| 4 | **Google Drive yedek** | AWS S3 | Kullanıcının kendi bulutu, ücretsiz 15GB |
| 5 | **Baileys (Web WhatsApp)** | WhatsApp Business API | İşletmenin kendi numarası, ek ücret yok, çift yönlü |
| 6 | **Pairing code (QR'siz)** | QR kod | Tek cihazda çalışır, bilgisayar gerekmez |
| 7 | **Oracle Cloud Free** | Heroku/Railway | 4vCPU 24GB RAM ücretsiz, süresiz |
| 8 | **Provider** | Riverpod/Bloc | Basit, yeterli, az boilerplate |
| 9 | **Flutter** | React Native | Performans, Firebase desteği, Google ekosistemi |
| 10 | **Node.js WhatsApp servisi** | .NET ile aynı dil | Baileys sadece Node.js'de çalışır |

---

## 13. WHATSAPP SERVİS — ÖNEMLİ NOTLAR

### Baileys Yeniden Bağlantı
Baileys bağlantısı kesilirse otomatik reconnect dener. Eğer 5 denemede başaramazsa:
1. Pairing code yeniden istenir
2. Kullanıcıya push notification gider
3. Kullanıcı app'ten yeni kod alır

### Anti-Ban Stratejisi
- Günde 5-6 mesaj (çok düşük hacim, tespit edilmez)
- Her mesaj arasında 2 saniye gecikme (bulk gönderimde)
- Doğal dilde mesajlar (şablon değil, gerçekçi)
- Hesap başına max 50 mesaj/gün limiti (kendimiz koyuyoruz)

### Gelen Mesajlar (Çift Yönlü)
Müşteri cevap yazdığında:
1. Baileys `messages.upsert` event'i tetiklenir
2. Mesaj backend'de loglanır
3. Flutter app'e push notification gönderilir
4. İşletme sahibi app'te mesajı görür, cevap yazabilir

### AI Geleceği
Gelen mesajlar için intent detection pipeline:
```
Gelen mesaj
    ↓
NLP preprocessing (tokenizasyon, stemming)
    ↓
Intent classifier (BERT/distilBERT fine-tune)
    ├── "reschedule" → randevu değiştirme
    ├── "cancel" → randevu iptal
    ├── "inquiry" → müsaitlik sorgulama
    └── "other" → işletme sahibine yönlendir
```

---

## 14. LİSANS VE YASAL UYARILAR

- **WhatsApp TOS:** Baileys resmi olmayan API'dir. WhatsApp TOS'a aykırıdır.
- **Risk:** Düşük hacim (günde 5-6 mesaj) nedeniyle tespit riski çok düşük.
- **Veri:** Tüm kullanıcı verisi kullanıcının kendi cihazında ve Drive'ında.
- **Maliyet:** Platform maliyeti yok. İşletme modeli: aylık ₺50-100 abonelik.

---

> **Hazırlayan:** Ertan & Claude Code  
> **Tarih:** 2026-07-09  
> **Sonraki Geliştirici:** Bu dosyadaki faz planını takip et. FAZ 0'dan başla.
