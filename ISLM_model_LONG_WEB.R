# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# A dynamic, stock-flow consistent (SFC) IS-LM model: extended version
# (production function, flexible prices, capital accumulation, private securities)
#
# Companion code to:
#   Veronese Passarella, M. (2026). "Mr. Keynes and the 'Classics' (Almost) a
#   Century Later: Reviewing the IS-LM Model." Journal of Post Keynesian
#   Economics. Open access. DOI: 10.1080/01603477.2026.2734483
#
# Author:  Marco Veronese Passarella
# Version: 2 October 2026
#
# What this script does.
#   It builds and simulates the extended (medium-to-long-run) SFC IS-LM model of
#   Section 3.5 of the paper. Relative to the basic version it adds a neoclassical
#   production function, a flexible price level, capital accumulation and private
#   securities issued by firms. It performs an accounting consistency check and
#   then reproduces the figures. With Stype = 0 it generates the tight-money
#   experiment of the complete model (Figure 7). With Stype = 1 it generates the
#   expansionary experiment (Figure 8, which is not shown in the paper).
#
# Licence.
#   This code is released under the Creative Commons Attribution-NonCommercial
#   4.0 International licence (CC BY-NC 4.0), as stated in the LICENSE file of
#   this repository. The article itself is open access under a Creative Commons
#   Attribution (CC BY) licence. If you use or adapt the code, please cite the
#   paper above.
#
# How to use.
#   Set Stype to choose the experiment (0 = tight money, 1 = expansionary),
#   then run the whole script. The figures are drawn on screen.
#
# Variable legend.
#   Flows.  I investment, S saving, Y national income, C consumption,
#           G government spending, TAX taxes, YD disposable income,
#           W labour income, A internal funds (retained profits),
#           g growth rate of national income, Yn potential (natural) output.
#   Stocks. M money supply, L liquidity demand, V net wealth,
#           Bs bills supplied by the government, Bh bills held by households,
#           Bcb bills held by the central bank, Es securities supplied by firms,
#           Eh securities held by households, K fixed capital, K_t target capital,
#           N labour force.
#   Rates and coefficients. rb interest rate on bills, re interest rate on
#           securities, rshock shock to the interest rate, Mshock shock to the
#           money supply, Ak total factor productivity, kappa target
#           capital-to-output ratio, pi inflation rate, P price level.
#   Scenarios (rows of each matrix).
#           1 endogenous money, baseline
#           2 endogenous money, policy shock
#           3 exogenous money, baseline
#           4 exogenous money, policy shock
#           5 exogenous money with zero lower bound, baseline
#           6 exogenous money with zero lower bound, policy shock
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# PREPARE THE WORKSPACE ####
# Clear environment
rm(list = ls(all = TRUE))

# Clear plots
if (!is.null(dev.list())) dev.off()

# Clear console
cat("\014")

# Number of periods
nPeriods = 150

# Number of scenarios (see the legend above)
nScenarios = 6

# SET THE COEFFICIENTS (PARAMETERS AND EXOGENOUS VARIABLES) ####
alpha1 = 0.6    # Marginal propensity to consume out of disposable income
alpha2 = 0.4    # Marginal propensity to consume out of net wealth
lambda10 = 0.3  # Autonomous share of liquidity demand to net wealth
lambda11 = 0.1  # Elasticity of liquidity demand to disposable income
lambda12 = 1    # Elasticity of liquidity demand to the interest rate on bills
lambda13 = 1    # Elasticity of liquidity demand to the interest rate on securities
G0 = 10         # Government spending
M0 = 1          # Initial value of the money supply (when money is exogenous)
r0 = 0.03       # Target policy rate
theta = 0.3     # Average tax rate (higher than in the basic model, see Section 3.5)
alphak = 0.5    # Output elasticity of capital in the production function
gamma_p = 0.001 # Speed of adjustment of the price level to the output gap
gamma_n = 0.25  # Speed of adjustment of the labour force to output
delta = 0.2     # Depreciation rate of fixed capital
gamma_k = 0.15  # Speed of adjustment of the capital stock to its target
kappa0 = 1      # Target capital-to-output ratio: autonomous component
kappa1 = 7      # Target capital-to-output ratio: interest rate elasticity

