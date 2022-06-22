--========JURUSAN==========--
CREATE TABLE Jurusan(
	id_departemen int NOT NULL,
	jurusan varchar(30) NOT NULL,
	
	CONSTRAINT PK_id_departemen PRIMARY KEY (id_departemen)
);
-- AUTO ID Table PETUGAS
--=============================--
CREATE SEQUENCE sequence_id_departemen
 AS INT
 INCREMENT BY 1
 MINVALUE 1
 OWNED BY jurusan.id_departemen;

CREATE OR REPLACE FUNCTION insert_id_departemen()
 RETURNS TRIGGER
 LANGUAGE plpgsql
 AS $new_id$
BEGIN
 IF NEW.id_departemen IS NULL THEN
  NEW.id_departemen = NEXTVAL('sequence_id_departemen');
 END IF;  
 RETURN NEW;
END;
$new_id$;

CREATE OR REPLACE TRIGGER trig_insert_id_departemen
 	BEFORE INSERT ON jurusan
 	FOR EACH ROW
 	EXECUTE PROCEDURE insert_id_departemen();
--================================--
INSERT INTO jurusan (jurusan)
VALUES 
('Statistika'),
('Aktuaria'),
('Fisika'),
('Teknik Mesin'),
('Teknik Informatika'),
('Teknik Industri'),
('Arsitektur'),
('Teknik Elektro'),
('Desain Komunikasi Visual'),
('Desain Interior');

--========PENULIS=========--
CREATE TABLE Penulis(
	id_penulis int NOT NULL,
	nama_penulis varchar(50) NOT NULL,
	
	CONSTRAINT PK_id_penulis PRIMARY KEY (id_penulis)
);
-- AUTO ID Table PETUGAS
--=============================--
CREATE SEQUENCE sequence_id_penulis
 AS INT
 INCREMENT BY 1
 MINVALUE 1
 OWNED BY penulis.id_penulis;

CREATE OR REPLACE FUNCTION insert_id_penulis()
 RETURNS TRIGGER
 LANGUAGE plpgsql
 AS $new_id$
BEGIN
 IF NEW.id_penulis IS NULL THEN
  NEW.id_penulis = NEXTVAL('sequence_id_penulis');
 END IF;  
 RETURN NEW;
END;
$new_id$;

CREATE OR REPLACE TRIGGER trig_insert_id_penulis
 	BEFORE INSERT ON penulis
 	FOR EACH ROW
 	EXECUTE PROCEDURE insert_id_penulis();
--================================--
INSERT INTO penulis (nama_penulis)
VALUES
('J.Supranto'),
('Muhammad Taqwa'),
('Akbar Taufik'),
('Syarif Hidayatullah'),
('Richard L. London'),
('J.Cunningham'),
('Thomas Herzog'),
('Robert Kiyosaki'),
('Sharon Lechter'),
('Pidi Baik'),
('Asma Nadia'),
('Douglas C. Giancoli'),
('David Halliday'),
('Robert Resnick'),
('Jearl Walker'),
('Peter Thiel'),
('Walter Isaac');

--=========PETUGAS==========--
CREATE TABLE Petugas(
 id_petugas INT NOT NULL,
 nama_petugas VARCHAR(50) NOT NULL,
 jabatan_petugas VARCHAR(50) NOT NULL,
 no_telp_petugas CHAR(13) NOT NULL,
 alamat_petugas VARCHAR(100) NOT NULL,
 
 CONSTRAINT PK_id_petugas PRIMARY KEY (id_petugas) 
);

-- AUTO ID Table PETUGAS
--=============================--
CREATE SEQUENCE sequence_id_petugas
 AS INT
 INCREMENT BY 1
 MINVALUE 1
 OWNED BY Petugas.id_petugas;

CREATE OR REPLACE FUNCTION insert_id_petugas()
 RETURNS TRIGGER
 LANGUAGE plpgsql
 AS $new_id$
