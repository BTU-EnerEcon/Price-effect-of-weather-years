t52728


*#####################  DIRECTORIRY and FILE MANAGEMENT  #####################

*Location of input files
$setglobal datadir                data\
$setglobal DataIn_pp              Input_pp
$setglobal DataIn_CHP             Input_CHP
*$setglobal DataIn_TimeSeries      Input_TimeSeries_2000-2009
$setglobal DataIn_TimeSeries      Input_TimeSeries
$setglobal DataIn_NTC             Input_NTC
$setglobal DataIn_time            Input_time_set


*Location of output files
$setglobal output_dir   output\
$setglobal result     Results_year2016

set
    year   all years  /y2015*y2017/
    year_focus(year)  the year which is on the current focus    /y2016/

    daily_window  all days of the model horizon /day1*day378/

    t      all hours                       /t52561*t61488/
;

*#############################   DATA LOAD     ###############################

*$include time_set_2000-2009.gms
$include time_set_2010-2019.gms

$include declare_parameters.gms

*#############################   REPORTING INPUT ###############################

*execute_unload '%datadir%Input_final.gdx'
*$stop

*#############################   MODEL     #####################################

$include MODEL.gms

*#############################   SOLVING     ###################################

$include loop.gms

*#############################   results     #################################

$include aftermath.gms













