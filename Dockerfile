# syntax=docker/dockerfile:1

ARG NODE_IMAGE=node:26-slim
ARG RUNTIME_IMAGE=node:26-slim

FROM ${NODE_IMAGE} AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

FROM ${NODE_IMAGE} AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

FROM ${RUNTIME_IMAGE}

ENV NODE_ENV=production
WORKDIR /app

COPY --from=deps --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/dist ./dist
COPY --chown=node:node package.json ./package.json

USER node

EXPOSE 3000

CMD ["node", "dist/index.js"]