BEGIN
 IF NEW.id_petugas IS NULL THEN
  NEW.id_petugas = NEXTVAL('sequence_id_petugas');
 END IF;  
 RETURN NEW;
END;
$new_id$;

CREATE OR REPLACE TRIGGER trig_insert_id_petugas
 	BEFORE INSERT ON Petugas
 	FOR EACH ROW
 	EXECUTE PROCEDURE insert_id_petugas();
--================================--
INSERT INTO Petugas (nama_petugas, jabatan_petugas, no_telp_petugas, alamat_petugas) 
VALUES
 ('Arya Nur Razzaq', 'Kepala', '0812121421459', 'Sukolilo, Surabaya'),
 ('Ahmad Ferdiansyah Ramadhani', 'Layanan Teknis', '0819593925235', 'Blimbing, Malang'),
 ('Surya Abdillah', 'Pengelola Keuangan', '0814141398839', 'Waru, Sidoarjo'),
 ('Muhammad Rafif Fadhil Naufal', 'Layanan Teknologi Informasi dan Komunikasi', '0812374823647', 'Mulyorejo, Surabaya'),
 ('Nuzul Abatony', 'Layanan Pemustaka', '0892346726755', 'Candi, Sidoarjo'),
 ('Azzura Mahendra Putra Malinus', 'Pustakawan Muda', '0823587239929', 'Sukun, Malang');

--=========RAK========--
CREATE TABLE rak (
	ID_rak INT NOT NULL,
	nama_rak VARCHAR(15) NOT NULL,
	lokasi_rak VARCHAR(100) NOT NULL,
	
	CONSTRAINT PK_ID_rak PRIMARY KEY (ID_rak)
);
-- AUTO ID Table PETUGAS
--=============================--
CREATE SEQUENCE sequence_ID_rak
	AS INT
	INCREMENT BY 1
	MINVALUE 1
	OWNED BY rak.ID_rak;

CREATE OR REPLACE FUNCTION insert_ID_rak()
	RETURNS TRIGGER AS
$BODY$
BEGIN
	IF NEW.ID_rak IS NULL THEN
		NEW.ID_rak = NEXTVAL('sequence_ID_rak');
	END IF;
	RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trig_insert_ID_rak
	BEFORE INSERT ON rak
	FOR EACH ROW
	EXECUTE FUNCTION insert_ID_rak();
--================================--
INSERT INTO rak (nama_rak, lokasi_rak)
VALUES 
	('Edukasi', 'ruang utama bagian kanan'),
	('Self-Help', 'ruang utama bagian tengah'),
	('Fiksi', 'ruang utama bagian kiri	'),
	('Horror', 'ruang utama bagian belakang');

--=========PENERBIT==========--
CREATE TABLE penerbit (
	ID_penerbit INT NOT NULL,
	nama_penerbit VARCHAR(50) NOT NULL,
	
	CONSTRAINT PK_ID_penerbit PRIMARY KEY (ID_penerbit)
);
-- AUTO ID Table PETUGAS
--=============================--
CREATE SEQUENCE sequence_ID_penerbit
	AS INT
	INCREMENT BY 1
	MINVALUE 1
	OWNED BY penerbit.ID_penerbit;

CREATE OR REPLACE FUNCTION insert_ID_penerbit()
	RETURNS TRIGGER AS 
$BODY$
BEGIN
	IF NEW.ID_penerbit IS NULL THEN
		NEW.ID_penerbit = NEXTVAL('sequence_ID_penerbit');
	END IF;
	RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trig_insert_ID_penerbit
	BEFORE INSERT ON penerbit
	FOR EACH ROW
	EXECUTE FUNCTION insert_ID_penerbit();
