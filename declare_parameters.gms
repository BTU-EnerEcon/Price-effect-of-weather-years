set

    i       set of technologies

*subsets for technologies
    nuclear(i)  nuclear clusters
    lignite(i)  lignite clusters
    coal(i)     hard coal clusters
    gas(i)      gas technologies
    oil(i)      oil technologies
    Biomass(i)  Biomass technology

    Hydro(i)    hydro power plants
    Thermal(i)  thermal power plants
    ResT(i)     RES technologies
    ReservoirCluster(i)
    StorageCluster(i)


    n   nodes

* further mapping
    map_YMDT(year,month,day,t)  mapping time steps t to years and months and days
    map_YMT(year,month,t)       mapping time steps t to years and months
    map_YDT(year,day,t)         mapping time steps t to years and days
    map_MDT(month,day,t)        mapping time steps t to years and months and days
    map_MDHT(month,day,hour,t)
    map_YT(year,t)              mapping time steps t to years
    map_MT(month,t)             mapping time steps t to months
    Day_T(day,t)                mapping time steps t to days
    hour_T(hour,t)              mapping time steps t to hours

    tfirst(t)  first hour of the model horizon
    tlast(t)   last hour of the model horizon

;

alias (n,nn), (t,tt)    ;

tfirst(t) = yes$(ord(t) eq 1);
tlast(t)  = yes$(ord(t) eq card(t));

*##############################   Parameters   ##############################

Parameters

*technology parameters
    cap_up(n,i,month)         installed capacity [MW]
    cap(i,n,t)
    cap_lig(n,t)                capacity of all lignite clusters
    cap_coal(n,t)               capacity of all hard coal clusters
    cap_gas(n,t)                capacity of all gas clusters
    cap_oil(n,t)                capacity of all oil clusters

    RES_cap_2019(month,day,n,i) daily capacity for RES [MW] in 2019

    g_min(i)                    minimum capacity
    eta_fl(i,n)                 power plant efficiency at full load
    eta_ml(i,n)                 power plant efficiency at minimum load
    carbon_content(i)           CO2 emission per MWh_th [ton_CO2 per MWh_th]
    outages_up_2019
    outages_up                  outage_upload
    outages(i,n,t)              outages of power plant technologies
    af_tech_general(i,n)        constant availability of power plants
*    af_tech_t(i,n,t)            hourly availability based on af_tech_general
*    af_month(month,i,n)         availability factor depending only on the month
*    af_month_t(i,n,t)           hourly availability factor depending only on the month and  based on af_month
    af_overall(i,n,t)           final overal availability factor


*cost parameters
    fc(i,n,year,month,day)         fuel costs [EUR per MWh_th]
    vOM_cost(i)                    variable O&M costs [EUR per MWh_el]
    co2_price(year,month,day)      CO2 price [EUR per ton_CO2]
    vc_fl(i,n,t)       variable costs at full load [EUR per MWh]
    vc_ml(i,n,t)       variable costs at min load [EUR per MWh]

*start-up parameters
    sc(i,n,t)          start-up costs [EUR per MW], are computed with in the model
    costs_depr(i)               depreciation costs for a start-up [EUR per MW]
    fuel_start(i)               fuel requirement for a cold start [MWhth per MW]
    start_factor(i)             defines if a technology is carrying out cold, warm or hot starts (scales the fuel requirementof a cold start)
$ontext     nuclear plants are assumed to carry out only hot starts, requiring only 30% of the cold-start fuel requirement
            Lignite and hard coal plants are assumed to carry out warm starts with 50% of the cold-start fuel requirement
            natural gas and oil technologies are assumed to carry out cold starts, incurring 100% of the start-up fuel requirements
$offtext
    nd_fuel_factor(i)       states to what percentage a second fuel is used for a start-up, second fuel always oil

*demand parameters
    demand_up_2019      demand upload of year 2019
    demand(t,n)         electricity demand [MWh per hour]

