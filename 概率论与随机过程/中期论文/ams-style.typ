// AMS 风格 Typst 模板（中文学术论文）
// 用法：#show: ams-paper.with(title: ..., authors: ..., abstract: ..., keywords: ...)

#let ams-paper(
  title: none,
  title-en: none,
  authors: (),
  abstract: none,
  abstract-en: none,
  keywords: (),
  keywords-en: (),
  body,
) = {
  // 页面
  set page(
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
    numbering: "1",
    number-align: center,
  )

  // 字体与正文
  set text(
    font: ("New Computer Modern", "Songti SC"),
    size: 10.5pt,
    lang: "zh",
    region: "cn",
  )
  set par(
    leading: 0.85em,
    first-line-indent: (amount: 2em, all: true),
    justify: true,
  )

  // 数学公式字体与编号（按节自动编号）
  set math.equation(
    numbering: n => {
      let h = counter(heading).get()
      if h.len() > 0 [(#h.first().#n)] else [(#n)]
    },
    supplement: [式],
  )
  // 每进入一个一级标题就重置公式计数
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
  }

  // 标题样式
  set heading(numbering: "1.1.1")
  show heading.where(level: 1): it => {
    set text(size: 13pt, weight: "bold")
    set block(above: 1.8em, below: 1.1em)
    it
  }
  show heading.where(level: 2): it => {
    set text(size: 11.5pt, weight: "bold")
    set block(above: 1.4em, below: 0.9em)
    it
  }
  show heading.where(level: 3): it => {
    set text(size: 10.8pt, weight: "bold", style: "italic")
    set block(above: 1.1em, below: 0.65em)
    it
  }

  // 标题块
  align(center)[
    #v(0.4em)
    #text(size: 16pt, weight: "bold")[#title]
    #v(0.8em)
    #for a in authors [
      #text(size: 11pt)[#a.name]
      #if "affiliation" in a [
        \ #text(size: 9.5pt, style: "italic")[#a.affiliation]
      ]
    ]
    #v(0.4em)
    #text(size: 9.5pt)[#datetime.today().display("[year] 年 [month] 月")]
    #v(0.6em)
  ]

  // 中文摘要与关键词
  if abstract != none {
    set par(first-line-indent: 0em)
    pad(left: 1.5em, right: 1.5em)[
      #set text(size: 9.8pt)
      #text(font: ("New Computer Modern", "Heiti SC", "PingFang SC"), weight: "bold")[摘要.]  #abstract
      #if keywords.len() > 0 [
        \ \ #text(font: ("New Computer Modern", "Heiti SC", "PingFang SC"), weight: "bold")[关键词.]  #keywords.map(k => text[#k]).join("；")
      ]
    ]
    v(0.6em)
  }

  // 英文摘要与关键词
  if abstract-en != none {
    set par(first-line-indent: 0em)
    pad(left: 1.5em, right: 1.5em)[
      #set text(size: 9.8pt, lang: "en")
      #if title-en != none [
        #align(center)[#text(weight: "bold", size: 10.5pt)[#title-en]]
        #v(0.3em)
      ]
      #text(weight: "bold")[Abstract.]  #abstract-en
      #if keywords-en.len() > 0 [
        \ \ #text(weight: "bold")[Keywords.]  #keywords-en.map(k => text[#k]).join("; ")
      ]
    ]
    v(0.8em)
  }

  // 图注左对齐 + 悬挂缩进
  show figure.caption: it => {
    set align(left)
    set par(hanging-indent: 2.5em, first-line-indent: 0em)
    set text(size: 9.5pt)
    it
  }

  // 正文
  body

  // 参考文献部分（手写时不需要，使用 bibliography 时由 main 控制）
}
