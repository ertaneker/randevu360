// SVG -> PNG dönüştürücü (flutter_launcher_icons için)
// Kullanım:  cd mobile/tool && npm install sharp && node generate_icon_pngs.js
const sharp = require('sharp');
const path = require('path');

const dir = path.join(__dirname, '..', 'assets', 'icon');
const jobs = [
  ['app_icon.svg', 'app_icon.png'],
  ['icon_foreground.svg', 'icon_foreground.png'],
  ['icon_background.svg', 'icon_background.png'],
];

(async () => {
  for (const [src, out] of jobs) {
    await sharp(path.join(dir, src), { density: 300 })
      .resize(1024, 1024)
      .png()
      .toFile(path.join(dir, out));
    console.log('OK ->', out);
  }
  console.log('Bitti. Şimdi: cd .. && flutter pub get && dart run flutter_launcher_icons');
})().catch((e) => { console.error(e); process.exit(1); });
