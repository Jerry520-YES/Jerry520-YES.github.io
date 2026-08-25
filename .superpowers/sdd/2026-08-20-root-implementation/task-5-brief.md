# 任务 5：实现 AI 增强模式

**文件：**
- 修改：`jerry520-yes.github.io/root.html`

## 上下文

当前 `root.html` 已有完整的 HTML 骨架、CSS 样式、词根数据库、匹配引擎和卡片渲染。现在需要添加 AI 增强模式。

HTML 中已有：
- AI 开关按钮：`<button id="ai-toggle" class="ai-toggle" onclick="toggleAI()"></button>`
- API Key 按钮：`<button id="btn-api-key" class="btn-api-key" onclick="toggleApiPanel()">⚙ API Key</button>`
- API Key 面板：`<div id="api-key-panel" class="api-key-panel">...</div>`
- AI 摘要区域：`<div id="ai-summary"></div>`

## 步骤 1：编写 AI 增强 JavaScript

在 `<script>` 标签中（在 `renderResults` 函数之后），添加以下代码：

```javascript
// ===== AI Enhancement =====
let aiEnabled = localStorage.getItem('root_ai_enabled') === 'true';
let apiKey = localStorage.getItem('root_api_key') || '';

// 初始化 AI 开关状态
if (aiEnabled) document.getElementById('ai-toggle').classList.add('on');

function toggleAI() {
  aiEnabled = !aiEnabled;
  localStorage.setItem('root_ai_enabled', aiEnabled);
  document.getElementById('ai-toggle').classList.toggle('on', aiEnabled);
  // 如果有当前结果，重新分析
  const word = input.value.trim();
  if (word) {
    // 清空 AI 摘要
    document.getElementById('ai-summary').style.display = 'none';
    // 触发本地分析
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      const result = analyzeWord(word);
      renderResults(result);
      if (aiEnabled && apiKey) {
        analyzeWithAI(word, document.getElementById('lang-select').value, result);
      }
    }, 300);
  }
}

function toggleApiPanel() {
  document.getElementById('api-key-panel').classList.toggle('show');
}

function saveApiKey() {
  apiKey = document.getElementById('api-key-input').value.trim();
  localStorage.setItem('root_api_key', apiKey);
  document.getElementById('api-key-panel').classList.remove('show');
}

async function analyzeWithAI(word, language, localResult) {
  if (!apiKey) {
    showToast('请先设置 API Key');
    return;
  }
  
  const aiSummary = document.getElementById('ai-summary');
  aiSummary.innerHTML = '<div class="ai-loading"><span class="spinner"></span> AI 分析中...</div>';
  aiSummary.style.display = 'block';
  
  const prompt = `分析单词 "${word}" 的词根词源结构。
语言：${language}
要求：
1. 拆解前缀/词根/后缀，每个部分给出含义
2. 给出词源来源（拉丁语/希腊语/古法语等）
3. 给出整体含义的演变逻辑
4. 对每个组成部分给出 2-3 个同根词示例
5. 以 JSON 格式返回，格式：{ "parts": [{"type":"prefix/root/suffix","root":"...","meaning":"...","origin":"...","examples":[...]}], "summary": "..." }`;

  try {
    const resp = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${apiKey}` },
      body: JSON.stringify({
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.3,
        max_tokens: 1000
      })
    });
    const data = await resp.json();
    const content = data.choices?.[0]?.message?.content;
    if (content) {
      renderAIResult(content, word);
    } else {
      aiSummary.innerHTML = '<div class="ai-error">AI 分析未返回结果，请检查 API Key 是否有效。</div>';
    }
  } catch (err) {
    console.error('AI analysis failed:', err);
    aiSummary.innerHTML = '<div class="ai-error">AI 分析失败，请检查网络连接和 API Key。</div>';
  }
}

