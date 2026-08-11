#import "ams-style.typ": ams-paper
#import "@preview/ctheorems:1.1.3": *

#show: thmrules.with(qed-symbol: $square$)

// 定理环境（中文化）
#let theorem = thmbox(
  "theorem", "定理",
  fill: rgb("#f4f4f8"),
  base_level: 1,
  inset: (x: 0.8em, top: 0.6em, bottom: 0.6em),
)
#let lemma       = thmbox("theorem", "引理", fill: rgb("#f4f4f8"), base_level: 1)
#let proposition = thmbox("theorem", "命题", fill: rgb("#f4f4f8"), base_level: 1)
#let definition  = thmbox("definition", "定义",
  stroke: rgb("#888888") + 0.5pt, fill: none, base_level: 1)
#let remark      = thmplain("remark", "注", base_level: 1)
#let proof       = thmproof("proof", "证明")

// 数学速记
#let EE = math.upright("E")
#let PP = math.upright("P")
#let RR = math.bb("R")
#let NN = math.bb("N")
#let Var = math.op("Var")
#let convd = $arrow.r.long^(upright(d))$   // 依分布收敛
#let convp = $arrow.r.long^(upright(P))$   // 依概率收敛

#show: ams-paper.with(
  title: [特征函数及其在中心极限定理证明中的应用],
  title-en: [Characteristic Functions and Their Application
    in the Proof of the Central Limit Theorem],
  authors: (
    (name: [姓名], affiliation: [刘稣安]),
  ),
  abstract: [
    中心极限定理（CLT）是概率论的中心结果，它解释了正态分布在自然界中的普遍性。
    然而，主流本科教材通常仅给出 CLT 的结论而略去证明，使读者难以体会该定理背后的分析机理。
    本文以课程笔记的内容为起点，引入*特征函数*这一连接概率论与傅立叶分析的工具，
    系统介绍其定义、基本性质与计算，并在 Lévy 连续性定理的桥接下，
    给出 Lindeberg–Lévy 中心极限定理的完整证明。
    在此基础上，本文进一步讨论 Berry–Esseen 不等式对收敛速度的刻画，
    以及当二阶矩不存在时（如 Cauchy 分布）特征函数如何揭示更一般的 $alpha$-稳定分布族。
    全文配合二项分布到正态分布的数值收敛实验，以期实现"理论推导 + 代码验证"的双重视角。
  ],
  keywords: (
    [特征函数],
    [中心极限定理],
    [Lévy 连续性定理],
    [Berry–Esseen 不等式],
    [稳定分布],
  ),
  abstract-en: [
    The central limit theorem (CLT) is a cornerstone of probability theory, yet
    standard undergraduate texts typically state only its conclusion and omit
    the proof, leaving readers without insight into the underlying analytic mechanism.
    Building on the lecture notes of a course in probability and mathematical statistics,
    this paper introduces the *characteristic function*, a tool linking probability theory
    with Fourier analysis, and systematically develops its definition, fundamental properties,
    and computation for common distributions. Through Lévy's continuity theorem as a bridge,
    we present a complete proof of the Lindeberg–Lévy CLT, with particular attention to the
    rigorous justification of the Peano-form Taylor remainder under the second-moment condition.
    We further discuss the Berry–Esseen inequality, which sharpens the qualitative convergence
    into a quantitative $O(n^(-1\/2))$ bound, and the family of $alpha$-stable distributions
    that emerge when the second moment fails (as in the Cauchy distribution).
    Numerical experiments illustrating the convergence of binomial distributions to the normal
    accompany the theoretical development, combining rigorous derivation with computational verification.
  ],
  keywords-en: (
    [characteristic function],
    [central limit theorem],
    [Lévy continuity theorem],
    [Berry–Esseen inequality],
    [stable distribution],
  ),
)

// ===================================================================
= 引言

中心极限定理（Central Limit Theorem，下文简称 CLT）刻画了一个深刻的事实：
当大量独立随机扰动叠加时，无论单个扰动遵循何种分布，
其规范化后的总和都会渐近地服从正态分布。
这一现象解释了为何正态分布在自然科学、社会科学以至工程实务中无处不在。

