// ============================================================
//  《电磁场与电磁波》课程开放题论文 —— 大纲（Outline）
//  题目：基于阻抗匹配与有耗介质波传播的雷达吸波材料原理分析
//  Principle Analysis of Radar Absorbing Materials Based on
//  Impedance Matching and Wave Propagation in Lossy Media
//
//  说明：本文件是 IEEE 风格论文大纲，含每节核心课本理论标注与
//  关键公式占位。正文（约 3000 字）将在下一轮生成。
//  正文阶段可将单栏改为双栏：
//    #show: rest => columns(2, gutter: 1em, rest)
// ============================================================

#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: ("Times New Roman", "Songti SC", "PingFang SC"), lang: "zh", size: 10.5pt)
#set par(justify: true, leading: 0.75em)
#set heading(numbering: "I.A.1.")
#set math.equation(numbering: "(1)")

#show heading.where(level: 1): set text(size: 12pt, weight: "bold")
#show heading.where(level: 2): set text(size: 11pt, weight: "bold")

// ---------- 标题区 ----------
#align(center)[
  #text(size: 16pt, weight: "bold")[
    基于阻抗匹配与有耗介质波传播的雷达吸波材料原理分析
  ]
  #v(0.4em)
  #text(size: 11pt, style: "italic")[
    Principle Analysis of Radar Absorbing Materials Based on \
    Impedance Matching and Wave Propagation in Lossy Media
  ]
  #v(0.6em)
  #text(size: 10pt)[作者姓名 · 学号 · 院系]
]

#v(0.8em)

// ---------- 摘要 / Index Terms ----------
*Abstract* —— #text(style: "italic")[
  〔约 150 字占位〕从隐身需求引出 → 指出 RAM 工作机理可由阻抗匹配
  与有耗介质中平面波传播解释 → 概述本文推导链（麦克斯韦方程组 →
  反射系数 → 阻抗变换 → RAM 设计）→ 给出 Salisbury / Jaumann
  对 RCS 的缩减量化估算结论。
]

*Index Terms* —— Radar absorbing material (RAM), impedance matching,
reflection coefficient, lossy dielectric, radar cross section (RCS),
Salisbury screen, Jaumann absorber.

// =============================================================
= 引言 Introduction
// =============================================================
- *1.1* 雷达隐身需求与 *雷达截面积（RCS）* 的工程含义；定义式：
  $ sigma = lim_(R -> infinity) 4 pi R^2 (|bold(E)_s|^2) / (|bold(E)_i|^2) $
- *1.2* 隐身的两条路径：外形修形 vs 材料吸收；本文聚焦后者。
- *1.3* 文章脉络：麦氏方程 → 平面波 → 反射系数 Γ → 阻抗匹配判据 →
  RAM 工程方案 → RCS 缩减估算。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：雷达截面积 RCS 定义；坡印廷矢量
  $bold(S) = bold(E) times bold(H)$ 对入射 / 散射功率的物理意义。
]

// =============================================================
= 平面波传播理论基础 Theoretical Foundations
// =============================================================

== 麦克斯韦方程组与亥姆霍兹方程
- 无源区时谐麦氏方程出发，推导矢量亥姆霍兹方程：
  $ nabla^2 bold(E) + k^2 bold(E) = 0, quad k = omega sqrt(mu epsilon.alt) $
- 平面波解：$bold(E)(z) = bold(E)_0 e^(-gamma z)$。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：麦克斯韦方程组（时谐形式）、本构关系
  $bold(D) = epsilon.alt bold(E)$、$bold(B) = mu bold(H)$、
  亥姆霍兹方程、平面波解、波数 $k = omega sqrt(mu epsilon.alt)$。
]

== 波阻抗与传播常数
- 由 $nabla times bold(E) = -j omega mu bold(H)$ 得本征波阻抗：
  $ eta = sqrt(mu / epsilon.alt), quad eta_0 = sqrt(mu_0 / epsilon.alt_0) approx 377 " " Omega $
- 相速度 $v_p = omega \/ beta$；平面波 $bold(E)$–$bold(H)$–$bold(k)$ 三正交。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：本征波阻抗 η、传播常数 β、相速度 $v_p$、
  $bold(E)$–$bold(H)$–$bold(k)$ 三正交关系（教材 6.1–6.2）。
]

