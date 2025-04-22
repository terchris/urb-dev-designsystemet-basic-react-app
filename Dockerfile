# filename: templates/designsystemet-basic-react-app/Dockerfile
# This Dockerfile is for a basic react application using serve to serve the static files.

# Build stage
FROM node:20-slim AS builder

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm install

# Copy source files
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:20-slim AS production
WORKDIR /app

# Copy only the built assets
COPY --from=builder /app/dist ./dist

# Install serve with specific version for consistency
RUN npm install -g serve@14.2.1

# Run as non-root user for security
USER node

EXPOSE 3000

# Corrected: Use a single `-l` parameter with host:port format
# This is the correct syntax for serve version 14.2.1
CMD ["serve", "-s", "dist", "-l", "tcp://0.0.0.0:3000"]