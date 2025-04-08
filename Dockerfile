FROM node:20-slim

WORKDIR /app

# Install only essential build tools
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy package files
COPY package.json ./

# Debug: Show environment and versions
RUN echo "Node.js version:" && node --version && \
    echo "npm version:" && npm --version && \
    echo "Current directory:" && pwd && \
    echo "Files in current directory:" && ls -la

# Install dependencies with detailed output
RUN npm install --verbose 2>&1 | tee npm-install.log || (cat npm-install.log && exit 1)

# Copy the rest of the application
COPY . .

# Expose the development server port
EXPOSE 5173

# Start the development server
CMD ["npm", "run", "dev", "--", "--host"] 