--================================--
INSERT INTO penerbit (nama_penerbit) 
VALUES
	('UGM Press'),
	('Deepublish'),
	('Salemba Teknika'),
	('ACTEX Learning'),
	('Warner Books'),
	('Pastel Books'),
	('Noura Publishing'),
	('Jakarta AsmaNadia Publishing'),
	('Pearson Education'),
	('John Wiley & Sons'),
	('Crown Business'),
	('Simon & Schuster'),
	('IDG Books/Hungry Minds'),
	('Dvir Publishing House');

--=========BUKU==========--
CREATE TABLE Buku(
 	ID_buku INT NOT NULL,
 	judul_buku VARCHAR(50) NOT NULL,
 	tahun_penerbit INT NOT NULL,
 	stok INT NOT NULL,
 	ID_rak INT NOT NULL,
 	ID_penerbit INT NOT NULL,

 	CONSTRAINT PK_ID_buku PRIMARY KEY (ID_buku),
 	CONSTRAINT BK_ID_rak_FK FOREIGN KEY (ID_rak) REFERENCES rak(ID_rak),
 	CONSTRAINT BK_ID_penerbit_FK FOREIGN KEY (ID_penerbit) REFERENCES penerbit(ID_penerbit)
);
-- AUTO ID Table BUKU
--=============================--
CREATE SEQUENCE sequence_ID_buku
	AS INT
	INCREMENT BY 1
	MINVALUE 1
	OWNED BY buku.ID_buku;

CREATE OR REPLACE FUNCTION insert_ID_buku()
 	RETURNS TRIGGER
 	LANGUAGE plpgsql
 	AS $new_id$
BEGIN
 	IF NEW.ID_buku IS NULL THEN
  		NEW.ID_buku = NEXTVAL('sequence_ID_buku');
 	END IF;
  
 	RETURN NEW;
END;
$new_id$;

CREATE OR REPLACE TRIGGER trig_insert_ID_buku
BEFORE INSERT ON Buku
FOR EACH ROW 
EXECUTE PROCEDURE insert_ID_buku();
--================================--
INSERT INTO Buku (judul_buku, tahun_penerbit, stok, ID_rak, ID_penerbit) 
VALUES 
('Statistika dengan R', 2019, 4, 1, 2),
('Statistika teori dan Terapan ', 2004, 4, 1, 4 ),
('Statistika dan Probabilitas', 2000, 5, 1, 3),
('Models for Quantifying Risk', 2005, 3, 1, 4),
('Rich and Poor dad', 1997, 5, 2, 8),
('Dilan : dia adalah dilanku tahun 1990', 2014, 9, 3, 6),
('Assalamualaikum, Beijing !', 2013, 1, 3, 7),
('Surga yang tak dirindukan', 2017, 3, 3, 8),
('Fisika : Prinsip dan Aplikasi', 1980, 1, 1, 3),
('Fisika Dasar' , 2013, 4, 1, 3),
('Zero To One', 2014, 1, 2, 4),
('Steve Jobs', 2013, 4, 3, 11);

--=========PENULIS_BUKU=========--
CREATE TABLE Penulis_Buku (
	ID_penulis INT NOT NULL,
	ID_buku INT NOT NULL,

	CONSTRAINT PK_penulis_buku PRIMARY KEY (ID_penulis, ID_buku),
	CONSTRAINT penulis_FK FOREIGN KEY (ID_penulis) REFERENCES penulis(ID_penulis),
	CONSTRAINT buku_FK FOREIGN KEY (ID_buku) REFERENCES buku(ID_buku)
);

INSERT INTO Penulis_Buku VALUES
	(1,2),
	(2,1),
	(3,1),
	(4,3),
	(5,4),
	(6,4),
	(7,4),
	(8,5),
	(9,5),
	(10,6),
	(11,7),
	(11,8),
	(12,9),
	(13,10),
	(14,10),
	(15,10),
	(16,11),
	(17,12);

