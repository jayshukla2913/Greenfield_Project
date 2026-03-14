FROM node:18-alpine

WORKDIR /app

COPY Node_App/package*.json ./

RUN npm install

COPY Node_App .

EXPOSE 3000

CMD ["node", "server.js"]