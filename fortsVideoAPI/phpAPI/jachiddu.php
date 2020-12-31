<?php
  $host = 'localhost';
  $port = 3002;
  $buffer = 1024;
  set_time_limit(0);
  $socket = socket_create(AF_INET, SOCK_STREAM, 0) or die("Could not create socket\n");
  socket_set_option($socket, SOL_SOCKET, SO_REUSEADDR, 1);
  $result = socket_bind($socket, $host, $port) or die("Could not bind to socket\n");
  $result = socket_listen($socket, 3) or die("Could not set up socket listener\n");
  $spawn = socket_accept($socket) or die("Could not accept incoming connection\n");
  $input = socket_read($spawn, $buffer) or die("Could not read input\n");
  $input = trim($input);
  socket_close($spawn);
  socket_close($socket);
  if($input == 'active') {
    header("Refresh:0; url=fortsVideo/jachiddu.mp4");
    exit();
  }
?>