*RES parameters
    res_gen(t,n,i)      electricity production by RES technologies [MWh per MW]
    res_pf(t,n,i)    RES production factor MWh per MW

*Hydro parameters

    cap_PSP_cluster_cluster_up(n,i,month)         PSP cluster upload
    cap_Reservoir_cluster_up(n,i,month)   Reservoir cluster upload
    cap_PSP_cluster(n,i,t)            hourly PSP cap
    cap_Reservoir_cluster(n,i,t)      hourly Reservoirs cap

    water_value_PSP_gen_up(n,i,month)   value for water regarding PSP while generating electricity upload [EUR per MWh]
    water_value_PSP_pump_up(n,i,month)  value for water regarding PSP while charging electricity [EUR per MWh]
    water_value_Reservoir_up(n,i,month) value for water regarding Reservoirs while generating electricity upload [EUR per MWh]
    water_value_PSP_gen(n,i,t)          hourly water value PSP
    water_value_PSP_pump(n,i,t)         value for water regarding PSP while charging electricity [EUR per MWh]
    water_value_Reservoir(n,i,t)        hourly water value Reservoirs

    availability_hydro(month,i,n)       turbine availability factor for hydro plants (seasonality etc)
    af_hydro(i,n,t)                     turbine availability factor for hydro plants (seasonality etc)
    budget(year,n)                      annual water budget factor for Reservoirs
    max_Gen_Res(i,n)                    maximum cummulated generation by Reservoirs in each country

*CHP parameters
    CHP_gen_lig(n,t)
    CHP_gen_coal(n,t)
    CHP_gen_gas(n,t)
    CHP_gen_oil(n,t)

    CHP_gen_lig_cluster(i,n,t)          CHP production is evenly allocated to the fuel specific clusters
    CHP_gen_coal_cluster(i,n,t)         CHP production is evenly allocated to the fuel specific clusters
    CHP_gen_gas_cluster(i,n,t)          CHP production is evenly allocated to the fuel specific clusters
    CHP_gen_oil_cluster(i,n,t)          CHP production is evenly allocated to the fuel specific clusters


    CHP_net_production_up               annual net electricty production by CHP plants [GWh]
    hourly_CHP_up                       upload of hourly CHP factors for warm water, space and process heat
    country_CHP_up                      country specific CHP factors as sector shares and scaling factor
    daily_temp_factor_CHP(year,month,day,n)        daily share of heat_degree days
    CHP_total_factor_hourly_2019
    CHP_total_factor_hourly(t,n)        country specific hourly CHP factor for the total CHP production

*NTC/Trade parameters
    ntc_monthly(month,n,nn)             maonthly average NTC [MW]
    ntc(t,n,nn)                         transfer capacity between node n and node nn [MW]


* upload tables
    priceup         upload table for prices (fuels and CO2)
    genup           upload table for generation
    techup          upload table for technologies


    running_cap_fx(i,n,t)  fixed running capacity for loop start

;

Scalars
    scaling_objective   scaling the objective function by 1 bn EUR /1000000/
    store_cpf           capacity power factor for Storages  /9/
    voll                value of lost load                  /3000/
    cost_curt           penalty cost for curtaiment         /20/
    number_hours        number of running hours

    share_PSP_daily     share of PSP cap that runs a daily cycle /0.4/

    x_down              first hour of the horizon
    x_up
    x_focus             first hour of the forcasted day
    x_focus_up
;

    number_hours = card(year)*8760  ;


*#############################   Data Upload   ##############################