# CREATE VARIABLES AND ASSIGN INITIAL VALUES ####
# Flows
I = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Investment
S = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Saving
Y = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # National income
g = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Growth rate of income
TAX = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)  # Tax revenue
C = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Consumption
G = matrix(data = G0, nrow = nScenarios, ncol = nPeriods)   # Government spending
YD = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)   # Disposable income
W = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Labour income
A = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Internal funds
Yn = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)   # Potential output

# Stocks
M = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Money supply
Mshock = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)  # Shock to money supply
L = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Liquidity demand
V = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Net wealth
Bs = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)   # Bills supplied by the government
Bh = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)   # Bills held by households
Bcb = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)  # Bills held by the central bank
Es = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)   # Securities supplied by firms
Eh = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)   # Securities held by households
K = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)    # Fixed capital stock
K_t = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)  # Target capital stock

# Labour force, initialised at the value that places the model at its steady state
N = matrix(data = 52.08297, nrow = nScenarios, ncol = nPeriods)

# Rates and coefficients
rb = matrix(data = r0, nrow = nScenarios, ncol = nPeriods)      # Interest rate on bills
rshock = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)   # Shock to the interest rate
re = matrix(data = r0, nrow = nScenarios, ncol = nPeriods)      # Interest rate on securities
Ak = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)       # Total factor productivity
kappa = matrix(data = kappa0 - kappa1 * r0, nrow = nScenarios, ncol = nPeriods)  # Target capital-to-output ratio
pi = matrix(data = 0, nrow = nScenarios, ncol = nPeriods)       # Inflation rate

# Prices
P = matrix(data = 1, nrow = nScenarios, ncol = nPeriods)        # Price level

# CHOOSE THE TYPE OF MONETARY POLICY SHOCK ####
# Note. Stype = 0 is a tight shock, Stype = 1 is an expansionary shock
Stype = 0

if (Stype == 0) {
  Mshock0 = -0.03
  rshock0 = 0.02
}
if (Stype == 1) {
  Mshock0 = 0.09
  rshock0 = -0.03
}

# RUN THE MODEL ####
# Note. Each period is solved by iteration (Gauss-Seidel), so the order of the
# equations within a period does not matter: 200 iterations are more than
# enough for the within-period values to converge to the simultaneous solution.

