# Use a compatible and common Node.js LTS version
FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Install essential build tools
RUN apk add --no-cache python3 make g++

# Debug: Show initial directory contents
RUN echo "Initial directory contents:" && ls -la

# Copy package files first
COPY package.json package-lock.json ./

# Debug: Show files after copying package.json
RUN echo "Files after copying package.json:" && ls -la && \
    echo "Package.json contents:" && cat package.json

# Install dependencies with verbose output and capture errors
RUN npm install --verbose 2>&1 | tee npm-install.log || (cat npm-install.log && exit 1)

# Copy the rest of the application
COPY . .

# Debug: Show final directory contents
RUN echo "Final directory contents:" && ls -la

# Expose port
EXPOSE 5173

# Start the app
CMD ["npm", "run", "dev", "--", "--host"] 