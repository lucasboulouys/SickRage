#import sickbeard
#import os.path
#import datetime
#import re
#from sickbeard import history
#from sickbeard import providers
#from sickbeard import sbdatetime
#from sickbeard.providers import generic
#from sickbeard.common import *
#set global $title="History"
#set global $header="History"
#set global $sbPath=".."
#set global $topmenu="history"#
#set $layout = $sickbeard.HISTORY_LAYOUT
#set $history_limit = $sickbeard.HISTORY_LIMIT

#include $os.path.join($sickbeard.PROG_DIR, "gui/slick/interfaces/default/inc_top.tmpl")

<style type="text/css">
.sort_data {display:none}
</style>

<script type="text/javascript">
<!--

\$.tablesorter.addParser({
    id: 'cDate',
    is: function(s) {
        return false;
    },
    format: function(s) {
        return s;
    },
    type: 'numeric'
});

\$(document).ready(function()
{
    \$("#historyTable:has(tbody tr)").tablesorter({
        widgets: ['zebra', 'filter'],
        sortList: [[0,1]],
      textExtraction: {
        #if ( $layout == 'detailed'):
            0: function(node) { return \$(node).find("span").text().toLowerCase(); },
            4: function(node) { return \$(node).find("span").text().toLowerCase(); }
        #else
            0: function(node) { return \$(node).find("span").text().toLowerCase(); },
            1: function(node) { return \$(node).find("span").text().toLowerCase(); },
            2: function(node) { return \$(node).attr("provider").toLowerCase(); },
            5: function(node) { return \$(node).attr("quality").toLowerCase(); }
        #end if
      },
        headers: {
        #if ( $layout == 'detailed'):
          0: { sorter: 'cDate' },
          4: { sorter: 'quality' }
        #else
          0: { sorter: 'cDate' },
          4: { sorter: false },
          5: { sorter: 'quality' }
        #end if
      }

    });
    \$('#limit').change(function(){
        url = '$sbRoot/history/?limit='+\$(this).val()
        window.location.href = url
    });

    #set $fuzzydate = 'airdate'
    #if $sickbeard.FUZZY_DATING:
    fuzzyMoment({
        containerClass : '.${fuzzydate}',
        dateHasTime : true,
        dateFormat : '${sickbeard.DATE_PRESET}',
        timeFormat : '${sickbeard.TIME_PRESET_W_SECONDS}',
        trimZero : #if $sickbeard.TRIM_ZERO then "true" else "false"#,
        dtGlue : ', ',
    });
    #end if

});
//-->
</script>
#if $varExists('header')
  <h1 class="header">$header</h1>
#else
  <h1 class="title">$title</h1>
#end if
<div class="h2footer pull-right"><b>Limit:</b>
    <select name="history_limit" id="history_limit" class="form-control form-control-inline input-sm" onchange="location = this.options[this.selectedIndex].value;">
        <option value="$sbRoot/setHistoryLimit/?history_limit=100" #if $history_limit == "100" then "selected=\"selected\"" else ""#>100</option>
        <option value="$sbRoot/setHistoryLimit/?history_limit=250" #if $history_limit == "250" then "selected=\"selected\"" else ""#>250</option>
        <option value="$sbRoot/setHistoryLimit/?history_limit=500" #if $history_limit == "500" then "selected=\"selected\"" else ""#>500</option>
        <option value="$sbRoot/setHistoryLimit/?history_limit=0" #if $history_limit == "0" then "selected=\"selected\"" else ""#>All</option>
    </select>


    <span> Layout:
        <select name="HistoryLayout" class="form-control form-control-inline input-sm" onchange="location = this.options[this.selectedIndex].value;">
            <option value="$sbRoot/setHistoryLayout/?layout=compact" #if $sickbeard.HISTORY_LAYOUT == "compact" then "selected=\"selected\"" else ""#>Compact</option>
            <option value="$sbRoot/setHistoryLayout/?layout=detailed" #if $sickbeard.HISTORY_LAYOUT == "detailed" then "selected=\"selected\"" else ""#>Detailed</option>
        </select>
    </span>
