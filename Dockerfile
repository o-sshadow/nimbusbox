# Use a compatible and common Node.js LTS version
FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Install essential build tools
RUN apk add --no-cache python3 make g++

# Copy only package files first
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Expose port
EXPOSE 5173

# Start the app
CMD ["npm", "run", "dev", "--", "--host"] 