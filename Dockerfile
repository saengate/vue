# etapa de compilación
FROM node:13.10.1-alpine3.10 as base-develop
WORKDIR /app
RUN mkdir -p vue

RUN apk add --no-cache git nano

# Oh my zsh
RUN apk add --no-cache zsh curl
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

WORKDIR /app/vue

ENV PATH /app/vue/node_modules/.bin:$PATH

COPY ./djfullapp-vue/package*.json ./
# COPY ./djfullapp-vue-nuxt/package*.json ./

RUN npm install @vue/cli -g
RUN npm install
RUN npm audit fix

COPY ./djfullapp-vue /app/vue
# COPY ./djfullapp-vue-nuxt /app/vue

RUN npm run test:unit

EXPOSE 80

WORKDIR /app/vue

CMD [ \
    "sh", \
    "-c", \
    "npm run serve -- --port 80 &&  \
    /bin/sh" \
    ]
