<?php
$title=($cfg && is_object($cfg))?$cfg->getTitle():'SAFLOK :: IT Support Portal';

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title><?=Format::htmlchars($title)?></title>

    <link rel="stylesheet" href="<?php echo $sub_dir ? '..' :'.'; ?>/styles/main.css" media="screen">
    <link rel="stylesheet" href="<?php echo $sub_dir ? '..' :'.'; ?>/styles/colors.css" media="screen">
</head>
<body>
<div id="container">
    <div id="header">
        <a id="logo" href="<?php echo $sub_dir ? '../' :''; ?>index.php" title="Support Center">
        <img src="<?php echo $sub_dir ? '..' :'.'; ?>/images/ostlogo.gif" border=0 alt="Support Center">
		</a>
		<div id="statusIndicators">
			<i>MAX</i> - <b><font color="green">OK</font></b><br>
			<i>Clientele</i> - <b><font color="green">OK</font></b><br>
			<i>Great Plains</i> - <b><font color="green">OK</font></b><br>
			<i>Email</i> - <b><font color="green">OK</font></b><br>
			<i>Internet</i> - <b><font color="green">OK</font></b>
		</div>
    </div>
    <ul id="nav">
         <?                    
         if(is_object($thisclient) && $thisclient->isValid()) {?>
         <li><a class="log_out" href="<?php echo $sub_dir ? '../' :''; ?>logout.php">Log Out</a></li>
         <li><a class="my_tickets" href="<?php echo $sub_dir ? '../' :''; ?>view.php">My Tickets</a></li>
         <?}else {?>
         <li><a class="ticket_status" href="<?php echo $sub_dir ? '../' :''; ?>view.php">Ticket Status</a></li>
         <?}?>
         <li><a class="new_ticket" href="<?php echo $sub_dir ? '../' :''; ?>open.php">New Ticket</a></li>
		 <li><a class="tutorials" href="<?php echo $sub_dir ? '../' :''; ?>tutorials.php">Tutorials</a></li>
         <li><a class="home" href="<?php echo $sub_dir ? '../' :''; ?>index.php">Home</a></li>
    </ul>
    <div id="content">
