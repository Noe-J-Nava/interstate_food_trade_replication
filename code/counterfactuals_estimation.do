******************************************************************
** Noé J Nava, Ph.D. Ag. Research Economist             **********
** USDA - ERS - MTED - APM                                    ****
** noe.nava@usda.gov                                 *************
******************************************************************
*
** Last updated: 09/22/2022
*

/* Notes:

- Replication codes section 4:

*! Simple program for solving a GE gravity model, by Tom Zylkin
*! Department of Economics, University of Richmond
*! Example .do file, March 2019
*!
*! Suggested citation: Baier, Yotov, and Zylkin (2019): 
*! "On the Widely Differing Effects of Free Trade Agreements: Lessons from Twenty Years of Trade Integration"
*! Journal of International Economics, 116, 206-226.

* v1.0: first version
* v1.1: now allows you to save computed changes in nominal wages and price indices
* v1.2: now you can examine welfare effects of changes in technology levels a la Eaton-Kortum 2002

** Counterfactual notes:

My counterfactuals assume the following
* 1) Perfect competition among farmers
* 2) Balanced trade
* 3) Land is fixed

*/

clear all
cd "C:\Users\noejn2\OneDrive - University of Illinois - Urbana\Drive\Projects\interstate_food_trade\"
cap set matsize 800
cap set matsize 11000
cap set maxvar 32000
use "~_set_working_directory_~"
rename trade value

bysort importer: egen b_expenditure = total(value)

/* ::: Counterfactual 1: Agricultural capacity is halved ::: */
gen beta  = 0 /* bilateral trade costs */
gen A_hat = 1 /* Trechnology */

gen w_agcap = 0
gen t_agcap = 0
foreach state in "alabama" "arizona" "arkansas" "california" "colorado" "connecticut" "delaware" "florida" "georgia" "idaho" "illinois" "indiana" "iowa" "kansas" "kentucky" "louisiana" "maine" "maryland" "massachusetts" "michigan" "minnesota" "mississippi" "missouri" "montana" "nebraska" "nevada" "new hampshire" "new jersey" "new mexico" "new york" "north carolina" "north dakota" "ohio" "oklahoma" "oregon" "pennsylvania" "rhode island" "south carolina" "south dakota" "tennessee" "texas" "utah" "vermont" "virginia" "washington" "west virginia" "wisconsin" "wyoming" {
	
	replace A_hat = 0.5 if exporter == "`state'"
	ge_gravity_tech exporter importer value beta, theta(2.962) gen_w(welfare) gen_X(trade) gen_rw(local_wages) a_hat(A_hat)

	replace A_hat = 1 
	replace welfare = 0 if exporter != "`state'" /* to control welfare spillovers for each simulation */
	replace w_agcap = w_agcap + welfare
	
	replace trade = 0 if importer != "`state'"
	replace t_agcap = t_agcap + trade

}

bysort importer: egen e_agcap = total(t_agcap) /* expenditure under simulation */
replace e_agcap = e_agcap/expenditure /* change in expenditure from baseline == expenditure */
gen p_agcap = e_agcap/w_agcap /* change in prices from baseline == 1 */ 

/* ::: Counterfactual 2: Bilateral trade costs are doubled ::: */
gen w_bitrade = 0
gen t_bitrade = 0
foreach state in "alabama" "arizona" "arkansas" "california" "colorado" "connecticut" "delaware" "florida" "georgia" "idaho" "illinois" "indiana" "iowa" "kansas" "kentucky" "louisiana" "maine" "maryland" "massachusetts" "michigan" "minnesota" "mississippi" "missouri" "montana" "nebraska" "nevada" "new hampshire" "new jersey" "new mexico" "new york" "north carolina" "north dakota" "ohio" "oklahoma" "oregon" "pennsylvania" "rhode island" "south carolina" "south dakota" "tennessee" "texas" "utah" "vermont" "virginia" "washington" "west virginia" "wisconsin" "wyoming" {
	
	replace beta = -2.962*log(1.5) if importer == "`state'" /* Notice that the simulation doubles the cost of sending food to each state (importer) from all the other states (exporters) */
	ge_gravity_tech exporter importer value beta, theta(2.962) gen_w(welfare) gen_X(trade) gen_rw(wages) a_hat(A_hat)

	replace beta = 0 
	replace welfare = 0 if exporter != "`state'"/* to control welfare spillovers for each simulation */
	replace w_bitrade = w_bitrade + welfare
	
	replace trade = 0 if importer != "`state'"
	replace t_bitrade = t_bitrade + trade
	
}
*end