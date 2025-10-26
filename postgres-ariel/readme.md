# Proyek Database Docker: PostgreSQL + pgAdmin

Ini adalah proyek untuk menjalankan PostgreSQL dan pgAdmin dalam kontainer Docker, lengkap dengan skema kustom, tabel, dan manajemen *roles*.

## Struktur Proyek

-   `docker-compose.yml`: Mendefinisikan *services* `postgres` dan `pgadmin`.
-   `init.sql`: Berisi semua skrip SQL untuk inisialisasi database (skema, tabel, *roles*, data *dummy*).
-   `.env.example`: Template untuk variabel lingkungan yang diperlukan.

## Cara Menjalankan

1.  **Clone repositori ini:**
    ```bash
    git clone [URL_REPO_ANDA]
    cd [NAMA_FOLDER_REPO]
    ```

2.  **Buat file `.env`:**
    Salin file `.env.example` dan ubah namanya menjadi `.env`.
    ```bash
    cp .env.example .env
    ```

3.  **Edit file `.env`:**
    Buka file `.env` dan sesuaikan nilainya (terutama `POSTGRES_PASSWORD`, `POSTGRES_PORT`, dan `PGADMIN_PORT`).

4.  **Jalankan Docker Compose:**
    ```bash
    docker-compose up -d
    ```

5.  **Akses Services:**
    -   **pgAdmin:** Buka `http://localhost:[PGADMIN_PORT]`
    -   **DBeaver (Eksternal):** Hubungkan ke `localhost` pada `[POSTGRES_PORT]`

6.  **Inisialisasi Database:**
    Buka pgAdmin atau DBeaver, hubungkan ke database, lalu **jalankan semua skrip** dari file `init.sql` untuk membuat tabel, *roles*, dan mengisi data *dummy*.