<?php
include 'connect.php';
if(isset($_GET['peminjamanDeleteID'])){
    $id=$_GET['peminjamanDeleteID'];

    $sql="DELETE FROM peminjaman WHERE id_peminjaman='$id'";
    $result=pg_query($conn,$sql);

    if($result){
        //echo "Deleted succesfully";
        header('location:peminjamanDisplay.php');
    } else {
        die(pg_last_error($conn));
    }
}


?>