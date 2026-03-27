FROM node:20-alpine

WORKDIR /app

COPY package.json ./
COPY src ./src
COPY .env.example ./.env.example

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

CMD ["npm", "start"]