CLT 的研究有近三百年的历史。
1733 年 De Moivre 在研究二项分布尾概率时已经给出了今日所称 De Moivre–Laplace 定理的雏形；
Laplace 推广至一般独立同分布的情形；
19 世纪末 Chebyshev、Markov 用矩方法证明了独立但不必同分布的情形；
直到 20 世纪初 Lyapunov（1901）与 Lindeberg（1922）才在严格意义下完成了一般定理。
而本文所采用的*特征函数方法*则源自 Lévy（1925），它将概率论的卷积运算翻译为复函数的乘法，
从而把"分布的极限"问题转化为"函数的逐点极限"问题，极大地简化了证明。
这一方法的早期雏形可追溯至 Cauchy 与 Poincaré 关于傅立叶变换在概率论中的应用，
但真正使之成为成熟工具的，是 Lévy 与 Khintchine 在 1920–1930 年间确立的连续性定理与无穷可分分布理论。
此后，特征函数几乎成为现代概率极限理论的"通用语言"，
从 Berry–Esseen 不等式、Lindeberg 条件，到马尔可夫链的谱论与 Lévy 过程的构造，
皆可见其身影。

课程笔记《概率论与数理统计》在第五章中给出了 Lindeberg–Lévy 定理、Lyapunov 定理
与 De Moivre–Laplace 定理的*结论叙述*，但出于篇幅未呈现证明，也未引入特征函数这一工具。
本文意在填补这一空白：
第 2 节回顾必要的预备概念；
第 3 节系统建立特征函数的定义与性质；
第 4 节给出 Lévy 连续性定理；
第 5 节用 Taylor 展开完成 CLT 的证明，并对余项的严密性给予专门讨论；
第 6 节延伸至 Berry–Esseen 误差界与 Lévy 稳定分布族；
第 6.5 节给出数值实验。

为避免符号冲突，本文用 $Phi(x)$ 表示标准正态分布的累积分布函数（CDF），
而特征函数则统一记为 $phi.alt_X (t)$。

// ===================================================================
= 预备知识

回顾若干基本约定。设 $(Omega, cal(F), PP)$ 为概率空间，
随机变量 $X$ 的分布函数记为 $F_X (x) = PP(X <= x)$。

#definition("依分布收敛")[
  设 $X_n, X$ 是随机变量，分布函数分别为 $F_n, F$。
  若 $F_n (x) -> F(x)$ 对一切 $F$ 的连续点 $x$ 成立，
  则称 $X_n$ 依分布收敛到 $X$，记作 $X_n convd X$ 或 $F_n convd F$。
]

对一个实值随机变量 $X$，复随机变量 $e^(i t X) = cos(t X) + i sin(t X)$ 显然满足 $|e^(i t X)| = 1$，
因此对任意 $t in RR$，$EE[e^(i t X)]$ 都作为复值积分良定义。这是引入特征函数的可积性基础。

依概率收敛 $X_n convp X$（即 $forall epsilon > 0$，$PP(|X_n - X| > epsilon) -> 0$）
是更强的收敛模式：依概率收敛蕴含依分布收敛；反之一般不成立，
但当极限 $X$ 为常数时二者等价。课程已学的弱大数定律即依概率收敛的典型例子。

// ===================================================================
= 特征函数：定义与基本性质

#definition("特征函数")[
  设 $X$ 是随机变量，其*特征函数*定义为
  $ phi.alt_X (t) := EE[e^(i t X)] = EE[cos(t X)] + i EE[sin(t X)], quad t in RR. $ <eq:def-cf>
] <def:cf>

直观上，$phi.alt_X$ 是分布 $F_X$ 的 Fourier 变换；
它把"分布"这一难以直接相加的对象，转化为复平面上易于运算的解析函数。
以下列出特征函数最核心的七条性质，构成全文推导的工具箱。

