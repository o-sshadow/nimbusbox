# Use a compatible and common Node.js LTS version
FROM node:20

# Set the working directory
WORKDIR /app

# Install essential build tools just in case a dependency needs native compilation
# Clean up apt cache afterwards to keep image size reasonable
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy package.json and package-lock.json (if it exists)
# This step is cached if these files don't change
COPY package.json package-lock.json* ./

# Install dependencies using npm ci for a clean, reproducible install from lockfile
# Use verbose logging and capture output in case of errors
# Ensure package-lock.json is up-to-date before building!
RUN echo "Attempting npm ci..." && \
    npm ci --verbose > npm-ci.log 2>&1 || \
    (echo "npm ci failed. See log below:" && cat npm-ci.log && exit 1)

# Copy the rest of the application code
# This layer is invalidated if any project files change
COPY . .

# Optional: Verify node_modules/.bin exists and contains vite (uncomment to debug)
# RUN ls -l node_modules/.bin

# Expose the port the Vite dev server runs on
EXPOSE 5173

# Command to run the application development server
# npm run dev should execute the locally installed vite from node_modules/.bin
CMD ["npm", "run", "dev", "--", "--host"] 