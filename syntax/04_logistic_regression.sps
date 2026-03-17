* ============================================================.
* 04 — LOGISTIC REGRESSION
* Household Income Contribution & Satisfaction Analysis
* Understanding Society Wave 14 (2023/2024)
* ============================================================.

* Reference Categories:
*   Dependent Variable: Satisfaction with Household Income
*     Satisfied (5-7) = 1, Dissatisfied (1-3) = 2
*   Household Income: £3577 to £4014 (5th decile)
*   Job Status: Unemployed (3)
*   General Health: Good (3)
*   Gender: Female (2)
*   Contribution to Household Income: 50%-75% (4)
*   Hours of Housework: Continuous (no reference category)
*
* Note: Neither Satisfied nor Dissatisfied (4) excluded
*   (see 02_variable_recoding.sps)
* ============================================================.

* Check reference categories before running.
FREQUENCIES n_fihhmnnet1_dv_cat n_scsf1 n_jbstat_re n_sex 
  new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat.

* Run the logistic regression model.
WEIGHT by n_inding2_xw.
LOGISTIC REGRESSION VARIABLES n_sclfsat2_log
  /METHOD=ENTER new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat
  /METHOD=ENTER n_fihhmnnet1_dv_cat
  /METHOD=ENTER n_scsf1
  /METHOD=ENTER n_jbstat_re
  /METHOD=ENTER n_sex
  /METHOD=ENTER n_howlng
  /CONTRAST (n_fihhmnnet1_dv_cat)=Indicator (5)
  /CONTRAST (n_scsf1)=Indicator (3)
  /CONTRAST (n_jbstat_re)=Indicator (3)
  /CONTRAST (new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat)=Indicator (4)
  /CONTRAST (n_sex)=Indicator (2)
  /PRINT=CI(95)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).
WEIGHT OFF.
