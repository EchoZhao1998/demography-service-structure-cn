# Foudings


<font color = "#2166AC">*Note: The following correlations are computed using pooled provincial panel data (2016–2024). These relationships reflect structural associations across provinces and time, and do not imply causal effects or within-province dynamic responsiveness.*</font>

### Pearson R

| r Value range  | Relation Level |
|:---------------|:---------------|
| r ≥ 0.7        | Strong         |
| 0.5 ≤ r < 0.7  | Moderate       |
| r < 0.5        | Weak           |

| Variable A              | Variable B  |    r    | Direction | Interpretation                                            |
| :---------------------- | :---------- | :-----: | :-------: | :-------------------------------------------------------- |
| bed\_per\_elderly\_1000 | ODR         | −0.7930 |  Negative | Aging regions have fewer beds per elderly person          |
| edu\_pri                | edu\_jun    |  0.7850 |  Positive | Education quality is consistent across levels             |
| birth\_rate             | ODR         | −0.7247 |  Negative | High-birth provinces have younger populations             |
| edu\_jun                | CDR         | −0.7184 |  Negative | More children → fewer teachers per student                |
| edu\_jun                | edu\_sen    |  0.7100 |  Positive | Education quality is consistent across levels             |
| bed\_per\_elderly\_1000 | birth\_rate |  0.6731 |  Positive | High-birth (younger) provinces have more beds per elderly |
| IT\_pc                  | retail\_pc  |  0.6546 |  Positive | Tech economy and consumption wealth move together         |
| IT\_pc                  | edu\_sen    |  0.5983 |  Positive | Tech-rich provinces have better senior high schools       |
| birth\_rate             | CDR         |  0.5788 |  Positive | More births → more child dependents (expected)            |
| retail\_pc              | edu\_sen    |  0.5758 |  Positive | Wealthier consumers → better senior high schools          |
| edu\_sen                | CDR         | −0.5695 |  Negative | More child dependents → fewer senior high teachers        |
| edu\_pri                | CDR         | −0.5677 |  Negative | More child dependents → fewer primary teachers            |




## Finding 1: The Aging Crisis and the Healthcare Gap (r = −0.7930)

The single strongest relationship in the entire matrix is between bed_per_elderly_1000 and ODR, at r = −0.7930. This is a strong negative correlation.

It means that provinces with a higher Old Dependency Ratio — that is, a greater burden of elderly dependents relative to the working-age population — tend to have fewer hospital beds available per 1,000 elderly residents. 

This suggests that healthcare infrastructure expansion has not kept pace with demographic aging across provinces.

> A business or government official could identify provinces with high ODR and immediately know that healthcare investment is likely to be both needed and underserved there.


## Finding 2: The Demographic Divide — Young Provinces vs. Aging Provinces (r = −0.7247)

The second strongest relationship is between birth_rate and ODR, at r = −0.7247. This is a strong negative correlation confirming a sharp structural divide across Chinese provinces.

Provinces with high birth rates are systematically associated with low Old Dependency Ratios, and vice versa. This is not simply a mathematical inevitability — it reflects a genuine socioeconomic divide between two types of provinces. Less urbanised provinces tend to cluster on the high-birth, low-aging end of the spectrum. (if point out specific province, show clustering output.*such as Tibet, Guizhou, Qinghai, and Ningxia*) maintain relatively high birth rates and have younger population structures. 

In contrast, highly urbanised and economically advanced provinces (*such as Liaoning, Jilin, and Shanghai*) have very low birth rates and carry a heavy aging burden.

## Finding 3: The Education Cluster — Internal Consistency (r = 0.7850, 0.7100)

The three education variables are strongly intercorrelated with one another. edu_pri and edu_jun share a correlation of r = 0.7850, and edu_jun and edu_sen share r = 0.7100. The weakest link in the chain, edu_pri and edu_sen, still has a moderate correlation of r = 0.3923.

This internal consistency is actually a positive sign for your data. It tells that teacher availability across primary, junior, and senior levels tends to move together within a province. A province that is well-resourced at the primary level tends to be well-resourced at the secondary level too. This means the three variables are measuring the same underlying construct — overall educational resource quality — from three different angles. 

> Note: While creating Shiny app, do not necessarily need to show all three simultaneously; edu_jun (junior high) could serve as a reasonable single representative of the education dimension.

## Finding 4: Education Quality is Inversely Linked to Children's Dependency (r = −0.7184, −0.5677, −0.5695)

edu_jun has a moderate-to-strong negative correlation with CDR of r = −0.7184. Both edu_pri and edu_sen also show moderate negative correlations with CDR at r = −0.5677 and r = −0.5695 respectively.

This means that provinces with a higher Children Dependency Ratio — more children relative to the working-age population — tend to have lower teacher availability per student. 

This indicates that teacher supply expansion has not proportionally adjusted to demographic youth pressure. The educational system is most stretched exactly where the demand is greatest.

> For a person considering a career in teaching, this finding is directly actionable: provinces with high CDR and low edu_* values represent both the greatest need and, potentially, the greatest opportunity for employment in education.

## Finding 5: Economic Development and Birth Rate are Negatively Associated (r = −0.3404, −0.3339)

IT_pc and retail_pc both show weak-to-moderate negative correlations with birth_rate, at r = −0.3404 and r = −0.3339 respectively. While these are not strong correlations, they are consistent and directionally clear.

Provinces with a more developed technology economy and higher consumer spending per capita tend to have lower birth rates. This is the classic demographic transition pattern: as regions become wealthier and more economically complex, fertility tends to decline. 

Compared to dependency ratios, economic development indicators show weaker explanatory power for fertility variation.

## Finding 6: The Surprising Weakness of Marriage Rate (r = 0.21 with birth_rate; near zero with most others)

marriagerate is notably the most isolated variable in the matrix. Its strongest correlation with any other variable is with birth_rate at only r = 0.2130, and its correlation with retail_pc is essentially zero at r = −0.0179. Its correlations with ODR and CDR are also very weak, at r = 0.0825 and r = 0.1388 respectively.

This is a genuinely interesting finding. It tells that marriage rate does not move in a predictable, linear way with the other demographic or economic variables in this dataset. 

Marriage behaviour in China appears to be driven by factors — cultural norms, local policy, housing costs, social expectations — that are not well captured by the economic and dependency-ratio variables have measured in this project. 

> When a user sees a province with an unusually high or low marriage rate on the map, they cannot simply explain it away by looking at the other variables. It demands its own investigation, which makes it a compelling standalone indicator.