</div>
<br>

#if $layout == "detailed"
    <table id="historyTable" class="sickbeardTable tablesorter" cellspacing="1" border="0" cellpadding="0">
        <thead>
            <tr>
                <th class="nowrap">Time</th>
                <th>Episode</th>
                <th>Action</th>
                <th>Provider</th>
                <th>Quality</th>
            </tr>
        </thead>

        <tfoot>
            <tr>
                <th class="nowrap" colspan="5">&nbsp;</th>
            </tr>
        </tfoot>

        <tbody>
        #for $hItem in $historyResults:
            #set $curStatus, $curQuality = $Quality.splitCompositeStatus(int($hItem["action"]))
            <tr>
                #set $curdatetime = $datetime.datetime.strptime(str($hItem["date"]), $history.dateFormat)
                <td align="center"><div class="${fuzzydate}">$sbdatetime.sbdatetime.sbfdatetime($curdatetime, show_seconds=True)</div><span class="sort_data">$time.mktime($curdatetime.timetuple())</span></td>
                <td class="tvShow" width="35%"><a href="$sbRoot/home/displayShow?show=$hItem["showid"]#season-$hItem["season"]">$hItem["show_name"] - <%="S%02i" % int(hItem["season"])+"E%02i" % int(hItem["episode"]) %>#if "proper" in $hItem["resource"].lower() or "repack" in $hItem["resource"].lower() then ' <span class="quality Proper">Proper</span>' else ""#</a></td>
                <td align="center" #if $curStatus == SUBTITLED then 'class="subtitles_column"' else ''#>
                #if $curStatus == SUBTITLED:
                    <img width="16" height="11" style="vertical-align:middle;" src="$sbRoot/images/subtitles/flags/${hItem['resource']}.png" onError="this.onerror=null;this.src='$sbRoot/images/flags/unknown.png';">
                #end if
                    <span style="cursor: help; vertical-align:middle;" title="$os.path.basename($hItem['resource'])">$statusStrings[$curStatus]</span>
                </td>
                <td align="center">
                #if $curStatus == DOWNLOADED:
                    #if $hItem["provider"] != "-1":
                        <span style="vertical-align:middle;"><i>$hItem["provider"]</i></span>
                    #end if
                #else
                    #if $hItem["provider"] > 0
                        #if $curStatus in [SNATCHED, FAILED]:
                            #set $provider = $providers.getProviderClass($generic.GenericProvider.makeID($hItem["provider"]))
                            #if $provider != None:
                                <img src="$sbRoot/images/providers/<%=provider.imageName()%>" width="16" height="16" style="vertical-align:middle;" /> <span style="vertical-align:middle;">$provider.name</span>
                            #else:
                                <img src="$sbRoot/images/providers/missing.png" width="16" height="16" style="vertical-align:middle;" title="missing provider"/> <span style="vertical-align:middle;">Missing Provider</span>
                            #end if
                        #else:
                                <img src="$sbRoot/images/subtitles/${hItem['provider']}.png" width="16" height="16" style="vertical-align:middle;" /> <span style="vertical-align:middle;"><%=hItem["provider"].capitalize()%></span>
                        #end if
                    #end if
                #end if
                </td>
                <span style="display: none;">$curQuality</span>
                <td align="center"><span class="quality $Quality.qualityStrings[$curQuality].replace("720p","HD720p").replace("1080p","HD1080p").replace("HDTV", "HD720p")">$Quality.qualityStrings[$curQuality]</span></td>
            </tr>
        #end for
        </tbody>
    </table>

