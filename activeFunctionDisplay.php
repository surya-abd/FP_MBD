<?php
include 'connect.php';

if(isset($_POST['submit'])){
    $id_anggota=$_POST['id_anggota'];
    header("location:activeFunction.php?activeFunctionId=$id_anggota");
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
  
    <title>FUNCTION</title>
  </head>

  <body>
    <div class="container my-5">
        <form method="post">
            <div class="form-group">
                <label>id_anggota</label>
                <input type="number" class="form-control" placeholder="Enter id_anggota" name="id_anggota" autocomplete="off">
            </div>
    
            <button type="submit" class="btn btn-primary" name="submit" >submit</button>
            <button type="cancel" class="btn btn-primary" name="cancel">cancel</button>    
        </form>
    </div>
    
</body>
</html>