== 有耗介质中的传播
- 复介电常数：
  $ epsilon.alt_c = epsilon.alt' - j epsilon.alt'' = epsilon.alt' (1 - j tan delta) $
  其中 $tan delta = (sigma + omega epsilon.alt'') / (omega epsilon.alt')$。
- 复传播常数：
  $ gamma = j omega sqrt(mu epsilon.alt_c) = alpha + j beta $
- 良导体近似：
  $ alpha approx beta approx sqrt(pi f mu sigma) $
- 趋肤深度：
  $ delta_s = 1 / alpha = 1 / sqrt(pi f mu sigma) $

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：复介电常数 $epsilon.alt' - j epsilon.alt''$、
  损耗角正切 tan δ、衰减常数 α、相位常数 β、趋肤深度 $delta_s$
  （教材 6.3–6.5）、有耗介质中的复波阻抗 $eta_c$。
]

// =============================================================
= 边界处的反射与阻抗匹配 Reflection at Interfaces
// =============================================================

== 边界条件与反射 / 透射系数推导
- 正入射时切向 $bold(E)$、$bold(H)$ 连续；设入射 + 反射 + 透射场，
  解联立方程：
  $ Gamma = (eta_2 - eta_1) / (eta_2 + eta_1), quad
    tau = (2 eta_2) / (eta_2 + eta_1) $
- 验证关系：$1 + Gamma = tau$。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：电磁场边界条件（切向 E、H 连续；法向 D、B 跳变）、
  垂直入射反射系数 Γ、透射系数 τ（教材 7.2）。
]

== 功率反射与能量守恒
- 时间平均功率密度：
  $ bold(S)_"av" = 1/2 "Re"(bold(E) times bold(H)^*) $
- 功率反射率 $|Gamma|^2$；功率透射率 $(eta_1\/eta_2)|tau|^2$；
  验证 $|Gamma|^2 + (eta_1\/eta_2)|tau|^2 = 1$。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：坡印廷矢量、时间平均功率密度、能量守恒。
]

== 阻抗匹配判据
- 完美吸收的必要条件：
  $ Gamma = 0 quad <==> quad Z_"in" = eta_0 $
- 工程指标：回波损耗 $"RL" = -20 log_10 |Gamma|$；吸波带宽常定义
  为 RL < −10 dB（即 $|Gamma|^2 < 0.1$）。
- 多层介质等效输入阻抗（传输线类比）：
  $ Z_"in" = eta_d (Z_L + eta_d tanh(gamma d)) / (eta_d + Z_L tanh(gamma d)) $

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：阻抗匹配条件 $Z_"in" = eta_0$；多层介质等效输入
  阻抗的传输线类比（教材 7.4 多层介质阻抗变换）。
]

// =============================================================
= 雷达吸波材料（RAM）原理分析 Analysis of RAM
// =============================================================
（本节为论文核心，约 900 字）

== RAM 的两大设计思路
- *吸收型*（lossy bulk）：靠有耗介质内部衰减 α 耗散能量。
- *抵消型*（destructive interference）：靠多层界面反射波相位相消。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*："内部 α 衰减"与"界面相位干涉"两种机制对照。
]

== 单层金属背板上的有耗介质 —— 传输线类比
- 后端短路 $Z_L = 0$，故：
  $ Z_"in" = eta_d tanh(gamma d) $
- 设计目标：选 $(mu_r, epsilon.alt_r, d)$ 使 $Z_"in" approx eta_0$，
  同时令 $alpha d$ 足够大以保证内部充分耗散。
- 磁性吸波材料（铁氧体）通过 $mu_r$ 上升使 $eta_d$ 接近 $eta_0$，
  从而实现"薄而宽"的吸波层。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：短路终端的输入阻抗变换公式；有耗介质 $gamma =
  alpha + j beta$ 在 tanh 中的耦合作用；$mu_r$ / $epsilon.alt_r$
  同时调节才能保 $eta_d approx eta_0$ 且 α 足够大。
]

== Salisbury 屏：经典抵消型 RAM 推导
- 结构：电阻片（$R_s = 377 " "Omega \/ "sq"$）+ 厚度 $d = lambda \/ 4$
  的空气间隔 + 金属反射板。
- 推导：金属背板 $Z = 0$ 经 λ/4 段变换 →
  $ Z_"在 R 屏处" = (eta_0)^2 / 0 -> infinity $
  （等效开路），R 屏与开路并联 $= R_s = eta_0$，故 $Gamma = 0$。
