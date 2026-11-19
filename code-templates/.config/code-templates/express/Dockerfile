# poderia usar apenas node:24, o alpine cria uma imagem bem mais reduzida
FROM node:24-alpine

# cria um diretorio app no container
WORKDIR /app 

# copia tudo do diretorio e cola no workdir folder/container folder (ou seja, /app)
COPY . .

# instala node_modules
RUN npm install

# porta onde será rodado dentro do container
EXPOSE 4250

# executa "npm run dev" ao arrancar -> script de desenvolvimento criado dentro do package.json
CMD [ "npm", "run", "dev" ]

