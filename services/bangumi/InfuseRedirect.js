// 有趣的一点
// telegram 的 inline URL 会后台预先访问一次。不支持直接使用 URL Scheme 地址
// 所以新建一个公网服务器，302 跳转到 infuse URL Scheme

const http = require('http');
const url = require('url');

const hostname = '127.0.0.1';
const port = 4666;

const server = http.createServer((req, res) => {
  let episode = url.parse(req.url, true).query.name
  let encoded = encodeURIComponent(episode)
  res.statusCode = 302;
  res.setHeader('Location', `infuse://x-callback-url/play?url=https://nc.raws.dev/0:/${encoded}`);
  res.end();
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
