Browse : [MATLAB](https://github.com/michel-leonard/ciede2000-matlab) · [Microsoft Excel](https://github.com/michel-leonard/ciede2000-excel) · [PHP](https://github.com/michel-leonard/ciede2000-php) · [Perl](https://github.com/michel-leonard/ciede2000-perl) · [Python](https://github.com/michel-leonard/ciede2000-python) · **R** · [Ruby](https://github.com/michel-leonard/ciede2000-ruby) · [Rust](https://github.com/michel-leonard/ciede2000-rust) · [SQL](https://github.com/michel-leonard/ciede2000-sql) · [Swift](https://github.com/michel-leonard/ciede2000-swift) · [TypeScript](https://github.com/michel-leonard/ciede2000-typescript)

# CIEDE2000 color difference formula in R

This page presents the CIEDE2000 color difference, implemented in the R programming language.

![The CIEDE2000 logo in R, for statistical computing and graphics](https://raw.githubusercontent.com/michel-leonard/ciede2000-color-matching/refs/heads/main/docs/assets/images/logo.jpg)

## About

Here you’ll find the first rigorously correct implementation of CIEDE2000 that doesn’t use any conversion between degrees and radians. Set parameter `canonical` to obtain results in line with your existing pipeline.

`canonical`|The algorithm operates...|
|:--:|-|
`FALSE`|in accordance with the CIEDE2000 values currently used by many industry players|
`TRUE`|in accordance with the CIEDE2000 values provided by [this](https://hajim.rochester.edu/ece/sites/gsharma/ciede2000/) academic MATLAB function|

## Our CIEDE2000 offer

This production-ready file, released in 2026, contain the CIEDE2000 algorithm.

Source File|Type|Bits|Purpose|Advantage|
|:--:|:--:|:--:|:--:|:--:|
[ciede2000.r](./ciede2000.r)|`numeric`|64|General|Vectorization, Interoperability|

### Software Versions

- R 4.5.3

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

### Test Results

LEONARD’s tests are based on well-chosen L\*a\*b\* colors, with various parametric factors `kL`, `kC` and `kH`.

```
CIEDE2000 Verification Summary :
          Compliance : [ ] CANONICAL [X] SIMPLIFIED
  First Checked Line : 40.0,0.5,-128.0,49.91,0.0,24.0,1.0,1.0,1.0,51.01866090771252
           Precision : 11 decimal digits
           Successes : 100000000
               Error : 0
            Duration : 1423.27 seconds
     Average Delta E : 67.12
   Average Deviation : 7.2e-15
   Maximum Deviation : 3.1e-13
```

```
CIEDE2000 Verification Summary :
          Compliance : [X] CANONICAL [ ] SIMPLIFIED
  First Checked Line : 40.0,0.5,-128.0,49.91,0.0,24.0,1.0,1.0,1.0,51.01846301969812
           Precision : 11 decimal digits
           Successes : 100000000
               Error : 0
            Duration : 1421.49 seconds
     Average Delta E : 67.12
   Average Deviation : 7.5e-15
   Maximum Deviation : 3.1e-13
```

## Public Domain Licence

You are free to use these files, even for commercial purposes.
