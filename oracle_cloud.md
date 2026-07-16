# Oracle Cloud Free Tier — Randevu 360 WhatsApp Servisi Kurulumu

> Son güncelleme: 2026-07-09

## İçindekiler
1. [Ön Koşullar](#ön-koşullar)
2. [Oracle Cloud Hesabı Açma](#1-oracle-cloud-hesabı-açma)
3. [VM Instance Oluşturma](#2-vm-instance-oluşturma)
4. [SSH Bağlantısı](#3-ssh-bağlantısı)
5. [Sunucu Kurulumu](#4-sunucu-kurulumu)
6. [WhatsApp Servisi Deploy](#5-whatsapp-servisi-deploy)
7. [Firewall ve Güvenlik](#6-firewall-ve-güvenlik)
8. [Domain ve SSL (Opsiyonel)](#7-domain-ve-ssl-opsiyonel)
9. [Monitoring ve Bakım](#8-monitoring-ve-bakım)
10. [Sorun Giderme](#9-sorun-giderme)

---

## Ön Koşullar

- Kredi kartı (Oracle doğrulama için, **ücret alınmaz**)
- Telefon numarası (SMS doğrulama)
- Email adresi
- Temel terminal bilgisi

---

## 1. Oracle Cloud Hesabı Açma

### Adım 1: Kayıt
```
https://www.oracle.com/cloud/free/
```
1. "Start for free" butonuna tıkla
2. Email, isim, ülke (Turkey) bilgilerini gir
3. **Home region: "Frankfurt (eu-frankfurt-1)"** seç — ping en düşük
4. Telefon doğrulaması yap
5. Kredi kartı bilgilerini gir (doğrulama amaçlı, **0 TL çekilir**)

### Adım 2: Free Tier Limitleri
| Kaynak | Limit | Bu Proje Kullanımı |
|--------|-------|---------------------|
| ARM vCPU (Ampere A1) | 4 OCPU | 2 OCPU |
| RAM | 24 GB | 8 GB |
| Disk | 200 GB | 50 GB |
| Çıkış trafiği | 10 TB/ay | ~5 GB/ay |
| IPv4 | 1 adet | 1 |
| **Süre** | **Süresiz** | — |

> **ÖNEMLİ:** "Always Free" tag'li kaynakları seç. Ücretli kaynak seçersen fatura gelir.

---

## 2. VM Instance Oluşturma

### Oracle Console'da:

1. **Menu > Compute > Instances > Create instance**

2. **Name:** `randevu360-whatsapp`

3. **Placement:** Varsayılan (AD 1)

4. **Image:** "Change image" → **Canonical Ubuntu 22.04 Minimal** (veya 24.04)
   - Minimal sürüm daha az disk kullanır

5. **Shape:** "Change shape" → **Specialty > Ampere**
   - OCPU: 2
   - Memory: 8 GB
   
   > Sebep: Ampere A1 ARM işlemciler Free Tier'a dahil. 2 OCPU + 8 GB fazlasıyla yeterli.

6. **Networking:** Varsayılan VCN (otomatik oluşturulur)
   - "Assign public IPv4 address" → **Evet**

7. **SSH Key:**
   
   Oracle Cloud iki yöntem sunar:
   
   **Yöntem A — Oracle'ın ürettiği key'i indir (önerilen, zaten yapıldı):**
   - "Generate key pair for me" seçeneğini işaretle
   - Instance oluşturulduktan sonra **private key otomatik iner** (örn: `ssh-key-2026-07-09.key`)
   - Bu dosya proje klasöründe: `D:\dosyalar\projeler\KolayRandevu\randevu360\ssh-key-2026-07-09.key`
   - `.ssh` dizinine kopyalandı: `C:\Users\ertan\.ssh\oracle_randevu360`
   
   **Yöntem B — Kendi key'ini yükle:**
   ```bash
   # PowerShell'de:
   ssh-keygen -t rsa -b 4096 -f C:\Users\ertan\.ssh\oracle_randevu360
   Get-Content C:\Users\ertan\.ssh\oracle_randevu360.pub
   ```
   "Paste public key" seç ve çıktıyı yapıştır.

8. **Boot volume:** 50 GB (varsayılan yeterli)

9. **"Create"** butonuna tıkla

### Provisioning — 1-2 dakika sürer. Bekle.

Instance "Running" durumuna geldiğinde **Public IP** adresini not al:
```
Instance > randevu360-whatsapp > Primary VNIC > Public IP
```
Örnek: `123.45.67.89`

---

## 3. SSH Bağlantısı

### ⚠️ ÖNCE: Oracle Console'dan Public IP'yi al
1. [Oracle Cloud Console](https://cloud.oracle.com) > Compute > Instances
2. `randevu360-whatsapp` instance'ına tıkla
3. **Primary VNIC > Public IP** adresini kopyala
4. Aşağıdaki komutlarda `<GERCEK_IP>` yerine bu IP'yi yaz

### SSH Config (zaten yapıldı)
`C:\Users\ertan\.ssh\config` dosyası oluşturuldu. `<GERCEK_IP>` kısmını kendi IP'n ile değiştir:
```
Host oracle-randevu360
    HostName <GERCEK_IP>
    User ubuntu
    IdentityFile C:\Users\ertan\.ssh\oracle_randevu360
```

Config'i güncellemek için:
```powershell
notepad C:\Users\ertan\.ssh\config
```
`ORACLE_INSTANCE_IP` yerine gerçek IP'yi yaz, kaydet.

### Bağlantı
```powershell
# Config ile:
ssh oracle-randevu360

# Veya direkt:
ssh -i C:\Users\ertan\.ssh\oracle_randevu360 ubuntu@<GERCEK_IP>
```

### İlk bağlantıda:
```
The authenticity of host '<GERCEK_IP>' can't be established.
Are you sure you want to continue connecting? yes
```

---

## 4. Sunucu Kurulumu

Tüm komutları SSH bağlantısında, **sırasıyla** çalıştır:

### 4.1 Sistem Güncelleme
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git ufw
```

### 4.2 Docker Kurulumu
```bash
# Resmi Docker script ile kur
curl -fsSL https://get.docker.com | sudo sh

# Ubuntu kullanıcısını docker grubuna ekle (sudo'suz docker kullanabilmek için)
sudo usermod -aG docker $USER

# Yeni grup yetkilerini aktifleştir (veya çıkıp tekrar bağlan)
newgrp docker

# Docker sürümünü kontrol et
docker --version
# Beklenen: Docker version 26.x veya üstü
```

### 4.3 Docker Compose
```bash
# Docker Compose zaten Docker ile geliyor
docker compose version
# Beklenen: Docker Compose version v2.x

# Eğer yoksa:
sudo apt install -y docker-compose-plugin
```

### 4.4 Git Repo Klonlama
```bash
# Home dizininde proje klasörü oluştur
cd ~
mkdir -p projects
cd projects

# Eğer GitHub'a pushladıysan:
# git clone https://github.com/sincera/randevu360.git
# cd randevu360/whatsapp-service

# Henüz GitHub'da değilse — dosyaları manuel kopyala (aşağıdaki SCP bölümüne bak)
```

### 4.5 Proje Dosyalarını Sunucuya Kopyala (SCP)
GitHub yoksa — kendi bilgisayarından sunucuya dosyaları kopyala:

```powershell
# Windows PowerShell'de (kendi bilgisayarında):
scp -i C:\Users\ertan\.ssh\oracle_randevu360 -r "D:\dosyalar\projeler\KolayRandevu\randevu360\whatsapp-service\*" ubuntu@123.45.67.89:~/projects/whatsapp-service/

# macOS/Linux:
# scp -i ~/.ssh/oracle_randevu360 -r ~/projeler/randevu360/whatsapp-service/* ubuntu@123.45.67.89:~/projects/whatsapp-service/
```

---

## 5. WhatsApp Servisi Deploy

### 5.1 Environment Yapılandırması
```bash
# Sunucuda:
cd ~/projects/whatsapp-service

# .env dosyasını oluştur
cat > .env << 'EOF'
PORT=3000
NODE_ENV=production
LOG_LEVEL=info
API_KEY=BurayaGuvenliBirRastgeleDegerYaz
FLUTTER_API_URL=http://localhost:8080
EOF

# API_KEY için güvenli rastgele değer üret:
# openssl rand -hex 32
# Çıkan değeri .env'de API_KEY satırına yaz
```

### 5.2 Docker Build ve Run
```bash
# Docker image oluştur
docker build -t randevu360-whatsapp .

# Container'ı başlat
docker run -d \
  --name randevu360-whatsapp \
  --restart unless-stopped \
  -p 3000:3000 \
  -v ~/projects/whatsapp-service/auth:/app/auth \
  -v ~/projects/whatsapp-service/data:/app/data \
  randevu360-whatsapp

# Logları kontrol et
docker logs -f randevu360-whatsapp
```

Beklenen çıktı:
```
{"level":"info","msg":"Randevu zamanlayıcı başladı (60s interval)"}
{"level":"info","msg":"Veritabanı başlatıldı"}
{"level":"info","msg":"Randevu360 WhatsApp servisi başladı :3000"}
```

`Ctrl+C` ile log takibinden çık.

### 5.3 Servisin Çalıştığını Doğrula
```bash
# Container durumu
docker ps

# Health check
curl http://localhost:3000/api/health
# Beklenen: {"status":"ok"}

# Dışarıdan test (kendi bilgisayarından):
# curl http://123.45.67.89:3000/api/health
```

---

## 6. Firewall ve Güvenlik

### 6.1 Oracle Cloud Security List (En Önemli!)
Oracle Cloud'da portlar **hem** sunucuda **hem** Oracle Console'da açılmalı.

**Oracle Console'da:**
1. Menu > Networking > Virtual Cloud Networks
2. VCN'ye tıkla (genelde `vcn-xxx`)
3. Security Lists > Default Security List
4. "Add Ingress Rules" butonuna tıkla

| Source | IP Protocol | Source Port | Dest Port | Description |
|--------|-------------|-------------|-----------|-------------|
| 0.0.0.0/0 | TCP | All | 22 | SSH |
| 0.0.0.0/0 | TCP | All | 3000 | WhatsApp API |
| 0.0.0.0/0 | TCP | All | 443 | HTTPS (ileride) |
| 0.0.0.0/0 | TCP | All | 80 | HTTP (ileride) |

### 6.2 Sunucu Firewall (UFW)
```bash
# SSH portu her zaman açık olsun
sudo ufw allow 22/tcp

# WhatsApp API portu
sudo ufw allow 3000/tcp

# HTTP/HTTPS (opsiyonel)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Firewall'ı aktifleştir
sudo ufw enable

# Durumu kontrol et
sudo ufw status verbose
```

### 6.3 API Key Güvenliği
`.env` dosyasındaki `API_KEY` değeri:
- En az 32 karakter olmalı
- Rastgele olmalı (`openssl rand -hex 32`)
- Her ortamda farklı olmalı
- GitHub'a **ASLA** commit'lenmemeli

### 6.4 Otomatik Güvenlik Güncellemeleri
```bash
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
# "Yes" seç
```

---

## 7. Domain ve SSL (Opsiyonel)

### Nginx Reverse Proxy + Let's Encrypt

```bash
# Nginx kur
sudo apt install -y nginx certbot python3-certbot-nginx

# Nginx config
sudo nano /etc/nginx/sites-available/randevu360
```

Aşağıdaki içeriği yapıştır:
```nginx
server {
    listen 80;
    server_name whatsapp.randevu360.com;  # Kendi domain'in

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# Site'ı aktifleştir
sudo ln -s /etc/nginx/sites-available/randevu360 /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# SSL sertifikası al
sudo certbot --nginx -d whatsapp.randevu360.com
# Email gir, şartları kabul et, redirect seç (2)

# Otomatik yenileme (certbot zaten systemd timer kurar)
sudo certbot renew --dry-run
```

---

## 8. Monitoring ve Bakım

### 8.1 Basit Health Check (Cron)
Sunucuda `crontab -e` ile:
```cron
# Her 5 dakikada bir health check
*/5 * * * * curl -f http://localhost:3000/api/health || docker restart randevu360-whatsapp
```

### 8.2 Docker Auto-Restart
Zaten `--restart unless-stopped` ile başlatıldı. Sunucu restart olursa container otomatik başlar.

### 8.3 Log Rotasyonu
```bash
# Docker log limiti ayarla
docker update --log-opt max-size=10m --log-opt max-file=3 randevu360-whatsapp
```

### 8.4 Disk Kullanımı
```bash
# Aylık kontrol et
df -h
docker system df
docker system prune -a  # Eski image'leri temizle (dikkatli kullan)
```

---

## 9. Sorun Giderme

### Container başlamıyor:
```bash
docker logs randevu360-whatsapp --tail 50
docker ps -a  # Exit status gör
```

### Port zaten kullanımda:
```bash
sudo lsof -i :3000
sudo kill -9 PID
```

### Docker build hatası:
```bash
docker build --no-cache -t randevu360-whatsapp .
```

### Memory yetersiz:
```bash
# Container memory limiti
docker update --memory 256m --memory-swap 512m randevu360-whatsapp

# Veya docker-compose.yml'de:
# mem_limit: 256m
```

### Baileys bağlantı sorunu:
```bash
# Auth dosyalarını temizle (yeniden pairing gerekir)
rm -rf ~/projects/whatsapp-service/auth/*
docker restart randevu360-whatsapp
```

### Oracle her şeyi silerse (nadir):
Oracle bazen idle kaynakları reclaim eder. **Verilerini yedekle:**
```bash
# Manuel yedek (kendi bilgisayarında):
scp -i oracle_randevu360 ubuntu@123.45.67.89:~/projects/whatsapp-service/data/whatsapp.db ./yedek/

# Ya da GitHub'a pushlandıysa her şey orada
```

---

## 10. Maliyet Özeti

| Kaynak | Aylık Maliyet |
|--------|---------------|
| 2 OCPU Ampere A1 | $0 (Free Tier) |
| 8 GB RAM | $0 (Free Tier) |
| 50 GB Boot Volume | $0 (Free Tier) |
| 10 TB Outbound | $0 (Free Tier) |
| Public IP | $0 (Free Tier) |
| **Toplam** | **$0/ay** |

> Eğer ücretli kaynak seçersen, Oracle dashboard'da maliyet görünür. "Always Free" tag'li kaynakları kullandığından emin ol.

---

## Flutter App'te Sunucu Adresini Güncelleme

WhatsApp servisi Oracle Cloud'da çalışmaya başladığında, Flutter uygulamasındaki API URL'sini güncelle:

`mobile/lib/core/constants/app_constants.dart` dosyasında (veya ilgili sabitler dosyasında):

```dart
// Production
static const String whatsappApiUrl = 'https://123.45.67.89:3000/api';

// Veya domain ile:
// static const String whatsappApiUrl = 'https://whatsapp.randevu360.com/api';

// API Key (bu değeri .env'den veya güvenli bir kaynaktan al)
static const String whatsappApiKey = 'BurayaGuvenliBirRastgeleDegerYaz';
```

> **Güvenlik uyarısı:** API Key'i asla client-side hardcode'lama. Firebase Remote Config veya backend'den fetch et.

---

## Hızlı Referans Kartı

```bash
# SSH bağlan
ssh oracle-randevu360

# Container durumu
docker ps

# Log takip
docker logs -f randevu360-whatsapp

# Restart
docker restart randevu360-whatsapp

# Health check
curl http://localhost:3000/api/health

# Disk
df -h

# Auth temizle (yeniden pairing)
rm -rf ~/projects/whatsapp-service/auth/*
docker restart randevu360-whatsapp
```

---

> **Hazırlayan:** Ertan & Claude Code  
> **Tarih:** 2026-07-09  
> **Not:** Oracle Cloud Free Tier süresiz ücretsizdir. Hesap açıldıktan sonra 30 gün içinde Free Trial biter, Always Free kaynaklar kalır. Free Trial'da 300$ kredi verilir — bunu harcama, Always Free dışı kaynak oluşturma.
