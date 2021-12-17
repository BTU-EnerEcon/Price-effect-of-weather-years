set
    month  months of a year                /m1*m12/
    day    days of a year                  /d1*d366/
    hour   hours of a day                  /h0*h23/

    map_YMDHT(year,month,day,hour,t) mapping time steps to years monthes days hour
;


*#############################   Data Upload   ##############################

*-------- Input_time -----------
$onecho > Import_time.txt
    set=map_YMDHT                     rng=timemap_2000-2009!B2      rdim=5

$offecho

$onUNDF
$call GDXXRW I=%datadir%%DataIn_time%.xlsx O=%datadir%%DataIn_time%.gdx cmerge=1 @Import_time.txt
$gdxin %datadir%%DataIn_time%.gdx

$LOAD map_YMDHT

$gdxin
$offUNDF
