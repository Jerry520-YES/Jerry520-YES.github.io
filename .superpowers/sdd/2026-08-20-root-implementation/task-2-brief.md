# 任务 2：构建词根数据库（JavaScript 数据）

**文件：**
- 修改：`jerry520-yes.github.io/root.html`（在 `<script>` 中追加数据）

## 步骤 1：编写词根数据库结构

在 `root.html` 的 `<script>` 标签中，在 `// 全部 JavaScript 内联于此` 注释位置，定义 `ROOT_DB` 数组。每个条目结构：

```javascript
{
  root: "tract",          // 词根
  type: "root",           // root / prefix / suffix
  meaning: "拉，拖",       // 含义（中文）
  meaning_en: "pull, draw",  // 含义（英文）
  origin: "拉丁语",        // 来源语言
  from: "trahere",        // 词源
  examples: ["tractor","extract","attract","contract","subtract"],  // 同根词
  priority: 2,            // 1普通，2高频，3核心
  languages: ["en","fr","es"]  // 适用语言
}
```

## 词根数据

### 拉丁语核心词根（~150 条）

每条都需要完整的 `meaning`、`meaning_en`、`origin`（拉丁语）、`from`（拉丁语原词）、`examples`（3-5 个）、`priority`、"languages" 字段。以下列出词根名，你需要为每个条目填写完整信息：

```
act, agri, am, anim, ann, aqua, aud, bell, bene, brev, capit, carn, ced, cent, cern, cess, cid, circum, civ, clam, clar, clud, clus, cogn, commun, cord, corpor, corp, cred, curr, curs, deb, dent, dict, dign, doc, domin, don, dorm, duc, duct, dur, ego, equi, erg, err, evit, fac, fact, fer, ferv, fid, fin, firm, fix, flex, flect, flu, flux, form, fort, frater, fug, fund, fus, gen, gest, grad, grat, grav, greg, hab, hab, haust, hosp, host, imit, imper, init, it, iter, jac, ject, jud, judic, junct, jur, just, labor, laps, lect, leg, leg, liber, lig, limin, lingu, liter, loc, log, loqu, luc, lud, lumin, lun, magn, major, mal, man, mand, manu, mar, mater, matur, medi, memor, ment, merg, migr, min, minor, mir, miss, mit, mob, moll, mon, monstr, mort, mot, mov, mult, mun, mut, narr, nat, nav, neg, noc, noct, nom, nomin, non, nov, null, num, ocul, od, oper, opt, or, ord, ori, orn, par, paren, part, pass, pater, pati, patri, ped, pel, pend, pens, pet, plac, plaud, plen, plet, plex, plic, plor, plu, plur, plus, pon, popul, port, pos, posit, poss, potent, prehend, prem, press, prim, prior, prob, propri, pugn, punct, pute, quest, quies, quit, radi, radic, rap, rapt, rat, rect, reg, rem, rid, ris, rog, rogat, rot, rupt, sacr, sanct, sat, satis, scend, sci, scop, scrib, script, sect, secut, sed, semin, sen, sent, sequ, serm, serr, serv, sign, simil, simul, sin, sing, sist, soci, sol, solv, somn, son, soph, sort, spati, spec, spect, sper, spir, spond, stat, stell, stern, stim, stip, stit, stitut, stingu, struct, suad, suav, sub, sum, sumpt, super, surg, tact, tang, teg, templ, tempor, tend, ten, tent, tenu, term, terr, test, test, tex, text, therm, tim, ting, toll, torp, tort, tract, trad, trud, trus, tum, turb, typ, umbr, un, unct, und, urb, urg, us, ut, vac, vad, val, van, vap, vari, ven, vend, vener, vent, ver, verb, ver, vers, vert, ves, vest, vet, via, vic, vid, vig, vinc, vind, viol, vir, vis, vit, viv, voc, vol, volv, vor, vulg
```

### 希腊语词根（~50 条）

```
aero, anthrop, arch, aster, auto, biblio, bio, chron, cosm, crat, cycl, dem, derm, geo, graph, gym, hemi, hetero, homo, hydr, hypno, iso, logy, macro, mega, meter, micro, mono, morph, myth, neo, ology, path, ped, phil, phobia, phone, photo, phys, poly, psych, scope, soph, tech, tele, therm, thesis, zo
```

### 前缀（~80 条）

每条 `type: "prefix"`，`origin` 为来源语言，`from` 为原词，`examples` 为示例词。

```
a-, ab-, ad-, ambi-, ante-, anti-, apo-, auto-, bi-, circum-, co-, com-, con-, contra-, counter-, de-, demi-, di-, dia-, dis-, dys-, e-, ex-, extra-, fore-, hemi-, hetero-, homo-, hyper-, hypo-, il-, im-, in-, inter-, intra-, intro-, ir-, macro-, mal-, mega-, meta-, micro-, mid-, mis-, mono-, multi-, neo-, non-, ob-, omni-, ortho-, out-, over-, pan-, para-, per-, peri-, poly-, post-, pre-, preter-, pro-, proto-, pseudo-, quad-, quasi-, re-, retro-, semi-, sub-, super-, supra-, sur-, sym-, syn-, tele-, trans-, tri-, ultra-, un-, under-, uni-, vice-
```

### 后缀（~80 条）

每条 `type: "suffix"`，`origin` 为来源语言，`from` 为原词，`examples` 为示例词。

```
-able, -ably, -aceous, -acious, -acy, -ade, -age, -al, -ance, -ant, -ar, -ard, -arian, -arium, -ary, -ate, -ation, -ative, -cle, -cracy, -crat, -cule, -cy, -dom, -ee, -en, -ence, -ency, -ent, -er, -ern, -ery, -ese, -esque, -ess, -est, -et, -etic, -ette, -ful, -fy, -hood, -ia, -ial, -ian, -ible, -ic, -ical, -ice, -ify, -ile, -ine, -ing, -ion, -ious, -ish, -ism, -ist, -ite, -ity, -ive, -ization, -ize, -less, -let, -like, -ling, -ly, -ment, -ness, -or, -ory, -ous, -ship, -sion, -some, -tion, -tious, -tude, -ty, -ure, -ward, -wards, -wise, -y
```

## 要求
- 每个条目必须包含所有字段：`root`, `type`, `meaning`, `meaning_en`, `origin`, `from`, `examples`, `priority`, `languages`
- 含义需要准确，符合词源学常识
- `examples` 至少 3 个，最多 5 个
- `priority` 值：核心词根用 3，高频用 2，普通用 1
- 前缀和后缀的 `meaning` 是功能含义（如 re- = "again, back"）
- 希腊语词根的 `origin` 是 "希腊语"

## 步骤 2：提交

```bash
git add jerry520-yes.github.io/root.html
git commit -m "feat: add root database with ~300 roots, ~80 prefixes, ~80 suffixes"
```