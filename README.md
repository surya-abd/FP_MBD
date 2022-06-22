# FINAL PROJECT MBD
#### Oleh:
- Ahmad Ferdiansyah Ramadhani / 5025201218
- Arya Nur Razzaq / 5025201102
- Azzura Mahendra Putra Malinus / 5025201211
- Muhammad Rafif Fadhil Naufal / 5205201273
- Nuzul Albatony / 5025201107
- Surya Abdillah / 5025201229

## CATATAN
Tambahkan `file connect.php`, lalu masukkan kode sumber berikut dan lakukan penyesuaian dengan device anda

```sh
<?php
$conn = pg_connect("host=localhost port=<port postgresql> dbname=<nama database> user=<nama user postgres> password=<password postgres>");

if(!$conn)
{
    echo "ERROR";
    exit;
}

?>
```
