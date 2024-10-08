#-----------BunJS Base to generate yarn.lock----------#
FROM oven/bun:alpine AS bun

# Change work directory
WORKDIR /app

# Prepare dev dependencies
COPY package.json bun.lockb ./

# Generate yarn.lock from bun.lockb
RUN bun install --yarn --dry-run

#---------------------NodeJS Base---------------------#
FROM node:18-slim AS base

# Change work directory
WORKDIR /app

# Prepare dev dependencies
COPY package.json ./
COPY --from=bun /app/yarn.lock ./

#------------Build NextJS From Source Code------------#
FROM base AS builder

# Set commit build ID
ARG CI_COMMIT_SHORT_SHA
ENV CI_COMMIT_SHORT_SHA=$CI_COMMIT_SHORT_SHA

# Install dependencies
RUN yarn install --ignore-scripts --frozen-lockfile

# Copy source code
COPY . .

# Disable NextJS Telemetry
ENV NEXT_TELEMETRY_DISABLED 1

# Fix sharp deps
RUN npm rebuild sharp

# NextJS Sharp PATH
ENV NEXT_SHARP_PATH=/app/node_modules/sharp

# Run build next app
RUN yarn run build

#------------Production Serving Built Code------------#
FROM base AS runner

# Set env to production
ENV ENV production
ENV NODE_ENV production

# Create unix user & group
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Copy NextJS built code bundle
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Change user
USER nextjs

# Expose port 3000
EXPOSE 3000

# Set env to serve at port 3000
ENV PORT 3000

# Set hostname serve
ENV HOSTNAME "0.0.0.0"

# Start serving
ENTRYPOINT [ "node", "./server.js" ]