--=========ANGGOTA===========--
CREATE TABLE anggota (
	id_anggota INT NOT NULL,
	nama_anggota VARCHAR(100) NOT NULL,
	no_telp_anggota VARCHAR(13) NOT NULL,
	alamat_anggota VARCHAR(100) NOT NULL,
	NRP VARCHAR(11) NOT NULL,
	id_departemen INT NOT NULL,
	
	CONSTRAINT PK_id_anggota PRIMARY KEY (id_anggota),
	CONSTRAINT AGT_id_departemen FOREIGN KEY (id_departemen) REFERENCES jurusan (id_departemen)
);
-- AUTO ID Table ANGGOTA
--=============================--
CREATE SEQUENCE sequence_ID_anggota
	AS INT
	INCREMENT BY 1
	MINVALUE 1
	OWNED BY anggota.ID_anggota;

CREATE OR REPLACE FUNCTION insert_ID_anggota()
 	RETURNS TRIGGER
 	LANGUAGE plpgsql
 	AS $new_id$
BEGIN
 	IF NEW.ID_anggota IS NULL THEN
  		NEW.ID_anggota = NEXTVAL('sequence_ID_anggota');
 	END IF;
  
 	RETURN NEW;
END;
$new_id$;

CREATE OR REPLACE TRIGGER trig_insert_ID_anggota
BEFORE INSERT ON anggota
FOR EACH ROW 
EXECUTE PROCEDURE insert_ID_anggota();
--================================--
INSERT INTO anggota (nama_anggota, no_telp_anggota, alamat_anggota, NRP, id_departemen)
VALUES 
	('Graddy Immanuel', '111222333444', 'Candi, Sidoarjo', '11112222333', 1),
	('Andromeda Merkuri', '222333444555', 'Sukolilo, Surabaya', '22223331111', 1),
	('Bima Sakti', '333444555666', 'Mulyosari, Surabaya', '33311112222', 4),
	('Awliya Hanun', '444555666777', 'Mulyorejo, Surabaya', '11122223333', 3),
	('Nadine Haninta', '555666777888', 'Gebang Putih, Surabaya', '22221113333', 8),
	('Andi Setyo Bekti', '666777888999', 'Keputih, Surabaya', '22233331111', 2),
	('Ilham Fikriansyah', '777888999111', 'Keputih, Surabaya', '77788889999', 6),
	('W Kusuma Annisa', '888999111222', 'Kenjeran, Surabaya', '88887779999', 9),
	('Tiara Dwi Prasasti', '999111222333', 'Waru, Sidoarjo', '88889999777', 5);

--=========PEMINJAMAN=========--
CREATE TABLE peminjaman (
	id_peminjaman INT NOT NULL,
	tanggal_pinjam TIMESTAMP NOT NULL,
	tanggal_kembali TIMESTAMP,
	tanggal_pengembalian TIMESTAMP,
	denda INT,
	id_petugas INT NOT NULL,
	id_anggota INT NOT NULL,
	id_buku INT NOT NULL,
	
	CONSTRAINT PK_id_peminjaman PRIMARY KEY (id_peminjaman),
	CONSTRAINT PJ_id_petugas FOREIGN KEY (id_petugas) REFERENCES petugas(id_petugas),
	CONSTRAINT PJ_id_anggota FOREIGN KEY (id_anggota) REFERENCES anggota(id_anggota),
	CONSTRAINT PJ_id_buku FOREIGN KEY (id_buku) REFERENCES buku(id_buku)
);
-- AUTO ID Table PEMINJAMAN
--=============================--
CREATE SEQUENCE sequence_ID_peminjaman
	AS INT
	INCREMENT BY 1
	MINVALUE 1
	OWNED BY peminjaman.ID_peminjaman;

CREATE OR REPLACE FUNCTION insert_ID_peminjaman()
 	RETURNS TRIGGER
 	LANGUAGE plpgsql
 	AS $new_id$
