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
