#Feature one
FROM node:18-alpine AS base
 
FROM base AS builder
RUN apk add --no-cache libc6-compat
RUN apk update
# Set working directory
WORKDIR /app
RUN npm install -g turbo
COPY . .
RUN turbo prune --scope=docs --docker
 
# Add lockfile and package.json's of isolated subworkspace
FROM base AS installer
RUN apk add --no-cache libc6-compat
RUN apk update
WORKDIR /app
 
# test if the turbo prune worked
# # First install the dependencies (as they change less often)
# # First install the dependencies (as they change less often)
# # First install the dependencies (as they change less often)
# # First install the dependencies (as they change less often)
# # First install the dependencies (as they change less often)
# # First install the dependencies (as they change less often)
# # First install the dependencies (as they change less often)


COPY .gitignore .gitignore
COPY --from=builder /app/out/json/ .
COPY --from=builder /app/out/package-lock.json ./package-lock.json
RUN npm install
 
COPY --from=builder /app/out/full/ .
COPY turbo.json turbo.json

RUN npx turbo run build --filter=docs...

FROM base AS runner
WORKDIR /app

RUN addgroup --system --gid 1001 nextjs
RUN adduser --system --uid 1001 nextjs
USER nextjs
COPY --from=installer /app .
EXPOSE 3000

# CMD ["sleep", "infinity"]
CMD [ "npm", "start", "--prefix", "apps/docs" ]
# CMD node apps/docs/dist/index.js
# CMD [ "npm", "run", "start" ]
