--	[ARYA]
-- Nama Peminjam Terbanyak --
SELECT c.id_anggota,c.nama_anggota
FROM(
	SELECT a.id_anggota, a.nama_anggota, COUNT(b.id_peminjaman)AS total
	FROM(SELECT id_anggota,nama_anggota FROM anggota) a JOIN (SELECT id_anggota,id_peminjaman FROM peminjaman) b on a.id_anggota = b.id_anggota
		GROUP BY (a.id_anggota,a.nama_anggota))AS c	
WHERE c.total = (SELECT MAX(d.total)FROM  
(SELECT a.id_anggota, a.nama_anggota, COUNT(b.id_peminjaman)AS total
	FROM(SELECT id_anggota,nama_anggota FROM anggota) a JOIN (SELECT id_anggota,id_peminjaman FROM peminjaman) b on a.id_anggota = b.id_anggota
		GROUP BY (a.id_anggota,a.nama_anggota))AS d)
	
--Jumlah peminjaman yang ditangani tiap petugas
SELECT a.id_petugas, count(b.id_peminjaman)AS Total
FROM (SELECT id_petugas,nama_petugas FROM petugas) a JOIN (SELECT id_petugas,id_peminjaman FROM peminjaman) b on a.id_petugas = b.id_petugas
 GROUP BY(a.id_petugas);


--	[RAMA]
--AGGREGATE
--	JUMLAH PEMINJAMAN SETIAP BULANNYA, pada tahun current. AGGREGATE
SELECT EXTRACT(MONTH FROM tanggal_pinjam) as bulan, COUNT(id_peminjaman) as jumlah_peminjaman
FROM peminjaman
WHERE EXTRACT(YEAR FROM tanggal_pinjam) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY bulan
ORDER BY bulan;

--KOMPLEKS
--	PENULIS dari buku favorit SETIAP JURUSAN. KOMPLEKS
--gabungin jurusan+anggota+peminjaman (ambil ID bukunya)
--lihat dari penulis_buku+penulis
WITH buku_perJurusan AS (
	SELECT P.id_buku, J.jurusan, COUNT(P.id_peminjaman) as banyaknya
	FROM (SELECT id_peminjaman, id_buku, id_anggota FROM peminjaman) P 
		JOIN (SELECT id_anggota, id_departemen FROM anggota) A ON (P.id_anggota = A.id_anggota)
		JOIN jurusan J ON (A.id_departemen = J.id_departemen)
	GROUP BY P.id_buku, J.jurusan
), list_penulis AS (
	SELECT PB.id_buku, string_agg(P.nama_penulis, ', ') as nama_penulis
	FROM penulis_buku PB NATURAL JOIN penulis P 
	GROUP BY id_buku
)
SELECT *
FROM (
	SELECT jurusan, MAX(banyaknya) as banyaknya
	FROM buku_perJurusan
	GROUP BY jurusan) A
		NATURAL JOIN
	buku_perJurusan B
		NATURAL JOIN
	list_penulis;

--NESTED
-- INFORMASI BUKU, NESTED
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
		NATURAL JOIN penerbit T;


--	[AZZURA]
--Aggregate: Jumlah peminjaman setiap anggota
SELECT * FROM anggota
 
SELECT (
(SELECT COUNT(id_anggota) FROM anggota)
-
(SELECT COUNT(T.jumlah_anggota_meminjam) 
FROM (SELECT COUNT(id_anggota) AS jumlah_anggota_meminjam
FROM peminjaman
GROUP BY id_anggota) T)
 
) AS jumlah_anggota_tidak_meminjam
--nested:Jurusan yang mahasiswanya tidak ada yang mendaftar menjadi anggota
SELECT jurusan
FROM jurusan
WHERE id_departemen NOT IN (SELECT DISTINCT id_departemen FROM anggota)
--Kompleks: Petugas yang jumlah pelayanan transaksi peminjamannya di atas rata-rata
SELECT P2.id_petugas, P2.nama_petugas, P2.jabatan_petugas, P2.no_telp_petugas, P2.alamat_petugas
FROM (SELECT id_petugas, COUNT(id_petugas) AS cnt1 
FROM peminjaman 
GROUP BY id_petugas) P1
 
INNER JOIN petugas P2 ON P1.id_petugas = P2.id_petugas
 
WHERE P1.cnt1 > (SELECT AVG(C.cnt) AS avg_service 
FROM (SELECT COUNT(P.id_petugas) AS cnt
FROM peminjaman P 
GROUP BY P.id_petugas) C);


