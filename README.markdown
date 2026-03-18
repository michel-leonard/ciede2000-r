# CIEDE2000 color difference formula in R

This page presents the CIEDE2000 color difference, implemented in the R programming language.

![The CIEDE2000 logo in R, for statistical computing and graphics](https://raw.githubusercontent.com/michel-leonard/ciede2000-color-matching/refs/heads/main/docs/assets/images/logo.jpg)

## Our CIEDE2000 offer

This production-ready file, released in 2026, contain the CIEDE2000 algorithm.

Source File|Type|Bits|Purpose|Advantage|
|:--:|:--:|:--:|:--:|:--:|
[ciede2000.r](./ciede2000.r)|`numeric`|64|General|Vectorization, Interoperability|

### Software Versions

- R 4.5.2

### Example Usage

We calculate the CIEDE2000 distance between two colors, first without and then with parametric factors.

```r
# Example of two L*a*b* colors
l1 <- 87.5; a1 <- 94.2; b1 <- -12.5;
l2 <- 85.5; a2 <- 71.4; b2 <- 14.8;

delta_e <- ciede2000(l1, a1, b1, l2, a2, b2);
cat("delta_e = ", delta_e, "\n"); # ΔE2000 = 11.66866

# Example of parametric factors used in the textile industry
kl <- 2.0; kc <- 1.0; kh <- 1.0;

# Perform a CIEDE2000 calculation compliant with that of Gaurav Sharma
canonical <- TRUE;

delta_e <- ciede2000(l1, a1, b1, l2, a2, b2, kl, kc, kh, canonical);
cat("delta_e = ", delta_e, "\n"); # ΔE2000 = 11.61455
```

**Note**: this example uses scalars, but if you prefer, it would have worked just as well with vectors.

## Public Domain Licence

You are free to use these files, even for commercial purposes.
