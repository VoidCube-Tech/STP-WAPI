FROM node:24.14-alpine AS builder

WORKDIR /opt/projects/wa_api

COPY --chown=node:node package*.json tsconfig.json ./
COPY --chown=node:node src ./src

RUN npm ci
RUN npm run build
RUN npm prune --omit=dev

FROM node:24.14-alpine AS runner

WORKDIR /opt/projects/wa_api

COPY --from=builder /opt/projects/wa_api/package*.json ./
COPY --from=builder /opt/projects/wa_api/node_modules ./node_modules
COPY --from=builder /opt/projects/wa_api/dist ./dist

USER node

EXPOSE 3000

CMD ["node", "dist/index.js"]