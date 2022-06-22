CREATE TABLE bulan (bulan INT);
INSERT INTO bulan VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12);

--Membuat view menampilkan jumlah peminjam setiap jurusan
CREATE OR REPLACE VIEW peminjam_jurusan AS
SELECT J.jurusan, COUNT(DISTINCT P.id_anggota) as jumlah_peminjam
FROM (
	--data dari tabel peminjaman
	SELECT id_peminjaman, id_anggota FROM peminjaman) P
		JOIN (
	--data dari tabel anggota
	SELECT id_anggota, id_departemen FROM anggota) A ON (P.id_anggota=A.id_anggota)
		RIGHT OUTER JOIN 
	--RIGHT OUTER karena ada kemungkinan jurusan yang tidak ada anggotanya
	jurusan J ON (A.id_departemen=J.id_departemen)
GROUP BY J.jurusan
ORDER BY J.jurusan;
--CEK hasil VIEW
SELECT * FROM peminjam_jurusan;


--ACTIVE
--VIEW INFORMASI BUKU
CREATE OR REPLACE VIEW informasi_buku AS
SELECT C.id_buku, C.judul_buku, C.nama_penulis, C.tahun_penerbit, C.stok, T.nama_penerbit, R.nama_rak, R.lokasi_rak
	FROM (
		SELECT * 
		FROM buku B 
		NATURAL JOIN (
			SELECT string_agg(P.nama_penulis, ', ') as nama_penulis, PB.id_buku 
			FROM penulis P 
				JOIN 
				penulis_buku PB 
				ON (P.id_penulis = PB.id_penulis)
			GROUP BY PB.id_buku) A
		) C
		NATURAL JOIN rak R
		NATURAL JOIN penerbit T
ORDER BY C.id_buku;

SELECT * FROM informasi_buku;

--stok buku berkurang ketika peminjaman terjadi (procedure)
--FUNCTION
CREATE OR REPLACE FUNCTION mengurangi_stok()
	RETURNS TRIGGER
	AS $new_ID$
DECLARE
	cur record;
BEGIN
	FOR cur IN (SELECT id_buku, stok FROM buku WHERE id_buku = NEW.id_buku)
	LOOP
		UPDATE buku
		SET stok = stok - 1
		WHERE id_buku = cur.id_buku;
	END LOOP;
	RETURN NEW;
END;
$new_ID$ LANGUAGE plpgsql;

--TRIGGER
CREATE OR REPLACE TRIGGER melakukan_peminjaman
AFTER INSERT ON peminjaman
FOR EACH ROW 
EXECUTE PROCEDURE mengurangi_stok();

INSERT INTO peminjaman (tanggal_pinjam, tanggal_pengembalian, id_petugas, id_anggota, id_buku)
VALUES ('2022-06-01','2022-06-07',3,1,1);

-- Function untuk mendapatkan record petugas perpustakaan berdasarkan namanya dan menampilkan data sebagai raise info
CREATE OR REPLACE FUNCTION ambil_data_petugas(nama VARCHAR(100))
RETURNS RECORD
LANGUAGE plpgsql
AS $$
DECLARE
tmp RECORD;
BEGIN
	FOR tmp IN (SELECT * FROM petugas) LOOP
		IF nama LIKE tmp.nama_petugas THEN
			RAISE INFO 'Data ditemukan';
			RAISE INFO 'Id: %', tmp.id_petugas;
			RAISE INFO 'Nama: %', tmp.nama_petugas;
			RAISE INFO 'Jabatan: %', tmp.jabatan_petugas;
			RAISE INFO 'Nomor Telepon: %', tmp.no_telp_petugas; 
			RAISE INFO 'Alamat: %', tmp.alamat_petugas;

	RETURN tmp;
	END IF;
	END LOOP;
 
-- Jika tidak ada data
RAISE INFO 'TIDAK ADA';
RETURN NULL;
END
$$;
 
-- Pengujian jika data ada
SELECT ambil_data_petugas('Azzura Mahendra Putra Malinus');
 
