<?php
    include 'connect.php';

    if(isset($_GET['activeFunctionId'])){
        $id=$_GET['activeFunctionId'];
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="styles2.css">
    <title>Display peminjaman</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
</head>

<body>
    
<div class="container">
    <button class="btn btn-primary my-5"><a href="peminjamanDisplay.php" class="text-light">Kembali ke Display</a></button>
    <button class="btn btn-primary my-5"><a href="peminjamanSelectDisplay.php" class="text-light">SELECT peminjaman</a></button>

    <table class="table">
  <thead>
    <tr>
      <th scope="col">Id_anggota</th>
      <th scope="col">Nama</th>
      <th scope="col">jumlah_peminjaman</th>
      <th scope="col">jarak_peminjaman_terakhir</th>
    </tr>
  </thead>
  <tbody>

    <?php
    $sql = "
        CREATE OR REPLACE FUNCTION keaktifan_anggota (ID_passing INT)
            RETURNS TABLE (
                ID int,
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
                    SELECT id_anggota, MAX(AGE(CURRENT_TIMESTAMP, tanggal_pinjam)) as jarak, COUNT(id_peminjaman) as banyak_kali
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
    ";
    $result = pg_query($conn,$sql);

    $sql = "SELECT * FROM keaktifan_anggota('$id')";
    $result = pg_query($conn,$sql);
    if($result){
        while($row = pg_fetch_assoc($result)){
            $id_anggota = $row['id'];
            $nama = $row['nama'];
            $jumlah_peminjaman = $row['jumlah_peminjaman'];
            $jarak_peminjaman_terakhir = $row['jarak_peminjaman_terakhir'];

            echo'<tr>
            <th scope="row">'.$id_anggota.'</th>
            <td>'.$nama.'</td>
            <td>'.$jumlah_peminjaman.'</td>
            <td>'.$jarak_peminjaman_terakhir.'</td>
          </tr>';
        }
    }

    ?>
  </tbody>
</table>
</div>
</body>

</html>