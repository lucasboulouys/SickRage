#import sickbeard
#from sickbeard.common import *
#from sickbeard import subtitles

        #if $sickbeard.USE_SUBTITLES:
        <br><div class="field-pair">
            <label for="subtitles" class="clearfix">
                <span class="component-title">Subtitles</span>
                <span class="component-desc">
                     <input type="checkbox" name="subtitles" id="subtitles" #if $sickbeard.SUBTITLES_DEFAULT then "checked=\"checked\"" else ""# />
                    <p>Download subtitles for this show?</p>
                </span>
            </label>
        </div>
        #end if

        <div class="field-pair">
            <label for="statusSelect">
                <span class="component-title">Status for previously aired episodes</span>
                <span class="component-desc">
                    <select name="defaultStatus" id="statusSelect" class="form-control form-control-inline input-sm">
                    #for $curStatus in [$SKIPPED, $WANTED, $ARCHIVED, $IGNORED]:
                        <option value="$curStatus" #if $sickbeard.STATUS_DEFAULT == $curStatus then 'selected="selected"' else ''#>$statusStrings[$curStatus]</option>
                    #end for
                    </select>
                </span>
            </label>
        </div>
        <div class="field-pair">
            <label for="statusSelectAfter">
                <span class="component-title">Status for all future episodes</span>
                <span class="component-desc">
                    <select name="defaultStatusAfter" id="statusSelectAfter" class="form-control form-control-inline input-sm">
                    #for $curStatus in [$SKIPPED, $WANTED, $ARCHIVED, $IGNORED]:
                        <option value="$curStatus" #if $sickbeard.STATUS_DEFAULT_AFTER == $curStatus then 'selected="selected"' else ''#>$statusStrings[$curStatus]</option>
                    #end for
                    </select>
                </span>
            </label>
        </div>
        <div class="field-pair alt">
            <label for="flatten_folders" class="clearfix">
                <span class="component-title">Flatten Folders</span>
                <span class="component-desc">
                    <input class="cb" type="checkbox" name="flatten_folders" id="flatten_folders" #if $sickbeard.FLATTEN_FOLDERS_DEFAULT then "checked=\"checked\"" else ""# />
                    <p>Disregard sub-folders?</p>
                </span>
            </label>
        </div>

#if $enable_anime_options
        <div class="field-pair alt">
            <label for="anime" class="clearfix">
                <span class="component-title">Anime</span>
                <span class="component-desc">
                    <input type="checkbox" name="anime" id="anime" #if $sickbeard.ANIME_DEFAULT then "checked=\"checked\"" else ""# />
                    <p>Is this show an Anime?<p>
                </span>
            </label>
        </div>
#end if

        <div class="field-pair alt">

            <label for="scene" class="clearfix">
                <span class="component-title">Scene Numbering</span>
                <span class="component-desc">
                    <input type="checkbox" name="scene" id="scene" #if $sickbeard.SCENE_DEFAULT then "checked=\"checked\"" else ""# />
                    <p>Is this show scene numbered?</p>
                </span>
            </label>
        </div>

        #set $qualities = $Quality.splitQuality($sickbeard.QUALITY_DEFAULT)
        #set global $anyQualities = $qualities[0]
        #set global $bestQualities = $qualities[1]
        #include $os.path.join($sickbeard.PROG_DIR, "gui/slick/interfaces/default/inc_qualityChooser.tmpl")

        <br>
        <div class="field-pair alt">
            <label for="saveDefaultsButton" class="nocheck clearfix">
                <span class="component-title"><input class="btn btn-inline" type="button" id="saveDefaultsButton" value="Save Defaults" disabled="disabled" /></span>
                <span class="component-desc">
                    <p>Use current values as the defaults</p>
                </span>
            </label>
        </div><br>

#if $enable_anime_options
#import sickbeard.blackandwhitelist
#include $os.path.join($sickbeard.PROG_DIR, "gui/slick/interfaces/default/inc_blackwhitelist.tmpl")
#else
        <input type="hidden" name="anime" id="anime" value="0" />
#end if