#proposition("特征函数的基本性质")[
  设 $X, Y$ 为随机变量，$a, b in RR$，则
  + $phi.alt_X (0) = 1$ 且 $|phi.alt_X (t)| <= 1$；
  + $phi.alt_X$ 在 $RR$ 上*一致连续*；
  + （线性变换）$phi.alt_(a X + b) (t) = e^(i b t) phi.alt_X (a t)$；
  + （独立和）若 $X$ 与 $Y$ 独立，则 $phi.alt_(X + Y)(t) = phi.alt_X (t) phi.alt_Y (t)$；
  + （矩与导数）若 $EE|X|^n < oo$，则 $phi.alt_X$ 在 $RR$ 上 $n$ 次可微，
    且 $phi.alt_X^((k)) (0) = i^k EE[X^k]$，$k = 0, 1, dots, n$；
  + （唯一性定理）若 $phi.alt_X = phi.alt_Y$，则 $F_X = F_Y$；
  + （反演公式）若 $phi.alt_X$ 可积，则 $X$ 具有密度
    $ f_X (x) = 1/(2 pi) integral_(-oo)^(oo) e^(-i t x) phi.alt_X (t) dif t. $ <eq:inversion>
] <prop:cf-props>

#proof[
  性质 1 由 $|e^(i t X)| = 1$ 与三角不等式立得。
  性质 2 由控制收敛定理：
  $|phi.alt_X (t + h) - phi.alt_X (t)| <= EE|e^(i h X) - 1| -> 0$，$h -> 0$，且不依赖于 $t$。
  性质 3 由期望线性性直接展开。
  性质 4 利用独立性 $EE[e^(i t (X + Y))] = EE[e^(i t X)] dot EE[e^(i t Y)]$。
  性质 5 通过在期望符号下对 $t$ 求导，
  $|partial_t^k e^(i t X)| = |X|^k$，由 $EE|X|^k < oo$ 与控制收敛定理保证导数可在期望符号下取出。
  性质 6 与 7 是 Fourier 分析中的经典结果，证明涉及反演积分的紧性讨论，本文不予展开（见 Billingsley §26）。
]

性质 4 是后续 CLT 证明的真正"引擎"：它把概率论中最难计算的卷积运算翻译为函数乘法。
性质 5 则赋予特征函数局部 Taylor 展开的合法性，是连接矩与极限的桥梁。

为了在第 5 节直接使用，下表汇总常见分布的特征函数。

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    stroke: (x, y) => (
      top:    if y == 0 { 0.9pt } else { none },
      bottom: if y == 0 { 0.4pt } else if y == 6 { 0.9pt } else { none },
    ),
    inset: (x: 0.8em, y: 0.45em),
    table.header[*分布*][*参数*][*特征函数 $phi.alt(t)$*],
    [Bernoulli $B(1, p)$], [$0 < p < 1$], [$1 - p + p e^(i t)$],
    [Binomial $B(n, p)$],  [$n in NN$],   [$(1 - p + p e^(i t))^n$],
    [Poisson $cal(P)(lambda)$], [$lambda > 0$], [$exp{lambda(e^(i t) - 1)}$],
    [Uniform $U(a, b)$], [$a < b$], [$(e^(i b t) - e^(i a t))/(i(b - a) t)$],
    [Exponential $cal(E)(lambda)$], [$lambda > 0$], [$lambda / (lambda - i t)$],
    [Normal $cal(N)(mu, sigma^2)$], [$mu in RR, sigma > 0$], [$exp{i mu t - sigma^2 t^2 / 2}$],
  ),
  caption: [常见分布的特征函数。],
) <tab:cf-table>

我们以正态分布为例给出完整推导，因为该结果在 CLT 证明中扮演关键参照。
设 $X tilde cal(N)(0, 1)$，密度为 $f(x) = (2 pi)^(-1\/2) e^(-x^2\/2)$。
则
$ phi.alt_X (t) = 1/sqrt(2 pi) integral_(-oo)^(oo) e^(i t x) e^(-x^2/2) dif x
  = 1/sqrt(2 pi) integral_(-oo)^(oo) e^(-(x - i t)^2 / 2) e^(-t^2 / 2) dif x = e^(-t^2 / 2), $ <eq:phi-normal>
其中对积分作复变量平移 $x mapsto x + i t$（由 Gauss 函数在复平面上的解析性合法）。
由性质 3 立即得 $X tilde cal(N)(mu, sigma^2)$ 时 $phi.alt_X (t) = exp(i mu t - sigma^2 t^2 \/ 2)$。

