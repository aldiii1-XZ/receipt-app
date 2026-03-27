# Receipt App

Aplikasi ini sekarang sudah diubah ke struktur Flutter.

## Yang sudah diubah

- Source utama dipindah ke `lib/main.dart`
- Entry web dipindah ke `web/index.html`
- `pubspec.yaml` sudah memakai dependency Flutter
- File web manual lama (`main.dart` root, `index.html` root, `style.css`) dibersihkan

## Fitur saat ini

- Input data rumah makan, pelanggan, kasir, dan waktu transaksi
- Tambah dan hapus item pesanan
- Hitung subtotal, pajak, servis, diskon, total, bayar, dan kembalian
- Preview struk langsung di sisi kanan atau bawah

## Menjalankan project

1. Install Flutter SDK.
2. Jalankan:

```bash
flutter pub get
flutter run -d chrome
```

Untuk memastikan frontend tersambung ke backend lokal, Anda juga bisa memberi environment explicit:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080 --dart-define=APP_ENV=local
```

## Backend Sandbox

Saya juga menambahkan backend minimal di folder [backend](./backend) untuk persiapan integrasi pembayaran online.

Fungsinya:

- membuat transaksi pembayaran
- mengecek status pembayaran
- simulasi pembayaran sukses
- menerima webhook

Menjalankan backend:

```bash
cd backend
copy .env.example .env
npm start
```

Endpoint utama:

- `POST /api/payments/create`
- `GET /api/payments/:orderId`
- `POST /api/payments/:orderId/simulate-paid`
- `POST /api/payments/webhook`

## Persiapan Online

Yang sudah disiapkan di repo:

- konfigurasi URL backend dari Flutter lewat `--dart-define`
- backend membaca `.env`
- backend menyimpan transaksi ke file lokal
- `backend/Dockerfile` untuk deploy container
- `firebase.json` untuk deploy Flutter web ke Firebase Hosting

Contoh build web untuk production:

```bash
flutter build web --dart-define=API_BASE_URL=https://your-backend-url --dart-define=APP_ENV=production
```

Contoh alur deploy:

1. Deploy backend Node ke Cloud Run / service container lain.
2. Deploy hasil `build/web` ke Firebase Hosting.
3. Gunakan URL backend production pada `API_BASE_URL`.

## Catatan

Environment saya saat ini belum memiliki Flutter SDK, jadi saya belum bisa menjalankan `flutter create`, `flutter pub get`, atau `flutter run` untuk verifikasi otomatis.

Kalau Anda mau, langkah berikutnya saya bisa lanjutkan dengan:

- menambahkan fitur cetak/PDF di Flutter
- merapikan form dengan picker tanggal
- menambahkan penyimpanan riwayat transaksi