# Loop over scenarios
for (j in 1:nScenarios) {

  # Loop over time
  for (i in 2:nPeriods) {

    # Loop for the iterative (within-period) solution
    for (iterations in 1:200) {

      # Endogenous-money shock, applied from period 21 onward
      if (j == 2 && i > 20) {rshock[j, i] = rshock0}

      # Exogenous-money shock (with or without the zero lower bound), from period 21
      if ((j == 4 || j == 6) && i > 20) {Mshock[j, i] = Mshock0}

      # Fiscal block
      G[j, i] = G0
      TAX[j, i] = theta * (W[j, i] + rb[j, i - 1] * Bh[j, i - 1] + re[j, i - 1] * Eh[j, i - 1])

      # IS block (flows), now with capital accumulation
      I[j, i] = gamma_k * (K_t[j, i - 1] - K[j, i - 1]) + delta * K[j, i - 1]
      K_t[j, i] = kappa[j, i] * Y[j, i]
      K[j, i] = K[j, i - 1] + I[j, i] - delta * K[j, i - 1]
      kappa[j, i] = kappa0 - kappa1 * (re[j, i - 1] - pi[j, i - 1])
      S[j, i] = YD[j, i] - C[j, i] * P[j, i]
      YD[j, i] = W[j, i] + rb[j, i - 1] * Bh[j, i - 1] + re[j, i - 1] * Eh[j, i - 1] - TAX[j, i]
      W[j, i] = Y[j, i] * P[j, i] - A[j, i] - re[j, i - 1] * Eh[j, i - 1]
      A[j, i] = delta * K[j, i - 1] * P[j, i]
      Y[j, i] = C[j, i] + I[j, i] + G[j, i]
      C[j, i] = alpha1 * YD[j, i] / P[j, i] + alpha2 * V[j, i - 1] / P[j, i]

      # LM block (stocks), now with private securities
      L[j, i] = lambda10 * V[j, i] + lambda11 * YD[j, i] - lambda12 * rb[j, i] * V[j, i] - lambda13 * re[j, i] * V[j, i]
      Eh[j, i] = Es[j, i]
      Es[j, i] = Es[j, i - 1] + (P[j, i] * K[j, i] - P[j, i - 1] * K[j, i - 1])
      Bs[j, i] = Bs[j, i - 1] + G[j, i] * P[j, i] + rb[j, i - 1] * (Bs[j, i - 1] - Bcb[j, i - 1]) - TAX[j, i]
      Bcb[j, i] = Bs[j, i] - Bh[j, i]
      Bh[j, i] = V[j, i] - L[j, i] - Eh[j, i]
      V[j, i] = V[j, i - 1] + S[j, i]

      # Closure A. Endogenous money (flat LM): the rate is set, money adjusts
      if (j == 1 || j == 2) {
        M[j, i] = Bcb[j, i]
        rb[j, i] = r0 + rshock[j, i]
      }

      # Closure B. Exogenous money (upward-sloping LM): money is set, the rate
      # clears the money market. A one-period lag avoids simultaneity
      if (i > 3 && j > 2) {
        rb[j, i] = (lambda10 * V[j, i] + lambda11 * YD[j, i] - lambda13 * re[j, i] * V[j, i] - M[j, i]) / (lambda12 * V[j, i])
        M[j, 3] = M0
        # Friedman-like money rule, with a zero floor on the money stock
        M[j, i] = max(0, M[j, i - 1] * (1 + g[j, i - 1]) + Mshock[j, i])
        # Zero lower bound (scenarios 5 and 6)
        if (j > 4 && rb[j, i - 1] <= 0) {
          rb[j, i] = 0
          M[j, i] = Bcb[j, i]
        }
      }

      # Interest rate on securities
      re[j, i] = r0 + rshock[j, i]

      # Long-run (production) block. Up to period 79 the natural level of output
      # tracks actual output and total factor productivity is backed out, so the
      # economy starts from its own steady state. From period 80 on, potential
      # output follows a Cobb-Douglas production function
      if (i < 80) {
        Yn[j, i] = Y[j, i]
        Ak[j, i] = Yn[j, i] / (K[j, i - 1]^alphak * N[j, i - 1]^(1 - alphak))
      } else {
        Ak[j, i] = Ak[j, i - 1]
        Yn[j, i] = Ak[j, i] * K[j, i - 1]^alphak * N[j, i - 1]^(1 - alphak)
      }

      # Prices and employment. Prices are fixed up to period 89, then react to
      # the output gap
      if (i < 90) {
        P[j, i] = 1
      } else {
        P[j, i] = P[j, i - 1] * exp(gamma_p * (Y[j, i - 1] - Yn[j, i - 1]))
      }
      pi[j, i] = (P[j, i] / P[j, i - 1]) - 1
      N[j, i] = N[j, i - 1] + gamma_n * (Y[j, i] - Y[j, i - 1])

      # Growth rate of national income (used by the money rule above)
      if (i > 3) {g[j, i] = Y[j, i] / Y[j, i - 1] - 1}

    }
  }
}

# CONSISTENCY CHECK (REDUNDANT EQUATION) ####
# Note. By Walras' Law one equation is redundant. Under endogenous money the
# hidden equation is M = L, so (M - L) should be nil for scenario 1.
error = 0
for (i in 2:(nPeriods - 1)) {error = error + (M[1, i] - L[1, i])^2}
aerror = error / nPeriods

if (aerror < 0.01) {
  cat(" *********************************** \n Good news! The model is watertight! \n", "Average error =", aerror, "< 0.01 \n", "Cumulative error =", error, "\n ***********************************")
} else {
  if (aerror < 1) {
    cat(" *********************************** \n Minor issues with model consistency \n", "Average error =", aerror, "> 0.01 \n", "Cumulative error =", error, "\n ***********************************")
  } else {
    cat(" ******************************************* \n Warning: the model is not fully consistent! \n", "Average error =", aerror, "> 1 \n", "Cumulative error =", error, "\n *******************************************")
  }
}

# PLOT THE CONSISTENCY CHECK ####
# Define the layout
layout(matrix(c(1), 1, 1, byrow = TRUE))
par(mar = c(5.1 + 1, 4.1 + 1, 4.1 + 1, 2.1 + 1))