*-------- Input_pp -----------
$onecho > Import_pp.txt
    set=i           rng=Technology!B3       rdim=1
    set=n           rng=nodes!B3            rdim=1

    par=af_tech_general               rng=nodes!E2        rdim=1 cdim=1
    par=cap_PSP_cluster_cluster_up    rng=Hydro!A3:N40    rdim=2 cdim=1
    par=cap_Reservoir_cluster_up      rng=Hydro!A118:N155 rdim=2 cdim=1
    par=RES_cap_2019                  rng=RES_cap!B1      rdim=2 cdim=2
    par=water_value_PSP_gen_up        rng=Hydro!A45:N80   rdim=2 cdim=1
    par=water_value_PSP_pump_up       rng=Hydro!A82:N116  rdim=2 cdim=1
    par=water_value_Reservoir_up      rng=Hydro!A157:N195 rdim=2 cdim=1

    par=availability_hydro  rng=nodes!D43:AC100     rdim=2 cdim=1

    par=outages_up_2019     rng=Outages!B1          rdim=3 cdim=2
    par=cap_up         rng=capacity!A3         rdim=2 cdim=1

    par=priceup        rng=prices!C2           rdim=2 cdim=1
    par=techup         rng=Technology!B2:O55   rdim=1 cdim=1


$offecho

$onUNDF
$call GDXXRW I=%datadir%%DataIn_pp%.xlsx O=%datadir%%DataIn_pp%.gdx cmerge=1 @Import_pp.txt
$gdxin %datadir%%DataIn_pp%.gdx
$LOAD i, n
$LOAD priceup, techup
$Load RES_cap_2019
$LOAD af_tech_general, cap_up
$LOAD outages_up_2019
$LOAD cap_Reservoir_cluster_up,cap_PSP_cluster_cluster_up,water_value_PSP_gen_up,water_value_Reservoir_up
$LOAD availability_hydro , water_value_PSP_pump_up

$gdxin
$offUNDF


*-------- Input_CHP -----------
$onecho > Import_CHP.txt
    par=CHP_net_production_up           rng=el_production_CHP!C2      rdim=1 cdim=1
    par=CHP_total_factor_hourly_2019    rng=hourly_factors_2019!A1     rdim=3 cdim=1
$offecho

$onUNDF
$call GDXXRW I=%datadir%%DataIn_CHP%.xlsx O=%datadir%%DataIn_CHP%.gdx cmerge=1 @Import_CHP.txt
$gdxin %datadir%%DataIn_CHP%.gdx

$LOAD CHP_net_production_up
$LOAD CHP_total_factor_hourly_2019
$gdxin
$offUNDF


*-------- Input_TimeSeries -----------
$onecho > Import_TimeSeries.txt
    par=demand_up_2019     rng=Demand!B1        rdim=3 cdim=1
    par=res_pf             rng=RES!B1           rdim=1 cdim=2
$offecho

$onUNDF
$call GDXXRW I=%datadir%%DataIn_TimeSeries%.xlsx O=%datadir%%DataIn_TimeSeries%.gdx cmerge=1 @Import_TimeSeries.txt
$gdxin %datadir%%DataIn_TimeSeries%.gdx
$LOAD demand_up_2019
$LOAD res_pf

$gdxin
$offUNDF

*-------- Input_NTC -----------
$onecho > Import_NTC.txt
    par=ntc_monthly                 rng=monthlyNTC!B1          rdim=1  cdim=2
$offecho

$onUNDF
$call GDXXRW I=%datadir%%DataIn_NTC%.xlsx O=%datadir%%DataIn_NTC%.gdx cmerge=1 @Import_NTC.txt
$gdxin %datadir%%DataIn_NTC%.gdx

$LOAD ntc_monthly

$gdxin
$offUNDF


*#############################   Parameter Processing   ##############################

* -------------------    MAPPING TIME   --------------------
    Loop(map_YMDHT(year,month,day,hour,t),

        Day_T(day,t)        = yes;
        map_YMT(year,month,t) = yes ;
        map_YMDT(year,month,day,t) = yes;
        map_YDT(year,day,t) = yes ;
        map_MDT(month,day,t)= yes ;
        map_MDHT(month,day,hour,t)= yes ;
        map_YT(year,t)      = yes ;
        map_MT(month,t)     = yes ;
        );

