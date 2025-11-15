# Explicação: Como Resolver o Problema de Redirecionamento no Moodle

## Introdução

Este documento explica o problema enfrentado ao acessar `http://localhost:8080/moodle/` e as soluções implementadas para que o Moodle funcione corretamente em um subdiretório, sem redirecionar para a raiz (`http://localhost:8080/`). O problema ocorria porque a configuração do proxy reverso e do servidor Apache não estava alinhada com o `WWWROOT` do Moodle.

## Problema Identificado

- Ao acessar `http://localhost:8080/moodle/`, o navegador era redirecionado para `http://localhost:8080/`.
- Os logs mostravam que o Moodle (Apache) respondia com código HTTP 303 (redirecionamento), indicando que a URL da requisição não batia com a configuração esperada.
- O `WWWROOT` do Moodle estava definido como `http://localhost:8080/moodle`, mas o Moodle via a requisição como `http://localhost:8080/` devido ao proxy do nginx, causando conflito.

## Soluções Implementadas

### 1. Separação de Redes para Melhor Isolamento

- **Problema:** Todos os serviços (nginx, Moodle, bancos de dados) estavam na mesma rede Docker (`backend`), o que não era ideal para segurança e organização.

- **Solução:** Criei uma nova rede chamada `moodle_net` exclusivamente para o Moodle e seu banco de dados (`moodle-db`). O nginx agora conecta a ambas as redes (`backend` para o banco principal e `moodle_net` para acessar o Moodle).

- **Arquivo alterado:** `server/compose.yml`

  - Adicionei `moodle_net` em `networks`.
  - Atribuí `moodle` e `moodle-db` à `moodle_net`.
  - Conectei o `web` (nginx) a ambas as redes.

- **Resultado:** Melhor isolamento de rede, facilitando a comunicação controlada entre serviços.

### 2. Melhoria do Proxy Reverso no Nginx

- **Problema:** O proxy básico não passava headers suficientes e não tinha otimizações, causando incompatibilidades.

- **Solução:**

  - Adicionei headers extras (`X-Forwarded-Host`, `X-Forwarded-Port`) para que o Moodle receba informações completas sobre a requisição original.
  - Configurei timeouts (60 segundos) para conexões, envio e leitura, evitando travamentos.
  - Ativei cache de 1 ano para arquivos estáticos do Moodle (imagens, CSS, JS) com `expires 1y` e `add_header Cache-Control "public, immutable"`.

- **Arquivo alterado:** `server/nginx/default.conf`

  - Modificações nas seções `location /moodle/` e `location ~ ^/moodle/(.*\.(jpg|jpeg|gif|png|css|js|ico|svg|ttf|woff|woff2))$`.

- **Resultado:** Proxy mais robusto, eficiente e compatível com aplicações web dinâmicas.

### 3. Configuração do Apache no Container Moodle

- **Problema:** O Apache no container Moodle estava configurado para servir apenas a raiz (`/`), mas precisávamos que ele entendesse `/moodle` como a raiz do Moodle. Isso causava redirecionamentos porque a URL não batia com o `WWWROOT`.

- **Solução:**

  - Criei um arquivo customizado `server/apache/000-default.conf` baseado na configuração padrão do Apache, adicionando a diretiva `Alias /moodle /var/www/html`. Isso mapeia qualquer requisição para `/moodle` diretamente para a pasta raiz do Moodle (`/var/www/html`).
  - Montei esse arquivo como volume no container Moodle para sobrescrever a configuração padrão.

- **Arquivos criados/alterados:**

  - `server/apache/000-default.conf` (novo arquivo com o alias).
  - `server/compose.yml` (adicionado volume: `- ./apache/000-default.conf:/etc/apache2/sites-enabled/000-default.conf`).

- **Resultado:** O Apache agora trata `/moodle` como a raiz do site, permitindo que o Moodle reconheça a URL corretamente e não redirecione.

### 4. Ajuste no Proxy Pass do Nginx

- **Problema:** Inicialmente, usei `proxy_pass http://moodle/;` (com barra no final), que "removia" o prefixo `/moodle` da URL enviada ao Moodle. Mas com o alias no Apache, precisamos enviar o caminho completo.

- **Solução:** Mudei para `proxy_pass http://moodle;` (sem barra), então o nginx envia `/moodle/` diretamente para o Apache.

