<?php
    include 'connect.php';

    if(isset($_POST['kembali'])){
      $id_kembali=$_POST['id_kembali'];

      $sql = "
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
      $$;";
      $result = pg_query($conn,$sql);

      $sql = "CALL pengembalian('$id_kembali')";
      $result = pg_query($conn, $sql);

      header("location:peminjamanSelect.php?peminjamanSelect=$id_kembali");
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
    <button class="btn btn-danger my-5"><a href="home.php" class="text-light">HOME</a></button>
    <button class="btn btn-primary my-5"><a href="peminjamanInsert.php" class="text-light">Add peminjaman</a></button>
    <button class="btn btn-primary my-5"><a href="peminjamanSelectDisplay.php" class="text-light">SELECT peminjaman</a></button>

    <table class="table">
  <thead>
    <tr>
      <th scope="col">id_peminjaman</th>
      <th scope="col">tanggal_pinjam</th>
      <th scope="col">tanggal_kembali</th>
      <th scope="col">tanggal_pengembalian</th>
      <th scope="col">denda</th>
      <th scope="col">id_petugas</th>
      <th scope="col">id_anggota</th>
      <th scope="col">id_buku</th>
      <th scope="col">Operation</th>
    </tr>
  </thead>
  <tbody>

    <?php
    $sql = "SELECT * FROM peminjaman ORDER BY id_peminjaman";
    $result = pg_query($conn,$sql);
    if($result){
        while($row = pg_fetch_assoc($result)){
            $id_peminjaman = $row['id_peminjaman'];
            $tanggal_pinjam = $row['tanggal_pinjam'];
            $tanggal_kembali = $row['tanggal_kembali'];
            $tanggal_pengembalian = $row['tanggal_pengembalian'];
            $denda = $row['denda'];
            $id_petugas = $row['id_petugas'];
            $id_anggota = $row['id_anggota'];
            $id_buku = $row['id_buku'];

            echo'<tr>
            <th scope="row">'.$id_peminjaman.'</th>
            <td>'.$tanggal_pinjam.'</td>
            <td>'.$tanggal_kembali.'</td>
            <td>'.$tanggal_pengembalian.'</td>
            <td>'.$denda.'</td>
            <td>'.$id_petugas.'</td>
            <td>'.$id_anggota.'</td>
            <td>'.$id_buku.'</td>
            <td>
            <button class="btn btn-primary"><a href="peminjamanUpdate.php?peminjamanUpdateID='.$id_peminjaman.'" class="text-light">Update</a></button>
            <button class="btn btn-danger"><a href="peminjamanDelete.php?peminjamanDeleteID='.$id_peminjaman.'" class="text-light">Delete</a></button>
            </td>
          </tr>';
        }
    }

    ?>

  </tbody>
  <br>


</table>
</div>

<div class="container my-5">
        <form method="post">
            <div class="form-group">
                <label>id_kembali</label>
                <input type="number" class="form-control" placeholder="Enter id_peminjaman" name="id_kembali" autocomplete="off">
            </div>
    
            <button type="kembali" class="btn btn-primary" name="kembali">kembalikan?</button>    
        </form>
</div>

<br>
<br>
</body>

</html>