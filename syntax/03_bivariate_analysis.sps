* ============================================================.
* 03 — BIVARIATE ANALYSIS
* Household Income Contribution & Satisfaction Analysis
* Understanding Society Wave 14 (2023/2024)
* ============================================================.

* ============================================================.
* CROSSTABULATIONS WITH CHI-SQUARE TESTS
* ============================================================.

* Contribution to Household Income × Satisfaction with Household Income.
WEIGHT by n_inding2_xw.
CROSSTABS new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat by n_sclfsat2_1
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* Gender × Satisfaction with Household Income.
WEIGHT by n_inding2_xw.
CROSSTABS n_sex by n_sclfsat2_1
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* Three-Way: Contribution × Satisfaction × Gender.
WEIGHT by n_inding2_xw.
CROSSTABS new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat by n_sclfsat2_1 by n_sex
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* General Health × Satisfaction with Household Income.
WEIGHT by n_inding2_xw.
CROSSTABS n_scsf1 by n_sclfsat2_1
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* Job Status × Satisfaction with Household Income.
WEIGHT by n_inding2_xw.
CROSSTABS n_jbstat_re by n_sclfsat2_1
  /CELLS row
  /STATISTICS PHI CHISQ.
WEIGHT OFF.

* ============================================================.
* CORRELATIONS (continuous × continuous)
* ============================================================.

* Household Income × Satisfaction.
WEIGHT by n_inding2_xw.
CORRELATIONS n_fihhmnnet1_dv n_sclfsat2.
WEIGHT OFF.

* Hours of Housework × Satisfaction.
WEIGHT by n_inding2_xw.
CORRELATIONS n_howlng n_sclfsat2.
WEIGHT OFF.

* ============================================================.
* STACKED BAR CHARTS
* ============================================================.

* Chart 1: Contribution to Household Income × Satisfaction.
WEIGHT by n_inding2_xw.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" 
    VARIABLES=new_n_fimnnet_dv_divided_by_n_fihhmnnet1_dv_cat
    COUNT()[name="COUNT"] n_sclfsat2_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
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

* Chart 2: General Health × Satisfaction.
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

* Chart 3: Job Status × Satisfaction.
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
