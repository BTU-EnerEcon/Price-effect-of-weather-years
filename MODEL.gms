Variables
    COSTS           total generation costs (ojective variable)[bn €]
;

Positive Variables
    G(i,n,t)        generation of each technology cluster [MWh per h]
    P_on(i,n,t)     running (started) generation capacities [MW]
    SU(i,n,t)       start-up activity of a generation technology [MW]
    FLOW(n,nn,t)    electricity transfer from node n to nn [MWh per h]
    Pump(i,n,t)     long-term storage charging based on a water value
    Charge(i,n,t)   mid-term storage charging filling the storage level
    storagelevel(i,n,t)
    Shed(n,t)           load shedding
    Curtailment(i,n,t)  RES curtailment
    X_dem(n,t)      dummy variable for load increase at high costs

;

*##############################   Equations   ###############################

Equations
    ojective            objective function minimizes total system costs
    energy_balance      demand equals supply
    max_gen             generation is lower than running capacity
    min_gen
    max_cap             running capacity is lower than installed capacity

    startup_constraint  constraining start-up activities
    P_on_tfirst         running capicity in the first hour of the rolling horizon
    P_on_tlast          running capicity in the last hour of the rolling horizon

    max_RES             maximum RES generation

    CHP_constraint_lig      must production for CHP plants fired by lignite
    CHP_constraint_coal     must production for CHP plants fired by coals
    CHP_constraint_gas      must production for CHP plants fired by gas
    CHP_constraint_oil      must production for CHP plants fired by oil

    Res_lineflow_1      Flow is restricted by the time dependent NTC

    Store_max_cluster       maximum turbine capacity of mid-term storage [MW]
    Pump_max_cluster        maximum pumping capacity of long-term storage [MW]
    Reservoir_power_max     maximum turbine capacity of reservoirs [MW]

    Store_Level         storage level mechanism
    Store_Level_max     maximum Storage Level (MWh)
    Store_max           maximum turbine capacity (MW)
    Store_tfirst        storage level in the first time period
    Store_tlast         storage level in the last time period
;

ojective..      COSTS =E= ( sum((Thermal,n,t)$cap(thermal,n,t), G(Thermal,n,t) * vc_fl(Thermal,n,t))
%Startup%              + sum((Thermal,n,t)$cap(thermal,n,t), SU(Thermal,n,t) * sc(Thermal,n,t))
%Startup%              + sum((Thermal,n,t)$cap(thermal,n,t), (P_on(Thermal,n,t)-G(Thermal,n,t)) * (vc_ml(Thermal,n,t)-vc_fl(Thermal,n,t))*g_min(Thermal) / (1-g_min(Thermal)))
                       + sum((StorageCluster,n,t),G(StorageCluster,n,t)* water_value_PSP_gen(n,StorageCluster,t) )
                       + sum((StorageCluster,n,t),Pump(StorageCluster,n,t)*  water_value_PSP_pump(n,StorageCluster,t))
                       + sum((ReservoirCluster,n,t),G(ReservoirCluster,n,t)*water_value_Reservoir(n,ReservoirCluster,t))
                       + sum((n,t), Shed(n,t)*voll) + sum((n,t), X_dem(n,t))*3500
                       + sum((ResT,n,t),Curtailment(ResT,n,t) * cost_curt)
                       
                          ) /scaling_objective
;


energy_balance(n,t)$(ord(t)>=x_down and ord(t)<=x_up)..      demand(t,n)+cap('PSP',n,t)*af_hydro('PSP',n,t)*(1-share_PSP_daily) =E= sum(i, G(i,n,t))
                                            + sum(StorageCluster, Pump(StorageCluster,n,t))
                                            - Charge('PSP',n,t)
%Flow%                                      + sum(nn$ntc(t,nn,n), FLOW(nn,n,t)) - sum(nn$ntc(t,n,nn), FLOW(n,nn,t))
                                            + Shed(n,t)-X_dem(n,t)

;

