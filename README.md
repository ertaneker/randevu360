# Randevu 360

Küçük işletmeler (berber, kuaför, vb.) için randevu yönetim uygulaması.  
WhatsApp entegrasyonu ile otomatik hatırlatma, çalışan yönetimi, finans takibi.

---

## Mimarisi

```
┌─────────────────────────────────────────────────┐
│                 FLUTTER APP                      │
│  ┌────────────┐  ┌────────────────────────────┐ │
│  │  SQLite    │  │  Firebase (Auth/Firestore) │  │
│  │  (tüm veri)│  │  (çalışan senk., giriş)   │  │
│  └────────────┘  └────────────────────────────┘ │
│  ┌────────────────────────────────────────────┐ │
│  │  Google Drive (yedek)                      │ │
│  └────────────────────────────────────────────┘ │
└──────────────────┬──────────────────────────────┘
                   │ (WhatsApp mesajı)
┌──────────────────┴──────────────────────────────┐
│  Node.js Baileys (Oracle Cloud / Docker)        │
│  - Pairing code ile bağlantı                    │
│  - Otomatik hatırlatma (24h / 5h / 1h)         │
│  - Çift yönlü mesajlaşma                        │
│  - AI bot altyapısı                             │
└─────────────────────────────────────────────────┘
```

## Teknoloji

| Katman | Teknoloji |
|--------|-----------|
| Mobil | Flutter (Dart) |
| Auth | Firebase Auth (Google Sign-In) |
| Local DB | SQLite (Drift) |
| Senkronizasyon | Firestore (sadece çalışanlar) |
| Yedekleme | Google Drive API |
| WhatsApp | Node.js + Baileys |
| Sunucu | Docker (Oracle Cloud Free Tier) |

## Proje Yapısı

```
randevu360/
├── mobile/                          # Flutter uygulama
│   ├── lib/
│   │   ├── main.dart                # Giriş noktası
│   │   ├── app.dart                 # Provider + routing
│   │   ├── core/
│   │   │   ├── auth/                # Firebase Auth servisi
│   │   │   ├── database/            # SQLite (Drift) tabloları
│   │   │   ├── backup/              # Google Drive yedekleme
│   │   │   ├── theme/               # Tema renkleri
│   │   │   └── constants/           # Sabitler
│   │   ├── models/                  # Veri modelleri
│   │   ├── providers/               # State management
│   │   ├── services/                # Firestore senkron, bildirim
│   │   └── screens/                 # Ekranlar
│   │       ├── auth/                # Giriş
│   │       ├── home/                # Dashboard
│   │       ├── appointment/         # Randevu takvimi
│   │       ├── business/            # İşletme kurulum
│   │       ├── employee/            # Çalışan yönetimi
│   │       ├── finance/             # Gelir/gider takibi
│   │       ├── profile/             # Profil ayarları
│   │       └── whatsapp/            # WhatsApp bağlantısı
│   └── pubspec.yaml
│
├── whatsapp-service/                # WhatsApp Baileys servisi
│   ├── src/
│   │   ├── index.js                 # Express sunucu
│   │   ├── client.js                # Baileys yönetimi
│   │   ├── scheduler.js             # Zamanlayıcı
│   │   ├── api.js                   # REST API
│   │   ├── db.js                    # Mesaj log (SQLite)
│   │   └── logger.js                # Log
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── package.json
│
├── firebase/
│   ├── firestore.rules              # Firestore güvenlik kuralları
│   └── firebase.json
│
└── README.md
```

## Kurulum

### 1. Firebase

```bash
firebase login
firebase init
# Seç: Firestore, Authentication
# Auth: Google Sign-In aktifleştir
# Firestore: firestore.rules dosyasını kullan
```

### 2. Flutter

```bash
cd mobile
flutter pub get
flutter run
```

### 3. WhatsApp Servisi

```bash
cd whatsapp-service
cp .env.example .env
# .env'de API_KEY değiştir

# Local geliştirme
npm install
npm run dev

# Docker
docker-compose up -d
```

### 4. Oracle Cloud Deployment

```bash
# Oracle Cloud Free Tier'a Docker kur
ssh opc@your-instance

# Clone
git clone https://github.com/your/randevu360.git
cd randevu360/whatsapp-service

# Başlat
docker-compose up -d
```

## Geliştirme Fazları

### Faz 1 — MVP
- [x] Proje skeleton
- [ ] Firebase Auth (Google Sign-In)
- [ ] İşletme kurulum ekranı
- [ ] SQLite veritabanı
- [ ] Çalışan ekleme/yönetme
- [ ] Randevu takvimi (table_calendar)
- [ ] WhatsApp servisi (Baileys pairing)

### Faz 2 — WhatsApp
- [ ] Pairing code ile bağlantı
- [ ] Otomatik hatırlatma (24h/5h/1h)
- [ ] Rehberden mesaj gönderme
- [ ] Mesaj geçmişi

### Faz 3 — Finans
- [ ] Gelir/gider takibi
- [ ] Müşteri borç takibi
- [ ] Raporlar

### Faz 4 — İleri
- [ ] Çalışan içi mesajlaşma
- [ ] Google Drive yedek
- [ ] AI WhatsApp asistan
- [ ] Online randevu alma

## Lisans

MIT
