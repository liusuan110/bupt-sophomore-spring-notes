"""
Generate CLT convergence visualization for the paper.
Outputs:
  - clt_convergence.svg: B(n, 0.4) PMF (bars) overlaid with N(np, np(1-p)) density (curve)
                        for n = 5, 20, 100
  - berry_esseen.svg:   actual sup-norm error vs. Berry-Esseen upper bound, log-log
"""
import math
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import binom, norm
import os

OUT_DIR = os.path.dirname(os.path.abspath(__file__))

# Minimal academic style
plt.rcParams.update({
    "font.family": "serif",
    "font.serif": ["CMU Serif", "Times New Roman", "Times", "DejaVu Serif"],
    "mathtext.fontset": "cm",
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.linewidth": 0.6,
    "xtick.major.width": 0.6,
    "ytick.major.width": 0.6,
    "xtick.labelsize": 8,
    "ytick.labelsize": 8,
    "axes.labelsize": 9,
    "axes.titlesize": 10,
    "legend.fontsize": 8,
    "legend.frameon": False,
    "svg.fonttype": "path",
})

# =========================================================
# Figure 1: B(n, p) -> N convergence
# =========================================================
def plot_binom_to_normal():
    p = 0.4
    ns = [5, 20, 100]
    fig, axes = plt.subplots(1, 3, figsize=(8.5, 2.6))
    bar_handle = None
    line_handle = None
    for ax, n in zip(axes, ns):
        mu, sigma = n*p, math.sqrt(n*p*(1-p))
        k = np.arange(0, n+1)
        pmf = binom.pmf(k, n, p)
        bars = ax.bar(k, pmf, width=0.85, color="#a8c5e8",
                      edgecolor="#3d6699", linewidth=0.5, label="$B(n,p)$ PMF")
        x = np.linspace(max(0, mu-4*sigma), min(n, mu+4*sigma), 400)
        line, = ax.plot(x, norm.pdf(x, mu, sigma), color="#c0392b",
                        linewidth=1.4, label=r"$\mathcal{N}(np,\, np(1-p))$")
        bar_handle, line_handle = bars, line
        ax.set_title(f"$n={n}$")
        ax.set_xlabel("$k$")
        if n == 5:
            ax.set_ylabel("probability")
        # Tight x-range
        lo = max(0, mu - 3.5*sigma)
        hi = min(n, mu + 3.5*sigma)
        ax.set_xlim(lo - 0.5, hi + 0.5)
        # Headroom so the curve peak never collides with the title
        ax.set_ylim(top=ax.get_ylim()[1] * 1.12)
    # Single shared legend above all panels — keeps it off the data
    fig.legend(handles=[bar_handle, line_handle],
               labels=["$B(n,p)$ PMF", r"$\mathcal{N}(np,\, np(1-p))$"],
               loc="upper center", ncol=2, bbox_to_anchor=(0.5, 1.06),
               frameon=False)
    fig.tight_layout()
    out = os.path.join(OUT_DIR, "clt_convergence.svg")
    fig.savefig(out, bbox_inches="tight", transparent=True)
    plt.close(fig)
    print(f"wrote {out}")

# =========================================================
# Figure 2: Berry-Esseen error scaling
# =========================================================
def plot_berry_esseen():
    # X_i ~ Bernoulli(0.5): mu=0.5, sigma^2=0.25, rho = E|X-mu|^3 = (0.5)^3 = 0.125
    # Y_n = (S_n - n*0.5) / (0.5 * sqrt(n))
    p = 0.5
    mu = p
    sigma = math.sqrt(p*(1-p))
    rho = abs(0 - mu)**3 * (1-p) + abs(1 - mu)**3 * p  # = 0.125

    ns = np.array([5, 10, 20, 50, 100, 200, 500, 1000])
    actual_err = []
    for n in ns:
        # CDF of (S_n - n*mu)/(sigma*sqrt(n)) at points x; S_n ~ B(n, p)
        # F_{Y_n}(x) = P(S_n <= n*mu + sigma*sqrt(n)*x)
        x_grid = np.linspace(-4, 4, 401)
        thresholds = n*mu + sigma*math.sqrt(n)*x_grid
        Fn = binom.cdf(np.floor(thresholds), n, p)
        Phi = norm.cdf(x_grid)
        err = np.max(np.abs(Fn - Phi))
        actual_err.append(err)
    actual_err = np.array(actual_err)
    # Berry-Esseen bound: C * rho / (sigma^3 * sqrt(n)), C = 0.4748
    C = 0.4748
    be_bound = C * rho / (sigma**3 * np.sqrt(ns))

    fig, ax = plt.subplots(figsize=(5.2, 3.2))
    ax.loglog(ns, actual_err, "o-", color="#3d6699", linewidth=1.2,
              markersize=4, label="actual $\\sup_x|F_{Y_n}(x)-\\Phi(x)|$")
    ax.loglog(ns, be_bound, "s--", color="#c0392b", linewidth=1.2,
              markersize=4, label=f"Berry-Esseen bound  ($C={C}$)")
    ax.set_xlabel("$n$")
    ax.set_ylabel("uniform error")
    ax.legend(loc="lower left")
    ax.grid(True, which="both", linewidth=0.3, alpha=0.4)
    fig.tight_layout()
    out = os.path.join(OUT_DIR, "berry_esseen.svg")
    fig.savefig(out, bbox_inches="tight", transparent=True)
    plt.close(fig)
    print(f"wrote {out}")

if __name__ == "__main__":
    plot_binom_to_normal()
    plot_berry_esseen()