# Display the redundant equation under both closures
plot(M[1, 4:nPeriods] - L[1, 4:nPeriods], type = "l", col = "green", lwd = 3, lty = 1, font.main = 1, cex.main = 1.5,
     main = expression("a) Consistency check: " * italic(M) - italic(L) * " (endog. " * italic(M) * "), " * italic(M) - italic(Bcb) * " (exog. " * italic(M) * ") "),
     cex.axis = 1.5, cex.lab = 1.5, ylab = '£',
     xlab = 'Time', ylim = range(-2, 2))
lines((M[3, 4:nPeriods] - Bcb[3, 4:nPeriods]), col = "lightblue", lwd = 3, lty = 2)
legend("topright", c("Exogenous interest rate", "Exogenous money supply (approx.)"), bty = "n",
       cex = 1.5, lty = c(1, 2), lwd = c(3, 3), col = c("green", "lightblue"), box.lty = 0)

# REPRODUCE THE FIGURES OF THE PAPER ####
# Tight-money experiment (Stype = 0): Figure 7 of the paper
if (Stype == 0) {

  # Figure 7
  layout(matrix(c(1, 2), 1, 2, byrow = TRUE))
  par(mar = c(5.1 + 1, 4.1 + 1, 4.1 + 1, 2.1 + 1))

  # Demand components after a tight shock, endogenous money
  plot(Y[2, 2:nPeriods] / Y[1, 2:nPeriods], type = "l", col = "red1", lwd = 3, lty = 1, font.main = 1, cex.main = 1,
       main = "a) Demand components following tight monetary policy \n with endogenous money (horizontal LM)",
       cex.axis = 1, cex.lab = 1, ylab = 'Ratio to baseline',
       xlab = 'Time', ylim = range(0.75, 1.05))
  lines(C[2, 2:nPeriods] / C[1, 2:nPeriods], col = "purple", lwd = 3, lty = 2)
  lines(I[2, 2:nPeriods] / I[1, 2:nPeriods], col = "blue", lwd = 3, lty = 3)
  lines(G[2, 2:nPeriods] / G[1, 2:nPeriods], col = "orange", lwd = 3, lty = 4)
  legend("right", c("Total demand", "Consumption", "Investment", "Government spending"), bty = "n",
         cex = 1, lty = c(1, 2, 3, 4), lwd = c(3, 3, 3, 3), col = c("red1", "purple", "blue", "orange"), box.lty = 0)

  # Demand components after a tight shock, exogenous money
  plot(Y[4, 2:nPeriods] / Y[3, 2:nPeriods], type = "l", col = "red1", lwd = 3, lty = 1, font.main = 1, cex.main = 1,
       main = "b) Demand components following tight monetary policy \n with exogenous money (upward-sloping LM)",
       cex.axis = 1, cex.lab = 1, ylab = 'Ratio to baseline',
       xlab = 'Time', ylim = range(0.9, 1.05))
  lines(C[4, 2:nPeriods] / C[3, 2:nPeriods], col = "purple", lwd = 3, lty = 2)
  lines(I[4, 2:nPeriods] / I[3, 2:nPeriods], col = "blue", lwd = 3, lty = 3)
  lines(G[4, 2:nPeriods] / G[3, 2:nPeriods], col = "orange", lwd = 3, lty = 4)
  legend("topleft", c("Total demand", "Consumption", "Investment", "Government spending"), bty = "n",
         cex = 1, lty = c(1, 2, 3, 4), lwd = c(3, 3, 3, 3), col = c("red1", "purple", "blue", "orange"), box.lty = 0)

}

