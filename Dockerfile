FROM node:20-slim as builder

WORKDIR /app

# Install only essential build tools
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Debug: Show initial directory contents
RUN echo "Initial directory contents:" && ls -la /app

# Copy package files first
COPY package.json package-lock.json ./

# Debug: Show files after copying package.json
RUN echo "Files after copying package.json:" && ls -la && \
    echo "Package.json contents:" && cat package.json && \
    echo "Current directory:" && pwd

# Install dependencies with detailed output
RUN npm install --verbose 2>&1 | tee npm-install.log || (cat npm-install.log && exit 1)

# Copy the rest of the application
COPY . .

# Debug: Show final directory contents
RUN echo "Final directory contents:" && ls -la

# Production stage
FROM node:20-slim

WORKDIR /app

# Copy from builder stage
COPY --from=builder /app .

# Expose the development server port
EXPOSE 5173

# Start the development server
CMD ["npm", "run", "dev", "--", "--host"] 