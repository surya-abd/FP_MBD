<?php
    include 'connect.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="styles2.css">
    <title>Display infomasi buku</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
</head>

<body>
    
<div class="container">
    <button class="btn btn-primary my-5"><a href="home.php" class="text-light">HOME</a></button>

    <table class="table">
  <thead>
    <tr>
      <th scope="col">id_buku</th>
      <th scope="col">judul_buku</th>
      <th scope="col">nama_penulis</th>
      <th scope="col">tahun_penerbit</th>
      <th scope="col">stok</th>
      <th scope="col">nama_penerbit</th>
      <th scope="col">nama_rak</th>
      <th scope="col">lokasi_rak</th>
    </tr>
  </thead>
  <tbody>

    <?php
    $sql = "CREATE OR REPLACE VIEW informasi_buku AS
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
            ORDER BY C.id_buku;";
    $result = pg_query($conn,$sql);

    $sql = "SELECT * FROM informasi_buku";
    $result = pg_query($conn,$sql);
    if($result){
        while($row = pg_fetch_assoc($result)){
            $id_buku = $row['id_buku'];
            $judul_buku = $row['judul_buku'];
            $nama_penulis = $row['nama_penulis'];
            $tahun_penerbit = $row['tahun_penerbit'];
            $stok = $row['stok'];
            $nama_penerbit = $row['nama_penerbit'];
            $nama_rak = $row['nama_rak'];
            $lokasi_rak = $row['lokasi_rak'];

            echo'<tr>
            <th scope="row">'.$id_buku.'</th>
            <td>'.$judul_buku.'</td>
            <td>'.$nama_penulis.'</td>
            <td>'.$tahun_penerbit.'</td>
            <td>'.$stok.'</td>
            <td>'.$nama_penerbit.'</td>
            <td>'.$nama_rak.'</td>
            <td>'.$lokasi_rak.'</td>
            </tr>';
        }
    }

    ?>
  </tbody>
</table>
</div>
</body>

</html>