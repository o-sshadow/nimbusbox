FROM node:20-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

# Show debug information
RUN echo "Current directory:" && pwd && \
    echo "Files in directory:" && ls -la && \
    echo "Package.json contents:" && cat package.json

# Install dependencies
RUN npm install

# Bundle app source
COPY . .

# Expose port
EXPOSE 5173

# Start the app
CMD ["npm", "run", "dev", "--", "--host"] 