作为对比，我们再考察两个具有不同特征的分布。
对 $X tilde cal(P)(lambda)$（Poisson 分布），$PP(X = k) = e^(-lambda) lambda^k \/ k!$。
直接级数求和给出
$ phi.alt_X (t) = sum_(k = 0)^oo e^(i t k) dot e^(-lambda) (lambda^k)/(k!)
  = e^(-lambda) sum_(k = 0)^oo ((lambda e^(i t))^k)/(k!) = exp{lambda(e^(i t) - 1)}. $ <eq:phi-poisson>
由此结合性质 4 可即时证明 Poisson 分布的可加性：$X_1 tilde cal(P)(lambda_1)$，$X_2 tilde cal(P)(lambda_2)$
独立时，$phi.alt_(X_1 + X_2)(t) = exp{(lambda_1 + lambda_2)(e^(i t) - 1)}$，
即 $X_1 + X_2 tilde cal(P)(lambda_1 + lambda_2)$。
对 $X tilde "Cauchy"(0, 1)$，则借助围道积分可证 $phi.alt_X (t) = e^(-|t|)$；
该结果将在第 6.2 节作为关键反例使用。
特征函数表 @tab:cf-table 中的其余条目（Bernoulli、Binomial、Uniform、Exponential）
均可由定义直接积分或求和得到，此处从略。

// ===================================================================
= Lévy 连续性定理

特征函数能为 CLT 提供证明的关键，在于一条把"特征函数收敛"翻译为"分布收敛"的定理。

#theorem("Lévy 连续性定理")[
  设 $X_n$ 是一列随机变量，特征函数为 $phi.alt_n$。
  + 若 $X_n convd X$，则 $phi.alt_n (t) -> phi.alt_X (t)$ 对一切 $t in RR$ 一致地于紧集上成立；
  + 若 $phi.alt_n (t) -> phi.alt(t)$ 对一切 $t in RR$ 逐点成立，
    且 $phi.alt$ 在 $t = 0$ 处连续，
    则 $phi.alt$ 是某分布函数 $F$ 的特征函数，且 $X_n convd F$。
] <thm:levy>

定理的方向 (1) 较易：由 $|e^(i t X)| = 1$ 与有界收敛定理直接得到。
方向 (2) 是真正的"桥"：它告诉我们，*只要证出特征函数的极限存在且在 $0$ 处连续，分布收敛便自动成立*。
其证明思路依赖紧性论证（Helly 选择原理）：分布函数列 $F_n$ 在 $RR$ 紧化下有子列收敛到某 $G$，
"$phi.alt$ 在 $0$ 处连续"这一条件用于排除"概率质量逃逸到无穷远"的退化情形，
从而保证 $G$ 仍是分布函数。详细证明见 Feller Vol. 2 第 XV 章或 Shiryaev §III.3。

"$t = 0$ 处连续"这一看似平凡的条件不可省去：若取 $X_n tilde cal(N)(0, n)$，
则 $phi.alt_n (t) = e^(-n t^2 \/ 2)$，对 $t = 0$ 恒为 $1$，对 $t != 0$ 收敛到 $0$。
极限 $phi.alt(t) = bb(1)_{t = 0}$ 在 $0$ 处不连续，对应的"分布" $G$ 全部概率质量都跑到了 $plus.minus oo$，
故 $X_n$ 不依分布收敛到任何（有限）分布。
这一反例生动展示了"$0$ 处连续"在排除质量逃逸方面的功能性。

至此，我们的证明路线图已经完整：
（i）写下 $phi.alt_(Y_n)$ 的表达式；
（ii）对其取 $n -> oo$ 的极限并证明该极限为 $e^(-t^2 / 2)$；
（iii）由 @thm:levy 与 @eq:phi-normal 得到 $Y_n convd cal(N)(0, 1)$。

// ===================================================================
= 中心极限定理的特征函数证明

下面给出本文的核心定理与证明。

#theorem("Lindeberg–Lévy 中心极限定理")[
  设 $X_1, X_2, dots$ 是独立同分布（independent and identically distributed, i.i.d.）
  随机变量序列，$EE X_i = mu$，$Var(X_i) = sigma^2 in (0, oo)$。
  记 $S_n = sum_(i = 1)^n X_i$，
  $ Y_n = (S_n - n mu)/(sigma sqrt(n)). $
  则 $Y_n convd cal(N)(0, 1)$，即 $forall x in RR$，
  $ lim_(n -> oo) PP(Y_n <= x) = Phi(x). $ <eq:clt>
] <thm:clt>