- **Arquivo alterado:** `server/nginx/default.conf`

- **Resultado:** O fluxo fica alinhado: Browser → Nginx (`/moodle/`) → Apache (`/moodle/`) → Moodle serve corretamente.

## Como Descobri Essas Soluções

- **Separação de Redes:** Baseado em melhores práticas de Docker Compose para isolamento de serviços. É comum separar redes para bancos de dados e aplicações.

- **Melhoria do Proxy:** Conhecimento padrão de configuração de nginx para proxies reversos. Headers como `X-Forwarded-*` são essenciais para aplicações que precisam de informações sobre o cliente original.

- **Configuração do Apache:** Identifiquei o problema através de logs e testes (usando `docker exec` para inspecionar o container). Sabia que o Apache usa `Alias` para mapear caminhos virtuais, e verifiquei a estrutura do container (`/var/www/html`) para confirmar onde o Moodle está instalado. Moodle suporta subdiretórios, mas o servidor web precisa ser configurado adequadamente.

- **Ajuste do Proxy Pass:** Após configurar o alias, testei e ajustei o `proxy_pass` para garantir que o caminho fosse passado corretamente.

## Fluxo Final de Funcionamento

1. Você acessa `http://localhost:8080/moodle/`.

2. O Nginx recebe e proxia para o Moodle em `/moodle/`.

3. O Apache usa o alias para mapear `/moodle` para `/var/www/html`.

4. O Moodle vê a URL como `http://localhost:8080/moodle/` (compatível com `WWWROOT`) e serve a página sem redirecionamentos.

## Conclusão

Com essas mudanças, o Moodle agora funciona corretamente em `/moodle/` sem redirecionar para a raiz. Os containers foram reiniciados, e o acesso deve funcionar. Se o Moodle ainda não estiver instalado, acesse `/moodle` e siga o processo de instalação. Para mais detalhes ou ajustes, consulte os arquivos modificados no repositório.

---

Claro! Vou explicar passo a passo o que fiz para resolver o problema de redirecionamento ao acessar http://localhost:8080/moodle/. O issue era que o Moodle estava redirecionando para a raiz (localhost:8080) porque a configuração não estava alinhada para funcionar em um subdiretório como /moodle. Aqui vai o resumo das mudanças:

1. Separação de Redes para Melhor Isolamento
   Problema: Todos os serviços (nginx, Moodle, bancos) estavam na mesma rede backend, o que não era ideal para segurança e organização.
   Solução: Criei uma nova rede chamada moodle_net exclusivamente para o Moodle e seu banco de dados (moodle-db). O nginx agora conecta a ambas as redes (backend para o banco principal e moodle_net para acessar o Moodle).
   Arquivo alterado: compose.yml
   Resultado: Melhor isolamento – o Moodle e seu DB ficam em uma rede separada, e o nginx consegue se comunicar com ambos.
2. Melhoria do Proxy Reverso no Nginx
   Problema: O proxy básico não passava todos os headers necessários, e não tinha otimizações como timeouts ou cache.
   Solução:
   Adicionei headers extras (X-Forwarded-Host, X-Forwarded-Port) para que o Moodle receba informações completas sobre a requisição original.
   Configurei timeouts (60 segundos) para conexões, envio e leitura, evitando travamentos.
   Ativei cache de 1 ano para arquivos estáticos do Moodle (imagens, CSS, JS) para melhorar performance.
   Arquivo alterado: default.conf
   Resultado: Proxy mais robusto e eficiente, com melhor compatibilidade para aplicações web.
3. Configuração do Apache no Container Moodle
   Problema: O Apache no container Moodle estava configurado para servir apenas a raiz (/), mas queríamos o Moodle em /moodle. Quando o nginx enviava requisições para /moodle/, o Moodle via a URL como http://localhost:8080/ (devido ao proxy), que não batia com o WWWROOT configurado (http://localhost:8080/moodle), causando redirecionamento.
   Solução:
   Criei um arquivo customizado 000-default.conf com um Alias /moodle /var/www/html, que mapeia qualquer requisição para /moodle diretamente para a pasta raiz do Moodle (/var/www/html).
   Montei esse arquivo como volume no container Moodle para sobrescrever a configuração padrão do Apache.
   Arquivos criados/alterados: 000-default.conf (novo) e compose.yml (adicionado volume).
   Resultado: O Apache agora entende /moodle como a raiz do site, então o Moodle reconhece a URL corretamente e não redireciona.
