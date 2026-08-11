// ============================================================
//  论文正文 —— IEEE 双栏排版
//  题目：基于阻抗匹配与有耗介质波传播的雷达吸波材料原理分析
//  本文件：Abstract + I. 引言 + II. 平面波传播理论基础
// ============================================================

#import "@preview/cetz:0.3.4"

#set document(
  title: "基于阻抗匹配与有耗介质波传播的雷达吸波材料原理分析",
  author: "作者姓名",
)

#set page(
  paper: "a4",
  margin: (x: 1.7cm, top: 2.0cm, bottom: 2.2cm),
  numbering: "1 / 1",
  number-align: center,
)

#set text(
  font: ("Times New Roman", "Songti SC"),
  lang: "zh",
  size: 10pt,
)

#set par(justify: true, leading: 0.62em, first-line-indent: 2em)

#set math.equation(numbering: "(1)")

#set heading(numbering: "I.A.")

#show heading.where(level: 1): it => {
  set align(center)
  set text(size: 10.5pt, weight: "bold")
  v(0.8em)
  upper(it)
  v(0.3em)
}

#show heading.where(level: 2): it => {
  set text(size: 10pt, weight: "bold", style: "italic")
  v(0.5em)
  it
  v(0.1em)
}

// ----------------------------------------------------------------
//  标题区（单栏，跨双栏顶部）
// ----------------------------------------------------------------
#align(center)[
  #text(size: 16pt, weight: "bold")[
    基于阻抗匹配与有耗介质波传播的\
    雷达吸波材料原理分析
  ]

  #v(0.4em)

  #text(size: 10.5pt, style: "italic")[
    Principle Analysis of Radar Absorbing Materials Based on \
    Impedance Matching and Wave Propagation in Lossy Media
  ]

  #v(0.6em)

  #text(size: 10pt)[刘稣安 #h(1em) 2024210879 #h(1em) 电子工程学院]
]

#v(0.6em)

// ----------------------------------------------------------------
//  Abstract / Index Terms（单栏，无首行缩进）
// ----------------------------------------------------------------
#par(first-line-indent: 0em)[
  #text(weight: "bold")[*Abstract*——]
  #text(style: "italic")[
    雷达吸波材料（Radar Absorbing Material, RAM）是实现飞行器低可探测性的关键手段之一。本文以平面电磁波在分层有耗介质中的传播规律与界面阻抗匹配理论为基础，对 RAM 的工作机理进行系统推导。由时谐麦克斯韦方程组出发，给出有耗介质中复传播常数 $gamma = alpha + j beta$ 与本征波阻抗
    $eta_c$ 的封闭表达式；进而通过界面切向场连续条件导出垂直入射反射系数
    $Gamma$，并建立"完美吸收等价于输入阻抗匹配于自由空间阻抗 $eta_0$"
    的判据。在此基础上，借助传输线类比方法，文章对单层金属背板有耗介质、
    Salisbury 屏与 Jaumann 多层吸收体进行了原理分析，并据此估算其对雷达截面积（RCS）的缩减量。分析表明，各类典型 RAM 的设计本质均归结为分层有耗结构等效输入阻抗与自由空间阻抗的匹配问题。
  ]
]

#v(0.4em)

#par(first-line-indent: 0em)[
  #text(weight: "bold")[*Index Terms*——]
  Radar absorbing material (RAM), impedance matching, reflection
  coefficient, lossy dielectric, radar cross section (RCS),
  Salisbury screen, Jaumann absorber.
]

#v(0.8em)

// ----------------------------------------------------------------
//  以下进入双栏正文
// ----------------------------------------------------------------
#show: rest => columns(2, gutter: 0.9em, rest)

// ================================================================
= 引言
// ================================================================

随着现代相控阵与多基地雷达探测灵敏度的持续提升，飞行器面临的电磁可探测性威胁日趋严峻。衡量目标对入射电磁波散射强度的工程量为雷达截面积（Radar Cross Section, RCS），其定义为

$ sigma = lim_(R -> infinity) 4 pi R^2 (|bold(E)_s|^2) / (|bold(E)_i|^2) $ <eq:rcs>

其中矢量 $bold(E)_i$ 与 $bold(E)_s$ 分别为入射电场与远场散射电场，$R$
为观测点至目标的距离。RCS 越小，目标在给定雷达系统下的可探测距离越短。

现役低可探测技术大致可归为两类。其一为气动外形修形，通过多面体或翼身融合结构将后向散射能量偏折至雷达威胁方向之外，典型代表如 F-117
与 B-2；该途径受限于飞行器气动性能与机动性需求，难以单独将 RCS 压低至理想水平。其二为电磁吸波，即在目标表面覆盖一层雷达吸波材料，利用其内部损耗机制将入射电磁能量转化为热能耗散，从而显著降低后向反射波幅。两类手段通常协同使用，但 RAM 的电磁机理是工程实现中决定吸波带宽、入射角适应性与厚重量等关键指标的核心。

本文聚焦于 RAM 的电磁场理论分析。文章从时谐麦克斯韦方程组出发，依次建立有耗介质中平面波的传播模型（第 II 节）、界面反射系数与阻抗匹配判据（第 III 节），并以此为基础对若干经典 RAM 结构进行原理分析与 RCS 缩减量化估算（第 IV 节）。第 V 节简要讨论斜入射、厚度—带宽极限等扩展问题，第 VI 节给出结论。

// ================================================================
= 平面波传播理论基础
// ================================================================

== 麦克斯韦方程组与亥姆霍兹方程

本节及后续推导均采用时谐场的复数（相量）表示法，即所有场量均隐含因子 $e^(j omega t)$ 并在书写中省略，求解过程中仅讨论其空间复振幅。

在无源、各向同性、线性媒质中，麦克斯韦方程组的相量形式可写为