function renderAIResult(content, word) {
  const aiSummary = document.getElementById('ai-summary');
  let html = '<div class="ai-section">';
  html += '<div class="ai-section-header"><span class="ai-badge">AI 增强</span></div>';
  
  // 尝试解析 JSON
  try {
    const jsonMatch = content.match(/\{[\s\S]*\}/);
    const data = jsonMatch ? JSON.parse(jsonMatch[0]) : null;
    if (data) {
      if (data.parts) {
        html += '<div class="ai-parts">';
        for (const p of data.parts) {
          html += `<div class="ai-part">
            <span class="ai-part-type">${p.type}</span>
            <strong>${p.root}</strong> — ${p.meaning}
            ${p.origin ? `<span class="ai-part-origin">${p.origin}</span>` : ''}
          </div>`;
        }
        html += '</div>';
      }
      if (data.summary) {
        html += `<div class="ai-summary-text">${data.summary}</div>`;
      }
    } else {
      // 不是 JSON，显示原始文本
      html += `<div class="ai-raw">${content.replace(/\n/g, '<br>')}</div>`;
    }
  } catch {
    // 解析失败，显示原始文本
    html += `<div class="ai-raw">${content.replace(/\n/g, '<br>')}</div>`;
  }
  
  html += '</div>';
  aiSummary.innerHTML = html;
  aiSummary.style.display = 'block';
}

// Toast 提示
function showToast(msg) {
  const existing = document.querySelector('.toast');
  if (existing) existing.remove();
  const toast = document.createElement('div');
  toast.className = 'toast';
  toast.textContent = msg;
  document.body.appendChild(toast);
  setTimeout(() => toast.classList.add('show'), 10);
  setTimeout(() => {
    toast.classList.remove('show');
    setTimeout(() => toast.remove(), 300);
  }, 2500);
}
```

## 步骤 2：修改输入框事件监听以支持 AI

在现有的 `input` 事件监听中，在 `renderResults(result)` 调用之后，添加 AI 增强检查：

```javascript
// 在 debounceTimer 回调中，renderResults(result) 之后添加：
if (aiEnabled && apiKey && result && result.parts.length > 0) {
  const lang = document.getElementById('lang-select').value;
  analyzeWithAI(word, lang, result);
}
```

## 步骤 3：添加 AI 摘要区域 CSS

在 `<style>` 标签中添加以下 CSS：

```css
/* ===== AI Enhancement ===== */
#ai-summary{display:none;margin-top:20px}
.ai-section{
  background:linear-gradient(135deg,#e8f5e9 0%,#f1f8e9 100%);
  border-radius:var(--radius);padding:24px;border:1px solid #c8e6c9;
}
.ai-section-header{display:flex;align-items:center;margin-bottom:16px}
.ai-badge{
  background:var(--accent);color:#fff;padding:3px 12px;border-radius:10px;
  font-size:0.75rem;font-weight:700;
}
.ai-parts{display:flex;flex-direction:column;gap:8px;margin-bottom:16px}
.ai-part{padding:8px 12px;background:rgba(255,255,255,0.7);border-radius:6px;font-size:0.9rem}
.ai-part-type{
  font-size:0.7rem;text-transform:uppercase;letter-spacing:0.05em;
  color:var(--muted);font-weight:700;margin-right:8px;
}
.ai-part-origin{color:var(--muted);font-size:0.8rem;margin-left:8px}
.ai-summary-text{
  padding:16px;background:rgba(255,255,255,0.7);border-radius:8px;
  font-size:0.95rem;line-height:1.7;border-left:4px solid var(--accent);
}
.ai-raw{white-space:pre-wrap;font-size:0.85rem;color:var(--muted);margin-top:12px;line-height:1.6}
.ai-loading{display:flex;align-items:center;gap:12px;color:var(--muted);padding:20px}
.ai-error{color:#e74c3c;padding:16px;font-size:0.9rem}
.spinner{
  width:16px;height:16px;border:2px solid rgba(39,174,96,0.3);
  border-top-color:var(--accent);border-radius:50%;animation:spin 0.6s linear infinite;
}
@keyframes spin{to{transform:rotate(360deg)}}
.toast{
  position:fixed;bottom:32px;left:50%;transform:translateX(-50%) translateY(20px);
  background:#333;color:#fff;padding:12px 24px;border-radius:8px;font-size:0.9rem;
  opacity:0;transition:all 0.3s;z-index:999;
}
.toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
```

## 步骤 4：提交

```bash
git add jerry520-yes.github.io/root.html
git commit -m "feat: add AI enhancement mode with API key panel and OpenAI integration"
```