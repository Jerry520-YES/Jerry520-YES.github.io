# 任务 3：实现词根匹配引擎

**文件：**
- 修改：`jerry520-yes.github.io/root.html`（在 `<script>` 中追加引擎逻辑）

## 上下文

当前 `root.html` 的 `<script>` 标签中已有 `ROOT_DB` 数组（549 条词根数据）。现在需要在 `ROOT_DB` 定义之后，添加匹配引擎代码。

## 步骤 1：编写匹配算法函数

在 `ROOT_DB` 定义之后，添加以下代码：

```javascript
// 按类型和优先级排序的索引
const ROOTS_BY_TYPE = {
  root: ROOT_DB.filter(e => e.type === 'root').sort((a,b) => b.priority - a.priority),
  prefix: ROOT_DB.filter(e => e.type === 'prefix').sort((a,b) => b.priority - a.priority),
  suffix: ROOT_DB.filter(e => e.type === 'suffix').sort((a,b) => b.priority - a.priority)
};

function analyzeWord(word) {
  if (!word || word.trim().length === 0) return null;
  const w = word.trim().toLowerCase();
  const parts = [];
  let remaining = w;
  
  // 1. 前缀匹配 — 从开头匹配最长前缀
  let matchedPrefix = null;
  for (const p of ROOTS_BY_TYPE.prefix) {
    if (remaining.startsWith(p.root)) {
      matchedPrefix = { ...p, matchedText: p.root, start: 0, end: p.root.length };
      remaining = remaining.slice(p.root.length);
      break;
    }
  }
  if (matchedPrefix) parts.push(matchedPrefix);
  
  // 2. 词根匹配 — 从剩余部分找最长匹配
  let matchedRoot = null;
  for (const r of ROOTS_BY_TYPE.root) {
    const idx = remaining.indexOf(r.root);
    if (idx !== -1) {
      if (!matchedRoot || r.root.length > matchedRoot.root.length) {
        matchedRoot = { ...r, matchedText: r.root, start: (matchedPrefix ? matchedPrefix.end : 0) + idx, end: (matchedPrefix ? matchedPrefix.end : 0) + idx + r.root.length };
      }
    }
  }
  if (matchedRoot) parts.push(matchedRoot);
  
  // 3. 后缀匹配 — 从剩余尾部匹配最长后缀
  remaining = w;
  if (matchedPrefix) remaining = remaining.slice(matchedPrefix.root.length);
  if (matchedRoot) {
    const rootIdx = remaining.indexOf(matchedRoot.root);
    if (rootIdx !== -1) {
      remaining = remaining.slice(rootIdx + matchedRoot.root.length);
    }
  }
  
  let matchedSuffix = null;
  for (const s of ROOTS_BY_TYPE.suffix) {
    if (remaining.endsWith(s.root)) {
      matchedSuffix = { ...s, matchedText: s.root, start: w.length - s.root.length, end: w.length };
      remaining = remaining.slice(0, remaining.length - s.root.length);
      break;
    }
  }
  if (matchedSuffix) parts.push(matchedSuffix);
  
  // 4. 计算未识别部分
  const unrecognized = [];
  let checkStr = w;
  if (matchedPrefix) checkStr = checkStr.slice(matchedPrefix.root.length);
  if (matchedRoot) {
    const rootIdx = checkStr.indexOf(matchedRoot.root);
    if (rootIdx > 0) unrecognized.push({ text: checkStr.slice(0, rootIdx), type: 'unrecognized' });
    checkStr = checkStr.slice(rootIdx + matchedRoot.root.length);
  }
  if (matchedSuffix) {
    checkStr = checkStr.slice(0, checkStr.length - matchedSuffix.root.length);
  }
  if (checkStr.length > 0) unrecognized.push({ text: checkStr, type: 'unrecognized' });
  
  return { word: w, parts, unrecognized };
}
```

## 步骤 2：编写输入框自动分析逻辑（带防抖）

在 `analyzeWord` 函数之后，添加：

```javascript
const input = document.getElementById('word-input');
const resultsEl = document.getElementById('results');
let debounceTimer;

input.addEventListener('input', function() {
  clearTimeout(debounceTimer);
  const word = this.value.trim();
  if (word.length === 0) {
    resultsEl.innerHTML = '<div class="placeholder">输入单词，自动拆解词根...</div>';
    return;
  }
  debounceTimer = setTimeout(() => {
    const result = analyzeWord(word);
    renderResults(result);
  }, 300);
});
```

