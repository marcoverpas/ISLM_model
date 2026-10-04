# A Dynamic, Stock-Flow Consistent IS-LM Model

Code and interactive model for:

> Veronese Passarella, M. (2026). "Mr. Keynes and the 'Classics' (Almost) a Century Later: Reviewing the IS-LM Model." *Journal of Post Keynesian Economics*. Open access. DOI: [10.1080/01603477.2026.2734483](https://doi.org/10.1080/01603477.2026.2734483)

## What the paper shows

The IS-LM model is still the standard tool for teaching macroeconomics, and it quietly shapes a good deal of policy reasoning. This paper takes it seriously: it makes the model dynamic and stock-flow consistent, that is, it tracks where every unit of money actually goes. Once the accounting is made watertight, several textbook conclusions no longer hold:

- Tight monetary policy can raise or lower output, depending on the parameters.
- Targeting the money supply tends to be destabilizing, whereas targeting the interest rate is not.
- The very first move taught to students, shifting one curve and reading off the new intersection, loses its footing, because the IS and LM blocks are not independent once accounting is imposed.

The conclusion is that the IS-LM model should be questioned as both a teaching and a policy tool, in favour of stock-flow consistent dynamic models.

## Interactive model

A free, browser-based version of the basic model lets you change the policy rate, the money supply, government spending, the tax rate and the interest elasticity of investment, and watch the economy respond in real time.

[![Launch the interactive model](https://img.shields.io/badge/launch-interactive%20model-2ea44f?style=for-the-badge)](https://x52gnt-marco-passarella.shinyapps.io/interactive_is-lm/)

Direct link: https://x52gnt-marco-passarella.shinyapps.io/interactive_is-lm/

It also works well as a classroom device: students can reproduce the paradoxes and the instability for themselves, rather than taking them on faith.

### How to use it

1. **Choose the closure.** *Flat LM (endogenous M)*: the central bank sets the interest rate and the money stock adjusts. *Upward-sloping LM (exogenous M)*: the central bank sets the money stock and the interest rate adjusts. The slider that is not a policy instrument under the selected closure is greyed out.
2. **Move a slider.** The economy starts from its steady state. The new value applies from the third of 40 simulated periods onwards, so each chart shows the initial position followed by the adjustment path. Leaving all sliders untouched gives flat lines.
3. **Read the charts.** Panels a) to f) show output, the interest rate, the money stock, the bills held by the private sector, investment and consumption. Panel g) compares tax revenue with total government outlays (spending plus interest payments). Panel h) compares the interest elasticity of investment with the term *B<sub>h</sub>*(1 − θ)/θ, which governs the sign of the effect of the interest rate on output for a given stock of bills. Panel i) shows the IS-LM diagram in the final period: the faded curves and the grey dot mark the initial position, so that every shift can be read against it.
4. **Reset.** *Reset baseline values* returns all sliders to the baseline. It does not change the closure.

### Coefficients

Controls (sliders):

| Symbol | Description | Baseline | Range | Step |
|--------|-------------|----------|-------|------|
| *r*<sub>0</sub> | Policy rate (active under the flat LM) | 0.03 | 0 to 0.10 | 0.001 |
| *M*<sub>0</sub> | Money supply (active under the upward-sloping LM) | 3.48 | 1.48 to 5.48 | 0.01 |
| *G*<sub>0</sub> | Government spending | 10 | 0 to 20 | 0.5 |
| θ | Average tax rate on income | 0.30 | 0.05 to 0.40 | 0.01 |
| ι<sub>1</sub> | Elasticity of investment to the interest rate (absolute value) | 56.7 | 0 to 180 | 0.1 |

Fixed parameters (as in Table 3 of the paper):

| Symbol | Description | Value |
|--------|-------------|-------|
| ι<sub>0</sub> | Autonomous investment | 2 |
| ι<sub>2</sub> | Elasticity of investment to expected demand | 0.05 |
| α<sub>1</sub> | Marginal propensity to consume out of disposable income | 0.6 |
| α<sub>2</sub> | Marginal propensity to consume out of net wealth | 0.4 |
| λ<sub>0</sub> | Autonomous share of liquidity demand to net wealth | 0.1 |
| λ<sub>1</sub> | Elasticity of liquidity demand to disposable income | 0.1 |
| λ<sub>2</sub> | Elasticity of liquidity demand to the interest rate (absolute value) | 2 |

Initial steady state implied by the baseline:

