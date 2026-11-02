# ===== 第一階段：在「工廠」裡編譯 =====
FROM node:24-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build
RUN npm prune --omit=dev

# ===== 第二階段：只把成品裝進「出貨箱」 =====
FROM node:24-alpine
WORKDIR /app
ENV NODE_ENV=production

LABEL org.opencontainers.image.source="https://github.com/SUN0115/ci-demo"

COPY --from=build /app/package.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

USER node
EXPOSE 3000
CMD ["node", "dist/main.js"]