--	[RAFIF]
-- PENULIS FAVORIT SETIAP KATEGORI (rak)
WITH data_data AS (
 SELECT P.nama_penulis, R.nama_rak, COUNT(P.id_penulis) as banyak
 FROM (SELECT id_buku, id_rak FROM buku) B NATURAL JOIN penulis_buku PB 
  NATURAL JOIN penulis P
  NATURAL JOIN rak R
 GROUP BY P.nama_penulis, R.nama_rak
)
SELECT A.nama_rak, B.nama_penulis, A.banyak
FROM (
  SELECT nama_rak, MAX(banyak) as banyak
  FROM data_data
  GROUP BY nama_rak
 ) A JOIN 
 data_data B ON (A.nama_rak = B.nama_rak AND A.banyak = B.banyak)
ORDER BY A.nama_rak;

-- penulis dari buku yang paling sering dipinjam
WITH data_data AS (
 SELECT P.id_buku, COUNT(P.id_peminjaman) as banyak
 FROM peminjaman P
 GROUP BY P.id_buku
)
SELECT A.id_buku, A.banyak, string_agg(P.nama_penulis, ', ')
FROM data_data A NATURAL JOIN penulis_buku PB NATURAL JOIN penulis P
WHERE A.banyak = (SELECT MAX(banyak) as banyak FROM data_data)
GROUP BY A.id_buku, A.banyak;


--	[TONI]
-- Aggregate : Jumlah buku tiap penerbit
SELECT pb.nama_penerbit, COUNT(b.id_buku) AS jumlah_buku
FROM penerbit pb LEFT JOIN buku b ON (b.id_penerbit = pb.id_penerbit)
GROUP BY pb.id_penerbit
ORDER BY jumlah_buku DESC;

-- Nested : Daftar anggota yang belum pernah melakukan peminjaman
SELECT nama_anggota
FROM anggota
WHERE id_anggota NOT IN (
	SELECT DISTINCT id_anggota 
	FROM peminjaman
);

-- Kompleks : daftar peminjaman buku bulan mei - april
SELECT ag.nama_anggota, pt.nama_petugas, bk.judul_buku, pm.tanggal_pinjam
FROM peminjaman pm 
	JOIN petugas pt ON (pm.id_petugas = pt.id_petugas)
	JOIN anggota ag ON (pm.id_anggota = ag.id_anggota)
	JOIN buku bk ON (pm.id_buku = bk.id_buku)
WHERE pm.tanggal_pinjam BETWEEN '2022-03-01' AND '2022-04-30'
ORDER BY pm.tanggal_pinjam;


--	[SURYA]
--AGGREGATE
--	PENDAPATAN SETIAP TAHUN, pada tahun current. AGGREGATE
WITH needed_data AS (
	SELECT id_peminjaman, tanggal_pengembalian, denda
	FROM peminjaman
)
SELECT EXTRACT(MONTH FROM tanggal_pengembalian) AS bulan, SUM(denda) 
FROM needed_data
WHERE EXTRACT(YEAR FROM tanggal_pengembalian) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY bulan
ORDER BY bulan;

--KOMPLEKS
--	ID_BUKU FAVORIT setiap bulan, pada tahun current. KOMPLEKS
WITH data_banyak AS (
	SELECT EXTRACT(MONTH FROM tanggal_pinjam) as bulan, B.id_buku as buku, COUNT(P.id_peminjaman) as banyak_peminjaman
	FROM (
		SELECT id_peminjaman, tanggal_pinjam, id_buku 
		FROM peminjaman) P 
			JOIN (
		SELECT id_buku 
		FROM buku) B
			ON (P.id_buku = B.id_buku)
	WHERE EXTRACT(YEAR FROM tanggal_pinjam) = EXTRACT(YEAR FROM CURRENT_DATE)
	GROUP BY buku, bulan
) 
SELECT A.bulan, B.buku, B.banyak_peminjaman
FROM (
	SELECT bulan, MAX(banyak_peminjaman) as terbanyak
 	FROM data_banyak 
	GROUP BY bulan
	) A 
		JOIN 
	data_banyak B
		ON (A.bulan = B.bulan)
WHERE A.terbanyak = B.banyak_peminjaman
ORDER BY A.bulan;

--NESTED
-- JURUSAN YANG MEMINJAM LEBIH DARI RATA-RATA, NESTED
WITH list_data AS (
	SELECT B.id_departemen, B.jurusan, COUNT(P.id_peminjaman) as banyaknya
	FROM (SELECT id_peminjaman, id_anggota FROM peminjaman) P 
		NATURAL JOIN (SELECT id_anggota, id_departemen FROM anggota) A
		NATURAL JOIN (SELECT id_departemen, jurusan FROM jurusan) B
	GROUP BY B.id_departemen, B.jurusan
)
SELECT *
FROM list_data
WHERE banyaknya > (SELECT AVG(banyaknya) FROM list_data);