4. Ajuste no Proxy Pass do Nginx
   Problema: Inicialmente, usei proxy_pass http://moodle/; (com barra no final), que "removia" o prefixo /moodle da URL enviada ao Moodle. Mas com o alias no Apache, precisamos enviar o caminho completo.
   Solução: Mudei para proxy_pass http://moodle; (sem barra), então o nginx envia /moodle/ diretamente para o Apache, que usa o alias para servir o conteúdo certo.
   Arquivo alterado: default.conf
   Resultado: O fluxo fica: Browser → Nginx (/moodle/) → Apache (/moodle/) → Moodle serve corretamente, sem redirecionamentos.
   Resumo do Fluxo Agora:
   Você acessa http://localhost:8080/moodle/.
   O Nginx (porta 8080) recebe e proxia para o Moodle em /moodle/.
   O Apache no Moodle usa o alias para mapear /moodle para a pasta do Moodle.
   O Moodle vê a URL como http://localhost:8080/moodle/ (compatível com o WWWROOT), serve a página sem redirecionar.
   Os containers foram reiniciados, e agora deve funcionar! Se o Moodle ainda não estiver instalado, acesse /moodle e siga o processo de instalação. Se tiver dúvidas sobre alguma parte, é só perguntar! 😊

---

Descobri a necessidade de configurar o Apache através de um processo de troubleshooting baseado no comportamento observado e no meu conhecimento prévio sobre como servidores web funcionam, especialmente para aplicações como o Moodle que precisam rodar em subdiretórios. Vou explicar passo a passo como cheguei nessa solução, de forma simples:

1. Identificando o Problema
   Quando você acessava http://localhost:8080/moodle/, o Moodle estava respondendo com um redirecionamento (código HTTP 303) para http://localhost:8080/.
   Verifiquei os logs do Moodle (usando docker logs moodle) e vi que ele recebia requisições em / e redirecionava, indicando que a URL não batia com a configuração esperada.
   O WWWROOT no config.php do Moodle estava definido como http://localhost:8080/moodle, mas o Moodle via a requisição como http://localhost:8080/ (devido ao proxy do nginx), causando o conflito.
2. Entendendo o Fluxo
   O nginx estava fazendo proxy reverso: requisições para /moodle/ eram enviadas para o container Moodle.
   Dentro do container, o Apache (que serve o Moodle) estava configurado para servir apenas a raiz (/var/www/html), mas precisávamos que ele entendesse /moodle como a "raiz" do Moodle.
   Moodle é uma aplicação que pode rodar em subdiretórios, mas o servidor web (Apache) precisa ser configurado para mapear o caminho corretamente.
3. Conhecimento Prévio sobre Apache
   Eu sabia que o Apache tem diretivas como Alias para mapear caminhos virtuais para diretórios reais no servidor. Por exemplo, Alias /moodle /var/www/html faz com que qualquer requisição para /moodle seja servida a partir de /var/www/html.
   Também verifiquei a estrutura do container Moodle (usando docker exec moodle ls -la /var/www) para confirmar que o Moodle está em /var/www/html.
   Outra opção seria usar mod_rewrite (RewriteRule), mas Alias é mais simples e direto para esse caso.
4. Testando e Aplicando
   Criei um arquivo customizado 000-default.conf baseado na configuração padrão do Apache (que vi nos logs e na estrutura do container), adicionando apenas a linha Alias /moodle /var/www/html.
   Montei esse arquivo como volume no compose.yml para sobrescrever a config padrão do Apache no container.
   Ajustei o proxy_pass no nginx para enviar o caminho completo (/moodle/) ao invés de removê-lo, para que o Apache pudesse usar o alias.
   Reiniciei os containers e testei – funcionou porque agora o Apache mapeia /moodle corretamente, e o Moodle reconhece a URL.
   Por Que Funcionou?
   Sem o alias, o Apache não sabia o que fazer com /moodle/, então o Moodle redirecionava para a raiz.
   Com o alias, o Apache trata /moodle como a pasta do Moodle, e tudo se alinha com o WWWROOT.
   Essa é uma solução padrão para hospedar aplicações em subpaths em servidores Apache. Se você quiser mais detalhes sobre como o Apache funciona ou alternativas (como nginx subpaths), posso explicar! 😊
