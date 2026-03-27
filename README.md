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

## Catatan

Environment saya saat ini belum memiliki Flutter SDK, jadi saya belum bisa menjalankan `flutter create`, `flutter pub get`, atau `flutter run` untuk verifikasi otomatis.

Kalau Anda mau, langkah berikutnya saya bisa lanjutkan dengan:

- menambahkan fitur cetak/PDF di Flutter
- merapikan form dengan picker tanggal
- menambahkan penyimpanan riwayat transaksi
