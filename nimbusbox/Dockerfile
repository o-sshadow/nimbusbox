FROM node:18-alpine

WORKDIR /app

# Install necessary build tools and dependencies
RUN apk add --no-cache python3 make g++ git

# Copy package files
COPY package*.json ./

# Install dependencies with verbose output
RUN npm install --verbose

# Copy the rest of the application
COPY . .

# Expose the development server port
EXPOSE 5173

# Start the development server
CMD ["npm", "run", "dev", "--", "--host"] 