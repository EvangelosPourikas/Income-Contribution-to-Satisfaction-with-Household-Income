# Household Income Contribution & Satisfaction Among UK Parents
### A Quantitative Analysis Using Understanding Society (Wave 14, 2023/2024)

## Overview

This project investigates how the proportion of personal income that parents contribute to their total household income affects their satisfaction with it — focusing specifically on UK couple households with children under the age of 16. The analysis uses Wave 14 (2023/2024) of the Understanding Society dataset and applies bivariate testing and logistic regression to examine this under-researched relationship in the UK context.

This was completed as an undergraduate dissertation at City, St George's, University of London (BSc Criminology with Data Analytics, First-Class Honours) and scored 75%. The analysis was conducted in SPSS, with full syntax provided for reproducibility.

---

## Research Questions

1. What is the relationship between the proportion of personal income that parents contribute to total household income and their satisfaction with it?
2. Does being a mother or a father change this relationship?
3. Which other socio-economic factors affect this relationship?

---

## Key Findings

- **Non-contributors and full contributors** to household income reported the highest satisfaction levels — suggesting that dual-earner households (where both partners contribute partially) experience lower satisfaction.
- **Fathers are 35% more likely** to report dissatisfaction with household income compared to mothers, likely shaped by breadwinning social norms.
- **Mothers who contribute 75%+ of household income** report the highest rates of complete dissatisfaction — the opposite pattern to fathers.
- **General health** emerged as the strongest predictor: individuals in poor health were 173% more likely to be dissatisfied with household income compared to those in good health.
- **Higher household income** was associated with a gradual decrease in dissatisfaction, with the highest income group showing 49% lower odds of dissatisfaction.
- These findings **contradict** a similar Czech study (Mysíková, 2016) which found no significant effects among couples with children — demonstrating that UK households behave differently.

---

## Data

