#import sickbeard
#import datetime
#from sickbeard.common import *
#set global $title="Manage Searches"
#set global $header="Manage Searches"
#set global $sbPath=".."

#set global $topmenu="manage"#
#import os.path
#include $os.path.join($sickbeard.PROG_DIR, "gui/slick/interfaces/default/inc_top.tmpl")

<script type="text/javascript" src="$sbRoot/js/plotTooltip.js?$sbPID"></script>
<div id="content800">
   #if $varExists('header')
       <h1 class="header">$header</h1>
   #else
       <h1 class="title">$title</h1>
   #end if

<div id="summary2" class="align-left">
<h3>Backlog Search:</h3>
<a class="btn" href="$sbRoot/manage/manageSearches/forceBacklog"><i class="icon-exclamation-sign"></i> Force</a>
<a class="btn" href="$sbRoot/manage/manageSearches/pauseBacklog?paused=#if $backlogPaused then "0" else "1"#"><i class="#if $backlogPaused then "icon-play" else "icon-pause"#"></i> #if $backlogPaused then "Unpause" else "Pause"#</a>
#if not $backlogRunning:
Not in progress<br />
#else:
#if $backlogPaused then "Paused: " else ""#
Currently running<br />
#end if
<br />

<h3>Daily Search:</h3>
<a class="btn" href="$sbRoot/manage/manageSearches/forceSearch"><i class="icon-exclamation-sign"></i> Force</a>
#if not $dailySearchStatus:
Not in progress<br />
#else:
In Progress<br />
#end if
<br />

<h3>Find Propers Search:</h3>
<a class="#if not $sickbeard.DOWNLOAD_PROPERS then 'btn disabled' else 'btn' #" href="$sbRoot/manage/manageSearches/forceFindPropers"><i class="icon-exclamation-sign"></i> Force</a>
#if not $findPropersStatus:
Not in progress<br />
#else:
In Progress<br />
#end if
<br />

<h3>Search Queue:</h3>
Backlog: <i>$queueLength['backlog'] pending items</i></br>
Daily: <i>$queueLength['daily'] pending items</i></br>
Manual: <i>$queueLength['manual'] pending items</i></br>
Failed: <i>$queueLength['failed'] pending items</i></br>
</div>
</div>
#include $os.path.join($sickbeard.PROG_DIR, "gui/slick/interfaces/default/inc_bottom.tmpl")
