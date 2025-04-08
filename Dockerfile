FROM node:20

WORKDIR /app

# Install necessary build tools and dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 --ingroup nodejs --shell /bin/false nodejs

# Copy package files and change ownership
COPY package.json package-lock.json* ./
RUN chown -R nodejs:nodejs /app

# Switch to the non-root user
USER nodejs

# Debug: Show package.json contents and Node.js version as non-root user
RUN echo "Node.js version:" && node --version && \
    echo "npm version:" && npm --version && \
    echo "Package.json contents:" && cat package.json && \
    echo "Package-lock.json exists?" && ls -l package-lock.json*

# Install dependencies using npm ci (more reliable for CI/Docker)
# Clean cache first just in case
RUN npm cache clean --force && \
    npm ci --verbose

# Copy the rest of the application (as root temporarily for permissions)
USER root
COPY . .
RUN chown -R nodejs:nodejs /app
USER nodejs

# Expose the development server port
EXPOSE 5173

# Start the development server
CMD ["npm", "run", "dev", "--", "--host"] 