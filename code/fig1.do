******************************************************************
** Noé J Nava, Ph.D. Ag. Research Economist             **********
** USDA - ERS - MTED - APM                                    ****
** noe.nava@usda.gov                                 *************
******************************************************************
*
** Last updated: 09/22/2022
*

/* Notes:

- Replication code for Figure 1 in Nava, Ridley, Dall'Erba (2022)

*/

clear all 
cd "~_set_working_directory_~"
use "data\dyadic"

qui{/* FE structure used to test symmetry */
	sort exporter
	egen exp_ID = group(exporter)

	sort importer
	egen imp_ID = group(importer)

	tab imp_ID, generate(IMPO_FE)
	tab exp_ID, generate(EXPO_FE)
	
	forv i = 1/48{ 
	gen FE_`i' = IMPO_FE`i' + EXPO_FE`i'
	replace FE_`i' = 1 if FE_`i' == 2
	
	}
}

qui{ /* Creating the weighting matrix for fgls estimator */
	constraint 1 EXPO_FE1 + EXPO_FE2 + EXPO_FE3 + EXPO_FE4 + EXPO_FE5 + EXPO_FE6 + EXPO_FE7 + EXPO_FE8 + EXPO_FE9 + EXPO_FE10 + EXPO_FE11 + EXPO_FE12 + EXPO_FE13 + EXPO_FE14 + EXPO_FE15 + EXPO_FE16 + EXPO_FE17 + EXPO_FE18 + EXPO_FE19 + EXPO_FE20 + EXPO_FE21 + EXPO_FE22 + EXPO_FE23 + EXPO_FE24 + EXPO_FE25 + EXPO_FE26 + EXPO_FE27 + EXPO_FE28 + EXPO_FE29 + EXPO_FE30 + EXPO_FE31 + EXPO_FE32 + EXPO_FE33 + EXPO_FE34 + EXPO_FE35 + EXPO_FE36 + EXPO_FE37 + EXPO_FE38 + EXPO_FE39 + EXPO_FE40 + EXPO_FE41 + EXPO_FE42 + EXPO_FE43 + EXPO_FE44 + EXPO_FE45 + EXPO_FE46 + EXPO_FE47 = -EXPO_FE48

	constraint 2 IMPO_FE1 + IMPO_FE2 + IMPO_FE3 + IMPO_FE4 + IMPO_FE5 + IMPO_FE6 + IMPO_FE7 + IMPO_FE8 + IMPO_FE9 + IMPO_FE10 + IMPO_FE11 + IMPO_FE12 + IMPO_FE13 + IMPO_FE14 + IMPO_FE15 + IMPO_FE16 + IMPO_FE17 + IMPO_FE18 + IMPO_FE19 + IMPO_FE20 + IMPO_FE21 + IMPO_FE22 + IMPO_FE23 + IMPO_FE24 + IMPO_FE25 + IMPO_FE26 + IMPO_FE27 + IMPO_FE28 + IMPO_FE29 + IMPO_FE30 + IMPO_FE31 + IMPO_FE32 + IMPO_FE33 + IMPO_FE34 + IMPO_FE35 + IMPO_FE36 + IMPO_FE37 + IMPO_FE38 + IMPO_FE39 + IMPO_FE40 + IMPO_FE41 + IMPO_FE42 +IMPO_FE43 + IMPO_FE44 + IMPO_FE45 + IMPO_FE46 + IMPO_FE47 = -IMPO_FE48

	cnsreg normTrade contiguity dist_* EXPO_FE* IMPO_FE*, constraints(1-2) nocons collinear vce(r)
	predict e, residuals
	gen sq_e = e^2
	nl (sq_e = exp({xb: contiguity dist_* EXPO_FE* IMPO_FE*})), nocons nolog
	predict v
}

/* Coefplots: Presentation of results */

***** Left Panel ******
***** Distance and contiguity *****
matrix est = J(1, 7, .)
matrix colnames est = cont d1 d2 d3 d4 d5 d6

matrix CI = J(2, 7, .)
matrix colnames CI = cont d1 d2 d3 d4 d5 d6
matrix rownames CI = low upp

cnsreg normTrade contiguity dist_* EXPO_FE* IMPO_FE* [aweight = 1/v], constraints(1-2) nocons collinear vce(r)

