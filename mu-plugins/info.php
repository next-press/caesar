<?php
/**
 * Plugin Name: PHP Info
 */
if (isset($_GET['info']) && $_GET['info']) {

  phpinfo();

  exit;

} // end if;
