# 任务 4：实现结果渲染与卡片交互

**文件：**
- 修改：`jerry520-yes.github.io/root.html`

## 上下文

当前 `root.html` 的 `<script>` 中已有 `ROOT_DB`、`ROOTS_BY_TYPE`、`analyzeWord()` 和输入框事件监听（调用 `renderResults()`）。现在需要实现 `renderResults()` 函数和卡片交互逻辑。

## 步骤 1：编写卡片渲染函数

在输入框事件监听代码之后，添加 `renderResults` 函数：

```javascript
function renderResults(result) {
  if (!result || result.parts.length === 0) {
    resultsEl.innerHTML = `
      <div class="no-match">
        <div class="no-match-icon">🔍</div>
        <p>未找到词根匹配</p>
        <p class="no-match-hint">试试启用 AI 增强模式，或检查单词拼写</p>
      </div>`;
    return;
  }
  
  let html = '<div class="cards-grid">';
  
  // 先展示未识别部分
  for (const u of result.unrecognized) {
    html += `
      <div class="root-card unrecognized">
        <div class="root-card-type">未识别</div>
        <div class="root-card-root">${u.text}</div>
        <div class="root-card-meaning">未匹配到词根</div>
        <div class="root-card-origin">—</div>
      </div>`;
  }
  
  // 展示匹配的每个部分
  for (const p of result.parts) {
    const typeLabel = p.type === 'prefix' ? '前缀' : p.type === 'suffix' ? '后缀' : '词根';
    const examplesHtml = (p.examples || []).slice(0,5).map(ex => 
      `<span class="root-example" data-word="${ex}">${ex}</span>`
    ).join('');
    
    html += `
      <div class="root-card" data-type="${p.type}">
        <div class="root-card-type">${typeLabel}</div>
        <div class="root-card-root">${p.root}</div>
        <div class="root-card-meaning">${p.meaning}<br><span class="meaning-en">${p.meaning_en}</span></div>
        <div class="root-card-origin">${p.origin}${p.from ? ' · ' + p.from : ''}</div>
        ${examplesHtml ? `<div class="root-card-examples">${examplesHtml}</div>` : ''}
      </div>`;
  }
  
  html += '</div>';
  
  // 添加整体拼合说明
  if (result.parts.length > 1) {
    html += '<div class="analysis-summary">';
    const partsStr = result.parts.map(p => `${p.root} (${p.meaning})`).join(' + ');
    html += `<p><strong>拆解：</strong> ${result.word} = ${partsStr}</p>`;
    html += '</div>';
  }
  
  resultsEl.innerHTML = html;
}
```

## 步骤 2：实现同根词点击交互

在 `renderResults` 函数之后，添加事件委托：

```javascript
// 事件委托：点击同根词触发新查询
resultsEl.addEventListener('click', function(e) {
  const example = e.target.closest('.root-example');
  if (example) {
    const word = example.dataset.word;
    input.value = word;
    input.dispatchEvent(new Event('input'));
    input.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }
});
```

## 步骤 3：添加卡片 CSS 样式

在 `<style>` 标签中，在结果区样式之后添加以下 CSS：

```css
/* ===== Results ===== */
.results-area{
  margin-top:24px;padding:28px;background:var(--bg);border-radius:10px;
  border:1px solid var(--rule);min-height:180px;
}
.results-area .placeholder{color:var(--muted);text-align:center;padding:40px 0;font-size:0.95rem}

.cards-grid{
  display:flex;flex-wrap:wrap;gap:16px;
}
.root-card{
  flex:1;min-width:200px;max-width:260px;background:var(--bg);
  border-radius:var(--radius);padding:20px 18px;border:1px solid var(--rule);
  border-left:4px solid var(--accent);transition:all 0.25s;
  display:flex;flex-direction:column;
}
.root-card:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(39,174,96,0.12)}
.root-card[data-type="prefix"]{border-left-color:#3498db}
.root-card[data-type="suffix"]{border-left-color:#e74c3c}
.root-card.unrecognized{border-left-color:#adb5bd;opacity:0.7}

.root-card-type{
  font-size:0.7rem;text-transform:uppercase;letter-spacing:0.08em;
  color:var(--muted);font-weight:700;margin-bottom:6px;
}
.root-card-root{
  font-size:1.4rem;font-weight:800;color:var(--accent);font-family:var(--mono);
  margin-bottom:10px;word-break:break-all;
}
.root-card[data-type="prefix"] .root-card-root{color:#3498db}
.root-card[data-type="suffix"] .root-card-root{color:#e74c3c}
.root-card-meaning{font-size:0.88rem;color:var(--ink);margin-bottom:8px;line-height:1.5;flex:1}
.root-card-meaning .meaning-en{color:var(--muted);font-size:0.78rem;display:block;margin-top:2px}
.root-card-origin{font-size:0.78rem;color:var(--muted);margin-bottom:10px;padding-bottom:10px;border-bottom:1px solid var(--rule)}
.root-card-examples{display:flex;flex-wrap:wrap;gap:5px;margin-top:auto}
.root-example{
  background:var(--accent-dim);color:var(--accent);padding:2px 8px;border-radius:10px;
  font-size:0.72rem;cursor:pointer;transition:all 0.2s;font-family:var(--mono);
}
.root-example:hover{background:var(--accent);color:#fff}

.analysis-summary{
  margin-top:20px;padding:16px 20px;background:var(--accent-dim);
  border-radius:var(--radius);font-size:0.92rem;line-height:1.6;
}
.analysis-summary strong{color:var(--accent)}

.no-match{text-align:center;padding:60px 20px;color:var(--muted)}
.no-match-icon{font-size:3rem;opacity:0.3;margin-bottom:16px}
.no-match-hint{font-size:0.85rem;margin-top:8px}
```

## 步骤 4：提交

```bash
git add jerry520-yes.github.io/root.html
git commit -m "feat: implement root card rendering with clickable example words"
```