#proof[
  *第一步：化为均值零、方差一的情形。*
  令 $tilde(X)_i = (X_i - mu)/sigma$，则 $EE tilde(X)_i = 0$，$Var(tilde(X)_i) = 1$。
  注意 $Y_n = n^(-1\/2) sum_(i = 1)^n tilde(X)_i$。
  以下不妨设 $mu = 0$，$sigma = 1$。

  *第二步：写出 $Y_n$ 的特征函数。*
  由独立性与性质 3、4（@prop:cf-props），
  $ phi.alt_(Y_n) (t) = product_(i = 1)^n phi.alt_(tilde(X)_i \/ sqrt(n)) (t)
    = [phi.alt_X (t / sqrt(n))]^n, $ <eq:phi-Yn>
  其中 $phi.alt_X$ 是 $tilde(X)_1$ 的特征函数（同分布的共同特征函数）。

  *第三步：Taylor 展开。*
  由性质 5，$EE|X|^2 < oo$ 保证 $phi.alt_X$ 在 $0$ 处二阶可微，且
  $ phi.alt_X (0) = 1, quad phi.alt_X' (0) = i EE X = 0, quad phi.alt_X'' (0) = -EE X^2 = -1. $
  由 Peano 型余项的二阶 Taylor 展开：当 $s -> 0$ 时，
  $ phi.alt_X (s) = 1 + 0 dot s + (-1)/2 s^2 + o(s^2) = 1 - s^2 / 2 + o(s^2). $ <eq:taylor>

  *第四步：取极限。*
  代入 $s = t / sqrt(n)$，对*固定的* $t in RR$，当 $n -> oo$ 时 $s -> 0$，
  故余项可写作 $o(t^2 \/ n)$，即
  $ phi.alt_X (t / sqrt(n)) = 1 - t^2 / (2 n) + o(1 / n), quad n -> oo. $
  代入 @eq:phi-Yn 并取对数（对充分大的 $n$，括号内非零）：
  $ log phi.alt_(Y_n) (t) = n log[1 - t^2 / (2 n) + o(1 / n)]
    = n[-t^2 / (2 n) + o(1 / n)] = -t^2 / 2 + o(1). $ <eq:log-conv>
  因此 $phi.alt_(Y_n) (t) -> e^(-t^2 \/ 2) = phi.alt_(cal(N)(0,1))(t)$，对一切 $t in RR$ 成立。

  *第五步：调用 Lévy 连续性定理.*
  极限 $t |-> e^(-t^2 \/ 2)$ 显然在 $t = 0$ 处连续，
  由 @thm:levy 之 (2) 得 $Y_n convd cal(N)(0, 1)$。
]

== 严谨性补遗：Taylor 余项的均匀控制

证明的第三、四步在初学者看来最易跳步：
"$o(s^2)$ 怎么就变成了 $o(t^2 \/ n)$？为何 $n dot o(t^2 \/ n) = o(1)$？"
此处的逻辑链条值得明确写出，因为它*直接依赖于二阶矩 $EE X^2 < oo$ 的存在性*。

Peano 余项的精确含义是：存在函数 $epsilon : RR -> RR$，
满足 $epsilon(s) -> 0$（$s -> 0$），使得
$ phi.alt_X (s) = 1 - s^2 / 2 + s^2 epsilon(s). $
对固定的 $t$，代入 $s_n = t \/ sqrt(n)$，由 $s_n -> 0$ 推出 $epsilon(s_n) -> 0$。
因此 $s_n^2 epsilon(s_n) = (t^2 \/ n) dot epsilon(s_n) = o(1 / n)$，
代入 @eq:phi-Yn 并展开 $log(1 + x) = x + O(x^2)$ 得 @eq:log-conv。
关键之处在于：*$EE X^2 < oo$ 保证了二阶 Taylor 展开的合法性*，
若仅有 $EE|X| < oo$ 而 $EE X^2 = oo$（如 Cauchy 分布），$phi.alt_X$ 在 $0$ 处不再二阶可微，
上述展开失败，CLT 也将失效——这一点将在第 6.2 节再现。