-- Pengujian jika data tidak ada
SELECT ambil_data_petugas('John Doe');


--jika dilakukan perubahan pada basis data
--Membuat tabel log
CREATE TABLE peminjaman_log (
  status VARCHAR(10),
  change_date DATE,
  ID int NOT NULL
);

--Membuat function, ketika terjadi perubahan berupa DELETE, UPDATE, INSERT
CREATE OR REPLACE FUNCTION log_peminjaman() RETURNS TRIGGER AS $audit_peminjaman$
BEGIN
 IF (TG_OP = 'DELETE') THEN
  INSERT INTO peminjaman_log VALUES ('DELETE',CURRENT_DATE, old.id_peminjaman);
  RETURN OLD;
   ELSEIF (TG_OP = 'UPDATE') THEN
     INSERT INTO peminjaman_log VALUES ('UPDATE',CURRENT_DATE, new.id_peminjaman);
     RETURN NEW;
  ELSEIF (TG_OP = 'INSERT') THEN
    INSERT INTO peminjaman_log VALUES ('INSERT',CURRENT_DATE, new.id_peminjaman);
    RETURN NEW;
  END IF;
END;
$audit_peminjaman$ LANGUAGE plpgsql;
--Membuat TRIGGER 
CREATE OR REPLACE TRIGGER peminjaman_change
AFTER INSERT OR UPDATE OR DELETE ON peminjaman
FOR EACH ROW 
EXECUTE PROCEDURE log_peminjaman();
--Periksa INSERT
INSERT INTO peminjaman (tanggal_pinjam, tanggal_kembali, id_petugas, id_anggota, id_buku) 
VALUES ('2022-05-01','2022-05-10',3,1,2);
--Periksa UPDATE
UPDATE peminjaman
SET id_buku = 3
WHERE Id_peminjaman = 18;
--Periksa DELETE
DELETE FROM peminjaman
WHERE id_peminjaman = 18;
--Periksa hasilnya
SELECT * FROM peminjaman_log;



-- Check wheter tanggal_pinjam and tanggal_pengembalian is valid or not
CREATE OR REPLACE FUNCTION validateTanggal()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
AS 	$BODY$
	BEGIN
		IF NEW.tanggal_pinjam >= NEW.tanggal_pengembalian THEN
			RAISE NOTICE 'Invalid date, please check your input.';
			RETURN OLD;
		END IF;
		RETURN NEW;
	END;
	$BODY$;

CREATE OR REPLACE TRIGGER trig_validateTanggal_peminjaman
	BEFORE INSERT ON peminjaman
	FOR EACH ROW 
	EXECUTE FUNCTION validateTanggal();

-- TEST CASE
-- valid, expected : nothing
INSERT INTO peminjaman (id_peminjaman, tanggal_pinjam, tanggal_kembali, tanggal_pengembalian, denda, id_petugas, id_anggota, id_buku)
VALUES (NULL, '2022-08-10', '2022-09-24', '2022-09-10', NULL, 6, 6, 4);

-- invalid, expected : "Invalid date, please check your input."
INSERT INTO peminjaman (id_peminjaman, tanggal_pinjam, tanggal_kembali, tanggal_pengembalian, denda, id_petugas, id_anggota, id_buku)
VALUES (NULL, '2022-09-16', '2022-09-30', '2022-08-10', NULL, 6, 6, 4);

-- Cheat Sheet
SELECT * FROM peminjaman;


--TRIGGER INSERT peminjaman terbaru
--auto tanggal pinjam dan kembali
CREATE OR REPLACE FUNCTION insert_ID_peminjaman()
	RETURNS TRIGGER
	AS $new_ID$
DECLARE
	cur record;
