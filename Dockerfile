FROM node:20

# Create app directory
WORKDIR /usr/src/app

# Install essential build tools
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy package files (ensure package-lock.json is included)
COPY package.json package-lock.json* ./

# Show debug information - Verify files are copied
RUN echo "Current directory:" && pwd && \
    echo "Files in directory:" && ls -la && \
    echo "Package.json contents:" && cat package.json && \
    echo "Package-lock.json exists?" && ls -l package-lock.json*

# Install dependencies using npm ci (more reliable for CI/Docker)
# Use verbose logging and redirect stderr to stdout for capture
RUN echo "Attempting npm ci..." && \
    npm ci --verbose 2>&1 | tee npm-ci.log || (echo "npm ci failed. Log content:" && cat npm-ci.log && exit 1)

# Bundle app source
COPY . .

# Expose port
EXPOSE 5173

# Start the app
CMD ["npm", "run", "dev", "--", "--host"] 