值得指出的是，性质 5 仅断言 $phi.alt_X$ 在 $0$ 处*存在*二阶导数；
这是比"$C^2$（即 $phi.alt_X''$ 处处存在且连续）"更弱的条件，
对应于 Bochner 关于特征函数光滑性的精确刻画。
但对 CLT 证明，我们恰好只需在 $0$ 处的二阶 Taylor 展开，因此性质 5 已经足够。
此外，若令 $sigma_n^2 := Var(X)$ 等条件随 $n$ 变化（如 Lyapunov、Lindeberg 情形），
同样的特征函数策略仍然有效，只需把 Taylor 展开升级为含余项的 Lindeberg 条件估计。
这也表明：本文给出的 i.i.d. 证明只是更一般框架的一个特殊却基本的入口。

#remark("De Moivre–Laplace 作为特例")[
  取 $X_i tilde B(1, p)$，则 $mu = p$，$sigma^2 = p(1 - p)$，
  $S_n tilde B(n, p)$。由 @thm:clt 立得 $(S_n - n p) \/ sqrt(n p (1-p)) convd cal(N)(0, 1)$，
  即课程笔记中独立列出的 De Moivre–Laplace 定理。
]

// ===================================================================
= 延伸：从收敛性到收敛速度与稳定分布

至此读者可能产生两个自然的追问：
*问 1*：CLT 只告诉我们 $F_(Y_n) (x) -> Phi(x)$，但*收敛得多快*？
*问 2*：若 $X_i$ 的方差不存在（如 Cauchy 分布），$bar(X)_n$ 将渐近服从什么分布？
两问皆只能借助特征函数给出令人满意的回答。

== Berry–Esseen 不等式：CLT 的收敛速度

#theorem("Berry–Esseen 不等式")[
  设 $X_1, X_2, dots$ i.i.d.，$EE X_i = mu$，$Var(X_i) = sigma^2 > 0$，
  且 $EE|X_i - mu|^3 = rho < oo$。则存在绝对常数 $C$，使
  $ sup_(x in RR) |F_(Y_n) (x) - Phi(x)| <= (C rho) / (sigma^3 sqrt(n)), $ <eq:BE>
  其中 $Y_n = (S_n - n mu) \/ (sigma sqrt(n))$。目前已知的最优常数为 $C <= 0.4748$（Shevtsova, 2011）。
] <thm:BE>

@thm:BE 给出了 CLT 的*一致*误差界，其衰减速率为 $O(n^(-1\/2))$。
该定理的证明本质上是 Esseen 的*光滑不等式*：
若 $F$ 与 $G$ 是分布函数且 $G$ 充分光滑（如 $|G'| <= m$），则对任意 $T > 0$，
$ sup_x |F(x) - G(x)| <= 1/pi integral_(-T)^T |(phi.alt_F (t) - phi.alt_G (t))/t| dif t + (24 m)/(pi T). $
即"*分布函数距离 $<=$ 特征函数距离的积分*"。
正是这一翻译机制让我们得以从特征函数层面 $|phi.alt_(Y_n)(t) - e^(-t^2 \/ 2)|$ 的精细估计，
反推出 CDF 层面的一致界。而矩生成函数（仅在某些情形可定义）并不具备这样的光滑不等式工具，
这是特征函数方法的*不可替代之处*。

定理中三阶矩条件 $EE|X|^3 < oo$ 并非偶然：在二阶 Taylor 展开的余项处，需要
$|phi.alt_X (s) - (1 - s^2 \/ 2)| <= EE|X|^3 |s|^3 \/ 6$ 这一量化估计才能将余项控制为 $O(n^(-1\/2))$。
若仅有二阶矩，仍可证 $sup_x|F_(Y_n)(x) - Phi(x)| -> 0$（即 CLT 本身），
但收敛速度可以慢于任意 $n^(-1\/2)$，甚至慢于任意 $1\/log n$。
Berry 与 Esseen 在 1941–1942 年间独立做出该结果，标志着 20 世纪概率极限理论
从"定性收敛"迈向"定量逼近"的转折。

第 6.5 节中的数值实验显示，Berry–Esseen 上界并非空洞：
即便对最简单的 Bernoulli$(0.5)$ 序列，实际误差与上界保持稳定的 $O(n^(-1 \/ 2))$ 共同衰减。

