FROM node:lts-alpine
WORKDIR /app
# USER npm
COPY . ./
RUN npm i -g --registry=https://registry.npm.taobao.org pnpm && pnpm install --registry=https://registry.npm.taobao.org
RUN npm run build && cp /app/public/index.html /app/dist/index.html

FROM ghcr.io/muchobien/pocketbase:latest
COPY --from=0 /app/dist /pb_public
EXPOSE 8090
ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/pb_data", "--publicDir=/pb_public"]