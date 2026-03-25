### STAGE 1: Build ###

# We label our stage as ‘builder’
FROM node:18.17.0-alpine3.17 as builder

COPY package.json package-lock.json ./

## Storing node modules on a separate layer will prevent unnecessary npm installs at each build

RUN npm ci && mkdir /nextjs-app && mv ./node_modules ./nextjs-app

WORKDIR /nextjs-app

COPY . .

## Build the nextjs app in production mode and store the artifacts in dist folder

RUN npm cache clean --force

ARG API_URL="/api"
ARG SCRNSHOT_URL_PRFX="/scrn_shot"

RUN apk --no-cache add sd --repository=http://dl-cdn.alpinelinux.org/alpine/v3.19/community/
RUN sd --string-mode "http://localhost:4201" "$API_URL" ./src/config.json
RUN sd --string-mode "http://localhost:9001" "$SCRNSHOT_URL_PRFX" ./src/config.json
RUN sd --string-mode "1x00000000000000000000AA" "$CF_TURNSTILE_SITE_KEY" ./src/config.json

RUN npm run build
RUN npm run export


### STAGE 2: Setup ###

FROM alpine:3.17.0

COPY --from=builder /nextjs-app/out /app/
