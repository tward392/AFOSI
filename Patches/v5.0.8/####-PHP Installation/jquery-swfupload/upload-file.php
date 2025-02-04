<?php
$uploaddir = 'E:/Oracle/Product/11.1.0/Oracle_WT1/instances/apex1/config/OHS/ohs1/images/jquery/jquery-swfupload/uploads/'; 
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