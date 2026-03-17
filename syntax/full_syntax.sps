* ============================================================.
* FULL ANALYSIS SYNTAX
* Household Income Contribution & Satisfaction Among UK Parents
* Understanding Society Wave 14 (2023/2024)
* 
* Author: Evangelos Pourikas
* BSc Criminology with Data Analytics — City, St George's, University of London
* 
* NOTE: Update all file paths to match your local data location.
* Data files required: n_indresp.sav, n_hhresp.sav (Wave 14)
* Download from UK Data Service: https://ukdataservice.ac.uk/ (SN: 6614)
* ============================================================.


* ============================================================.
* SECTION 1: DATA PREPARATION
* Merging individual and household files, filtering, missing values
* ============================================================.

* Open each dataset and sort by household identifier.

GET FILE='/YOUR/PATH/HERE/n_indresp.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.
SORT CASES BY n_hidp (A).
SAVE OUTFILE='/YOUR/PATH/HERE/n_indresp.sav'.

GET FILE='/YOUR/PATH/HERE/n_hhresp.sav'.
DATASET NAME DataSet2.
SORT CASES BY n_hidp (A).
SAVE OUTFILE='/YOUR/PATH/HERE/n_hhresp.sav'.

DATASET CLOSE ALL.

* Match individual and household files by household identifier.
* Keep only the variables required for this analysis.

MATCH FILES
  /FILE='/YOUR/PATH/HERE/n_indresp.sav'
  /TABLE='/YOUR/PATH/HERE/n_hhresp.sav'
  /BY n_hidp
  /KEEP pidp pid n_hidp n_pno n_hhorig n_memorig n_psu n_strata n_sampst 
    n_month n_quarter n_ivfio n_ioutcome
    n_indpxui_lw n_indinui_lw n_inding2_xw
    n_sex n_dvage n_ethn_dv n_hhsize n_hhtype_dv n_finnow n_Hsownd n_Finfut 
    n_Humops n_Huiron n_Hudiy n_Hucbed n_Hucunwell n_Howlng n_jbstat n_agechy_dv
    n_finnow n_finfut n_jbsat n_scsf1
    n_sclfsato n_sclfsat2
    n_fimnmisc_dv n_fimnprben_dv n_fimninvnet_dv n_fimnpen_dv n_fimnsben_dv n_fimnnet_dv
    n_fihhmnnet1_dv n_fihhmnlabnet_dv n_fihhmnmisc_dv n_fihhmnprben_dv 
    n_fihhmninv_dv n_fihhmnpen_dv n_fihhmnsben_dv.
EXECUTE.

* Save as a new merged file.
SAVE OUTFILE='/YOUR/PATH/HERE/merged_analysis_file.sav'.
DATASET CLOSE ALL.

* Open the merged file.
GET FILE='/YOUR/PATH/HERE/merged_analysis_file.sav'.

* Filter: Keep only couple households with children under 16.
* Household types 10, 11, 12 = couple households.

SELECT IF (n_hhtype_dv = 10 OR n_hhtype_dv = 11 OR n_hhtype_dv = 12) AND
  (n_agechy_dv GE 0 AND n_agechy_dv LT 16).

* Missing values: Recode negative values as missing.
* Negative values in USoc indicate refusals, inapplicable, or errors.

MISSING VALUES n_sclfsat2 (LO THRU -1).
MISSING VALUES n_sex (LO THRU -1).
MISSING VALUES n_howlng (LO THRU -1).
MISSING VALUES n_agechy_dv (LO thru -1).
MISSING VALUES n_jbstat (LO THRU -1).
MISSING VALUES n_scsf1 (lo THRU -1).


* ============================================================.
* SECTION 2: VARIABLE CREATION & RECODING
* Computing contribution %, recoding variables for analysis
* ============================================================.

* KEY INDEPENDENT VARIABLE: % contributed to household income.
* Computed as (personal net income / household net income) * 100.

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

* HOUSEHOLD INCOME: Recode from continuous into deciles.
* Percentile boundaries identified via FREQUENCIES.

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

* DEPENDENT VARIABLE: Satisfaction with household income.
* Recoded into binary for logistic regression.
* Dissatisfied (1-3) = 2, Satisfied (5-7) = 1.
* Neither (4) = excluded.

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

* JOB STATUS: Recode to remove vague/small categories.

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


* ============================================================.
* SECTION 3: BIVARIATE ANALYSIS
* Chi-square tests, correlations, crosstabulations, and charts
* ============================================================.

* --- Crosstabulations with Chi-Square Tests ---