- 频带分析：偏离中心频率时 $d != lambda\/4$，电长度 βd 变化，
  $Z_"in"$ 偏离 $eta_0$，反射回升 —— 解释 Salisbury 屏窄带本质。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：四分之一波长阻抗变换器（短路 ↔ 开路转换）、
  驻波分布、表面阻抗 $R_s$、阻抗并联运算。
]

== Jaumann 吸收体：宽带化的多层结构
- 多层 R 屏级联，每层近似 λ/4 间隔；
- 利用多层介质逐级阻抗变换 → 在更宽频带内保持 RL < −10 dB；
- 广义反射系数递推：
  $ Gamma_n = (Gamma_(n,0) + Gamma_(n-1) e^(-2 gamma d)) /
    (1 + Gamma_(n,0) Gamma_(n-1) e^(-2 gamma d)) $
- 权衡：层数 ↑ → 带宽 ↑、总厚度 ↑。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：多层介质级联阻抗变换、广义反射系数递推（教材 7.4）。
]

== RCS 缩减的量化估算
- 单站 RCS 与反射系数的关系：
  $ sigma_"RAM" / sigma_"metal" approx |Gamma|^2 $
- 估算：
  - $|Gamma| = 0.1$ → RCS 缩减 20 dB；
  - $|Gamma| = 0.032$ → RCS 缩减 30 dB。

#figure(
  rect(width: 100%, height: 4cm, stroke: 0.5pt + gray),
  caption: [〔图占位〕Salisbury 屏与 Jaumann 吸收体的
            $|Gamma|(f)$ 频率响应示意。],
)

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：RCS 与反射系数的关系、坡印廷矢量计算散射功率。
]

// =============================================================
= 讨论与拓展 Discussion
// =============================================================

== 斜入射与极化依赖
- TE / TM 极化下 Fresnel 反射系数：
  $ Gamma_"TE" = (eta_2 cos theta_i - eta_1 cos theta_t) /
    (eta_2 cos theta_i + eta_1 cos theta_t) $
  $ Gamma_"TM" = (eta_2 cos theta_t - eta_1 cos theta_i) /
    (eta_2 cos theta_t + eta_1 cos theta_i) $
- Brewster 角下 TM 波 $Gamma = 0$；RAM 设计需宽角度，不能仅依赖
  Brewster 单点匹配。

#text(fill: rgb("#1a73e8"))[
  *核心理论标注*：斜入射 Snell 定律、Fresnel 反射系数、Brewster 角
  （教材 7.5–7.6）。
]

== 厚度 – 带宽的物理极限
- Rozanov 极限（定性）：
  $ |integral_0^infinity ln |Gamma(lambda)| d lambda| <= 2 pi^2
    mu_(r,s) d $
- 物理根源：因果性 + Kramers–Kronig 关系（课程内容的延伸）。

== 与现代超材料 / FSS 的关系
- 一句话过渡：超材料通过等效 $mu_"eff"$、$epsilon.alt_"eff"$ 设计，
  在本文的阻抗匹配框架内拓展了 RAM 的设计自由度。

// =============================================================
= 结论 Conclusion
// =============================================================
- RAM 的本质：让分层有耗结构的等效输入阻抗 $Z_"in" approx eta_0$。
- 数学本质：麦克斯韦方程组在分层有耗介质中的边值问题。
- Salisbury / Jaumann 案例展示了课程中的反射系数、阻抗变换、传输线
  类比等公式如何直接指导工程实现。

// =============================================================
= References（占位，待补充）
// =============================================================
+ D. M. Pozar, *Microwave Engineering*, 4th ed. Wiley, 2012.
+ E. F. Knott, *Radar Cross Section*, 2nd ed. SciTech, 2004.
+ K. N. Rozanov, "Ultimate thickness to bandwidth ratio of radar
  absorbers," *IEEE Trans. Antennas Propag.*, vol. 48, no. 8,
  pp. 1230–1234, Aug. 2000.
+ W. W. Salisbury, "Absorbent body for electromagnetic waves,"
  U.S. Patent 2 599 944, Jun. 10, 1952.
+ C. M. Watts, X. Liu, W. J. Padilla, "Metamaterial electromagnetic
  wave absorbers," *Adv. Mater.*, vol. 24, no. 23, pp. OP98–OP120,
  2012.
+ 〔本课程教材〕《电磁场与电磁波》，第 6、7 章。
