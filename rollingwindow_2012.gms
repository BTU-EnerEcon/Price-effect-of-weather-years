$ontext
Dispatch model project ProKoMo

Chair of Energy Economics BTU

target:
    price forecast for 24 hours of the day ahead

method:
    - rolling horizon including a time intervall before and after the forecasted day
    - for a share of storages a fixed (water)price is implemented
    - data is uploaded by annual data sets
    - years, months, days and hours are mapped
    - UTC time is applied for all data
    
Note:
    - create an output folder named 'output'
    - the data should be placed in a folder named 'data'
$offtext


*#############################  DEFAULT OPTIONS  #############################
$eolcom #

$setglobal Startup ""     # if "*" the startup functions excluded, if "" startup functions included
$setglobal Flow   ""      # if "*" the trade excluded, if "" trade included
$setglobal CHP   ""       # if "*" the trade excluded, if "" trade included


$ifthen "%Startup%" == ""   $setglobal exc_Startup "*"
$else                       $setglobal exc_Startup ""
$endif


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
$setglobal result     Results_year2012

set
    year   all years  /y2011*y2013/
    year_focus(year)  the year which is on the current focus    /y2012/

    daily_window  all days of the model horizon /day1*day374/

    t      all hours                       /t17521*t26448/
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