== 当 $EE X^2 = oo$：Cauchy 反例与稳定分布

考虑 $X_1, X_2, dots$ i.i.d. $tilde$ Cauchy$(0, 1)$，密度 $f(x) = 1 \/ [pi (1 + x^2)]$。
该分布连一阶矩都不存在，更遑论二阶矩。其特征函数为
$ phi.alt_X (t) = e^(-|t|). $ <eq:cauchy-cf>
（可由围道积分或反演公式直接计算。）
于是 $bar(X)_n = n^(-1) sum_(i = 1)^n X_i$ 的特征函数为
$ phi.alt_(bar(X)_n) (t) = [phi.alt_X (t \/ n)]^n = [e^(-|t \/ n|)]^n = e^(-|t|), $ <eq:cauchy-mean>
即 $bar(X)_n$ 与 $X_1$ *完全同分布*！
样本均值并不集中到任何常数，CLT、甚至大数定律都彻底失效。
这一现象不是技术性的瑕疵，而是源自尾部的本质重——其根因可由 @eq:taylor 的二阶展开失败直接读出。

特征函数为如下广义极限定理提供了入口：

#definition([$alpha$-稳定分布])[
  随机变量 $Z$ 称为*严格稳定*（strictly $alpha$-stable），
  若其特征函数形如
  $ phi.alt_Z (t) = exp{-|t|^alpha}, quad alpha in (0, 2]. $ <eq:stable>
] <def:stable>

特别地，$alpha = 2$ 对应正态 $cal(N)(0, 2)$（$1/2$ 系数差异），
$alpha = 1$ 对应 Cauchy 分布。
Gnedenko–Kolmogorov 的*广义中心极限定理*断言：
若 $X_i$ i.i.d. 且其分布尾部呈 $|x|^(-alpha)$ 衰减（$0 < alpha < 2$，方差不存在），
则存在适当的规范化常数使 $sum X_i$ 依分布收敛到 $alpha$-稳定分布。
经典 CLT 是 $alpha = 2$ 的特殊情形。
这正是特征函数方法"分类极限分布"力量的体现：
*单一的代数表达式 $exp(-|t|^alpha)$ 同时统一了正态与重尾极限*。

直观地说，参数 $alpha$ 衡量了分布的*尾重*：$alpha$ 越小，尾部越重；
$alpha < 2$ 时方差发散，$alpha <= 1$ 时连均值都不存在。
稳定分布之所以重要，是因为它是"独立同分布之和的唯一吸引域"——
任何"无穷可分"地积累独立扰动而又自身保持形状不变的分布，都必属于该族。
这一刻画在金融建模（如股价对数收益的重尾）、物理学（反常扩散）、
随机网络（无标度网络的度分布）中均扮演关键角色。
读者可对照 @eq:stable 与 @eq:cauchy-cf：
Cauchy 分布的特征函数 $e^(-|t|)$ 在 $0$ 处不可微（导数发散），
正是这一不可微性"出卖"了它的方差发散性——这与 CLT 严格依赖二阶可微性的事实形成精妙对偶。

== 数值实验与可视化

为了让"二项分布渐近正态"这一抽象论断具有几何直观，
我们对 $B(n, 0.4)$ 与对应正态 $cal(N)(n p, n p (1-p))$ 作叠加（@fig:clt）。
可清楚看到：$n = 5$ 时柱状图离散且偏斜；
$n = 20$ 时已大致呈钟形；
$n = 100$ 时离散 PMF 几乎完美贴合连续密度曲线。

#figure(
  image("figures/clt_convergence.svg", width: 100%),
  caption: [二项分布 $B(n, 0.4)$（蓝柱）与对应正态密度 $cal(N)(n p, n p (1-p))$（红线）
    在 $n = 5, 20, 100$ 时的叠加。],
) <fig:clt>

对 Berry–Esseen 不等式（@thm:BE），我们以 $X_i tilde B(1, 0.5)$ 为例
（此时 $rho = 0.125$，$sigma^3 = 0.125 sqrt(2)\/4$），
在 $n in {5, 10, 20, 50, 100, 200, 500, 1000}$ 上计算实际一致误差
$sup_x |F_(Y_n)(x) - Phi(x)|$，并与 @eq:BE 的理论上界 $0.4748 rho \/ (sigma^3 sqrt(n))$ 对比，
结果见 @fig:BE。两条曲线在双对数坐标下*平行*，斜率约 $-1\/2$，
明确印证了误差界的 $n^(-1 \/ 2)$ 衰减率。