#else:

    <table id="historyTable" class="sickbeardTable tablesorter" cellspacing="1" border="0" cellpadding="0">
        <thead>
            <tr>
                <th class="nowrap">Time</th>
                <th>Episode</th>
                <th>Snatched</th>
                <th>Downloaded</th>
            #if sickbeard.USE_SUBTITLES
                <th>Subtitled</th>
            #end if
                <th>Quality</th>
            </tr>
        </thead>

        <tfoot>
            <tr>
                <th class="nowrap" colspan="6">&nbsp;</th>
            </tr>
        </tfoot>

        <tbody>
        #for $hItem in $compactResults:
            <tr>
                #set $curdatetime = $datetime.datetime.strptime(str($hItem["actions"][0]["time"]), $history.dateFormat)
                <td align="center"><div class="${fuzzydate}">$sbdatetime.sbdatetime.sbfdatetime($curdatetime, show_seconds=True)</div><span class="sort_data">$time.mktime($curdatetime.timetuple())</span></td>
                <td class="tvShow" width="25%">
                    <span><a href="$sbRoot/home/displayShow?show=$hItem["show_id"]#season-$hItem["season"]">$hItem["show_name"] - <%="S%02i" % int(hItem["season"])+"E%02i" % int(hItem["episode"]) %>#if "proper" in $hItem["resource"].lower() or "repack" in $hItem["resource"].lower() then ' <span class="quality Proper">Proper</span>' else ""#</a></span>
                </td>
                <td align="center" provider="<%=str(sorted(hItem["actions"])[0]["provider"])%>">
                    #for $action in sorted($hItem["actions"]):
                        #set $curStatus, $curQuality = $Quality.splitCompositeStatus(int($action["action"]))
                        #if $curStatus in [SNATCHED, FAILED]:
                            #set $provider = $providers.getProviderClass($generic.GenericProvider.makeID($action["provider"]))
                            #if $provider != None:
                                <img src="$sbRoot/images/providers/<%=provider.imageName()%>" width="16" height="16" style="vertical-align:middle;" alt="$provider.name" style="cursor: help;" title="$provider.name: $os.path.basename($action["resource"])"/>
                            #else:
                                <img src="$sbRoot/images/providers/missing.png" width="16" height="16" style="vertical-align:middle;" alt="missing provider" title="missing provider"/>
                            #end if
                        #end if
                    #end for
                </td>
                <td align="center">
                    #for $action in sorted($hItem["actions"]):
                        #set $curStatus, $curQuality = $Quality.splitCompositeStatus(int($action["action"]))
                        #if $curStatus == DOWNLOADED:
                            #if $action["provider"] != "-1":
                                <span style="cursor: help;" title="$os.path.basename($action["resource"])"><i>$action["provider"]</i></span>
                            #else:
                                <span style="cursor: help;" title="$os.path.basename($action["resource"])"></span>
                            #end if
                        #end if
                    #end for
                </td>
                #if sickbeard.USE_SUBTITLES:
                <td align="center">
                    #for $action in sorted($hItem["actions"]):
                        #set $curStatus, $curQuality = $Quality.splitCompositeStatus(int($action["action"]))
                        #if $curStatus == SUBTITLED:
                            <img src="$sbRoot/images/subtitles/${action['provider']}.png" width="16" height="16" style="vertical-align:middle;" alt="$action["provider"]" title="<%=action["provider"].capitalize()%>: $os.path.basename($action["resource"])"/>
                            <span style="vertical-align:middle;"> / </span>
                            <img width="16" height="11" style="vertical-align:middle;" src="$sbRoot/images/flags/${action['resource']}.png" onError="this.onerror=null;this.src='$sbRoot/images/flags/unknown.png';" style="vertical-align: middle !important;">
                            &nbsp;
                        #end if
                    #end for
                </td>
                #end if
                <td align="center" width="14%" quality="$curQuality"><span class="quality $Quality.qualityStrings[$curQuality].replace("720p","HD720p").replace("1080p","HD1080p").replace("RawHD TV", "RawHD").replace("HD TV", "HD720p")">$Quality.qualityStrings[$curQuality]</span></td>
            </tr>
        #end for
        </tbody>
    </table>

#end if

#include $os.path.join($sickbeard.PROG_DIR,"gui/slick/interfaces/default/inc_bottom.tmpl")
