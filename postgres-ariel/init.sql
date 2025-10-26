-- Isi file: setup.sql

-- =======================================================
-- SOAL 3: Membuat skema dan tabel dengan constraint (Skor 10)
-- =======================================================

-- 1. Membuat skema dengan nama SALAM
CREATE SCHEMA SALAM;

-- 2. Membuat tabel mahasiswa di dalam skema SALAM
CREATE TABLE SALAM.mahasiswa (
    -- PRIMARY KEY: nim
    nim VARCHAR(15) PRIMARY KEY, 
    
    -- UNIQUE constraint: email
    email VARCHAR(100) UNIQUE, 
    
    -- NOT NULL constraint: nama
    nama VARCHAR(100) NOT NULL, 
    
    tanggal_lahir DATE,
    
    -- CHECK constraint: angkatan harus di atas 2000
    angkatan INTEGER CHECK (angkatan > 2000) 
);

-- =======================================================
-- FITUR KHAS TAMBAHAN: View dan Role Analitik (Bukti Tambahan)
-- =======================================================

-- Membuat View untuk memudahkan reporting (misalnya menghitung umur mahasiswa)
CREATE VIEW SALAM.mahasiswa_usia_view AS
SELECT 
    nim, 
    nama, 
    angkatan,
    EXTRACT(YEAR FROM age(CURRENT_DATE, tanggal_lahir)) AS usia_tahun -- Fungsi khas
FROM 
    SALAM.mahasiswa;

-- =======================================================
-- SOAL 4: Membuat User/Role dan Hak Akses (Skor 30)
-- =======================================================

-- Membuat 3 Role/User baru untuk login (sertakan password)
CREATE ROLE backend_dev NOINHERIT LOGIN PASSWORD 'dev_pass';
CREATE ROLE bi_dev NOINHERIT LOGIN PASSWORD 'bi_pass';
CREATE ROLE data_engineer NOINHERIT LOGIN PASSWORD 'data_eng_pass';

-- Membuat Role Khas: REPORT_VIEWER (Hanya bisa SELECT di View)
CREATE ROLE report_viewer NOINHERIT LOGIN PASSWORD 'report_pass';


-- Memberi hak koneksi ke database 'postgres' dan akses skema SALAM
GRANT CONNECT ON DATABASE postgres TO backend_dev, bi_dev, data_engineer, report_viewer;
GRANT USAGE ON SCHEMA SALAM TO backend_dev, bi_dev, data_engineer, report_viewer;


-- 4a. backend_dev: Role CRUD semua tabel
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA SALAM TO backend_dev;
-- Hak default untuk tabel di masa depan
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;


-- 4b. bi_dev: Role hanya read/select semua tabel/view
GRANT SELECT ON ALL TABLES IN SCHEMA SALAM TO bi_dev;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA SALAM TO bi_dev;
-- Hak default untuk tabel di masa depan
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT ON TABLES TO bi_dev;


-- 4c. data_engineer: Role CREATE, MODIFY, DROP semua objects, CRUD semua tabel
GRANT ALL ON ALL TABLES IN SCHEMA SALAM TO data_engineer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA SALAM TO data_engineer;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA SALAM TO data_engineer;
-- Memberi hak CREATE pada skema (penting untuk membuat/modify objek)
GRANT CREATE ON SCHEMA SALAM TO data_engineer; 
-- Hak default untuk objek di masa depan
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON TABLES TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON SEQUENCES TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON FUNCTIONS TO data_engineer;


-- Hak Akses untuk Role Khas (REPORT_VIEWER)
-- Role ini hanya bisa SELECT dari VIEW yang sudah dibuat (mahasiswa_usia_view)
GRANT SELECT ON SALAM.mahasiswa_usia_view TO report_viewer;

-- Catatan:
-- Backend_dev, bi_dev, dan data_engineer juga bisa SELECT dari view tersebut 
-- karena mereka memiliki hak SELECT pada skema dan tabel.