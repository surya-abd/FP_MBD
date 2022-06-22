<?php
include 'connect.php';

if(isset($_POST['submit'])){
    $id_petugas=$_POST['id_petugas'];
    $id_anggota=$_POST['id_anggota'];
    $id_buku=$_POST['id_buku'];

    $sql = "SELECT setval('sequence_id_peminjaman',(SELECT MAX(id_peminjaman) FROM peminjaman))";
    $result = pg_query($conn,$sql);

    $sql = "
        --auto tanggal pinjam dan kembali
        CREATE OR REPLACE FUNCTION insert_ID_peminjaman()
            RETURNS TRIGGER
            AS \$new_ID$
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
        \$new_ID$ LANGUAGE plpgsql;

        --TRIGGER
        CREATE OR REPLACE TRIGGER melakukan_peminjaman
        BEFORE INSERT ON peminjaman
        FOR EACH ROW 
        EXECUTE PROCEDURE insert_ID_peminjaman();";
    $result = pg_query($conn,$sql);

    $sql = "INSERT INTO peminjaman (id_petugas,id_anggota,id_buku) 
            VALUES ('$id_petugas','$id_anggota','$id_buku')";
    $result = pg_query($conn,$sql);

    if($result){
        header('location:peminjamanDisplay.php');
        //echo "data inserted succesfully";
    } else {
        //die(pg_error($con));
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

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="styles2.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
  
    <title>peminjaman</title>
  </head>

  <body>
    <div class="container my-5">
        <form method="post">
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
    
            <button type="submit" class="btn btn-primary" name="submit" >Submit</button>
            <button type="cancel" class="btn btn-primary" name="cancel">CANCEL</button>
        </form>
    </div>
    
</body>
</html>