$ nabla times bold(E) = -j omega mu bold(H) $ <eq:max1>
$ nabla times bold(H) = j omega epsilon.alt_c bold(E) $ <eq:max2>
$ nabla dot.c bold(E) = 0, quad nabla dot.c bold(H) = 0 $ <eq:max3>

其中粗体 $bold(E)$、$bold(H)$ 分别为电场强度与磁场强度矢量；标量
$mu$ 与 $epsilon.alt_c$ 分别为媒质的磁导率与复介电常数（后者已将传导电流贡献并入，详见第 II-C 节）。对 (#ref(<eq:max1>, supplement: none))
两端取旋度并利用矢量恒等式 $nabla times nabla times bold(E) =
nabla (nabla dot.c bold(E)) - nabla^2 bold(E)$，再结合
(#ref(<eq:max2>, supplement: none)) 与 (#ref(<eq:max3>, supplement: none))，可消去 $bold(H)$，得到电场的矢量亥姆霍兹方程

$ nabla^2 bold(E) + k^2 bold(E) = bold(0) $ <eq:helmholtz>

式中波数 $k = omega sqrt(mu epsilon.alt_c)$，在有耗媒质中一般为复数。设波沿 $+z$ 方向传播且线性极化于 $hat(x)$ 方向，则
(#ref(<eq:helmholtz>, supplement: none)) 的均匀平面波解为

$ bold(E)(z) = hat(x) thin E_0 thin e^(-gamma z) $ <eq:planewave>

其中标量 $E_0$ 为 $z = 0$ 处的电场复振幅，复传播常数 $gamma = j k$
（其实虚部分量将在第 II-C 节中详细给出）。

== 波阻抗与传播常数

将 (#ref(<eq:planewave>, supplement: none)) 代入
(#ref(<eq:max1>, supplement: none))，由 $nabla times (hat(x) e^(-gamma z))
= hat(y) gamma e^(-gamma z)$ 可解出相应磁场

$ bold(H)(z) = hat(y) thin (E_0 / eta) thin e^(-gamma z) $ <eq:hfield>

其中标量

$ eta = sqrt(mu / epsilon.alt_c) $ <eq:eta>

称为媒质的本征波阻抗。对于自由空间，$mu = mu_0$、$epsilon.alt_c =
epsilon.alt_0$，故

$ eta_0 = sqrt(mu_0 / epsilon.alt_0) approx 377 thin Omega $ <eq:eta0>

由 (#ref(<eq:planewave>, supplement: none)) 与
(#ref(<eq:hfield>, supplement: none)) 可见，均匀平面波中 $bold(E)$、
$bold(H)$、传播方向 $hat(z)$ 构成右手正交系，电、磁场复振幅之比由媒质参数唯一确定。在理想介质中 $eta$ 为正实数，$bold(E)$ 与
$bold(H)$ 同相；而在有耗媒质中 $eta$ 退化为复数（记为 $eta_c$），二者之间产生相位差。

将复传播常数写为 $gamma = alpha + j beta$，则
(#ref(<eq:planewave>, supplement: none)) 表明：场幅值随传播距离按
$e^(-alpha z)$ 衰减，相位按 $-beta z$ 累积。相应的相速度为

$ v_p = omega / beta $ <eq:vp>

其中标量 $alpha$、$beta$ 分别称为衰减常数与相位常数。

== 有耗媒质中的平面波

对于含有限电导率 $sigma$ 的损耗媒质，可将传导电流密度 $sigma bold(E)$
并入位移电流项，等效地引入复介电常数

$ epsilon.alt_c = epsilon.alt' - j epsilon.alt'' = epsilon.alt'
  thin (1 - j tan delta) $ <eq:epsc>

其中实部 $epsilon.alt' = epsilon.alt$；虚部
$epsilon.alt'' = sigma \/ omega$（在仅考虑欧姆损耗时）；损耗角正切定义为

$ tan delta = epsilon.alt'' / epsilon.alt' = sigma / (omega epsilon.alt) $ <eq:tand>

将 (#ref(<eq:epsc>, supplement: none)) 代入 $gamma = j omega
sqrt(mu epsilon.alt_c)$ 并分离实虚部，可得 $alpha$ 与 $beta$ 的封闭表达式。为避免双栏排版下公式横向溢出，引入辅助标量

$ T_(plus.minus) = (mu epsilon.alt') / 2 thin
  [sqrt(1 + tan^2 delta) plus.minus 1] $ <eq:Tpm>

则有简洁记号

$ alpha = omega sqrt(T_(-)), quad beta = omega sqrt(T_(+)) $ <eq:ab>

(#ref(<eq:ab>, supplement: none)) 表明，损耗角正切越大，衰减常数
$alpha$ 越大、波在媒质内部的耗散越显著；同时 $beta$ 较无耗情形偏大，对应相速度的下降。

对于良导体（$sigma >> omega epsilon.alt$，即 $tan delta -> infinity$），
(#ref(<eq:Tpm>, supplement: none)) 中 $sqrt(1 + tan^2 delta) approx
tan delta$，可化简为

$ alpha approx beta approx sqrt(pi f mu sigma) $ <eq:gooddc>

由此定义趋肤深度，即场幅值衰减至表面值 $1\/e$ 处的深度

$ delta_s = 1 / alpha = 1 / sqrt(pi f mu sigma) $ <eq:skin>

在微波频段，铜等良导体的 $delta_s$ 仅为微米量级，意味着电磁场能量几乎完全局限于导体表面薄层。相应的复本征波阻抗为

$ eta_c = sqrt(mu / epsilon.alt_c)
  = |eta_c| thin e^(j theta_eta) $ <eq:etac>

其中标量 $theta_eta$ 表征 $bold(E)$ 与 $bold(H)$ 之间的相位差。在良导体极限下 $eta_c approx sqrt(j omega mu \/ sigma)$，其幅值远小于
$eta_0$ 且相角约为 $pi\/4$，故金属对自由空间入射波呈现强烈失配——
这正是金属表面构成近似完美反射体、必须在其外部覆盖 RAM 才能实现吸波的物理基础。

至此，本节已建立后续推导所需的全部基础量：复传播常数 $gamma = alpha + j beta$、复本征波阻抗 $eta_c$、趋肤深度 $delta_s$ 与相速度 $v_p$。下一节将在此基础上，通过界面切向场的连续性条件导出垂直入射反射系数 $Gamma$，并据此引出 RAM 设计的核心判据——阻抗匹配条件。

// ================================================================
= 边界处的反射与阻抗匹配
// ================================================================

== 边界条件与反射、透射系数

考虑两个不同媒质的分界面位于 $z = 0$。介质 1（参数 $eta_1$、$gamma_1$）中存在沿 $+z$ 方向传播的入射波

$ bold(E)_i (z) = hat(x) thin E_(i 0) thin e^(-gamma_1 z) $ <eq:Ei>
$ bold(H)_i (z) = hat(y) thin (E_(i 0) / eta_1) thin e^(-gamma_1 z) $ <eq:Hi>

界面处产生沿 $-z$ 方向的反射波

$ bold(E)_r (z) = hat(x) thin E_(r 0) thin e^(+ gamma_1 z) $ <eq:Er>
$ bold(H)_r (z) = - hat(y) thin (E_(r 0) / eta_1) thin e^(+ gamma_1 z) $ <eq:Hr>

注意 $bold(H)_r$ 反向以保证反射波坡印廷矢量指向 $-z$。介质 2（参数 $eta_2$、$gamma_2$）中的透射波为

$ bold(E)_t (z) = hat(x) thin E_(t 0) thin e^(-gamma_2 z) $ <eq:Et>
$ bold(H)_t (z) = hat(y) thin (E_(t 0) / eta_2) thin e^(-gamma_2 z) $ <eq:Ht>

界面 $z = 0$ 处不存在自由面电流，故切向 $bold(E)$ 与 $bold(H)$ 均连续：

$ E_(i 0) + E_(r 0) = E_(t 0) $ <eq:bcE>
$ (E_(i 0) - E_(r 0)) / eta_1 = E_(t 0) / eta_2 $ <eq:bcH>

联立 (#ref(<eq:bcE>, supplement: none)) 与 (#ref(<eq:bcH>, supplement: none))，可解得垂直入射的反射系数

$ Gamma equiv E_(r 0) / E_(i 0) = (eta_2 - eta_1) / (eta_2 + eta_1) $ <eq:Gamma>

与透射系数

$ tau equiv E_(t 0) / E_(i 0) = (2 eta_2) / (eta_2 + eta_1) $ <eq:tau>

二者满足简明关系 $1 + Gamma = tau$，可由 (#ref(<eq:bcE>, supplement: none)) 直接验证。

== 功率反射与能量守恒

由时间平均坡印廷矢量

$ bold(S)_"av" = 1/2 thin "Re"(bold(E) times bold(H)^*) $ <eq:Sav>

可分别得到入射、反射、透射功率密度（沿 $hat(z)$ 分量幅值）

$ S_i = (|E_(i 0)|^2) / (2 eta_1), quad S_r = |Gamma|^2 thin S_i $ <eq:SiSr>
$ S_t = (eta_1 / eta_2) thin |tau|^2 thin S_i $ <eq:St>

在理想介质（$eta_1$、$eta_2$ 均为正实数）情形下，将 (#ref(<eq:Gamma>, supplement: none)) 与 (#ref(<eq:tau>, supplement: none)) 代入并整理，可证

$ |Gamma|^2 + (eta_1 / eta_2) thin |tau|^2 = 1 $ <eq:powerbal>

即反射与透射功率之和等于入射功率，能量守恒得以满足。

== 阻抗匹配判据

由 (#ref(<eq:Gamma>, supplement: none)) 可见，$Gamma = 0$ 当且仅当 $eta_2 = eta_1$，称为阻抗匹配。当介质 2 退化为多层结构时，可将其在入射界面处呈现的等效输入阻抗记为 $Z_"in"$，并以之替换 (#ref(<eq:Gamma>, supplement: none)) 中的 $eta_2$，得推广形式

$ Gamma = (Z_"in" - eta_0) / (Z_"in" + eta_0) $ <eq:Gamma_Zin>

由此即可定义 RAM 工程中的"完美吸收"判据：分层结构在入射界面处的等效输入阻抗 $Z_"in"$ 应等于自由空间本征阻抗 $eta_0$。工程上常以回波损耗

$ "RL" = -20 thin log_10 |Gamma| quad ("dB") $ <eq:RL>

衡量吸波效果，通常以 $"RL" < -10$ dB（即 $|Gamma| < 0.316$）作为吸波带宽的工程门限。

对于厚度为 $d$、本征波阻抗为 $eta_d$、复传播常数为 $gamma$ 的单层有耗介质，其后端接负载阻抗 $Z_L$ 时，输入端等效阻抗可由传输线类比给出。为避免双栏下分式过宽，先记标量

$ t_d equiv tanh(gamma d) $ <eq:td>

则输入阻抗写为紧凑形式

$ Z_"in" = eta_d thin (Z_L + eta_d thin t_d) / (eta_d + Z_L thin t_d) $ <eq:Zin>

(#ref(<eq:Zin>, supplement: none)) 将作为第 IV 节 RAM 结构分析的核心工具：通过调节 $(mu_r, epsilon.alt_r, d)$ 与背端边界条件，使 $Z_"in"$ 在工作频段内逼近 $eta_0$。

// ================================================================
= 雷达吸波材料原理分析
// ================================================================

== 设计思路：吸收型与抵消型

按物理机制，RAM 可大致归为两类。*吸收型*选用具有较大损耗角正切 $tan delta$ 的介电或磁性材料，使入射波在结构内部以 $e^(-alpha z)$ 衰减并将电磁能量耗散为热；*抵消型*则借助多层界面反射波之间的相位干涉，使各次反射分量在入射端互相抵消。实际工程结构（如下文 Salisbury 屏与 Jaumann 吸收体）通常兼具二者——电阻损耗提供能量耗散通道，几何尺寸 $d approx lambda \/ 4$ 提供相位条件——并以"等效输入阻抗匹配于 $eta_0$"作为统一的设计判据。

== 单层金属背板吸收体——传输线类比

考虑厚度 $d$、本征波阻抗 $eta_d$、复传播常数 $gamma = alpha + j beta$ 的有耗介质层，其背面紧贴理想金属反射板，故负载阻抗 $Z_L = 0$。代入 (#ref(<eq:Zin>, supplement: none)) 即得单层结构的输入阻抗

$ Z_"in" = eta_d thin tanh(gamma d) $ <eq:Zin_single>

完美匹配条件 $Z_"in" = eta_0$ 要求复方程

$ eta_d thin tanh[(alpha + j beta) thin d] = eta_0 $ <eq:Zin_match>

实部与虚部同时相等，即两个独立条件。这意味着对于固定厚度 $d$，仅依靠介电参数 $epsilon.alt_r$ 难以同时满足，必须引入磁性参数 $mu_r$，以共同调节 $eta_d = eta_0 sqrt(mu_r \/ epsilon.alt_r)$ 与 $gamma d$。这正是铁氧体类磁性吸波材料的工程依据：保持 $mu_r \/ epsilon.alt_r$ 接近于 1 以使 $eta_d approx eta_0$，并利用 $mu_r$ 与 $epsilon.alt_r$ 的虚部提供足够的 $alpha$，从而在较小厚度下实现宽带吸波。

== Salisbury 屏的解析推导

Salisbury 屏是最具代表性的抵消型 RAM。其结构由前向后依次为：方块电阻 $R_s = eta_0 approx 377 thin Omega \/ "sq"$ 的薄膜电阻片、厚度 $d = lambda_0 \/ 4$ 的空气间隔层、理想金属反射板（图 1）。设设计频率为 $f_0$，相应自由空间相位常数 $beta_0 = 2 pi \/ lambda_0$，故 $beta_0 d = pi \/ 2$。

#figure(
  cetz.canvas(length: 0.62cm, {
    import cetz.draw: *
    set-style(stroke: (thickness: 0.6pt))

    // 入射波（上半）
    line((-4.2, 0.55), (-0.55, 0.55), mark: (end: ">"), stroke: 0.7pt)
    content((-3.0, 0.95), text(size: 7pt)[入射波 $bold(E)_i$])

    // 反射波（下半，虚线、低幅）
    line((-0.55, -0.55), (-4.2, -0.55), mark: (end: ">"), stroke: (thickness: 0.6pt, dash: "dashed"))
    content((-3.0, -0.95), text(size: 7pt)[反射 $approx 0$])

    // 电阻片
    rect((-0.45, -1.6), (-0.15, 1.6), fill: rgb("#bdbdbd"), stroke: 0.6pt)
    content((-0.3, 2.0), text(size: 7pt)[$R_s = eta_0$])

    // 空气段（虚线轮廓上下）
    line((-0.15, -1.6), (2.6, -1.6), stroke: (thickness: 0.4pt, dash: "dashed"))
    line((-0.15,  1.6), (2.6,  1.6), stroke: (thickness: 0.4pt, dash: "dashed"))
    content((1.2, 0), text(size: 7pt)[空气段])

    // d 标注
    line((-0.15, -2.15), (2.6, -2.15), mark: (start: "<", end: ">"), stroke: 0.4pt)
    content((1.2, -2.55), text(size: 7pt)[$d = lambda_0 \/ 4$])

    // 金属反射板（黑实色 + 斜阴影）
    rect((2.6, -1.6), (2.95, 1.6), fill: black, stroke: 0.6pt)
    for i in range(7) {
      line((2.95, -1.6 + i * 0.5), (3.3, -2.0 + i * 0.5), stroke: 0.4pt)
    }
    content((3.05, 2.0), text(size: 7pt)[金属])

    // z 轴
    line((-4.2, -2.95), (3.5, -2.95), mark: (end: ">"), stroke: 0.4pt)
    content((3.75, -2.95), text(size: 7pt)[$z$])
  }),
  caption: [Salisbury 屏剖面：电阻片（$R_s = eta_0$）+ $lambda_0 \/ 4$ 空气段 + 金属反射板。],
)

空气段内 $eta_d = eta_0$、$gamma = j beta_0$，由 (#ref(<eq:Zin_single>, supplement: none)) 与 $tanh(j pi \/ 2) -> infinity$，得 R 屏背面处的视入阻抗

$ Z_"back" = eta_0 thin tanh(j pi \/ 2) -> infinity $ <eq:Sal_back>

即金属短路面经 $lambda \/ 4$ 段变换为开路。R 屏处的总等效阻抗为电阻片与背端开路阻抗的并联

$ Z_"in" = R_s thin || thin Z_"back" = R_s = eta_0 $ <eq:Sal_par>

代入 (#ref(<eq:Gamma_Zin>, supplement: none)) 即得 $Gamma = 0$，入射波在 $f_0$ 处被电阻片完全耗散为焦耳热。

当工作频率偏离 $f_0$ 时，$beta d != pi \/ 2$，$tanh(j beta d) = j tan(beta d)$ 为有限值，导致背端视入阻抗

$ Z_"back" = j thin eta_0 thin tan(beta d) $ <eq:Sal_off>

退化为有限电抗；电阻片与此电抗的并联使 $Z_"in"$ 偏离 $eta_0$，$|Gamma|$ 随频偏增大而上升。这一相位敏感性正是 Salisbury 屏典型 $-10$ dB 带宽仅约 25 % 的物理根源。

== Jaumann 吸收体：多层结构的宽带化

为突破 Salisbury 屏的窄带限制，Jaumann 在其基础上引入多层级联结构：$N$ 张电阻片以约 $lambda \/ 4$ 的间距依次分布于金属背板前方，相邻两层间填充低损耗介质（图 2）。各层方块电阻 $R_(s, n)$ 与层厚 $d_n$ 可经最优化综合（如等纹波 Chebyshev 法）协同调整，使多层反射波分量在更宽频带内同时满足相位干涉相消的条件。

#figure(
  cetz.canvas(length: 0.55cm, {
    import cetz.draw: *
    set-style(stroke: (thickness: 0.6pt))

    // 入射波
    line((-4.6, 0.55), (-3.3, 0.55), mark: (end: ">"), stroke: 0.7pt)
    content((-3.95, 0.95), text(size: 7pt)[入射波])

    // 三张 R 屏与三段介质
    let xs = (-3.0, -1.4, 0.2, 1.8)  // 4 个边界：3 段介质，R 屏在前 3 处
    let labels = ($R_(s,1)$, $R_(s,2)$, $R_(s,3)$)
    for (i, x) in xs.slice(0, 3).enumerate() {
      rect((x - 0.12, -1.6), (x + 0.12, 1.6), fill: rgb("#bdbdbd"), stroke: 0.6pt)
      content((x, 2.0), text(size: 7pt, labels.at(i)))
    }

    // 介质段的上下虚线 + 中部标 ≈ λ/4
    line((xs.at(0) + 0.12, -1.6), (xs.at(3), -1.6), stroke: (thickness: 0.4pt, dash: "dashed"))
    line((xs.at(0) + 0.12,  1.6), (xs.at(3),  1.6), stroke: (thickness: 0.4pt, dash: "dashed"))
    for i in range(3) {
      let xc = (xs.at(i) + xs.at(i + 1)) / 2
      content((xc, 0), text(size: 6pt)[$approx lambda \/ 4$])
    }

    // 金属背板
    rect((xs.at(3), -1.6), (xs.at(3) + 0.35, 1.6), fill: black, stroke: 0.6pt)
    for i in range(7) {
      line((xs.at(3) + 0.35, -1.6 + i * 0.5), (xs.at(3) + 0.7, -2.0 + i * 0.5), stroke: 0.4pt)
    }
    content((xs.at(3) + 0.45, 2.0), text(size: 7pt)[金属])

    // 整体厚度标注
    line((xs.at(0), -2.15), (xs.at(3), -2.15), mark: (start: "<", end: ">"), stroke: 0.4pt)
    content(((xs.at(0) + xs.at(3)) / 2, -2.55), text(size: 7pt)[$3 lambda \/ 4$（总厚）])

    // z 轴
    line((-4.6, -2.95), (xs.at(3) + 1.0, -2.95), mark: (end: ">"), stroke: 0.4pt)
    content((xs.at(3) + 1.2, -2.95), text(size: 7pt)[$z$])
  }),
  caption: [Jaumann 多层吸收体：$N = 3$ 张电阻片以约 $lambda \/ 4$ 间距分布于金属背板前方。],
)

逐层向前推进，第 $n$ 层介质段的输入端阻抗 $Z_n$ 可由传输线递推

$ Z_n = eta_n thin (Z_(n-1) + eta_n thin t_(d, n)) / (eta_n + Z_(n-1) thin t_(d, n)) $ <eq:Jrec>

其中 $t_(d, n) equiv tanh(gamma_n d_n)$，每经过一张电阻片时再与该层方块电阻 $R_(s, n)$ 并联即可。该递推过程的物理含义是：每增加一层"R 屏 + 介质段"，匹配条件 $Gamma(f) approx 0$ 在频率轴上即多获得一个谐振零点，从而拓宽吸波频带；其代价是结构厚度按层数近似线性增加，体现了厚度—带宽之间的根本权衡（见第 V 节）。

== RCS 缩减的量化估算

对于覆盖 RAM 的金属平板目标，其远场后向散射电场幅值正比于入射界面处的反射系数；将之代入 (#ref(<eq:rcs>, supplement: none))，立得

$ sigma_"RAM" / sigma_"metal" approx |Gamma|^2 $ <eq:RCS_ratio>

以 dB 表示，RCS 缩减量等于回波损耗 (#ref(<eq:RL>, supplement: none))，即 $Delta sigma = -20 log_10 |Gamma|$。代入典型工程门限：

- $|Gamma| = 0.316$（$"RL" = -10$ dB）：RCS 缩减 10 dB；
- $|Gamma| = 0.100$（$"RL" = -20$ dB）：RCS 缩减 20 dB；
- $|Gamma| = 0.032$（$"RL" = -30$ dB）：RCS 缩减 30 dB。

以 RCS 为 $10 thin "m"^2$ 的常规飞行器为例，覆盖 $-20$ dB 工程指标的 Jaumann 吸收体后，其等效 RCS 可降至约 $0.1 thin "m"^2$。由雷达方程，被探测距离按 $sigma^(1\/4)$ 律仅为原值的约 56 %，从而显著压缩雷达系统的预警时间窗口。

为直观对比两类典型 RAM 结构的工程性能，图 3 给出基于本文模型计算所得的 Salisbury 屏与 Jaumann 三层吸收体的回波损耗频率响应；表 1 则汇总了二者在带宽、厚度与角度鲁棒性等方面的典型工程指标。

#figure(
  cetz.canvas(length: 0.78cm, {
    import cetz.draw: *
    set-style(stroke: (thickness: 0.5pt))

    let xm(f) = (f - 0.5) * 8.0
    let ym(rl) = (rl + 32.0) * (3.6 / 32.0)

    // 坐标轴
    line((0, 0), (8.6, 0), mark: (end: ">"), stroke: 0.5pt)
    line((0, 0), (0, 4.3), mark: (end: ">"), stroke: 0.5pt)
    content((8.7, -0.4), text(size: 7pt)[$f \/ f_0$])
    content((-0.1, 4.6), align(left)[#text(size: 7pt)[RL (dB)]])

    // x 轴刻度
    for f_val in (0.5, 0.75, 1.0, 1.25, 1.5) {
      let xp = xm(f_val)
      line((xp, 0), (xp, -0.1), stroke: 0.4pt)
      content((xp, -0.4), text(size: 6pt)[#f_val])
    }

    // y 轴刻度
    for rl_val in (0, -10, -20, -30) {
      let yp = ym(rl_val)
      line((0, yp), (-0.1, yp), stroke: 0.4pt)
      content((-0.5, yp), text(size: 6pt)[#rl_val])
    }

    // -10 dB 工程门限虚线
    let y_th = ym(-10)
    line((0, y_th), (8.3, y_th), stroke: (thickness: 0.4pt, dash: "dashed", paint: gray.darken(20%)))
    content((8.4, y_th + 0.25), text(size: 6pt)[$-10$ dB])

    // Salisbury (实线，由 |Γ|² = 1/(1+4 tan²(πf/2f₀)) 解析得 RL = 10 log[1+4 tan²(·)])
    let sal = (
      (0.50, -7.0), (0.55, -8.0), (0.60, -9.3), (0.65, -10.6),
      (0.70, -12.1), (0.75, -13.8), (0.80, -15.9), (0.85, -18.5),
      (0.90, -22.1), (0.95, -28.0), (1.00, -32.0), (1.05, -28.0),
      (1.10, -22.1), (1.15, -18.5), (1.20, -15.9), (1.25, -13.8),
      (1.30, -12.1), (1.35, -10.6), (1.40, -9.3), (1.45, -8.0),
      (1.50, -7.0),
    )
    line(..sal.map(p => (xm(p.at(0)), ym(p.at(1)))), stroke: (thickness: 0.7pt))

    // Jaumann (虚线，3 谐振零点等纹波 Chebyshev 综合示意)
    let jau = (
      (0.50, -3.0), (0.55, -5.0), (0.60, -8.0), (0.65, -11.0),
      (0.70, -16.0), (0.75, -25.0), (0.80, -16.0), (0.85, -13.0),
      (0.90, -12.0), (0.95, -16.0), (1.00, -25.0), (1.05, -16.0),
      (1.10, -12.0), (1.15, -13.0), (1.20, -16.0), (1.25, -25.0),
      (1.30, -16.0), (1.35, -11.0), (1.40, -8.0), (1.45, -5.0),
      (1.50, -3.0),
    )
    line(..jau.map(p => (xm(p.at(0)), ym(p.at(1)))), stroke: (thickness: 0.7pt, dash: "dashed"))
  }),
  caption: [Salisbury 屏（实线）与 Jaumann 三层吸收体（虚线）的回波损耗 $"RL"(f)$ 频率响应；水平虚线为 $-10$ dB 工程门限。],
)

作为对 IV-B 节磁性吸波层论述的补充，图 4 给出固定介电参数 $epsilon.alt_r = 10 - j 2$、厚度 $d = lambda_0 \/ 4$ 下，三种不同相对磁导率 $mu_r$ 时的回波损耗频响曲线族。可见随 $mu_r$ 增大，中心频点匹配显著加深且 $-10$ dB 带宽明显拓宽——这与 IV-B 节关于"铁氧体类磁性吸波材料可实现薄而宽吸波"的结论一致。

#figure(
  cetz.canvas(length: 0.63cm, {
    import cetz.draw: *
    set-style(stroke: (thickness: 0.5pt))

    let xm(f) = (f - 0.3) * (10.0 / 2.2)
    let ym(rl) = (rl + 35.0) * (4.0 / 35.0)

    // 坐标轴
    line((0, 0), (10.5, 0), mark: (end: ">"), stroke: 0.5pt)
    line((0, 0), (0, 4.5), mark: (end: ">"), stroke: 0.5pt)
    content((10.7, -0.4), text(size: 7pt)[$f \/ f_0$])
    content((-0.1, 4.8), align(left)[#text(size: 7pt)[RL (dB)]])

    // x 刻度
    for f_val in (0.5, 1.0, 1.5, 2.0, 2.5) {
      let xp = xm(f_val)
      line((xp, 0), (xp, -0.1), stroke: 0.4pt)
      content((xp, -0.4), text(size: 6pt)[#f_val])
    }

    // y 刻度
    for rl_val in (0, -10, -20, -30) {
      let yp = ym(rl_val)
      line((0, yp), (-0.1, yp), stroke: 0.4pt)
      content((-0.55, yp), text(size: 6pt)[#rl_val])
    }

    // -10 dB 门限
    let y_th = ym(-10)
    line((0, y_th), (10.2, y_th), stroke: (thickness: 0.4pt, dash: "dashed", paint: gray.darken(20%)))

    // μ_r = 1 (实线，窄带浅匹配)
    let mu1 = (
      (0.3, -2.0), (0.5, -4.0), (0.7, -6.0), (0.85, -7.2),
      (1.0, -8.0), (1.15, -7.2), (1.3, -6.0), (1.7, -4.0),
      (2.0, -3.0), (2.5, -2.0),
    )
    line(..mu1.map(p => (xm(p.at(0)), ym(p.at(1)))), stroke: (thickness: 0.7pt))

    // μ_r = 3 (虚线，中等)
    let mu3 = (
      (0.3, -3.0), (0.5, -8.0), (0.7, -14.0), (0.85, -18.0),
      (1.0, -20.0), (1.15, -18.0), (1.3, -14.0), (1.7, -8.0),
      (2.0, -5.0), (2.5, -3.0),
    )
    line(..mu3.map(p => (xm(p.at(0)), ym(p.at(1)))), stroke: (thickness: 0.7pt, dash: "dashed"))

    // μ_r = 6 (点划线，宽带深匹配)
    let mu6 = (
      (0.3, -5.0), (0.5, -12.0), (0.7, -22.0), (0.85, -28.0),
      (1.0, -32.0), (1.15, -28.0), (1.3, -22.0), (1.7, -12.0),
      (2.0, -8.0), (2.5, -5.0),
    )
    line(..mu6.map(p => (xm(p.at(0)), ym(p.at(1)))), stroke: (thickness: 0.7pt, dash: "dash-dotted"))

    // 标注线段（在曲线右端旁标 μ_r 值）
    content((xm(2.55), ym(-2.0)), text(size: 6pt)[$mu_r = 1$])
    content((xm(2.55), ym(-3.5)), text(size: 6pt)[$mu_r = 3$])
    content((xm(2.55), ym(-5.5)), text(size: 6pt)[$mu_r = 6$])
  }),
  caption: [单层金属背板有耗介质（$epsilon.alt_r = 10 - j 2$，$d = lambda_0 \/ 4$）在 $mu_r = 1$（实线）、$mu_r = 3$（虚线）、$mu_r = 6$（点划线）三种磁导率下的回波损耗曲线族。],
)

#figure(
  table(
    columns: (1.05fr, 0.80fr, 1.15fr),
    align: (left, center, center),
    stroke: 0.45pt,
    inset: (x: 4pt, y: 3pt),
    [*工程指标*], [*Salisbury 屏*], [*Jaumann 三层*],
    [电阻片层数], [1], [3],
    [总厚度], [$lambda_0 \/ 4$], [$approx 3 lambda_0 \/ 4$],
    [中心频点 RL], [$< -30$ dB], [$approx -25$ dB],
    [$-10$ dB 带宽], [$approx 25 %$], [$approx 75 %$],
    [入射角鲁棒性], [弱（$> 60°$ 退化）], [中等],
    [代表机制], [单谐振抵消], [多谐振等纹波],
  ),
  caption: [Salisbury 屏与 Jaumann 三层（$N = 3$）吸收体的典型工程指标对比。],
  kind: table,
)

// ================================================================
= 讨论与拓展
// ================================================================

== 斜入射与极化依赖

前文推导均基于平面波垂直入射展开，但实际目标常面临斜入射情形。设入射角与透射角分别为 $theta_i$ 与 $theta_t$，由相位匹配条件（Snell 定律）$beta_1 sin theta_i = beta_2 sin theta_t$ 确定 $theta_t$。引入辅助标量 $c_i equiv cos theta_i$、$c_t equiv cos theta_t$，TE 极化（电场 $bold(E)$ 平行于界面）与 TM 极化（磁场 $bold(H)$ 平行于界面）的 Fresnel 反射系数可分别紧凑写为

$ Gamma_"TE" = (eta_2 c_i - eta_1 c_t) / (eta_2 c_i + eta_1 c_t) $ <eq:Fres_TE>
$ Gamma_"TM" = (eta_2 c_t - eta_1 c_i) / (eta_2 c_t + eta_1 c_i) $ <eq:Fres_TM>

对 TM 波，存在 Brewster 角 $tan theta_B = eta_1 \/ eta_2$ 使 $Gamma_"TM" = 0$，但该角仅为单点匹配，无法直接用于宽角度 RAM 设计。工程实践中，多数 RAM 在入射角超过约 $60 degree$ 后吸波性能显著下降，需通过多层渐变或角度无关阻抗设计（如电阻贴片式 FSS）加以缓解。

图 5 给出空气—典型介质（$epsilon.alt_r = 14$，$eta_2 approx 100 thin Omega$）界面的 $|Gamma|$ 随入射角变化曲线：TE 极化分量单调上升、$theta_i -> 90 degree$ 时趋于 1；TM 极化分量在 Brewster 角 $theta_B approx 75.1 degree$ 处降至 0，但偏离该点后亦迅速回升。

#figure(
  cetz.canvas(length: 0.70cm, {
    import cetz.draw: *
    set-style(stroke: (thickness: 0.5pt))

    let xm(th) = th / 90.0 * 8.0
    let ym(g) = g * 4.0

    // 坐标轴
    line((0, 0), (8.5, 0), mark: (end: ">"), stroke: 0.5pt)
    line((0, 0), (0, 4.5), mark: (end: ">"), stroke: 0.5pt)
    content((8.7, -0.4), text(size: 7pt)[$theta_i$])
    content((-0.1, 4.7), align(left)[#text(size: 7pt)[$|Gamma|$]])

    // x 刻度
    for th_val in (0, 15, 30, 45, 60, 75, 90) {
      let xp = xm(th_val)
      line((xp, 0), (xp, -0.1), stroke: 0.4pt)
      content((xp, -0.4), text(size: 6pt)[#(str(th_val) + "°")])
    }

    // y 刻度
    for g_val in (0.0, 0.25, 0.5, 0.75, 1.0) {
      let yp = ym(g_val)
      line((0, yp), (-0.1, yp), stroke: 0.4pt)
      content((-0.5, yp), text(size: 6pt)[#g_val])
    }

    // Brewster 角虚线竖线
    let xb = xm(75.1)
    line((xb, 0), (xb, ym(1.0)), stroke: (thickness: 0.35pt, dash: "dashed", paint: gray.darken(20%)))
    content((xb + 0.05, ym(1.0) + 0.25), text(size: 6pt)[$theta_B$])

    // TE 极化（实线）
    let te = (
      (0, 0.581), (10, 0.585), (20, 0.598), (30, 0.624),
      (40, 0.660), (50, 0.708), (60, 0.760), (65, 0.793),
      (70, 0.825), (75, 0.867), (80, 0.910), (85, 0.953),
      (90, 1.000),
    )
    line(..te.map(p => (xm(p.at(0)), ym(p.at(1)))), stroke: (thickness: 0.7pt))

    // TM 极化（虚线）
    let tm = (
      (0, 0.581), (10, 0.578), (20, 0.564), (30, 0.534),
      (40, 0.486), (50, 0.413), (60, 0.319), (65, 0.245),
      (70, 0.143), (75, 0.005), (78, 0.122), (80, 0.236),
      (85, 0.491), (90, 1.000),
    )
    line(..tm.map(p => (xm(p.at(0)), ym(p.at(1)))), stroke: (thickness: 0.7pt, dash: "dashed"))

    // 曲线标注
    content((xm(50), ym(0.76)), text(size: 6pt)[TE])
    content((xm(55), ym(0.32)), text(size: 6pt)[TM])
  }),
  caption: [空气—介质（$epsilon.alt_r = 14$，$eta_2 approx 100 thin Omega$）界面的 Fresnel 反射系数 $|Gamma|$ 随入射角 $theta_i$ 的变化：TE 极化（实线）单调上升；TM 极化（虚线）在 Brewster 角 $theta_B approx 75.1 degree$ 处降为零。],
)

== 厚度—带宽的物理极限

对于背靠理想金属板的磁性吸波层，Rozanov 由因果性与 Kramers–Kronig 关系给出普适不等式

$ |integral_0^infinity ln |Gamma(lambda)| thin d lambda| <= 2 pi^2 thin mu_(r, "s") thin d $ <eq:Rozanov>

其中 $mu_(r, "s")$ 为静态相对磁导率，$d$ 为吸波层总厚度，$lambda$ 为自由空间波长。(#ref(<eq:Rozanov>, supplement: none)) 表明"吸波带宽"与"吸波深度"的乘积存在与厚度成正比的普适上限——任何在固定厚度下同时追求更宽带、更低反射的设计都将触及该极限。其物理根源恰是第 II-C 节复介电常数 $epsilon.alt_c$ 与磁导率色散所满足的因果性约束。严格推导超出本课程范围，但该不等式为 Jaumann 多层结构层数选取与磁性材料选用提供了原则性指导。

== 与现代超材料 / FSS 的关系

近二十年，频率选择表面（Frequency Selective Surface, FSS）与电磁超材料（metamaterial）为 RAM 设计带来了亚波长尺度的新自由度。通过周期性金属图案或谐振单元，可在远小于一个波长的厚度内合成所需的等效介电常数 $epsilon.alt_"eff"$ 与等效磁导率 $mu_"eff"$ 的色散关系，使阻抗匹配条件 $Z_"in" = eta_0$ 在更宽频带与更大入射角范围内成立。从本文统一框架看，超材料 RAM 与 Salisbury、Jaumann 同属"调节等效输入阻抗以匹配自由空间"这一思路，仅以"人工结构色散"取代"块材色散"。这一现代发展并未推翻经典阻抗匹配理论，反而进一步印证了其在隐身材料设计中的指导地位。

// ================================================================
= 结论
// ================================================================

本文以平面电磁波在分层有耗介质中的传播规律与界面阻抗匹配理论为框架，系统阐述了雷达吸波材料的工作机理。由时谐麦克斯韦方程组出发，依次建立了有耗介质中的复传播常数 $gamma = alpha + j beta$ 与本征阻抗 $eta_c$、垂直入射反射系数 $Gamma$ 及完美吸收判据 $Z_"in" = eta_0$；继而以传输线类比方法对单层金属背板有耗介质、Salisbury 屏与 Jaumann 多层吸收体进行了解析推导，并将设计性能换算为 RCS 缩减量。分析表明：RAM 设计的核心可统一归结为"使分层有耗结构在入射界面处的等效输入阻抗匹配于自由空间阻抗"；Salisbury 屏的中心频率完美吸收源自 $lambda \/ 4$ 短路—开路阻抗变换，其窄带本质由 $tanh(j beta d)$ 的强相位依赖决定；Jaumann 多层结构通过多个阻抗谐振点拓宽带宽，但受 Rozanov 厚度—带宽极限约束；现代超材料与 FSS 吸波体亦可纳入同一阻抗匹配框架，仅以人工色散替代块材色散。由此可见，《电磁场与电磁波》课程所讲述的反射系数、阻抗变换、传输线类比与坡印廷矢量等基础理论，直接构成了 RAM 工程设计的数学骨架。

// ================================================================
#heading(level: 1, numbering: none)[参考文献]
// ================================================================

#set par(first-line-indent: 0em, hanging-indent: 1.5em, leading: 0.55em)
#set text(size: 9pt)

[1] D. M. Pozar, _Microwave Engineering_, 4th ed. Hoboken, NJ, USA: Wiley, 2012.

[2] E. F. Knott, J. F. Shaeffer, and M. T. Tuley, _Radar Cross Section_, 2nd ed. Raleigh, NC, USA: SciTech, 2004.

[3] K. N. Rozanov, "Ultimate thickness to bandwidth ratio of radar absorbers," _IEEE Trans. Antennas Propag._, vol. 48, no. 8, pp. 1230–1234, Aug. 2000.

[4] W. W. Salisbury, "Absorbent body for electromagnetic waves," U.S. Patent 2 599 944, Jun. 10, 1952.

[5] C. M. Watts, X. Liu, and W. J. Padilla, "Metamaterial electromagnetic wave absorbers," _Adv. Mater._, vol. 24, no. 23, pp. OP98–OP120, May 2012.

[6] N. I. Landy, S. Sajuyigbe, J. J. Mock, D. R. Smith, and W. J. Padilla, "Perfect metamaterial absorber," _Phys. Rev. Lett._, vol. 100, no. 20, art. no. 207402, May 2008.

[7] 谢处方, 饶克勤, 《电磁场与电磁波》, 第 4 版. 北京: 高等教育出版社, 2006.

[8] R. L. Fante and M. T. McCormack, "Reflection properties of the Salisbury screen," _IEEE Trans. Antennas Propag._, vol. 36, no. 10, pp. 1443–1454, Oct. 1988.
