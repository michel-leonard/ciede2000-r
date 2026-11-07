# This function written in R is not affiliated with the CIE (International Commission on Illumination),
# and is released into the public domain. It is provided "as is" without any warranty, express or implied.

# The classic vectorized CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
# "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
ciede2000 <- function(l1, a1, b1, l2, a2, b2, kl = 1.0, kc = 1.0, kh = 1.0, canonical = FALSE) {
	# Working in R with the CIEDE2000 color-difference formula.
	# kl, kc, kh are parametric factors to be adjusted according to
	# different viewing parameters such as textures, backgrounds...
	c1 <- b1 * b1;
	c2 <- b2 * b2;
	n <- sqrt(a1 * a1 + c1);
	n <- n + sqrt(a2 * a2 + c2);
	n <- n * 0.5;
	n <- n ^ 7.0;
	n <- n / (n + 6103515625.0);
	n <- sqrt(n);
	n <- n * 0.5;
	n <- 1.5 - n; # The chroma correction factor.

	# atan2 is preferred over atan because it accurately computes the angle of
	# a point (x, y) in all quadrants, handling the signs of both coordinates.
	c <- a1 * n;
	c1 <- c1 + c * c;
	c1 <- sqrt(c1);
	hm <- atan2(b1, c);
	hm <- hm + ifelse(hm < 0.0, 2.0 * pi, 0.0);

	c <- a2 * n;
	c2 <- c2 + c * c;
	c2 <- sqrt(c2);
	h <- atan2(b2, c);
	h <- h + ifelse(h < 0.0, 2.0 * pi, 0.0);

	# When the hue angles lie in different quadrants, the straightforward
	# average can produce a mean that incorrectly suggests a hue angle in
	# the wrong quadrant, the next 14 lines handle this issue.
	h <- h - hm;
	n <- pi + 1E-14 < abs(h);
	h <- h * 0.5; # h_delta
	hm <- hm + h; # h_mean

	# The part where most programmers get it wrong.
	h[n] <- h[n] + pi;
	if (canonical) {
		# Sharma’s implementation, OpenJDK, ...
		hm[n] <- hm[n] + ifelse(pi + 1E-14 < hm[n], -pi, pi);
	} else {
		# Lindbloom’s implementation, Netflix’s VMAF, ...
		hm[n] <- hm[n] + pi;
	}
	h <- 2.0 * sin(h);
	h <- h * sqrt(c1 * c2);

	# Application of the chroma correction factor.
	c <- c1 + c2;
	n <- 0.5 * c;
	n <- n ^ 7.0;
	n <- n / (n + 6103515625.0);

	# The hue rotation correction term is designed to account for the
	# non-linear behavior of hue differences in the blue region.
	r_t <- -2.0 * sqrt(n);
	n <- 36.0 * hm;
	n <- n - 55.0 * pi;
	n <- n / (5.0 * pi);
	n <- n * n;
	n <- exp(-n);
	n <- n * (pi / 3.0);
	r_t <- r_t * sin(n);

	# These coefficients adjust the impact of different harmonic
	# components on the hue difference calculation.
	n <- 150.0;
	n <- n - 25.5 * sin(hm + pi / 3.0);
	n <- n + 36.0 * sin(2.0 * hm + pi * 0.5);
	n <- n + 48.0 * sin(3.0 * hm + 8.0 * pi / 15.0);
	n <- n - 30.0 * sin(4.0 * hm + 3.0 * pi / 20.0);
	hm <- FALSE; # Not used anymore.
	n <- n / 20000.0;
	n <- n * c;
	n <- n + 1.0;
	n <- n * kh;
	# Hue.
	h <- h / n;

	# Lightness.
	l <- l2 - l1;
	n <- l1 + l2;
	n <- n * 0.5;
	n <- n - 50.0;
	n <- n * n;
	n <- n / sqrt(20.0 + n);
	n <- n * 3.0;
	n <- n / 200.0;
	n <- n + 1.0;
	n <- n * kl;
	l <- l / n;

	# Chroma.
	n <- 9.0 * c;
	n <- n / 400.0;
	c <- c2 - c1;
	n <- n + 1.0;
	n <- n * kc;
	c <- c / n;
	c1 <- FALSE; c2 <- FALSE; n <- FALSE; # Not used anymore.

	cie00 <- l * l;
	cie00 <- cie00 + h * h;
	h <- h * r_t;
	h <- h + c;
	cie00 <- cie00 + c * h;
	cie00 <- sqrt(cie00);
	# The result accurately reflects the geometric distance in the color space.
	# The function allocates no more than 9 temporary vectors at any one time.
	return(cie00);
}

# If you remove the constant 1E-14, the code will continue to work, but CIEDE2000
# interoperability between all programming languages will no longer be guaranteed.

# Source code tested by Michel LEONARD
# Website: ciede2000.pages-perso.free.fr