* --------------- Subset Definitions    --------------------
    Thermal(i) = NO;
    Hydro(i)   = NO;
    ResT(i)    = NO;
    Nuclear(i)  = NO;
    Lignite(i)  = NO;
    Coal(i)     = NO;
    Gas(i)      = NO;
    Oil(i)      = NO;
    Biomass(i)  = NO;
    ReservoirCluster(i)= NO;
    StorageCluster(i) = NO;

    Thermal(i)  = techup(i,'Tech_class_2')= 1 ;
    ResT(i)     = techup(i,'Tech_class_2')= 2 ;
    Hydro(i)    = techup(i,'Tech_class_2')= 3 ;
    Nuclear(i)  = techup(i,'Tech_class_1')= 1 ;
    Lignite(i)  = techup(i,'Tech_class_1')= 2 ;
    Coal(i)     = techup(i,'Tech_class_1')= 3 ;
    Gas(i)      = techup(i,'Tech_class_1')= 4 ;
    Oil(i)      = techup(i,'Tech_class_1')= 5 ;
    Biomass(i)  = techup(i,'Tech_class_1')= 6 ;
    ReservoirCluster(i) = techup(i,'Tech_class_1')= 7 ;
    StorageCluster(i)   = techup(i,'Tech_class_1')= 8 ;


* ------------   Loading Parameters     ---------------------
    co2_price(year,month,day)    = priceup(month,day,'CO2')   ;
    fc(Nuclear,n,year,month,day) = priceup(month,day,'Nuclear')            ;
    fc(Lignite,n,year,month,day) = priceup(month,day,'Lignite')            ;
    fc(Coal,n,year,month,day)    = priceup(month,day,'Coal')           ;
    fc(Gas,n,year,month,day)     = priceup(month,day,'Gas')            ;
    fc(Oil,n,year,month,day)     = priceup(month,day,'Oil')            ;
    fc(Biomass,n,year,month,day) = priceup(month,day,'Biomass')            ;

    vOM_cost(i) = techup(i,'variable OM costs') ;

    eta_fl(i,n) = techup(i,'efficiency full load') ;
    eta_ml(i,n) = techup(i,'efficiency min load') ;
    carbon_content(i) = techup(i,'carbon content') ;

    g_min(i) = techup(i,'minimum generation')  ;

    costs_depr(i)   = techup(i,'depreciation costs')    ;
    fuel_start(i)   = techup(i,'fuel startup')    ;
    nd_fuel_factor(i) = techup(i,'share second startup fuel')    ;
    start_factor(i) = techup(i,'startup_factor')    ;

    demand(t,n) = sum( (month,day,hour)$map_MDHT(month,day,hour,t),demand_up_2019(month,day,hour,n) )        ;

    res_gen(t,n,i) = res_pf(t,n,i) * sum( (month,day)$map_MDT(month,day,t), RES_cap_2019(month,day,n,i) )   ;

    CHP_total_factor_hourly(t,n) = sum( (month,day,hour)$map_MDHT(month,day,hour,t), CHP_total_factor_hourly_2019(month,day,hour,n) )  ;

    ntc(t,n,nn) = sum( (month)$map_MT(month,t), ntc_monthly(month,n,nn))        ;

    cap(i,n,t)    =  sum( (month)$map_MT(month,t), cap_up(n,i,month))  ;

    cap_lig(n,t)  = sum(lignite, cap(lignite,n,t))   ;
    cap_coal(n,t) = sum(coal, cap(coal,n,t))   ;
    cap_gas(n,t)  = sum(gas, cap(gas,n,t))   ;
    cap_oil(n,t)  = sum(oil, cap(oil,n,t))   ;

    cap_PSP_cluster(n,i,t)        = sum( (month)$map_MT(month,t), cap_PSP_cluster_cluster_up(n,i,month) );
    cap_Reservoir_cluster(n,i,t)  = sum( (month)$map_MT(month,t), cap_Reservoir_cluster_up(n,i,month) );

    water_value_PSP_pump(n,i,t)   = sum( (month)$map_MT(month,t),  water_value_PSP_pump_up(n,i,month) );
    water_value_PSP_gen(n,i,t)    = sum( (month)$map_MT(month,t),  water_value_PSP_gen_up(n,i,month) )      ;
    water_value_Reservoir(n,i,t)  = sum( (month)$map_MT(month,t),  water_value_Reservoir_up(n,i,month) );

    af_hydro(i,n,t) = sum( (month)$map_MT(month,t), availability_hydro(month,i,n))  ;
    af_overall(i,n,t) =  af_tech_general(i,n)

