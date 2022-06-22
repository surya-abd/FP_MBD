<?php
include 'connect.php';
$id_peminjaman = $_GET['peminjamanUpdateID'];
$sql = "SELECT * FROM peminjaman WHERE id_peminjaman='$id_peminjaman'";
$result = pg_query($conn,$sql);

$row = pg_fetch_assoc($result);
$id_peminjaman = $row['id_peminjaman'];
$tanggal_pinjam = $row['tanggal_pinjam'];
$tanggal_kembali = $row['tanggal_kembali'];
$tanggal_pengembalian = $row['tanggal_pengembalian'];
$denda = $row['denda'];
$id_petugas = $row['id_petugas'];
$id_anggota = $row['id_anggota'];
$id_buku = $row['id_buku'];

if(isset($_POST['submit'])){
    if($_POST['tanggal_pengembalian'] != NULL)
        $taggal_pengembalian = $_POST['tanggal_pengembalian'];
    if($denda = $_POST['denda'] != NULL)
        $denda = $_POST['denda'];
    if($_POST['id_petugas'] != NULL)
        $id_petugas = $_POST['id_petugas'];
    if($_POST['id_anggota'] != NULL)
        $id_anggota = $_POST['id_anggota'];
    if($_POST['id_buku'] != NULL)
        $id_buku = $_POST['id_buku'];

    $sql = "UPDATE peminjaman SET tanggal_pengembalian='$tanggal_pengembalian', denda='$denda', id_petugas = '$id_petugas', id_anggota='$id_anggota', 
        id_buku='$id_buku' WHERE id_peminjaman='$id_peminjaman'";
    $result = pg_query($conn,$sql);

    if($result){
        header('location:peminjamanDisplay.php');
        //echo "UPDATE succesfully";
    } else {
        die(pg_last_error($conn));
    }
}

if(isset($_POST['cancel'])){
    header('location:peminjamanDisplay.php');
}
?>

<!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="styles2.css">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
  
    <title>UPDATE peminjaman</title>
  </head>

  <body>
    <div class="container my-5">
        <form method="post">
            <div class="form-group">
                <label>tanggal_pengembalian</label>
                <input type="datetime-local" class="form-control" placeholder="Enter your tanggal_pengembalian" name="tanggal_pengembalian" value=<?php echo $tanggal_pengembalian;?> autocomplete="off">
            </div>
            <div class="form-group">
                <label>denda</label>
                <input type="number" class="form-control" placeholder="Enter your denda" name="denda" value=<?php echo $denda;?> autocomplete="off">
            </div>
            <div class="form-group">
                <label>id_petugas</label>
                <input type="number" class="form-control" placeholder="Enter id_petugas" name="id_petugas" autocomplete="off">
            </div>
            <div class="form-group">
                <label>id_anggota</label>
                <input type="number" class="form-control" placeholder="Enter id_anggota" name="id_anggota" autocomplete="off">
            </div>
            <div class="form-group">
                <label>id_buku</label>
                <input type="number" class="form-control" placeholder="Enter id_buku" name="id_buku" autocomplete="off">
            </div>

            <button type="submit" class="btn btn-primary" name="submit" >Update</button>
            <button type="cancel" class="btn btn-primary" name="cancel">CANCEL</button>
        </form>
    </div>
</body>
</html>