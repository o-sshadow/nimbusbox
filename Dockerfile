FROM node:20.11.1

WORKDIR /app

# Install essential build tools
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy only package files first
COPY package.json package-lock.json ./

# Install dependencies with verbose output
RUN npm install --verbose

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 5173

# Start the app
CMD ["npm", "run", "dev", "--", "--host"] 