max_gen(Thermal,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..       G(Thermal,n,t) =L=
%Startup%                                       P_on(Thermal,n,t)
%exc_Startup%                                   cap(Thermal,n,t) * af_overall(Thermal,n,t) - outages(Thermal,n,t)
;

min_gen(Thermal,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..       G(Thermal,n,t) =G= P_on(Thermal,n,t)*g_min(Thermal)
;

max_cap(Thermal,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..         P_on(Thermal,n,t) =L= cap(Thermal,n,t) * af_overall(Thermal,n,t) - outages(Thermal,n,t)
;

startup_constraint(Thermal,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..  P_on(Thermal,n,t)- P_on(Thermal,n,t-1) =L= SU(Thermal,n,t)
;

max_RES(ResT,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..         G(ResT,n,t) =E= sqrt(sqr(res_gen(t,n,ResT)))-Curtailment(ResT,n,t)
;

CHP_constraint_lig(lignite,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..    G(lignite,n,t) =G= CHP_gen_lig_cluster(lignite,n,t)
;
CHP_constraint_coal(coal,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..      G(coal,n,t) =G= CHP_gen_coal_cluster(coal,n,t)
;
CHP_constraint_gas(gas,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..        G(gas,n,t) =G= CHP_gen_gas_cluster(gas,n,t)
;
CHP_constraint_oil(oil,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..        G(oil,n,t) =G= CHP_gen_oil_cluster(oil,n,t)
;

Res_lineflow_1(n,nn,t)$(ord(t)>=x_down and ord(t)<=x_up)..      FLOW(n,nn,t)  =L=  ntc(t,n,nn)
;

*daily storages
Store_Level(n,t)$(ord(t)>=x_down and ord(t)<=x_up)..     storagelevel('PSP',n,t) =E= storagelevel('PSP',n,t-1)-G('PSP',n,t)+Charge('PSP',n,t)*eta_fl('PSP',n)
;

Store_Level_max(n,t)$(ord(t)>=x_down and ord(t)<=x_up)..      storagelevel('PSP',n,t) =L= cap('PSP',n,t) * share_PSP_daily * store_cpf
;

Store_max(n,t)$(ord(t)>=x_down and ord(t)<=x_up)..        G('PSP',n,t)
                                                                      + Charge('PSP',n,t)*1.1                                 #assuming that the pump capacity is generally lower than the turbine capacity
                                                                                        =L= cap('PSP',n,t) * share_PSP_daily * af_hydro('PSP',n,t)
;
Store_tfirst(n,t,'PSP')$(ord(t)=x_down)..    storagelevel('PSP',n,t) =E= cap('PSP',n,t)* share_PSP_daily * af_hydro('PSP',n,t)*store_cpf * 0.8
;
Store_tlast(n,t,'PSP')$(ord(t)=x_up)..     storagelevel('PSP',n,t) =E= cap('PSP',n,t) * share_PSP_daily * af_hydro('PSP',n,t)*store_cpf * 0.8
;

*seasonal storages
Store_max_cluster(StorageCluster,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..
                                        G(StorageCluster,n,t) =L= cap_PSP_cluster(n,StorageCluster,t) * (1-share_PSP_daily)
;
Pump_max_cluster(StorageCluster,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..
                                        Pump(StorageCluster,n,t) =L= cap_PSP_cluster(n,StorageCluster,t) * (1-share_PSP_daily)
;

Reservoir_power_max(ReservoirCluster,n,t)$(ord(t)>=x_down and ord(t)<=x_up)..
                                        G(ReservoirCluster,n,t) =L= cap_Reservoir_cluster(n,ReservoirCluster,t)
;

G.fx(Biomass,n,t)     = cap(Biomass,n,t) * af_overall(Biomass,n,t) ;
G.fx('RoR',n,t)       = cap('RoR',n,t) * af_hydro('RoR',n,t)      ;


model ProKoMo
    /
            ojective
            energy_balance
            max_gen
%Startup%   min_gen
            max_cap
%Startup%   startup_constraint

            max_RES

%CHP%       CHP_constraint_lig
%CHP%       CHP_constraint_coal
%CHP%       CHP_constraint_gas
%CHP%       CHP_constraint_oil
%Flow%      Res_lineflow_1

            Store_max_cluster
            Pump_max_cluster
            Reservoir_power_max

            Store_Level
            Store_Level_max
            Store_max
            Store_tfirst
            Store_tlast

    /  ;

ProKoMo.reslim = 1000000000;
ProKoMo.iterlim = 1000000000;
ProKoMo.holdfixed = 1;

option LP = CPLEX   ;

option limcol = 10;
option limrow = 10;
option threads = 4;
option BRatio = 1 ;


option
    limrow = 0,         # equations listed per block
    limcol = 0,         # variables listed per block
    solprint = off,     # solver's solution output printed
    sysout = off;       # solver's system output printed

* Turn off the listing of the input file
$offlisting

* Turn off the listing and cross-reference of the symbols used
$offsymxref offsymlist

;
