FROM node:20-alpine as builder

# Debug: Show Node.js and npm versions
RUN echo "=== Node.js Environment ===" && \
    echo "Node.js version:" && node --version && \
    echo "npm version:" && npm --version && \
    echo "Current user:" && whoami && \
    echo "Current directory:" && pwd

WORKDIR /app

# Debug: Show initial directory state
RUN echo "=== Initial Directory State ===" && \
    echo "Working directory:" && pwd && \
    echo "Directory contents:" && ls -la && \
    echo "Directory permissions:" && ls -ld . && \
    echo "Parent directory contents:" && ls -la ..

# Install essential build tools
RUN echo "=== Installing Build Tools ===" && \
    apk add --no-cache python3 make g++ && \
    echo "Python version:" && python3 --version && \
    echo "Make version:" && make --version && \
    echo "G++ version:" && g++ --version

# Debug: Show directory after installing tools
RUN echo "=== Directory After Tool Installation ===" && \
    echo "Working directory:" && pwd && \
    echo "Directory contents:" && ls -la

# Copy package files first
COPY package.json package-lock.json ./

# Debug: Show files after copying package.json
RUN echo "=== After Copying Package Files ===" && \
    echo "Working directory:" && pwd && \
    echo "Directory contents:" && ls -la && \
    echo "Package.json contents:" && cat package.json && \
    echo "Package-lock.json exists?" && ls -l package-lock.json* && \
    echo "File permissions:" && ls -l package.json package-lock.json*

# Install dependencies with verbose output
RUN echo "=== Installing Dependencies ===" && \
    echo "npm config list:" && npm config list && \
    echo "npm cache verify:" && npm cache verify && \
    npm install --verbose 2>&1 | tee npm-install.log || \
    (echo "=== npm install failed ===" && \
     echo "npm-install.log contents:" && \
     cat npm-install.log && \
     echo "=== Directory contents after failure ===" && \
     ls -la && \
     exit 1)

# Debug: Show node_modules after installation
RUN echo "=== After Dependency Installation ===" && \
    echo "node_modules directory exists?" && ls -ld node_modules && \
    echo "node_modules/.bin contents:" && ls -la node_modules/.bin

# Copy the rest of the application
COPY . .

# Debug: Show final directory contents
RUN echo "=== Final Directory State ===" && \
    echo "Working directory:" && pwd && \
    echo "Directory contents:" && ls -la && \
    echo "src directory contents:" && ls -la src && \
    echo "node_modules size:" && du -sh node_modules

# Production stage
FROM node:20-alpine

WORKDIR /app

# Debug: Show production stage initial state
RUN echo "=== Production Stage Initial State ===" && \
    echo "Working directory:" && pwd && \
    echo "Directory contents:" && ls -la

# Copy from builder stage
COPY --from=builder /app .

# Debug: Show production stage final state
RUN echo "=== Production Stage Final State ===" && \
    echo "Working directory:" && pwd && \
    echo "Directory contents:" && ls -la && \
    echo "node_modules exists?" && ls -ld node_modules && \
    echo "package.json exists?" && ls -l package.json

# Expose port
EXPOSE 5173

# Debug: Show environment before starting
RUN echo "=== Environment Before Start ===" && \
    echo "PATH:" && echo $PATH && \
    echo "NODE_ENV:" && echo $NODE_ENV && \
    echo "npm config list:" && npm config list

# Start the app
CMD ["npm", "run", "dev", "--", "--host"] 