matrix est[1,1] = _b[contiguity]
matrix CI[1, 1] = _b[contiguity] - invttail(e(df_r), 0.025)*_se[contiguity]
matrix CI[2, 1] = _b[contiguity] + invttail(e(df_r), 0.025)*_se[contiguity]
forv i = 1/6 {
	matrix est[1, `i' + 1] = _b[dist_`i']
	matrix CI[1, `i' + 1]  = _b[dist_`i'] - invttail(e(df_r), 0.025)*_se[dist_`i']
	matrix CI[2, `i' + 1]  = _b[dist_`i'] + invttail(e(df_r), 0.025)*_se[dist_`i']
}

set scheme s1mono
coefplot (matrix(est), ci(CI) label(Aggregated)), vertical yline(0) coeflabels(cont = "Contiguity" d1 = "(0, 865]" d2 = "(865, 1730]" d3 = "(1730, 2595]" d4 = "(2595, 3460]" d5 = "(3460, 4325]" d6 = "(4325, Max]", labsize(small))

***** Right Panel ******
***** Importer and exporter fixed effects *****
matrix s1_est = J(1, 48, .)
matrix colnames s1_est = AL AZ AR CA CO CT DE FL GA ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY
matrix s1_ci  = J(2, 48, .)
matrix rownames s1_ci = low upp

matrix s2_est = J(1, 48, .)
matrix colnames s2_est = AL AZ AR CA CO CT DE FL GA ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY
matrix s2_ci  = J(2, 48, .)
matrix rownames s1_ci = low upp

matrix FE_est = J(1, 48, .)
matrix colnames FE_est = AL AZ AR CA CO CT DE FL GA ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY
matrix FE_ci  = J(2, 48, .)
matrix rownames FE_ci = low upp

cnsreg normTrade contiguity dist_* EXPO_FE* IMPO_FE* [aweight = 1/v], constraints(1-2) nocons collinear vce(r)
forv i = 1/48 {

	matrix s1_est[1,`i'] = _b[EXPO_FE`i']
	matrix s1_ci[1,`i']  = _b[EXPO_FE`i'] - invttail(e(df_r), 0.025)*_se[EXPO_FE`i']
	matrix s1_ci[2,`i']  = _b[EXPO_FE`i'] + invttail(e(df_r), 0.025)*_se[EXPO_FE`i']
	
	matrix s2_est[1,`i'] = _b[IMPO_FE`i']
	matrix s2_ci[1,`i']  = _b[IMPO_FE`i'] - invttail(e(df_r), 0.025)*_se[IMPO_FE`i']
	matrix s2_ci[2,`i']  = _b[IMPO_FE`i'] + invttail(e(df_r), 0.025)*_se[IMPO_FE`i']
	
}

* The Standard Errors
constraint 1 FE_1 + FE_2 + FE_3 + FE_4 + FE_5 + FE_6 + FE_7 + FE_8 + FE_9 + FE_10 + FE_11 + FE_12 + FE_13 + FE_14 + FE_15 + FE_16 + FE_17 + FE_18 + FE_19 + FE_20 + FE_21 + FE_22 + FE_23 + FE_24 + FE_25 + FE_26 + FE_27 + FE_28 + FE_29 + FE_30 + FE_31 + FE_32 + FE_33 + FE_34 + FE_35 + FE_36 + FE_37 + FE_38 + FE_39 + FE_40 + FE_41 + FE_42 +FE_43 + FE_44 + FE_45 + FE_46 + FE_47 = -FE_48

cnsreg normTrade contiguity dist_* FE_* [aweight = 1/v], constraints(1) nocons collinear vce(r)
forv i = 1/48{
	matrix FE_est[1,`i'] = _b[FE_`i']
	matrix FE_ci[1, `i'] = _b[FE_`i'] - invttail(e(df_r), 0.025)*_se[FE_`i']
	matrix FE_ci[2, `i'] = _b[FE_`i'] + invttail(e(df_r), 0.025)*_se[FE_`i']	
}

coefplot (matrix(s1_est), label(Exporter)) (matrix(s2_est), label(Importer)) (matrix(FE_est), ci(FE_ci) label(S.E.) msize(vsmall)),  vertical yline(0) sort(1) coeflabels(,labsize(small) angle(90))
*end 