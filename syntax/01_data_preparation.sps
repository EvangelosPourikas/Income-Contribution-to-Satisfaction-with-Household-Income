* ============================================================.
* 01 — DATA PREPARATION
* Household Income Contribution & Satisfaction Analysis
* Understanding Society Wave 14 (2023/2024)
* ============================================================.

* Open each dataset and sort by household identifier.
* NOTE: Update file paths to match your local data location.

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

* ============================================================.
* FILTER: Keep only couple households with children under 16
* Household types 10, 11, 12 = couple households
* ============================================================.

SELECT IF (n_hhtype_dv = 10 OR n_hhtype_dv = 11 OR n_hhtype_dv = 12) AND
  (n_agechy_dv GE 0 AND n_agechy_dv LT 16).

* ============================================================.
* MISSING VALUES: Recode negative values as missing
* Negative values indicate refusals, inapplicable, or errors
* ============================================================.

MISSING VALUES n_sclfsat2 (LO THRU -1).
MISSING VALUES n_sex (LO THRU -1).
MISSING VALUES n_howlng (LO THRU -1).
MISSING VALUES n_agechy_dv (LO thru -1).
MISSING VALUES n_jbstat (LO THRU -1).
MISSING VALUES n_scsf1 (lo THRU -1).
