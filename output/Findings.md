---
title: "Findings"
output:
  html_document:
    css: styles.css
---


<font color = "#2166AC">*Note: The following correlations are computed using pooled provincial panel data (2016–2024). These relationships reflect structural associations across provinces and time, and do not imply causal effects or within-province dynamic responsiveness.*</font>


#### Basic Knowledge: Pearson R

| r Value range  | Relation Level |
|:---------------|:---------------|
| r ≥ 0.7        | Strong         |
| 0.5 ≤ r < 0.7  | Moderate       |
| r < 0.5        | Weak           |

![correlation heatmap](correlation_heatmap.png)

| Variable A              | Variable B  |    r    | Direction | Interpretation                                            |
| :---------------------- | :---------- | :-----: | :-------: | :-------------------------------------------------------- |
| bed\_per\_elderly\_1000 | ODR         | −0.7930 |  Negative | Healthcare infrastructure has not kept pace with demographic aging          |
| edu\_pri                | edu\_jun    |  0.7850 |  Positive | Education quality is consistent across levels             |
| birth\_rate             | ODR         | −0.7247 |  Negative | High-birth provinces have younger populations             |
| edu\_jun                | CDR         | −0.7184 |  Negative | Higher child dependency is associated with lower teacher availability per student                |
| edu\_jun                | edu\_sen    |  0.7100 |  Positive | Education quality is consistent across levels             |
| bed\_per\_elderly\_1000 | birth\_rate |  0.6731 |  Positive | High-birth (younger) provinces have more beds per elderly |
| IT\_pc                  | retail\_pc  |  0.6546 |  Positive | Tech economy and consumption wealth move together         |
| IT\_pc                  | edu\_sen    |  0.5983 |  Positive | Tech-rich provinces have better senior high schools       |
| birth\_rate             | CDR         |  0.5788 |  Positive | More births → more child dependents (expected)            |
| retail\_pc              | edu\_sen    |  0.5758 |  Positive | Wealthier consumers → better senior high schools          |
| edu\_sen                | CDR         | −0.5695 |  Negative | Higher child dependency is associated with lower senior-level teacher availability        |
| edu\_pri                | CDR         | −0.5677 |  Negative | Higher child dependency is associated with lower primary-level teacher availability            |




## Finding 1: Structural Healthcare Imbalance Under Aging Pressure

***(r = −0.7930)***

The strongest relationship in the matrix is between bed_per_elderly_1000 and ODR (r = −0.7930), indicating a strong negative structural association across provinces.

Provinces with higher Old Dependency Ratios — meaning a greater burden of elderly dependents relative to the working-age population — tend to exhibit lower hospital bed availability per 1,000 elderly residents.

Importantly, this pattern reflects cross-provincial structural positioning rather than dynamic adjustment. Structurally older provinces appear to operate with comparatively lower elderly-adjusted healthcare capacity. The pooled scatter plot reinforces this pattern, with a clearly downward-sloping regression line.

![Healthcare Capacity vs Aging Pressure](healthcare_vs_aging.png)

This suggests persistent cross-regional imbalance in healthcare infrastructure relative to demographic aging pressure.

> Structural aging pressure is concentrated precisely where elderly-adjusted bed capacity is weakest.

## Finding 2: Provincial Demographic Bifurcation

***(r = −0.7247)***

The strong negative correlation between birth_rate and ODR (r = −0.7247) reveals a pronounced demographic divide across provinces.

While mechanically related through demographic structure, the magnitude of this relationship reflects a broader socioeconomic divide between two types of provinces. Less urbanised provinces tend to cluster on the high-birth, low-aging end of the spectrum, while highly urbanised and economically advanced provinces occupy the opposite end, characterised by low fertility and heavy aging pressure.

## Finding 3:  Internal Consistency of Educational Resource Indicators

***(r = 0.7850; 0.7100; 0.3923)***

The three education variables (edu_pri, edu_jun, edu_sen) display strong internal correlations, particularly between primary and junior levels (r = 0.7850) and junior and senior levels (r = 0.7100).

