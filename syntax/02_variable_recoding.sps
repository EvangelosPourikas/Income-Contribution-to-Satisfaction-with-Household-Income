* ============================================================.
* 02 — VARIABLE CREATION & RECODING
* Household Income Contribution & Satisfaction Analysis
* Understanding Society Wave 14 (2023/2024)
* ============================================================.

* ============================================================.
* KEY INDEPENDENT VARIABLE: % contributed to household income
* Computed as (personal net income / household net income) * 100
* ============================================================.

COMPUTE new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv = n_fimnnet_dv * 100 / n_fihhmnnet1_dv.

* Recode into categorical form for bivariate analysis.

RECODE new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv
  (0.00 THRU 0.9999 = 1)
  (1 THRU 25.0 = 2)
  (25.0001 THRU 50.0 = 3)
  (50.0001 THRU 75.0 = 4)
  (75.0001 THRU 99.9999 = 5)
  (100.00 = 6)
  INTO new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat.

VALUE LABELS new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat
  1 'No Contribution'
  2 '1%-25%'
  3 '25%-50%'
  4 '50%-75%'
  5 '75%-99%'
  6 'Full Contribution'.

VARIABLE LABELS new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat 
  '% of Contributed into Total Net Household Income'.

* ============================================================.
* HOUSEHOLD INCOME: Recode from continuous into deciles
* Percentile boundaries identified via FREQUENCIES
* ============================================================.

WEIGHT by n_inding2_xw.
FREQUENCIES n_fihhmnnet1_dv
  /PERCENTILES = 0.0 10.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0
  /STATISTICS MEAN MEDIAN MINIMUM MAXIMUM RANGE.
WEIGHT OFF.

RECODE n_fihhmnnet1_dv
  (LO thru 1997.1612 = 1)
  (1997.1613 thru 2678.6499 = 2)
  (2678.6500 thru 3120.8461 = 3)
  (3120.8462 thru 3576.4975 = 4)
  (3576.4976 thru 4014.4700 = 5)
  (4014.4701 thru 4562.3761 = 6)
  (4562.3762 thru 5172.6602 = 7)
  (5172.6603 thru 5908.9273 = 8)
  (5908.9274 thru 7246.1979 = 9)
  (7246.1980 thru HI = 10)
  INTO n_fihhmnnet1_dv_cat.

VALUE LABELS n_fihhmnnet1_dv_cat
  1 'Lowest to £1997'
  2 '£1998 to £2678'
  3 '£2679 to £3120'
  4 '£3121 to £3576'
  5 '£3577 to £4014'
  6 '£4015 to £4562'
  7 '£4563 to £5172'
  8 '£5173 to £5908'
  9 '£5909 to £7246'
  10 '£7247 to Highest'.

VARIABLE LABELS n_fihhmnnet1_dv_cat 'Categorical Household Income £ Per Month'.

WEIGHT by n_inding2_xw.
FREQUENCIES n_fihhmnnet1_dv_cat.
WEIGHT OFF.

* ============================================================.
* DEPENDENT VARIABLE: Satisfaction with household income
* Recoded into binary for logistic regression
* Dissatisfied (1-3) = 2, Satisfied (5-7) = 1
* Neither (4) = excluded
* ============================================================.

RECODE n_sclfsat2
  (1,2,3=2)
  (4 = SYSMIS)
  (7,6,5=1)
  INTO n_sclfsat2_log.

VALUE LABELS n_sclfsat2_log
  1 'Satisfied'
  2 'Dissatisfied'.

VARIABLE LABELS n_sclfsat2_log 'Satisfaction with Household Income for Logistic Regression'.

FREQUENCIES n_sclfsat2_log.

* ============================================================.
* JOB STATUS: Recode to remove vague/small categories
* ============================================================.

RECODE n_jbstat
  (1=1)
  (2=2)
  (3=3)
  (4=4)
  (5=5)
  (6=6)
  (7=7)
  (8=8)
  (10 THRU HI = SYSMIS)
  INTO n_jbstat_re.

VALUE LABELS n_jbstat_re
  1 'Self Employed'
  2 'Paid Employment (ft/pt)'
  3 'Unemployed'
  4 'Retired'
  5 'On Maternity Leave'
  6 'Family Care or Home'
  7 'Full-Time Student'
  8 'LT Sick or Disabled'.

VARIABLE LABELS n_jbstat_re 'Job Status'.

FREQUENCIES n_jbstat_re.
