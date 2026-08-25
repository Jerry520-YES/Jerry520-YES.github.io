# Task 4 报告：实现结果渲染与卡片交互

## 状态：DONE

## 提交

- 提交 SHA: `f14cabf`
- commit 标题: `feat: implement root card rendering with clickable example words`
- 文件变更: `root.html` (+113 行)

## 完成的工作

### 1. 添加卡片 CSS 样式（`<style>` 标签）

在 `#ai-summary` 样式之后、Features Grid 之前，添加了完整的结果卡片 CSS，包括：

- **`.cards-grid`** — 弹性布局容器，卡片间间距 16px
- **`.root-card`** — 卡片基础样式（圆角、边框、左侧色条、hover 上浮阴影）
- **`.root-card[data-type="prefix"]`** — 前缀卡片蓝色色条
- **`.root-card[data-type="suffix"]`** — 后缀卡片红色色条
- **`.root-card.unrecognized`** — 未识别部分灰色半透明
- **`.root-card-type` / `.root-card-root` / `.root-card-meaning` / `.root-card-origin`** — 卡片内部各字段样式
- **`.root-card-examples` / `.root-example`** — 同根词标签样式（可点击，hover 变绿底白字）
- **`.analysis-summary`** — 整体拼合说明区域
- **`.no-match` / `.no-match-icon` / `.no-match-hint`** — 无匹配结果占位样式

### 2. 添加 `renderResults()` 函数（`<script>` 标签）

在输入框事件监听代码之后，实现了完整的渲染函数：

- **无匹配时**：显示包含搜索图标、提示文字和 AI 建议的占位信息
- **未识别部分**：以灰色不透明卡片展示，标注"未识别"
- **匹配部分**：为每个前缀/词根/后缀生成独立卡片，包含：
  - 类型标签（前缀/词根/后缀，中文显示）
  - 词根名称（绿色高亮，等宽字体）
  - 中文释义 + 英文释义
  - 来源语言 + 原始词
  - 同根词标签（最多 5 个，可点击）
- **多部分拆解**：当词根数量 > 1 时，在卡片下方显示拼合说明（如 `extractable = ex- (向外) + tract (拉) + -able (能够...的)`）

### 3. 添加事件委托（`<script>` 标签）

在 `renderResults()` 之后添加了 `resultsEl.addEventListener('click', ...)`：

- 通过 `e.target.closest('.root-example')` 捕获点击的同根词标签
- 将输入框值设为点击的单词
- 触发 `input` 事件以重新分析
- 平滑滚动到输入框位置

## 疑虑

无。