# Expansionary experiment (Stype = 1): Figure 8 (not shown in the paper)
if (Stype == 1) {

  # Figure 8
  layout(matrix(c(1, 2, 3, 4), 2, 2, byrow = TRUE))
  par(mar = c(5.1 + 1, 4.1 + 1, 4.1 + 1, 2.1 + 1))

  # Interest rate under alternative expansionary rules (including the ZLB)
  plot(rb[2, 2:nPeriods] * 100, type = "l", col = "pink", lwd = 3, lty = 1, font.main = 1.2, cex.main = 1.2,
       main = "a) Interest rate after expans. monetary policy",
       cex.axis = 1.2, cex.lab = 1.2, ylab = '%',
       xlab = 'Time', ylim = range(-20, 40))
  lines(rb[4, 2:nPeriods] * 100, col = "tomato", lwd = 3, lty = 2)
  lines(rb[6, 2:nPeriods] * 100, col = "purple", lwd = 3, lty = 3)
  abline(h = 0, col = 1, lwd = 1, lty = 3)
  legend("topright", c("Interest rate policy", "Quantitative policy", "Quantitative policy with ZLB"), bty = "n",
         cex = 1.2, lty = c(1, 2, 3), lwd = c(3, 3, 3), col = c("pink", "tomato", "purple"), box.lty = 0)

  # Demand components, endogenous money
  plot(Y[2, 2:nPeriods] / Y[1, 2:nPeriods], type = "l", col = "red1", lwd = 3, lty = 1, font.main = 1.2, cex.main = 1.2,
       main = "b) Demand components following expans. monetary policy \n with endogenous money (horizontal LM)",
       cex.axis = 1.2, cex.lab = 1.2, ylab = 'Ratio to baseline',
       xlab = 'Time', ylim = range(0.85, 1.55))
  lines(C[2, 2:nPeriods] / C[1, 2:nPeriods], col = "purple", lwd = 3, lty = 2)
  lines(I[2, 2:nPeriods] / I[1, 2:nPeriods], col = "blue", lwd = 3, lty = 3)
  lines(G[2, 2:nPeriods] / G[1, 2:nPeriods], col = "orange", lwd = 3, lty = 4)
  legend("bottomleft", c("Total demand", "Consumption", "Investment", "Government spending"), bty = "n",
         cex = 1.2, lty = c(1, 2, 3, 4), lwd = c(3, 3, 3, 3), col = c("red1", "purple", "blue", "orange"), box.lty = 0)

  # Demand components, exogenous money
  plot(Y[4, 2:nPeriods] / Y[3, 2:nPeriods], type = "l", col = "red1", lwd = 3, lty = 1, font.main = 1.2, cex.main = 1.2,
       main = "c) Demand components following expans. monetary policy \n with exogenous money (upward-sloping LM)",
       cex.axis = 1.2, cex.lab = 1.2, ylab = 'Ratio to baseline',
       xlab = 'Time', ylim = range(0.6, 2.5))
  lines(C[4, 2:nPeriods] / C[3, 2:nPeriods], col = "purple", lwd = 3, lty = 2)
  lines(I[4, 2:nPeriods] / I[3, 2:nPeriods], col = "blue", lwd = 3, lty = 3)
  lines(G[4, 2:nPeriods] / G[3, 2:nPeriods], col = "orange", lwd = 3, lty = 4)
  legend("bottomleft", c("Total demand", "Consumption", "Investment", "Government spending"), bty = "n",
         cex = 1.2, lty = c(1, 2, 3, 4), lwd = c(3, 3, 3, 3), col = c("red1", "purple", "blue", "orange"), box.lty = 0)

  # Demand components, exogenous money with the zero lower bound
  plot(Y[6, 2:nPeriods] / Y[5, 2:nPeriods], type = "l", col = "red1", lwd = 3, lty = 1, font.main = 1.2, cex.main = 1.2,
       main = "d) Demand components following expans. monetary policy \n with exogenous money and ZLB",
       cex.axis = 1.2, cex.lab = 1.2, ylab = 'Ratio to baseline',
       xlab = 'Time', ylim = range(0.7, 2))
  lines(C[6, 2:nPeriods] / C[5, 2:nPeriods], col = "purple", lwd = 3, lty = 2)
  lines(I[6, 2:nPeriods] / I[5, 2:nPeriods], col = "blue", lwd = 3, lty = 3)
  lines(G[6, 2:nPeriods] / G[5, 2:nPeriods], col = "orange", lwd = 3, lty = 4)
  legend("bottomleft", c("Total demand", "Consumption", "Investment", "Government spending"), bty = "n",
         cex = 1.2, lty = c(1, 2, 3, 4), lwd = c(3, 3, 3, 3), col = c("red1", "purple", "blue", "orange"), box.lty = 0)

}
