<?php
  $host = '192.168.1.40';
  $port = 3000;
  $buffer = 1024;
  set_time_limit(0);
  $socket = socket_create(AF_INET, SOCK_STREAM, 0) or die("Could not create socket\n");
  socket_set_option($socket, SOL_SOCKET, SO_REUSEADDR, 1);
  $result = socket_bind($socket, $host, $port) or die("Could not bind to socket\n");
  $result = socket_listen($socket, 1) or die("Could not set up socket listener\n");
  $spawn = socket_accept($socket) or die("Could not accept incoming connection\n");
  $input = socket_read($spawn, $buffer) or die("Could not read input\n");
  $input = trim($input);
  socket_close($spawn);
  socket_close($socket);
  if($input == '!active'):
?>
<html>
  <style>
    #myVideo {
      position: fixed;
      right: 0;
      bottom: 0;
      min-width: 100%; 
      min-height: 100%;
    }
  </style>
  <body>
    <video autoplay muted loop id="myVideo">
      <source src="./video/cavalli.mp4" type="video/mp4">
    </video>
  </body>
</html>
<?php
  endif
?>