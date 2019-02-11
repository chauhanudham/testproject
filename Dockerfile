FROM node:8
ARG version
ARG lastcommitsha
ENV version=${version}
ENV lastcommitsha=${lastcommitsha}
# Create app directory
WORKDIR /usr/src/app
HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:8080/healthcheck || exit 1
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
RUN npm install
# Bundle app source
COPY . .
EXPOSE 8080
CMD [ "npm", "start" ]
