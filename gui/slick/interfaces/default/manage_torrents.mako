#import sickbeard
#import datetime
#from sickbeard.common import *
#set global $title="Manage Torrents"
#set global $header="Manage Torrents"
#set global $sbPath=".."

#set global $topmenu="manage"#
#import os.path
#include $os.path.join($sickbeard.PROG_DIR, "gui/slick/interfaces/default/inc_top.tmpl")

<script type="text/javascript" src="$sbRoot/js/plotTooltip.js?$sbPID"></script>
   #if $varExists('header')
       <h1 class="header">$header</h1>
   #else
       <h1 class="title">$title</h1>
   #end if

$info_download_station
<iframe id="extFrame" src="$webui_url" width="100%" height="500" frameBorder="0" style="border: 1px black solid;"></iframe>

#include $os.path.join($sickbeard.PROG_DIR, "gui/slick/interfaces/default/inc_bottom.tmpl")