* Contribution to Household Income x Satisfaction with Household Income.
WEIGHT by n_inding2_xw.
CROSSTABS new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat by n_sclfsat2_1
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* Gender x Satisfaction with Household Income.
WEIGHT by n_inding2_xw.
CROSSTABS n_sex by n_sclfsat2_1
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* Three-Way: Contribution x Satisfaction x Gender.
WEIGHT by n_inding2_xw.
CROSSTABS new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat by n_sclfsat2_1 by n_sex
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* General Health x Satisfaction with Household Income.
WEIGHT by n_inding2_xw.
CROSSTABS n_scsf1 by n_sclfsat2_1
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* Job Status x Satisfaction with Household Income.
WEIGHT by n_inding2_xw.
CROSSTABS n_jbstat_re by n_sclfsat2_1
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* --- Correlations (continuous x continuous) ---

* Household Income x Satisfaction.
WEIGHT by n_inding2_xw.
CORRELATIONS n_fihhmnnet1_dv n_sclfsat2.
WEIGHT OFF.

* Hours of Housework x Satisfaction.
WEIGHT by n_inding2_xw.
CORRELATIONS n_howlng n_sclfsat2.
WEIGHT OFF.

* --- Stacked Bar Charts ---

* Chart 1: Contribution to Household Income x Satisfaction.
WEIGHT by n_inding2_xw.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" 
    VARIABLES=new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat
    COUNT()[name="COUNT"] n_sclfsat2_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /COLORCYCLE COLOR1(49,175,255), COLOR2(161,24,80), COLOR3(33,213,210), COLOR4(79,33,150),
    COLOR5(0,158,154), COLOR6(0,114,195), COLOR7(208,176,255), COLOR8(0,97,97), 
    COLOR9(250,117,166), COLOR10(0,60,115), COLOR11(169,112,255), COLOR12(209,39,101),
    COLOR13(108,202,255), COLOR14(110,50,201), COLOR15(1,186,182), COLOR16(118,11,57),
    COLOR17(17,147,232), COLOR18(0,125,121), COLOR19(255,160,194), COLOR20(137,63,252)
  /FRAME OUTER=NO INNER=NO
  /GRIDLINES XAXIS=NO YAXIS=YES
  /STYLE GRADIENT=NO.
BEGIN GPL
  GUIDE: axis(dim(1), label("% of Contributed into Total Net Household Income"))
  GUIDE: axis(dim(2), label("Percent"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("How Satisfied Are You With Your ",
    "Household Income"))
  SCALE: cat(dim(1), include("1.00", "2.00", "3.00", "4.00", "5.00", "6.00"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include(
    "1.00", "2.00", "3.00", "4.00", "5.00", "6.00", "7.00"))
  ELEMENT: interval.stack(position(summary.percent(
    new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat*COUNT, base.coordinate(dim(1)))), 
    color.interior(n_sclfsat2_1), shape.interior(shape.square))
END GPL.
WEIGHT OFF.

* Chart 2: General Health x Satisfaction.
WEIGHT by n_inding2_xw.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=n_scsf1 COUNT()[name="COUNT"] n_sclfsat2_1
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  GUIDE: axis(dim(1), label("General health"))
  GUIDE: axis(dim(2), label("Percent"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("How Satisfied Are You With Your ",
    "Household Income"))
  SCALE: cat(dim(1), include("1", "2", "3", "4", "5"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include(
    "1.00", "2.00", "3.00", "4.00", "5.00", "6.00", "7.00"))
  ELEMENT: interval.stack(position(summary.percent(n_scsf1*COUNT, base.coordinate(dim(1)))),
    color.interior(n_sclfsat2_1), shape.interior(shape.square))
END GPL.
WEIGHT OFF.

* Chart 3: Job Status x Satisfaction.
WEIGHT by n_inding2_xw.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=n_jbstat_re COUNT()[name="COUNT"] n_sclfsat2_1
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  GUIDE: axis(dim(1), label("Job Status"))
  GUIDE: axis(dim(2), label("Percent"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("How Satisfied Are You With Your ",
    "Household Income"))
  SCALE: cat(dim(1), include("1.00", "2.00", "3.00", "4.00", "5.00", "6.00", "7.00", "8.00"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include(
    "1.00", "2.00", "3.00", "4.00", "5.00", "6.00", "7.00"))
  ELEMENT: interval.stack(position(summary.percent(n_jbstat_re*COUNT, base.coordinate(dim(1)))),
    color.interior(n_sclfsat2_1), shape.interior(shape.square))
END GPL.
WEIGHT OFF.


* ============================================================.
* SECTION 4: LOGISTIC REGRESSION
* Binary logistic regression predicting dissatisfaction
* ============================================================.

* Reference Categories:
*   Dependent: Satisfied (5-7) = 1, Dissatisfied (1-3) = 2
*   Contribution: 50%-75% (4)
*   Household Income: £3,577-£4,014 — 5th decile (5)
*   Job Status: Unemployed (3)
*   General Health: Good (3)
*   Gender: Female (2)
*   Housework: Continuous (no reference)
*
*   Note: Neither Satisfied nor Dissatisfied (4) = excluded.

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

* ============================================================.
* END OF ANALYSIS
* ============================================================.