**Source:** Wave 14 (2023/2024) of the [UK Household Longitudinal Study (Understanding Society)](https://www.understandingsociety.ac.uk/), conducted by the Institute for Social and Economic Research (ISER), University of Essex.

**Sample:** Approximately 40,000 households across the UK. This analysis filters to couple households (household types 10, 11, 12) with at least one child under the age of 16.

**Access:** The data is classified as "Safeguarded" and can be accessed by registering with the [UK Data Service](https://ukdataservice.ac.uk/) and accepting the End User Licence Agreement. **The data is not included in this repository.**

**Files needed to reproduce:**
- `n_indresp.sav` — Individual response file (Wave 14)
- `n_hhresp.sav` — Household response file (Wave 14)

---

## Variables

### Dependent Variable
| Variable | Description | Original Scale | Recoded |
|---|---|---|---|
| `n_sclfsat2` | Satisfaction with household income | 1 (Completely Dissatisfied) to 7 (Completely Satisfied) | Binary: Dissatisfied (1-3) / Satisfied (5-7). Neutral (4) excluded. |

### Key Independent Variable
| Variable | Description | Notes |
|---|---|---|
| `% contributed` | Proportion of personal net income to total household net income | Computed: `(n_fimnnet_dv / n_fihhmnnet1_dv) * 100`. Recoded into 6 categories: No Contribution, 1-25%, 25-50%, 50-75%, 75-99%, Full Contribution. |

### Control Variables
| Variable | Description | Type |
|---|---|---|
| `n_sex` | Gender | Categorical (Male/Female) |
| `n_scsf1` | General health | Categorical (Excellent to Poor) |
| `n_jbstat` | Job status | Categorical (8 categories after recoding) |
| `n_fihhmnnet1_dv` | Total net household income (monthly) | Recoded into deciles |
| `n_howlng` | Hours of housework per week | Continuous |

---

## Methodology

### Data Preparation
1. Merged individual (`n_indresp`) and household (`n_hhresp`) response files on household ID (`n_hidp`)
2. Filtered to couple households with children under 16
3. Removed missing values (refusals, inapplicable, errors)
4. Created the income contribution variable and recoded variables as described above

### Analysis
1. **Bivariate Analysis** — Chi-square tests, Cramér's V, correlations, and stacked bar charts to assess individual relationships between each independent variable and satisfaction
2. **Three-Way Crosstabulation** — Contribution × Satisfaction × Gender to uncover gendered patterns
3. **Logistic Regression** — Binary logistic regression predicting dissatisfaction with household income, controlling for all six independent variables simultaneously

### Reference Categories (Logistic Regression)
- Dependent: Satisfied (5-7) = reference
- Contribution: 50%-75%
- Household Income: £3,577–£4,014 (5th decile)
- Job Status: Unemployed
- General Health: Good
- Gender: Female
- Housework: Continuous (no reference)

---

## Repository Structure

```
uk-household-income-satisfaction-analysis/
│
├── README.md
├── LICENSE
│
├── syntax/
│   ├── 01_data_preparation.sps        # Merging files, filtering, missing values
│   ├── 02_variable_recoding.sps       # Computing contribution %, recoding variables
│   ├── 03_bivariate_analysis.sps      # Chi-square tests, correlations, crosstabs
│   ├── 04_logistic_regression.sps     # Logistic regression model
│   └── full_syntax.sps                # Complete syntax in one file
│
├── outputs/
│   └── figures/
│       ├── contribution_by_satisfaction.png
│       ├── health_by_satisfaction.png
│       ├── job_status_by_satisfaction.png
│       ├── Logistic-Regression-Graph.png
│       └── regression_summary.png
│
├── docs/
│   ├── variable_codebook.md           # Detailed variable descriptions and coding decisions
│   └── dissertation_abstract.md       # Full abstract for context
│
└── .gitignore
```

---

## How to Reproduce

### 1. Get the Data
- Register at [UK Data Service](https://ukdataservice.ac.uk/)
- Download Understanding Society Wave 14: SN 6614
- Place `n_indresp.sav` and `n_hhresp.sav` in a local folder on your machine

### 2. Update File Paths
- Open the syntax files in `syntax/` and update the file paths to match your local data location
- The original paths reference macOS directories — adjust these to your own setup

### 3. Run in SPSS
- Open IBM SPSS Statistics (version 28 or later recommended)
- Run `full_syntax.sps` to execute the entire analysis end-to-end
- Alternatively, run each numbered syntax file in order (01 → 04)

---

## Tools Used

- **IBM SPSS Statistics 28** — All data preparation, analysis, and visualisation
- **Understanding Society (Wave 14)** — UK Household Longitudinal Study, 2023/2024

---

## Limitations

- Social norms (e.g. breadwinning expectations) are acknowledged theoretically but could not be directly measured in the dataset
- Self-reported housework hours may contain reporting bias (Achen & Stafford, 2005)
- The analysis is cross-sectional (single wave) and does not capture changes over time
- Respondents reporting neutral satisfaction (4) were excluded from the logistic regression

---

## References

Key academic references underpinning this analysis:

- Gash, V. & Plagnol, A. C. (2020). The Partner Pay Gap. *Work, Employment and Society*, 35(3), 566-583.
- Hajdu, G. & Hajdu, T. (2018). Intra-couple income distribution and subjective wellbeing. *European Sociological Review*, 34(2), 138-156.
- Knies, G. (2017). Income effects on children's life satisfaction. ISER, University of Essex.
- Kowalewska, H. & Vitali, A. (2023). The female-breadwinner well-being 'penalty'. *European Sociological Review*, 40(2), 293-308.
- Mahadea, D. (2012). On the economics of happiness. *South African Journal of Economic and Management Sciences*, 16(1), 39-51.
- Mysíková, M. (2016). Within-couple Financial Satisfaction in the Czech Republic. *Ekonomicky Casopis*, 64(4), 301-316.

---

## Author

**Evangelos Pourikas**
- MSc Applied Social Data Science, London School of Economics (2025-2026)
- BSc Criminology with Data Analytics, City, St George's, University of London (First-Class Honours)
- [LinkedIn](https://www.linkedin.com/in/evangelos-pourikas-18056b2a0/)
