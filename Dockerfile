FROM node:20

# Create app directory
WORKDIR /usr/src/app

# Install essential build tools
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install app dependencies
COPY package*.json ./

# Show debug information
RUN echo "Current directory:" && pwd && \
    echo "Files in directory:" && ls -la && \
    echo "Package.json contents:" && cat package.json

# Install dependencies with verbose output
RUN npm install --verbose

# Bundle app source
COPY . .

# Expose port
EXPOSE 5173

# Start the app
CMD ["npm", "run", "dev", "--", "--host"] 