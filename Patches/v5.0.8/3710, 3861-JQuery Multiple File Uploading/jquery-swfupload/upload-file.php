<?php
$uploaddir = 'd:/app/orcladmin/product/11.2.0/dbhome_1/apex/images/jquery/jquery-swfupload/uploads/'; 
$file = $uploaddir.$_POST['actualfilename'];
$size=$_FILES['uploadfile']['size'];

if($size>15728640)
{
 echo "error file size > 15 MB";
 unlink($_FILES['uploadfile']['tmp_name']);
 exit;
}

if (move_uploaded_file($_FILES['uploadfile']['tmp_name'], $file)) 
  {
   $finfo = finfo_open(FILEINFO_MIME_TYPE);
   $type = finfo_file($finfo, $file);
   finfo_close($finfo);

   echo "$file"."~~~"."$type";
  } 
else
  {
   echo "error ".$_FILES['uploadfile']['error']." --- ".$_FILES['uploadfile']['tmp_name']." %%% ".$file."($size)";
  }
?>