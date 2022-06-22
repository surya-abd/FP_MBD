<?php
    include 'connect.php';

    if(isset($_GET['peminjamanSelect'])){
        $id=$_GET['peminjamanSelect'];
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Display peminjaman</title>
    <link rel="stylesheet" href="styles2.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
</head>

<body>
    
<div class="container">
    <button class="btn btn-primary my-5"><a href="peminjamanDisplay.php" class="text-light">Kembali ke Display</a></button>
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
    $sql = "SELECT * FROM peminjaman WHERE id_peminjaman='$id' ORDER BY id_peminjaman";
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
</table>
</div>
</body>

</html>