;

         outages_up(t,n,'Lig')  =   sum((month,day,hour)$map_MDHT(month,day,hour,t), outages_up_2019(month,day,hour,n,'Lig' )  )               ;
         outages_up(t,n,'HC')    =  sum((month,day,hour)$map_MDHT(month,day,hour,t), outages_up_2019(month,day,hour,n,'HC' )   )               ;
         outages_up(t,n,'natural gas') =  sum((month,day,hour)$map_MDHT(month,day,hour,t), outages_up_2019(month,day,hour,n,'natural gas' ) )  ;
         outages_up(t,n,'nuc')         =  sum((month,day,hour)$map_MDHT(month,day,hour,t), outages_up_2019(month,day,hour,n,'nuc' ) )          ;

    outages('lignite_1',n,t)$cap('lignite_1',n,t) = outages_up(t,n,'Lig')*cap('lignite_1',n,t)/sum(lignite,cap(lignite,n,t))     ;
    outages('lignite_2',n,t)$cap('lignite_2',n,t) = outages_up(t,n,'Lig')*cap('lignite_2',n,t)/sum(lignite,cap(lignite,n,t))     ;
    outages('lignite_3',n,t)$cap('lignite_3',n,t) = outages_up(t,n,'Lig')*cap('lignite_3',n,t)/sum(lignite,cap(lignite,n,t))     ;
    outages('lignite_4',n,t)$cap('lignite_4',n,t) = outages_up(t,n,'Lig')*cap('lignite_4',n,t)/sum(lignite,cap(lignite,n,t))     ;

    outages('coal_1',n,t)$cap('coal_1',n,t) = outages_up(t,n,'HC')*cap('coal_1',n,t)/sum(coal,cap(coal,n,t))     ;
    outages('coal_2',n,t)$cap('coal_2',n,t) = outages_up(t,n,'HC')*cap('coal_2',n,t)/sum(coal,cap(coal,n,t))     ;
    outages('coal_3',n,t)$cap('coal_3',n,t) = outages_up(t,n,'HC')*cap('coal_3',n,t)/sum(coal,cap(coal,n,t))     ;
    outages('coal_4',n,t)$cap('coal_4',n,t) = outages_up(t,n,'HC')*cap('coal_4',n,t)/sum(coal,cap(coal,n,t))     ;

    outages('CCGT_1',n,t)$cap('CCGT_1',n,t) = outages_up(t,n,'natural gas')*cap('CCGT_1',n,t)/sum(gas,cap(gas,n,t))     ;
    outages('CCGT_2',n,t)$cap('CCGT_2',n,t) = outages_up(t,n,'natural gas')*cap('CCGT_2',n,t)/sum(gas,cap(gas,n,t))     ;
    outages('CCGT_3',n,t)$cap('CCGT_3',n,t) = outages_up(t,n,'natural gas')*cap('CCGT_3',n,t)/sum(gas,cap(gas,n,t))     ;
    outages('CCGT_4',n,t)$cap('CCGT_4',n,t) = outages_up(t,n,'natural gas')*cap('CCGT_4',n,t)/sum(gas,cap(gas,n,t))     ;

    outages('OCGT_1',n,t)$cap('OCGT_1',n,t) = outages_up(t,n,'natural gas')*cap('OCGT_1',n,t)/sum(gas,cap(gas,n,t))     ;
    outages('OCGT_2',n,t)$cap('OCGT_2',n,t) = outages_up(t,n,'natural gas')*cap('OCGT_2',n,t)/sum(gas,cap(gas,n,t))     ;
    outages('OCGT_3',n,t)$cap('OCGT_3',n,t) = outages_up(t,n,'natural gas')*cap('OCGT_3',n,t)/sum(gas,cap(gas,n,t))     ;
    outages('OCGT_4',n,t)$cap('OCGT_4',n,t) = outages_up(t,n,'natural gas')*cap('OCGT_4',n,t)/sum(gas,cap(gas,n,t))     ;

    outages('gassteam_1',n,t)$cap('gassteam_1',n,t) = outages_up(t,n,'natural gas')*cap('gassteam_1',n,t)/sum(gas,cap(gas,n,t))     ;
    outages('gassteam_2',n,t)$cap('gassteam_2',n,t) = outages_up(t,n,'natural gas')*cap('gassteam_2',n,t)/sum(gas,cap(gas,n,t))     ;
    outages('gassteam_3',n,t)$cap('gassteam_3',n,t) = outages_up(t,n,'natural gas')*cap('gassteam_3',n,t)/sum(gas,cap(gas,n,t))     ;
    outages('gassteam_4',n,t)$cap('gassteam_4',n,t) = outages_up(t,n,'natural gas')*cap('gassteam_4',n,t)/sum(gas,cap(gas,n,t))     ;

    outages('nuclear_3',n,t) = outages_up(t,n,'nuc')  ;

    vc_fl(i,n,t)$eta_fl(i,n) = vOM_cost(i)+ sum( (year,month,day)$map_YMDT(year,month,day,t),(fc(i,n,year,month,day)+carbon_content(i)*co2_price(year,month,day)) / eta_fl(i,n))   ;
    vc_ml(i,n,t)$eta_ml(i,n) = vOM_cost(i)+ sum( (year,month,day)$map_YMDT(year,month,day,t),(fc(i,n,year,month,day)+carbon_content(i)*co2_price(year,month,day)) / eta_ml(i,n))   ;

    sc(i,n,t) = sum( (year,month,day)$map_YMDT(year,month,day,t), (costs_depr(i) + fuel_start(i)*start_factor(i) *
           (fc(i,n,year,month,day)+carbon_content(i)*co2_price(year,month,day)) *(1-nd_fuel_factor(i))
         + (fc('OCOT_1',n,year,month,day)+carbon_content('OCOT_1') * co2_price(year,month,day)) *nd_fuel_factor(i)) )
    ;


    CHP_gen_lig(n,t)        = sum((year)$map_YT(year,t), CHP_net_production_up('Lig',n))*1000 * CHP_total_factor_hourly(t,n)  ;
    CHP_gen_coal(n,t)       = sum((year)$map_YT(year,t), CHP_net_production_up('HC',n))*1000 * CHP_total_factor_hourly(t,n)     ;
    CHP_gen_gas(n,t)        = sum((year)$map_YT(year,t), CHP_net_production_up('natural gas',n))*1000 * CHP_total_factor_hourly(t,n)     ;
    CHP_gen_oil(n,t)        = sum((year)$map_YT(year,t), CHP_net_production_up('oil',n))*1000 * CHP_total_factor_hourly(t,n)         ;

    CHP_gen_lig_cluster(lignite,n,t)$cap_lig(n,t) =    CHP_gen_lig(n,t) * cap(lignite,n,t) /  cap_lig(n,t) ;
    CHP_gen_coal_cluster(coal,n,t)$cap_coal(n,t)  =   CHP_gen_coal(n,t) * cap(coal,n,t) /   cap_coal(n,t) ;
    CHP_gen_gas_cluster(gas,n,t)$cap_gas(n,t)    =   CHP_gen_gas(n,t) * cap(gas,n,t) / cap_gas(n,t) ;
    CHP_gen_oil_cluster(oil,n,t)$cap_oil(n,t)    =   CHP_gen_oil(n,t) * cap(oil,n,t) / cap_oil(n,t) ;







