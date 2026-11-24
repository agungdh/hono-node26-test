# syntax=docker/dockerfile:1

ARG NODE_IMAGE=node:26-slim
ARG RUNTIME_IMAGE=ghcr.io/agungdh/chiseled-runtimes/nodejs:26-ubuntu26.04

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

COPY --from=deps --chown=10001:10001 /app/node_modules ./node_modules
COPY --from=builder --chown=10001:10001 /app/dist ./dist
COPY --chown=10001:10001 package.json ./package.json

EXPOSE 3000

CMD ["node", "dist/index.js"]
