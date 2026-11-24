```
npm install
npm run dev
```

```
open http://localhost:3000
```

## Docker

The image is built on the shell-less [chiseled-runtimes](https://github.com/agungdh/chiseled-runtimes)
Node.js 26 runtime, with dependencies compiled in a builder stage.

```
docker build -t hono-node26-test .
docker run --rm -p 3000:3000 hono-node26-test
```

Prebuilt multi-arch images (`linux/amd64`, `linux/arm64`) are published to GHCR
on every push to `main`, on `v*` tags, and manually via `workflow_dispatch`:

```
docker run --rm -p 3000:3000 ghcr.io/agungdh/hono-node26-test:latest
```
