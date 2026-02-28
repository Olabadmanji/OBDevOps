# Start from official Node.js image (Alpine = small/lightweight)
FROM node:20-alpine

# Set working directory inside the container
WORKDIR /app

# Copy package files first (Docker caches this layer if unchanged)
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of your app code
COPY . .

# Tell Docker your app uses port 3000
EXPOSE 3000

# Command to start your app when the container runs
CMD ["node", "server.js"]