BEGIN
 	IF NEW.ID_peminjaman IS NULL THEN
  		NEW.ID_peminjaman = NEXTVAL('sequence_ID_peminjaman');
 	END IF;
  
 	RETURN NEW;
END;
$new_id$;

CREATE OR REPLACE TRIGGER trig_insert_ID_peminjaman
BEFORE INSERT ON peminjaman
FOR EACH ROW 
EXECUTE PROCEDURE insert_ID_peminjaman();
--================================--
INSERT INTO peminjaman (tanggal_pinjam, tanggal_pengembalian, id_petugas, id_anggota, id_buku)
VALUES
	('2022-01-03','2022-01-15',3,1,1),
	('2022-01-16','2022-01-13',6,6,4),
	('2022-01-23','2022-01-30',6,2,3),
	('2022-02-02','2022-02-10',6,5,7),
	('2022-02-02','2022-02-28',6,8,9),
	('2022-02-28','2022-03-01',4,8,6),
	('2022-03-05','2022-03-19',5,9,11),
	('2022-03-12','2022-03-20',3,5,12),
	('2022-03-13','2022-03-21',1,2,1),
	('2022-03-23','2022-04-25',2,1,4),
	('2022-03-29','2022-04-09',4,4,12),
	('2022-04-04','2022-04-19',2,8,10),
	('2022-04-13','2022-04-27',4,9,5),
	('2022-04-13','2022-04-19',3,2,7),
	('2022-04-14','2022-04-29',1,4,1),
	('2022-04-27','2022-05-04',6,4,2),
	('2022-04-29','2022-05-05',2,6,2);

UPDATE peminjaman
SET tanggal_kembali = tanggal_pinjam + INTERVAL '14 day';

--aturan denda -> kurang dari 1 bulan 5k, 1 bulan 10k, 3 bulan 30k, 6 bulan 75k, 12 bulan 150k 

--aturan denda -> kurang dari 1 bulan 5k, 1 bulan 10k, 3 bulan 30k, 6 bulan 75k, 12 bulan 150k 
CREATE OR REPLACE PROCEDURE pengembalian ()
LANGUAGE plpgsql
AS $$
	DECLARE 
		cur record;
		nilai_denda int := 0;
		month_dif int := 0;
BEGIN
	FOR cur IN (
		SELECT id_peminjaman, tanggal_kembali, tanggal_pengembalian, denda
		FROM peminjaman)
	LOOP
			--tidak terkena denda
			IF cur.tanggal_pengembalian <= cur.tanggal_kembali THEN
				RAISE NOTICE 'TIDAK TERKENA DENDA';
				
				UPDATE peminjaman
				SET denda = 0
				WHERE id_peminjaman = cur.id_peminjaman;
			--terkena denda
			ELSE
				--menghitung perbedaan bulan
				month_dif := EXTRACT(YEAR FROM AGE(cur.tanggal_pengembalian, cur.tanggal_kembali))*12 
					+ EXTRACT(MONTH FROM AGE(cur.tanggal_pengembalian, cur.tanggal_kembali));
				--12 bulan, 150k
				IF month_dif >= 12 THEN
					nilai_denda := 150000;
				--6 bulan, 75k
				ELSEIF month_dif >= 6 THEN
					nilai_denda := 75000;
				--3 bulan, 30k
				ELSEIF month_dif >= 3 THEN
					nilai_denda := 30000;
				--1 bulan, 10k
				ELSEIF month_dif >= 1 THEN
					nilai_denda := 10000;
				--kurang dari 1 bulan, 5k
				ELSE
					nilai_denda := 5000;
				END IF;
				--melakukan UPDATE pada tabel peminjaman
				UPDATE peminjaman
				SET denda = nilai_denda
				WHERE id_peminjaman = cur.id_peminjaman;
			END IF;
			RAISE NOTICE 'update denda, id_peminjaman: %', cur.id_peminjaman;
	END LOOP;
END;
$$;

CALL pengembalian();