#figure(
  image("figures/berry_esseen.svg", width: 75%),
  caption: [对 $X_i tilde B(1, 0.5)$，实际一致误差与 Berry–Esseen 上界的对比（双对数坐标）。],
) <fig:BE>

// ===================================================================
= 讨论与结语

== 主要结果回顾

本文以特征函数为主线，把课程笔记中只给"结论"的 CLT 还原为一个可执行的严格证明。
回顾全文，特征函数发挥了三层作用：
其一，把卷积翻译为乘法（性质 4），使独立和机械化；
其二，把分布收敛翻译为特征函数的逐点收敛（@thm:levy），化分布层论证为函数层论证；
其三，把矩信息编码进 Taylor 展开（性质 5），让 CLT 的极限分布从代数式中自然涌现。
此外，特征函数还能刻画收敛速度（@thm:BE）与广义极限分布（$alpha$-稳定分布族）。

== 局限性反思

本文的处理仍有若干局限。
*第一*，仅证明了 i.i.d. 情形；独立但不必同分布的 Lindeberg–Feller 情形
需要引入 Lindeberg 条件并对余项作均匀化估计，技术上复杂一个数量级。
*第二*，唯一性定理、反演公式以及 Lévy 连续性定理本身的完整证明都未给出，
仅作陈述并指向文献——其证明依赖测度论与紧性论证，超出本科课程工具范围。
*第三*，Berry–Esseen 不等式的最优常数仍是开放问题
（目前 $0.4097 <= C <= 0.4748$），本文未涉及这一活跃方向。

== 未来研究方向与开放问题

由本文出发，自然延伸出若干值得探索的方向：
（i）*测度论层面*——Bochner 定理刻画哪些复函数恰好是特征函数（见 Shiryaev §II.12）；
（ii）*多元 CLT*——通过 Cramér–Wold 装置研究高维分布收敛；
（iii）*随机过程层面*——Lévy 过程的 Lévy–Khintchine 表示
是连续时间随机建模的基石（见 Sato, 1999），亦可应用于鞅差序列与弱依赖情形的非经典 CLT。
这些主题共同构成现代概率论与数理金融、统计物理之间的桥梁。

== 结语

特征函数本质上是把概率论"傅立叶化"的开端：
*概率层面的难题（卷积、极限分布、收敛速度）在频率域往往成为可计算的解析问题*。
正是这一翻译机制，让 20 世纪的概率论从离散计算演化为成熟的分析学科。
对初学者而言，掌握特征函数不仅意味着获得 CLT 的严格证明，
更意味着获得一把通往整个现代极限理论的主钥匙。

// ===================================================================
#heading(numbering: none)[参考文献]

#set par(first-line-indent: 0em, hanging-indent: 1.5em)
#set text(size: 9.8pt)

[1] 何书元. 概率论. 北京: 北京大学出版社, 2006.

[2] 林正炎, 陆传荣, 苏中根. 概率极限理论基础. 北京: 高等教育出版社, 1999.

[3] W. Feller. _An Introduction to Probability Theory and Its Applications_, Vol. II,
  2nd ed. New York: Wiley, 1971.

[4] P. Billingsley. _Probability and Measure_, 3rd ed. New York: Wiley, 1995.

[5] A. N. Shiryaev. _Probability_, 2nd ed. Graduate Texts in Mathematics 95. Berlin: Springer, 1996.

[6] I. G. Shevtsova. On the absolute constants in the Berry–Esseen type inequalities for
  identically distributed summands. _Doklady Mathematics_, 81(1):180–182, 2011.

[7] B. V. Gnedenko, A. N. Kolmogorov. _Limit Distributions for Sums of Independent Random Variables_.
  Cambridge, MA: Addison-Wesley, 1954.

[8] K. Sato. _Lévy Processes and Infinitely Divisible Distributions_.
  Cambridge Studies in Advanced Mathematics 68. Cambridge: Cambridge University Press, 1999.
