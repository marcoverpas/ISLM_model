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
