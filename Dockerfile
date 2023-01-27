#dependency installation
FROM node:18-alpine as install-dependencies

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm ci --omit=dev

COPY . .


# creating a build

FROM node:18-alpine as create-build

WORKDIR /usr/src/app

COPY --from=install-dependencies usr/src/app ./

RUN npm run build

USER node

# Running the application

FROM node:18-alpine as run

WORKDIR /usr/src/app

COPY --from=install-dependencies usr/src/app/node_modules ./node_modules
COPY --from=create-build usr/src/app/dist ./dist
COPY package.json ./

CMD [ "npm", "run", "start" ]

