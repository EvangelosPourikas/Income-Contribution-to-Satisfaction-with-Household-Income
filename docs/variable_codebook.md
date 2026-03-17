# Variable Codebook

This document describes all variables used in the analysis, their sources, and any transformations applied.

---

## Data Sources

Two files from Understanding Society Wave 14 (2023/2024) were merged on `n_hidp` (household identifier):

| File | Level | Description |
|---|---|---|
| `n_indresp.sav` | Individual | Individual-level responses (income, satisfaction, demographics) |
| `n_hhresp.sav` | Household | Household-level responses (total household income) |

---

## Dependent Variable

### Satisfaction with Household Income (`n_sclfsat2`)

- **Question asked:** "How dissatisfied or satisfied are you with the income of your household?"
- **Original scale:** 1 = Completely Dissatisfied → 7 = Completely Satisfied
- **Used as:** Original 1-7 scale in bivariate analysis
- **Recoded for logistic regression** → `n_sclfsat2_log`:
  - 1 = Satisfied (original values 5, 6, 7)
  - 2 = Dissatisfied (original values 1, 2, 3)
  - System missing = Neither (original value 4) — excluded to focus on respondents with clearer positions

---

## Key Independent Variable

### Proportion Contributed to Household Income (computed)

- **How it was created:** `(n_fimnnet_dv / n_fihhmnnet1_dv) * 100`
- **Components:**
  - `n_fimnnet_dv` — Total estimated net monthly personal income (from `n_indresp`)
  - `n_fihhmnnet1_dv` — Total net monthly household income (from `n_hhresp`)
- **Continuous version:** Percentage from 0 to 100
- **Categorical version** (6 groups):

| Code | Label | Range |
|---|---|---|
| 1 | No Contribution | 0% to <1% |
| 2 | 1%-25% | 1% to 25% |
| 3 | 25%-50% | >25% to 50% |
| 4 | 50%-75% | >50% to 75% (reference category in regression) |
| 5 | 75%-99% | >75% to <100% |
| 6 | Full Contribution | 100% |

---

## Control Variables

### Gender (`n_sex`)
- 1 = Male
- 2 = Female (reference category in regression)

### General Health (`n_scsf1`)
- **Question asked:** "In general, would you say your health is..."
- 1 = Excellent
- 2 = Very Good
- 3 = Good (reference category in regression)
- 4 = Fair
- 5 = Poor

### Job Status (`n_jbstat` → recoded to `n_jbstat_re`)
- 1 = Self Employed
- 2 = Paid Employment (ft/pt)
- 3 = Unemployed (reference category in regression)
- 4 = Retired
- 5 = On Maternity Leave
- 6 = Family Care or Home
- 7 = Full-Time Student
- 8 = Long-Term Sick or Disabled
- Categories 10+ = excluded (vague or insufficient sample size)

### Total Household Income (`n_fihhmnnet1_dv` → recoded to `n_fihhmnnet1_dv_cat`)
- Recoded into deciles based on weighted percentile boundaries:

| Code | Label |
|---|---|
| 1 | Lowest to £1,997 |
| 2 | £1,998 to £2,678 |
| 3 | £2,679 to £3,120 |
| 4 | £3,121 to £3,576 |
| 5 | £3,577 to £4,014 (reference category in regression) |
| 6 | £4,015 to £4,562 |
| 7 | £4,563 to £5,172 |
| 8 | £5,173 to £5,908 |
| 9 | £5,909 to £7,246 |
| 10 | £7,247 to Highest |

### Hours of Housework per Week (`n_howlng`)
- Continuous variable (no recoding)
- Used as-is in both correlation and logistic regression

---

## Sample Filters

The analysis is restricted to:
- **Household types 10, 11, 12** — couple households (married, cohabiting, civil partnership)
- **`n_agechy_dv` between 0 and 15** — households where the youngest child is under 16

---

## Weighting

All analyses use the cross-sectional individual weight `n_inding2_xw` to ensure population representativeness.

---

## Missing Values

All variables had negative values recoded as system missing. In Understanding Society, negative values indicate:
- -1 = Don't know
- -2 = Refused
- -7 = Proxy respondent
- -8 = Inapplicable
- -9 = Missing
