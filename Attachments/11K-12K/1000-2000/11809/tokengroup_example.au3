;Token group Sample
;Just enter the name of the group (please prefer a Nested Group, to test if the script Works well)
#include"TokenGroup.au3"
$group=inputbox("Information","Please enter the Group")
$user=InputBox("Information","Please enter the Username",@UserName)
_ismembertoken($group,$user)