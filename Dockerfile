# FROM node:23-slim qual node utilizar
# apelido o aslias
FROM node:lts-alpine3.20 AS build 


# Diretorio de trabalho
WORKDIR /usr/src/app

# Copia o package.json e o package-lock.json porque o npm install
# vai usar esses arquivos para instalar as dependencias
COPY package*.json ./

# Instala as dependencias
RUN npm i

# Copia o restante dos arquivos da aplicacao
COPY . .

# Roda o build da aplicacao
RUN npm run build
RUN npm i --omit=dev 

# O segundo estagio nao precisa dos passos executados no primeiro estagio
FROM node:lts-alpine3.20

# Diretorio de trabalho
WORKDIR /usr/src/app

# Copio o que foi construido no primeiro estagio com o alias build
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
# Expõe a porta 3000
EXPOSE 3000

# Comando para subir a aplicacao
CMD ["npm", "run", "start:prod"]

