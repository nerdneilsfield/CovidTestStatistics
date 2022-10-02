# CovoidLateStatistics

一个简单的管理和查询核酸记录迟交记录的系统。

# 测试前端

前端基于 `Vue3` 开发。

1. 首先安装 `Nodejs`， 推荐使用 `fnm` 下载管理
2. 安装 `pnpm`: `npm i -g --registry=https://registry.npm.taobao.org pnpm `
3. 安装依赖: `pnpm install --registry=https://registry.npm.taobao.org`
4. 使用
   1. 启动 hot reload 模式: `pnpm run dev`
   2. 编译生成静态文件: `pnpm run build`, 生成的文件会在 `dist/` 目录下。手动复制 `cp ./public/index.html ./dist`。然后可以用静态服务器打开，比如 `python3 -m http.server 8800`
   3. 使用 `ESLint` Lint 代码: `pnpm run lint`

## 测试后端

后端基于 `pocketbase`。

1. 从 [PocketBase](https://pocketbase.io) 下载最新的 Binary 文件
2. 启动一个测试的 demo, ` ./pocketbase serve --http "0.0.0.0:9091" --dir pp`
3. 打开 `http://[ip地址]:9091/_/` 进入后台页面
4. 初次使用需要新建一个管理员账户，登录并新建一个用户
5. 在 `Settings -> Import Collections` 中导入当前目录下的 `pb_schema.json`
6. 可以手动的添加一些 `users` 和 `late_record`


## 部署

使用 `Docker` 搭配 `docker-compose` 来进行生产环境的部署。

1. 下载安装 `Docker` 和 `docker-compose`
2. 使用 `docker-compose` 启动命令: `docker-compose up -d` 会自动从 `Dockerfile` 编译并启动 `docker`
3. 使用 `nginx.conf` 来做端口转发和负载均衡，具体请自己查看相关教程