BEGIN
	IF NEW.ID_peminjaman IS NULL THEN
  		NEW.ID_peminjaman = NEXTVAL('sequence_ID_peminjaman');
 	END IF;
	
	IF NEW.tanggal_pinjam IS NULL THEN
		NEW.tanggal_pinjam := CURRENT_TIMESTAMP;
	END IF;
	
	IF NEW.tanggal_kembali IS NULL THEN
		NEW.tanggal_kembali := CURRENT_DATE + INTERVAL '14 day';
	END IF;
	RETURN NEW;
END;
$new_ID$ LANGUAGE plpgsql;
--TRIGGER
CREATE OR REPLACE TRIGGER melakukan_peminjaman
BEFORE INSERT ON peminjaman
FOR EACH ROW 
EXECUTE PROCEDURE insert_ID_peminjaman();

SELECT setval('sequence_id_peminjaman',(SELECT MAX(id_peminjaman) FROM peminjaman));

--Merubah status tanggal pengembalian, dan menghitung denda. include UPDATE tanggal_pengembalian. PROCEDURE
--aturan denda -> kurang dari 1 bulan, 1 bulan 10k, 3 bulan 30k, 6 bulan 75k, 12 bulan 150k 
CREATE OR REPLACE PROCEDURE pengembalian (ID integer)
LANGUAGE plpgsql
AS $$
	DECLARE 
		cur record;
		nilai_denda int := 0;
		month_dif int := 0;
BEGIN
	FOR cur IN (
		SELECT id_peminjaman, tanggal_kembali, tanggal_pengembalian, denda, id_buku
		FROM peminjaman
		WHERE id_peminjaman = ID)
	LOOP
		UPDATE buku
		SET stok = stok + 1
		WHERE id_buku = cur.id_buku;
		
		--ID yang dimasukkan salah, sudah dilakukan pengembalian
		IF cur.tanggal_pengembalian IS NOT NULL THEN
			RAISE NOTICE '% telah dikembalikan, salah id?', ID; 
		--ID benar
		ELSE
			--UPDATE tanggal_pengembalian
			UPDATE peminjaman
			SET tanggal_pengembalian = CURRENT_TIMESTAMP
			WHERE id_peminjaman = ID;
			--tidak terkena denda
			IF CURRENT_TIMESTAMP <= cur.tanggal_kembali THEN
				RAISE NOTICE 'TIDAK TERKENA DENDA';
				
				nilai_denda := 0;
			--terkena denda
			ELSE
				--menghitung perbedaan bulan
				month_dif := EXTRACT(YEAR FROM AGE(CURRENT_DATE, cur.tanggal_kembali))*12 
					+ EXTRACT(MONTH FROM AGE(CURRENT_DATE, cur.tanggal_kembali));
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
				RAISE NOTICE 'terkena denda: %', nilai_denda;
			END IF;
			--melakukan UPDATE pada tabel peminjaman
			UPDATE peminjaman
			SET denda = nilai_denda
			WHERE id_peminjaman = ID;
		END IF;
	END LOOP;
END;
$$;
--melakukan tes insert
--	tidak denda
INSERT INTO peminjaman (id_petugas, id_anggota, id_buku) VALUES (3,1,1);
--	terkena denda
INSERT INTO peminjaman (tanggal_pinjam, tanggal_kembali, id_petugas, id_anggota, id_buku) VALUES ('2022-04-01','2022-04-15',3,1,2);
--cek data insert baru
SELECT * FROM peminjaman;
--Menjalankan PROCEDURE
CALL pengembalian(20);
CALL pengembalian(19);
--cek hasil update dari procedure
SELECT * FROM peminjaman WHERE id_peminjaman IN (19,20);


--FUNCTIION untuk menampilkan id_peminjam, nama, jumlah peminjaman yang dilakukan, dan jarak dari peminjaman yang terakhir
CREATE OR REPLACE FUNCTION keaktifan_anggota (ID_passing INT)
RETURNS TABLE (
	ID INT,
	NAMA VARCHAR(100),
	JUMLAH_PEMINJAMAN INT,
	JARAK_PEMINJAMAN_TERAKHIR INTERVAL
	)
LANGUAGE plpgsql
AS $$
DECLARE
	cur record;
