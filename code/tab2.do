******************************************************************
** Noé J Nava, Ph.D. Ag. Research Economist             **********
** USDA - ERS - MTED - APM                                    ****
** noe.nava@usda.gov                                 *************
******************************************************************
*
** Last updated: 09/22/2022
*

/* Notes:

- Replication code for Table 2 (theta recovering).

* Because Dr. Jhorland Garcia (Colombian Central Bank) pointed out that efficiency 
* -- few observations -- may be in issue in IV estimation, I employ Andrews and Armstrong (2017)
* which is unbiased (2sls is only assymptotically unbiased -- needs lots of observations)

*/

clear all 
cd "~_set_working_directory_~"
use "data\monadic"

* Reviewer said I should change precipitation from cubic inches to cubic mililiters.
replace prec_sum = prec_sum*16.387

qui{
   gen lnOper = log(oper_exp/acres)
   gen lnDensity = log(density)
   gen inter_sum = temp_sum*prec_sum
   gen sq_temp_sum = temp_sum*temp_sum
   gen sq_prec_sum = prec_sum*prec_sum
   replace dep_j = (-1)*dep_j
}

/* Exporter side */
reg dep_i lnOper temp_sum prec_sum sq_temp_sum sq_prec_sum inter_sum
ivregress 2sls dep_i temp_sum prec_sum sq_temp_sum sq_prec_sum inter_sum (lnOper = lnDensity), first vce(r)
aaniv dep_i temp_sum prec_sum sq_temp_sum sq_prec_sum inter_sum (lnOper = lnDensity) /* Andrews and Armstrong (2017) estimator */

/* Importer side */
reg dep_j lnOper temp_sum prec_sum sq_temp_sum sq_prec_sum inter_sum
ivregress 2sls dep_j  temp_sum prec_sum sq_temp_sum sq_prec_sum inter_sum (lnOper = lnDensity), first vce(r)
aaniv dep_j temp_sum prec_sum sq_temp_sum sq_prec_sum inter_sum (lnOper = lnDensity) /* Andrews and Armstrong (2017) estimator */
*end