let ID = 0
const ID_MAP = new Map()
function generateId() {
    return ++ID;
}

function getId(key) {
    if (ID_MAP.has(key)) {
        return ID_MAP.get(key);
    }
    const id = generateId();
    ID_MAP.set(key, id);
    return id;
}

function readMarkDown(url = './docs/webgpu.md') {
    return new Promise((res, rej) => {
        // 读取并渲染 md 文件
        fetch(url) // 这里换成你的 md 文件路径
            .then(response => response.text())
            .then(text => {
                res(text);
            })
            .catch(err => rej(err));
    })
}

/**
 * 获取关键词的上下文
 * @param {string} text - 原始文本
 * @param {string} keyword - 要搜索的关键词
 * @param {number} range - 前后字符数
 * @returns {Array} - 包含所有匹配上下文的数组
 */
function getKeywordContext(text, keyword, range = 5) {
    const regex = new RegExp(`(.{0,${range}})(${keyword})(.{0,${range}})`, "g");
    let match;
    const results = [];

    while ((match = regex.exec(text)) !== null) {
        results.push({
            before: match[1],
            keyword: match[2],
            after: match[3],
            context: match[1] + match[2] + match[3]
        });
    }

    return results;
}

function searchWithContext(mdContent, keyword) {
    const lines = mdContent.split('\n');
    const results = [];
    let lastAnchor = ""; // 记录最近找到的标题 ID

    lines.forEach((line, index) => {
        // 1. 如果这一行是标题，更新当前的锚点坐标
        if (line.startsWith('#')) {
            // 将 "## 我的标题" 转换为 "我的标题"，再转为 id 格式
            lastAnchor = line.trim()
        }

        // 2. 如果这一行包含关键词
        if (line.includes(keyword)) {
            results.push({
                text: line.trim(),
                anchor: lastAnchor ? `#${lastAnchor}` : "" // 最近的标题锚点
            });
        }
    });

    return results;
}

/**
 * 高亮句子中的关键词
 * @param {string} sentence - 原始句子
 * @param {string} keyword - 要高亮的关键词
 * @returns {string} - 带有高亮 HTML 的句子
 */
function highlightKeyword(sentence, keyword) {
    if (!keyword) return sentence; // 如果没有关键词，直接返回原句

    // 创建一个正则表达式，忽略大小写，全局匹配
    const regex = new RegExp(`(${keyword})`, 'gi');

    // 用 span 包裹关键词
    return sentence.replace(regex, '<span class="highlight">$1</span>');
}


function highlightKeywords(keyword, content = document.getElementById("content")) {
    const walker = document.createTreeWalker(
        content,
        NodeFilter.SHOW_TEXT, // 只看文本
        null,
        false
    );

    const nodes = [];
    let currentNode;

    // 1. 先把所有匹配的文本节点找出来（避免边遍历边修改导致的死循环）
    while (currentNode = walker.nextNode()) {
        if (currentNode.textContent.includes(keyword)) {
            nodes.push(currentNode);
        }
    }

    for (const node of nodes) {
        const index = node.nodeValue.indexOf(keyword);
        if (index !== -1) {
            // 创建 Range
            const range = document.createRange();
            range.setStart(node, index);
            range.setEnd(node, index + keyword.length);

            // 用 span 包裹高亮
            const highlight = document.createElement("span");
            highlight.style.background = "yellow";
            highlight.style.color = "black";
            range.surroundContents(highlight);

            // break; // 如果只需要第一个匹配，可以跳出循环
        }
    }
}

function getQueryParam() {
    const url = window.location.href;
    const arr = url.split("?");

    // 没有 ? 参数，直接返回空对象
    if (arr.length < 2) return {};

    // 取 ? 后面的部分，并去掉 # 后面的 hash 部分（如果有）
    const query = arr[1].split('#')[0];
    const obj = {};

    query.split("&").forEach(item => {
        // 处理 item 为空的情况（例如 ?a=1&&b=2）
        if (!item) return;

        // 分割 key 和 value，最多只分割一次（防止 value 中含有 = 号被截断）
        const [rawKey, rawValue] = item.split("=");

        if (rawKey) {
            // 解码 key
            const key = decodeURIComponent(rawKey);
            // 解码 value，如果没有 value 则设为空字符串
            const value = rawValue ? decodeURIComponent(rawValue) : "";

            // (可选) 如果你想支持同名参数变成数组，可以在这里加逻辑
            // if (key in obj) { ... } 

            obj[key] = value;
        }
    });

    return obj;
}