This indicates that teacher availability across educational stages tends to move together within provinces. Education resource intensity therefore appears to function as a coherent structural dimension rather than fragmented subcomponents.

Because of this high intercorrelation, subsequent panel regressions use a representative indicator to avoid multicollinearity and preserve model parsimony.

> Note: While creating Shiny app, do not necessarily need to show all three simultaneously; edu_jun (junior high) could serve as a reasonable single representative of the education dimension.

## Finding 4:  Youth Dependency and Educational Resource Strain

***(r = −0.7184, −0.5677, −0.5695)***

All three education indicators are negatively associated with CDR (Children Dependency Ratio), with the strongest relationship observed for edu_jun (r = −0.7184).

Structurally, provinces with higher child dependency burdens tend to exhibit lower teacher availability per student.

Again, this reflects cross-sectional structural positioning rather than confirmed dynamic responsiveness. The pattern suggests that youth-heavy provinces may experience comparatively lower educational resource intensity.

Whether this reflects insufficient supply adjustment or persistent structural capacity differences requires further dynamic analysis.

## Finding 5: Economic Development and Fertility Transition

***(r = −0.3404, −0.3339)***

IT_pc and retail_pc show weak-to-moderate negative correlations with birth_rate.

While not strong predictors, both indicators move consistently in the expected direction: provinces with more developed technological economies and higher consumer spending levels tend to exhibit lower fertility.

Compared with dependency ratios, however, economic development variables show weaker structural association with demographic pressure in this dataset.

## Finding 6: Institutional Independence of Marriage Rate

***(r = 0.21 with birth_rate; near zero with most others)***

marriagerate is the least integrated variable in the matrix. Its strongest correlation — with birth_rate — is modest (r = 0.2130), and its associations with economic and dependency indicators are weak.

This suggests that marriage behavior does not align predictably with demographic pressure or economic development in this framework.

Marriage dynamics likely operate under institutional, cultural, or housing-market influences not directly captured by dependency ratios or economic output indicators in this dataset.

Its relative structural independence makes it analytically distinct rather than redundant.

> When a user sees a province with an unusually high or low marriage rate on the map, they cannot simply explain it away by looking at the other variables. It demands its own investigation, which makes it a compelling standalone indicator.

## Limitations and Next Analytical Step

The correlation analysis presented above is based on pooled provincial panel data (2016–2024). While it reveals strong structural associations, it does not distinguish between cross-provincial differences and within-province dynamic adjustments over time. Correlation does not imply causality, nor does it test whether provinces actively adjust service supply in response to demographic pressure.

The next stage of this project will apply fixed-effects panel regression to examine within-province responsiveness. This approach will help determine whether increases in aging or child dependency within a province are associated with subsequent adjustments in healthcare or education supply, controlling for time-invariant provincial characteristics.

## Insights base on FE regression results

### Healthcare Capacity vs Aging Pressure

![Healthcare Capacity vs Aging Pressure](healthcare_vs_aging.png)

*The downward-sloping regression line visually confirms the strong negative structural association (r = −0.79). Provinces experiencing higher aging pressure tend to exhibit lower elderly-adjusted bed capacity.*

### Aging Pressure on Healthcare Supply
![Aging Pressure on Healthcare Supply](<Aging Pressure on Healthcare Supply.png>)

*The fixed-effects estimate remains negative and statistically significant, suggesting that within provinces, increases in aging pressure are associated with reductions in elderly-adjusted bed capacity.*

### Structural Quadrant Plot (High Value)
![Structural Quadrant Plot](<Provincial Service Alignment Quadrants.png>)

*Most data points in the bottom-right quadrant confirm the concern from your fixed-effects model: healthcare supply is not keeping pace with aging demand in high-ODR provinces.*

*The top-left cluster (ODR ~10–12, beds >9) likely represents less-aged provinces that happen to have relatively well-resourced healthcare systems.*