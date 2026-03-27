# DiResto Backend

Backend minimal ini dipakai untuk menyiapkan alur pembayaran online yang lebih realistis.

## Fitur

- `POST /api/payments/create`
- `GET /api/payments/:orderId`
- `POST /api/payments/:orderId/simulate-paid`
- `POST /api/payments/webhook`
- `GET /health`

Saat ini provider default adalah `mock`, jadi backend bisa dipakai untuk uji alur sandbox tanpa dana nyata.

## Menjalankan

1. Pastikan Node.js `>=18` tersedia.
2. Salin file environment:

```bash
copy .env.example .env
```

3. Jalankan server:

```bash
npm start
```

Atau mode watch:

```bash
npm run dev
```

## Contoh Request

Membuat payment:

```bash
curl -X POST http://localhost:8080/api/payments/create ^
  -H "Content-Type: application/json" ^
  -d "{\"orderId\":\"DR-001\",\"amount\":32000,\"paymentMethod\":\"e_wallet\",\"provider\":\"shopeepay\",\"items\":[{\"name\":\"Nasi Goreng\",\"qty\":1,\"price\":15000}]}"
```

Cek status:

```bash
curl http://localhost:8080/api/payments/DR-001
```

Simulasi sukses:

```bash
curl -X POST http://localhost:8080/api/payments/DR-001/simulate-paid
```

## Catatan Integrasi Nyata

Untuk production, ganti `PAYMENT_PROVIDER` dari `mock` ke provider nyata lalu sambungkan adapter gateway di server ini. Struktur endpointnya sudah disiapkan agar frontend Flutter dapat:

- membuat transaksi
- menampilkan instruksi pembayaran
- mengecek status pembayaran
- menerima update dari webhook gateway