BEGIN
	FOR cur IN (
				SELECT B.id_anggota, B.nama_anggota, A.banyak_kali, A.jarak
				FROM(
					SELECT id_anggota, MIN(AGE(CURRENT_TIMESTAMP, tanggal_pinjam)) AS jarak, COUNT(id_peminjaman) AS banyak_kali
					FROM peminjaman
					GROUP BY id_anggota) A
						RIGHT OUTER JOIN
							(SELECT id_anggota, nama_anggota FROM anggota) B
							ON (A.id_anggota = B.id_anggota)
				)
		LOOP
		--PESAN UNTUK ID PASSINGAN
		IF cur.id_anggota = ID_passing  THEN
		RAISE NOTICE 'ID: %', cur.id_anggota;
		RAISE NOTICE 'NAMA: %', cur.nama_anggota;
		RAISE NOTICE 'JUMLAH KEDATANGAN: %', cur.banyak_kali;
		RAISE NOTICE 'JARAK PINJAMAN TERKAHIR: %', cur.jarak;
		END IF;
		--INSERT KE TABEL DULU
		ID := cur.id_anggota;
		NAMA := cur.nama_anggota;
		IF cur.banyak_kali IS NOT NULL THEN
		JUMLAH_PEMINJAMAN := cur.banyak_kali;
		ELSE 
		JUMLAH_PEMINJAMAN := 0;
		END IF;

		JARAK_PEMINJAMAN_TERAKHIR := cur.jarak;
		RETURN NEXT;
	END LOOP;
END
$$;
 
SELECT * FROM keaktifan_anggota(1);

--tambahan VIEW-VIEW untuk WEB 1
--jumlah kunjungan
WITH pinjam AS (
	SELECT EXTRACT(MONTH FROM P.tanggal_pinjam) as bulan, COUNT(P.id_peminjaman) as banyak
	FROM peminjaman P
	WHERE EXTRACT(YEAR FROM P.tanggal_pinjam) = EXTRACT(YEAR FROM CURRENT_DATE)
	GROUP BY bulan
), kembali AS(
	SELECT EXTRACT(MONTH FROM P.tanggal_pengembalian) as bulan, COUNT(P.id_peminjaman) as banyak
	FROM peminjaman P
	WHERE EXTRACT(YEAR FROM P.tanggal_pinjam) = EXTRACT(YEAR FROM CURRENT_DATE)
	GROUP BY bulan
) 
SELECT B.bulan, COALESCE(P.banyak,0)+COALESCE(K.banyak,0) AS banyak 
FROM pinjam P FULL OUTER JOIN kembali K ON (P.bulan = K.bulan) CROSS JOIN bulan B
WHERE B.bulan = P.bulan OR B.bulan = K.bulan;

--view nama jurusan, jumlah peminjam berdasarkan jurusan
CREATE OR REPLACE VIEW peminjam_jurusan AS
SELECT J.jurusan, COUNT(DISTINCT P.id_anggota) as jumlah_peminjam
FROM (SELECT id_peminjaman, id_anggota FROM peminjaman) P
	JOIN (SELECT id_anggota, id_departemen FROM anggota) A ON (P.id_anggota=A.id_anggota)
	RIGHT OUTER JOIN jurusan J ON (A.id_departemen=J.id_departemen)
GROUP BY J.jurusan
ORDER BY J.jurusan;

--view bulan, jumlah peminjam setiap bulan
CREATE OR REPLACE VIEW peminjam_bulan AS
SELECT B.bulan, COALESCE(A.banyak,0)
FROM (
	SELECT EXTRACT(MONTH FROM P.tanggal_pinjam) as bulan, COUNT(P.id_anggota) as banyak
	FROM peminjaman P
	WHERE EXTRACT(YEAR FROM P.tanggal_pinjam) = EXTRACT(YEAR FROM CURRENT_DATE)
	GROUP BY bulan
	) A RIGHT OUTER 
		JOIN
	bulan B ON (B.bulan=A.bulan);
