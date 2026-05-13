# BUILD STAGE
FROM node:20-alpine AS builder

WORKDIR /build

# Install dependencies (including devDependencies for build)
COPY package*.json ./
RUN npm ci && npm cache clean --force

# Copy source code
COPY . .

# Build application
RUN npm run build

# Remove devDependencies for production
RUN npm prune --production

# PRODUCTION STAGE
FROM node:20-alpine

WORKDIR /app

# Security: Create non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nestjs -u 1001

# Copy built application from builder
COPY --from=builder --chown=nestjs:nodejs /build/dist ./dist
COPY --from=builder --chown=nestjs:nodejs /build/node_modules ./node_modules
COPY --from=builder --chown=nestjs:nodejs /build/package.json ./

# Switch to non-root user
USER nestjs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

CMD ["node", "dist/main"]