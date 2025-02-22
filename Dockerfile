# # base-image for node on any machine using a template variable,
# # see more about dockerfile templates here: https://www.balena.io/docs/learn/develop/dockerfile/#dockerfile-templates
# # and about balena base images here: https://www.balena.io/docs/reference/base-images/base-images/
# FROM balenalib/%%BALENA_ARCH%%-node:20-run

# # use `install_packages` if you need to install dependencies,
# # for instance if you need git, just uncomment the line below.
# # RUN install_packages git

# # Defines our working directory in container
# WORKDIR /usr/src/app

# # Copies the package.json first for better cache on later pushes
# COPY package*.json ./

# # Check node and npm versions
# # RUN node -v && npm -v

# # This install npm dependencies on the balena build server,
# # making sure to clean up the artifacts it creates in order to reduce the image size.
# # RUN npm install --production --unsafe-perm && npm cache verify && rm -rf /tmp/*

# # This will copy all files in our root to the working directory in the container
# COPY . ./

# # server.js will run when container starts up on the device
# CMD ["npm", "start"]





# Stage 1: Build
FROM balenalib/aarch64-node:20-build AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev --unsafe-perm --no-audit && npm cache verify
# COPY . ./
# RUN npm run build

# Stage 2: Run
FROM balenalib/aarch64-node:20-run
WORKDIR /app
COPY . ./
# COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
# RUN npm install --production --no-audit --unsafe-perm
CMD ["npm", "start"]