| Variable | Value |
|----------|-------|
| Output (*Y*) | 36.98 |
| Consumption = disposable income = net wealth (*C* = *YD* = *V*) | 24.83 |
| Investment (*I*) | 2.15 |
| Tax revenue (*T*) | 10.64 |
| Bills held by the private sector (*B<sub>h</sub>*) | 21.35 |
| Money stock (*M* = *L*) | 3.48 |

### How the baseline differs from the paper

The interactive model uses the equations of the basic model, but not the calibration of Table 3. Two coefficients differ: the tax rate is 0.30 (0.20 in Table 3) and the interest elasticity of investment is 56.71 (20 in Table 3). The latter is the value at which the steady-state effect of the interest rate on output, d*Y*\*/d*r*, is exactly zero at *r* = 3%. The baseline therefore sits on the frontier between the two regimes discussed in the paper, and the user decides which side to explore:

- lower ι<sub>1</sub> or θ: tight money *raises* output (the paradox of the interest rate);
- raise ι<sub>1</sub> or θ: tight money *lowers* output (the conventional sign).

To reproduce the calibration of Table 3, set θ = 0.20 and ι<sub>1</sub> = 20. Note that the starting point remains the steady state of the interactive baseline, so the economy first travels to the new steady state.

The sliders display rounded values for *M*<sub>0</sub> and ι<sub>1</sub>; the exact baseline values (3.475917 and 56.71142) are used in the computations.

### Things to try

- **The paradox.** Under the flat LM, lower ι<sub>1</sub> to 20 and note where output settles. Then raise the policy rate to 5%: output settles at a higher level. Repeat with ι<sub>1</sub> = 80: output now settles at a lower level.
- **The frontier.** At the baseline, move the policy rate by one or two points in either direction: output ends almost exactly where it started.
- **Money versus interest rate targeting.** Under the upward-sloping LM, reduce *M*<sub>0</sub> and compare the adjustment of the interest rate and output with that obtained by raising the policy rate under the flat LM.
- **The interest rate floor.** Under the upward-sloping LM, raise *M*<sub>0</sub> to its maximum or cut *G*<sub>0</sub> to 5. The interest rate reaches zero and the money stock becomes demand-determined (panel c).
- **Fiscal policy and the budget.** Change *G*<sub>0</sub> or θ and follow, in panel g), how tax revenue catches up with government outlays as the economy approaches its new steady state.

### Modelling notes

- **Zero lower bound.** Under exogenous money the interest rate cannot fall below zero. When the floor binds, the money stock is determined by the demand for liquidity, so that the accounting remains watertight.
- **Investment floor.** Investment cannot be negative. With a high ι<sub>1</sub> or a high interest rate it falls to zero, which appears as a vertical segment of the IS curve in panel i).
- **Panel i).** The IS curve is drawn for the final period, holding consumption and government spending at their final values. The slope of the upward-sloping LM is illustrative: the curve is drawn through the final equilibrium.
- **Consistency check.** At each run the redundant equation (*M* = *L*) is verified, and the result is printed to the R console.
- **Low tax rates.** With a very low θ, interest payments feed on themselves and output does not settle within the 40 periods shown.

## Replication code

| File | What it does | Figures |
|------|--------------|---------|
| `ISLM_model_SHORT_WEB.R` | Basic (short-run) model, both closures | Figures 2 and 3 with `Stype = 0`, Figure 5 with `Stype = 1` |
| `ISLM_model_LONG_WEB.R` | Extended model (production function, flexible prices, capital accumulation, private securities) | Figure 7 with `Stype = 0` |

Both scripts use base R only, with no additional packages. Open a file, set `Stype` near the top to choose the experiment (0 = tight money, 1 = expansionary), and run the whole script. The figures are drawn on screen. The other scripts behind the paper (the stability and sensitivity exercises, the static IS-LM diagram and the accounting tables) are available from the author on request.

## Licence

The code in this repository is licensed under CC BY-NC 4.0 (see the [LICENSE](LICENSE) file). The article itself is open access under a Creative Commons Attribution (CC BY) licence.

## How to cite

> Veronese Passarella, M. (2026). "Mr. Keynes and the 'Classics' (Almost) a Century Later: Reviewing the IS-LM Model." *Journal of Post Keynesian Economics*. DOI: 10.1080/01603477.2026.2734483

```bibtex
@article{VeronesePassarella2026ISLM,
  author  = {Veronese Passarella, Marco},
  title   = {Mr. Keynes and the `Classics' (Almost) a Century Later: Reviewing the IS-LM Model},
  journal = {Journal of Post Keynesian Economics},
  year    = {2026},
  doi     = {10.1080/01603477.2026.2734483}
}
```
