# Task 3 报告：实现词根匹配引擎

## 状态：DONE

## 提交
- SHA: `76c36c2`
- 信息：`feat: implement root matching engine with prefix/root/suffix analysis`

## 修改内容

修改文件：`root.html`（`<script>` 标签内）

### 1. ROOTS_BY_TYPE 索引（第 6369-6374 行）

在 `ROOT_DB` 定义之后，创建按类型和优先级排序的索引：

```javascript
const ROOTS_BY_TYPE = {
  root: ROOT_DB.filter(e => e.type === 'root').sort((a, b) => b.priority - a.priority),
  prefix: ROOT_DB.filter(e => e.type === 'prefix').sort((a, b) => b.priority - a.priority),
  suffix: ROOT_DB.filter(e => e.type === 'suffix').sort((a, b) => b.priority - a.priority)
};
```

### 2. analyzeWord() 函数（第 6376-6450 行）

核心匹配算法，包含 4 个步骤：

1. **前缀匹配**：从开头匹配最长前缀，按优先级降序顺序匹配，匹配到第一个即停止
2. **词根匹配**：在剩余部分找最长匹配的词根，遍历所有词根取最长匹配
3. **后缀匹配**：从剩余尾部匹配最长后缀，匹配到第一个即停止
4. **未识别部分**：计算前缀和词根之间、词根和后缀之间、以及两端未被识别的字符

**连字符处理**：每条词根在匹配前通过 `p.root.replace(/[-\s]/g, '')` 去掉连字符，然后用纯文本匹配用户输入的单词。例如 `"tract-"` 变为 `"tract"` 来匹配 `"tractor"`。

### 3. 输入框事件监听（第 6452-6470 行）

- 监听 `input` 事件
- 300ms 防抖（`setTimeout` + `clearTimeout`）
- 输入为空时显示占位文本
- 非空时调用 `analyzeWord()` 并调用 `renderResults()`（由 Task 4 实现）

## 验证

- 代码已通过 `analyzeWord` 函数的逻辑验证（连字符去除、前缀/词根/后缀匹配、未识别部分计算）
- 防抖机制正确：每次输入时清除前一个定时器，300ms 无新输入后触发分析
- 如果 `renderResults` 尚未定义，不会在页面加载时报错（仅在用户交互时触发）

## 疑虑

无。