## 注意

- `renderResults` 函数将在任务 4 中实现，目前先确保它被调用（即使函数尚未定义，页面加载时不会报错，因为输入事件是在用户交互时触发）
- 确保代码放在 `ROOT_DB` 定义之后
- 词根的 `root` 值包含连字符（如 `"tract-"`），所以匹配时 `indexOf` 会匹配到带连字符的形式。需要在匹配时特殊处理——实际上，连字符是数据格式的一部分，但用户输入的单词中不会有连字符。所以匹配时应该去掉连字符。

等等，这是个重要问题！词根数据中 `root` 字段是 `"tract-"`（带连字符），但用户输入的单词是 `"tractor"`，`"tractor".indexOf("tract-")` 会返回 -1，因为 `"tractor"` 中不包含 `"tract-"`。

**所以匹配时需要去掉连字符：**

在匹配时，应该用 `p.root.replace(/[-\s]/g, '')` 来获取纯词根字符串进行匹配，然后用原始 `p.root` 存储。

让我修改算法：

```javascript
function analyzeWord(word) {
  if (!word || word.trim().length === 0) return null;
  const w = word.trim().toLowerCase();
  const parts = [];
  let remaining = w;
  
  // 1. 前缀匹配 — 从开头匹配最长前缀
  let matchedPrefix = null;
  for (const p of ROOTS_BY_TYPE.prefix) {
    const cleanRoot = p.root.replace(/[-\s]/g, '');
    if (remaining.startsWith(cleanRoot)) {
      matchedPrefix = { ...p, matchedText: cleanRoot, start: 0, end: cleanRoot.length };
      remaining = remaining.slice(cleanRoot.length);
      break;
    }
  }
  if (matchedPrefix) parts.push(matchedPrefix);
  
  // 2. 词根匹配 — 从剩余部分找最长匹配
  let matchedRoot = null;
  for (const r of ROOTS_BY_TYPE.root) {
    const cleanRoot = r.root.replace(/[-\s]/g, '');
    const idx = remaining.indexOf(cleanRoot);
    if (idx !== -1) {
      if (!matchedRoot || cleanRoot.length > matchedRoot.matchedText.length) {
        matchedRoot = { ...r, matchedText: cleanRoot, start: (matchedPrefix ? matchedPrefix.end : 0) + idx, end: (matchedPrefix ? matchedPrefix.end : 0) + idx + cleanRoot.length };
      }
    }
  }
  if (matchedRoot) parts.push(matchedRoot);
  
  // 3. 后缀匹配 — 从剩余尾部匹配最长后缀
  remaining = w;
  if (matchedPrefix) remaining = remaining.slice(matchedPrefix.matchedText.length);
  if (matchedRoot) {
    const rootIdx = remaining.indexOf(matchedRoot.matchedText);
    if (rootIdx !== -1) {
      remaining = remaining.slice(rootIdx + matchedRoot.matchedText.length);
    }
  }
  
  let matchedSuffix = null;
  for (const s of ROOTS_BY_TYPE.suffix) {
    const cleanRoot = s.root.replace(/[-\s]/g, '');
    if (remaining.endsWith(cleanRoot)) {
      matchedSuffix = { ...s, matchedText: cleanRoot, start: w.length - cleanRoot.length, end: w.length };
      remaining = remaining.slice(0, remaining.length - cleanRoot.length);
      break;
    }
  }
  if (matchedSuffix) parts.push(matchedSuffix);
  
  // 4. 计算未识别部分
  const unrecognized = [];
  let checkStr = w;
  if (matchedPrefix) checkStr = checkStr.slice(matchedPrefix.matchedText.length);
  if (matchedRoot) {
    const rootIdx = checkStr.indexOf(matchedRoot.matchedText);
    if (rootIdx > 0) unrecognized.push({ text: checkStr.slice(0, rootIdx), type: 'unrecognized' });
    checkStr = checkStr.slice(rootIdx + matchedRoot.matchedText.length);
  }
  if (matchedSuffix) {
    checkStr = checkStr.slice(0, checkStr.length - matchedSuffix.matchedText.length);
  }
  if (checkStr.length > 0) unrecognized.push({ text: checkStr, type: 'unrecognized' });
  
  return { word: w, parts, unrecognized };
}
```

## 步骤 3：提交

```bash
git add jerry520-yes.github.io/root.html
git commit -m "feat: implement root matching engine with prefix/root/suffix analysis"
```