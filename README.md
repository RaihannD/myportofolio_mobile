# MyPortofolio Mobile

Aplikasi portofolio pribadi multiplatform yang dibuat dengan Flutter dan Dart untuk mata kuliah Pemrograman Berbasis Platform (PBP). Proyek ini merupakan versi mobile dari [MyPortofolio](https://github.com/RaihannD/myportofolio), proyek portofolio berbasis Django yang dikembangkan terpisah.

## Deskripsi Proyek

Aplikasi saat ini menampilkan identitas pemilik dalam tiga kartu informasi, serta menu tindakan portofolio berupa kartu berikon dan berwarna berbeda. Kartu menu mencakup melihat proyek, melihat dan menambah pengalaman, menambah proyek, serta logout. Setiap kartu menampilkan `SnackBar` ketika ditekan.

Versi ini berfokus pada fondasi UI Flutter dari Tutorial 08 dan Tugas 7. Kartu tindakan masih berupa prototipe interaktif: tombol menampilkan pesan, tetapi belum membuka halaman data, menyimpan proyek/pengalaman, atau mengakhiri sesi login.

> **Identitas:** Raihan Daffa Aprilianda · NPM 2506620021 · PBP B

## Struktur Proyek

```text
myportofolio_mobile/
├── android/                 # Konfigurasi runner Android
├── ios/                     # Konfigurasi runner iOS
├── lib/
│   ├── main.dart            # Bootstrap aplikasi, tema, dan MaterialApp
│   └── menu.dart            # MyHomePage, InfoCard, ItemHomepage, dan ItemCard
├── linux/                   # Konfigurasi runner Linux
├── macos/                   # Konfigurasi runner macOS
├── test/                    # Pengujian widget
├── web/                     # Konfigurasi runner web
├── windows/                 # Konfigurasi runner Windows
├── analysis_options.yaml    # Aturan analisis Dart
├── pubspec.yaml             # Metadata, SDK, dependensi, dan aset Flutter
├── pubspec.lock             # Versi dependensi yang terkunci
└── README.md                # Dokumentasi proyek
```


## Setup

### Prasyarat

- Flutter SDK yang memenuhi batas SDK pada `pubspec.yaml` (`^3.13.7`).
- Git.
- Emulator atau perangkat untuk menjalankan aplikasi. Untuk target tertentu, ikuti kebutuhan platform Flutter, misalnya Android Studio untuk Android atau Xcode untuk iOS.

### Instalasi dan menjalankan

```bash
# Kloning repositori
git clone https://github.com/RaihannD/myportofolio_mobile.git
cd myportofolio_mobile

# Periksa instalasi Flutter dan perangkat yang tersedia
flutter doctor
flutter devices

# Ambil dependensi
flutter pub get

# Jalankan pada emulator/perangkat yang aktif
flutter run
```

Jika terdapat lebih dari satu perangkat, pilih target dengan `flutter run -d <device-id>`, ID perangkat dapat dilihat melalui `flutter devices`.

### Analisis statis

```bash
flutter analyze
```

Perintah ini seharusnya berakhir dengan `No issues found!`. Jika perintah Flutter tidak mengeluarkan output atau tidak selesai, periksa instalasi Flutter/Dart dan catat bahwa analisis melalui Dart langsung bukan pengganti verifikasi lengkap perintah Flutter.

## Weekly Progress

### Tutorial 8
- Setup dan Inisialisasi Proyek
- Menampilkan 3 kartu informasi (InfoCard) di bagian atas halaman
- Membuat minimal 3 tombol aksi sederhana dalam bentuk kartu (ItemCard) dengan ikon dan teks yang relevan 
- Memastikan tidak ada isu atau kesalahan pada kode dengan menjalankan perintah flutter analyze pada root folder proyek (No issues found)

### Tugas 7

- Membuat kartu tindakan `ItemCard` dengan ikon serta warna masing-masing.
- Menambahkan lihat pengalaman dan tambah pengalaman. Ketika ditekan, menu menampilkan `SnackBar` sesuai nama tindakan.
- Menambahkan instruksi setup dan dokumentasi penggunaan AI pada README.

## Pertanyaan Reflektif

### Tugas 7

#### 1. Jelaskan apa yang dimaksud dengan *widget tree* pada Flutter dan bagaimana hubungan induk-anak (*parent-child*) bekerja antar-*widget*!

*Widget tree* adalah susunan hierarkis widget yang mendeskripsikan antarmuka aplikasi. Setiap widget dapat menjadi induk bagi satu atau beberapa widget lain. Widget induk menyusun dan mengatur widget anak melalui properti seperti `child` atau `children`, widget anak bertanggung jawab atas bagian UI yang lebih kecil. Flutter membangun antarmuka dengan menggabungkan widget-widget sederhana menjadi bagian yang lebih besar.

Pada proyek ini, pohon dimulai dari `MyApp`, yang mengembalikan `MaterialApp`. `MaterialApp` menampilkan `MyHomePage`, yang mengembalikan `Scaffold`. Di dalam `Scaffold`, `AppBar` dan `body` menjadi bagian UI, `body` berisi `Padding`, `Column`, `Row`, `InfoCard`, dan grid `ItemCard`. Susunan ini membuat bagian layar dapat dipisahkan dan digunakan kembali. Widget sendiri merupakan deskripsi UI yang immutable, Flutter mengelola elemen dan render untuk menampilkan hasilnya.

#### 2. Sebutkan semua *widget* yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!

Widget yang digunakan langsung dalam `main.dart` dan `menu.dart` adalah:

- `MyApp`: widget buatan sendiri yang menjadi titik awal UI aplikasi.
- `MaterialApp`: menyediakan struktur aplikasi bergaya Material, tema, judul, dan halaman awal.
- `MyHomePage`: widget buatan sendiri yang menyusun halaman menu utama.
- `Scaffold`: menyediakan kerangka halaman seperti `AppBar`, isi halaman, dan dukungan `SnackBar`.
- `AppBar`: menampilkan bilah judul di bagian atas halaman.
- `Padding`: memberi jarak di sekeliling bagian UI.
- `Column`: menyusun anak-anak widget secara vertikal.
- `Row`: menyusun kartu informasi secara horizontal.
- `InfoCard`: widget buatan sendiri yang menampilkan judul dan nilai informasi profil.
- `Card`: memberi tampilan kartu pada setiap informasi profil.
- `Container`: mengatur lebar dan jarak dalam `InfoCard`, serta padding konten `ItemCard`.
- `SizedBox`: memberi jarak vertikal dengan ukuran tertentu.
- `Center`: menempatkan konten di tengah ruang yang tersedia.
- `GridView.count`: menyusun kartu tindakan dalam grid dengan jumlah kolom yang ditentukan.
- `MediaQuery`: informasi ukuran layar diakses melalui `MediaQuery.of(context)` untuk menentukan lebar `InfoCard`.
- `ItemCard`: widget buatan sendiri yang menampilkan satu tindakan portofolio dan menangani ketukan.
- `Material`: menyediakan latar berwarna dan permukaan Material untuk kartu tindakan.
- `InkWell`: mendeteksi ketukan dan menyediakan efek interaksi pada kartu.
- `Icon`: menampilkan ikon yang mewakili tindakan.
- `Text`: menampilkan judul halaman, pesan sambutan, label, isi informasi, dan nama tindakan.
- `SnackBar`: menampilkan pesan singkat setelah kartu tindakan ditekan.

#### 3. Apa fungsi dari *widget* `MaterialApp`? Jelaskan mengapa *widget* ini umumnya digunakan sebagai *root widget* pada aplikasi Flutter!

`MaterialApp` adalah widget tingkat atas untuk aplikasi yang menggunakan Material Design. Widget ini menyediakan konfigurasi seperti tema, judul, halaman awal (`home`), navigasi dan rute, serta dukungan lokalitas. Di proyek ini, `MyApp` mengembalikan `MaterialApp` yang menetapkan tema warna aplikasi dan `MyHomePage` sebagai halaman awal.

`MaterialApp` biasa diletakkan dekat root agar konfigurasi dan layanan aplikasinya tersedia bagi seluruh widget turunannya melalui `BuildContext`. Dengan demikian, halaman anak dapat menggunakan tema yang sama dan navigasi aplikasi secara konsisten, tanpa harus mengatur semuanya dari awal pada tiap halaman.

#### 4. Jelaskan perbedaan antara `StatelessWidget` dan `StatefulWidget`! Kapan kita sebaiknya memilih `StatelessWidget` dan kapan harus menggunakan `StatefulWidget`?

`StatelessWidget` digunakan ketika tampilan widget ditentukan oleh konfigurasi yang immutable dan tidak menyimpan state lokal yang berubah selama widget hidup. `StatefulWidget` digunakan ketika tampilan bergantung pada state yang dapat berubah. Nilai yang berubah disimpan di objek `State`, setelah perubahan yang memengaruhi UI, `setState` memberi tahu Flutter untuk membangun ulang bagian terkait.

Gunakan `StatelessWidget` untuk UI yang informasinya tetap atau diterima melalui parameter, seperti `InfoCard` dan `ItemCard` pada proyek ini. Gunakan `StatefulWidget` untuk UI yang perlu mengelola perubahan lokal, misalnya nilai perhitungan, status pilihan, input form, atau kondisi buka/tutup. `MyHomePage` cocok menjadi `StatelessWidget` karena daftar menu dan informasi profilnya tidak berubah sebagai akibat ketukan, ketukan hanya meminta `ScaffoldMessenger` menampilkan `SnackBar`.

#### 5. Apa itu `BuildContext` dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode `build`?

`BuildContext` adalah referensi ke lokasi sebuah widget dalam *widget tree*. Melalui context, widget dapat mencari konfigurasi atau layanan dari ancestor terdekat, termasuk inherited widget seperti tema. Setiap widget mempunyai context-nya sendiri, sehingga lokasi context menentukan ancestor mana yang dapat ditemukan.

Metode `build(BuildContext context)` menerima context yang terkait dengan widget yang sedang dibangun. Pada `MyHomePage`, `Theme.of(context).colorScheme.primary` mengambil warna utama dari tema terdekat untuk `AppBar`. Pada `ItemCard`, `ScaffoldMessenger.of(context)` mencari messenger terdekat untuk menampilkan `SnackBar`. Penggunaan context harus dilakukan pada lokasi yang berada di bawah ancestor yang dibutuhkan, context tidak sebaiknya disimpan untuk dipakai setelah widget dilepas dari tree.

#### 6. Jelaskan konsep *hot reload* di Flutter dan apa perbedaannya dengan *hot restart*! Kapan kita tidak bisa hanya mengandalkan *hot reload* dan harus melakukan *hot restart* atau *full restart*?

*Hot reload* mengirim perubahan kode Dart ke aplikasi yang sedang berjalan dalam mode debug, lalu membangun ulang widget tree sambil mempertahankan state aplikasi. Karena `main()` dan `initState()` tidak dijalankan ulang, perubahan UI biasa dapat terlihat cepat tanpa mengulang alur aplikasi.

*Hot restart* memulai ulang aplikasi Flutter dari `main()` dan menghapus state yang sedang berjalan, tetapi sesi debug tetap aktif. Gunakan hot restart jika perubahan pada `main()`, `initState()`, atau inisialisasi state global/static tidak tercermin setelah hot reload, atau jika state lama perlu dibuang. *Full restart* menghentikan dan menjalankan kembali aplikasi/target, ini diperlukan untuk menerapkan perubahan kode native platform seperti Kotlin/Java di Android atau Swift/Objective-C di iOS. Semua mekanisme reload ini digunakan saat aplikasi berjalan dalam mode debug.

## AI Disclosure

Saya menggunakan ChatGPT/Codex sebagai alat bantu selama proses pengembangan proyek. AI membantu saya memahami konsep dan implementasi yang belum saya kuasai, meninjau kode atau pesan kesalahan, mencari alternatif solusi, dan materi pendukung. Saya memberikan konteks proyek, pertanyaan, dan bagian kode yang relevan agar saran yang diberikan lebih terarah.

AI tidak mengerjakan keseluruhan proyek secara mandiri. Perancangan, implementasi, pemilihan solusi, pengujian, dan keputusan akhir tetap menjadi tanggung jawab saya. Saya membaca dan mengevaluasi saran AI, lalu menyesuaikan atau menolak saran tersebut jika tidak sesuai dengan kebutuhan dan struktur proyek.

Saya menyadari bahwa jawaban AI dapat keliru, menerapkan hal yang tidak sesuai dengan versi teknologi yang digunakan, atau mengabaikan konteks yang tidak disertakan langsung dalam prompt. AI juga terkadang menyarankan solusi yang lebih rumit daripada yang diperlukan dan tidak selalu dapat menjalankan atau memverifikasi kode. Oleh karena itu, saya harus memverifikasi sendiri saran-saran tersebut, menguji kodenya, serta terkadang menyederhanakan atau memodifikasi solusi yang diusulkan.

### AI Prompting Strategy

Prompt saya mendeskripsikan masalah spesifik yang sedang saya hadapi dengan menyertakan konteks proyek, bagian kode yang relevan, atau pesan kesalahan dan output terminal jika diperlukan. Saya kemudian menggunakan penjelasan yang diberikan untuk memahami konsep dan kemungkinan penyebab masalah sebelum memutuskan apakah saran AI sesuai untuk diterapkan.

Untuk pertanyaan seputar pemrograman, saya biasanya meminta penjelasan tentang mengapa suatu masalah dapat terjadi dan bagaimana konsep yang terkait bekerja, bukan hanya meminta solusi siap pakai. Pendekatan ini membantu saya memahami kode, mengevaluasi saran secara kritis, dan menyelesaikan masalah secara mandiri daripada sekadar menyalin hasil dari AI.

### Prompt Log

AI chat / Prompting Log disediakan dalam bentuk docs : 
[Prompt Log](https://docs.google.com/document/d/1UfjLTFVKztRLaLuK6iaB9szSkNGfCZNJHBG6W8Jvv04/edit?usp=sharing)

## Catatan Tambahan

Nama : Raihan Daffa Aprilianda

NPM : 2506620021

Kelas : PBP B
