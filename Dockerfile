# Declaramos que version de Node vamos a usar.
FROM node:18.12-alpine

# Declaramos que directorio vamos a usar dentro del contenedor.
WORKDIR /usr/src/app

# Copiamos el package.json y package-lock.json para saber que dependencias usamos.
COPY package*.json ./

# Instalamos todas la dependencias.
RUN npm i

# Copiamos todo lo que haya en esta carpeta al contenedor.
COPY . .

# Exponemos el puerto 3000 del contenedor (La misma que la que usamos en app.js).
EXPOSE 3000

# Por ultimo iniciamos con Node el archivo app.js
CMD [ "node", "app.js" ]
