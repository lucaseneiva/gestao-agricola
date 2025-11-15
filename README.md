# Desafio Técnico Arauc - Gestão Agrícola para a Fazenda do Murilo 🍓

Este aqui é o README do meu projeto pro desafio da Arauc. Mas não é só mais um README genérico não, é mais uma conversa onde eu conto como pensei, quebrei a cabeça e resolvi esse desafio.

## Como Tudo Começou

Quando recebi o case, a primeira coisa que fiz foi sentar e realmente entender o problema do Murilo. O cara precisava de uma forma simples de mapear onde estavam aparecendo pragas e doenças na plantação de morangos dele. Nada de muito doido, mas tinha que funcionar bem.

## A Primeira Ideia (Que Não Foi Pra Frente)

Assim que vi o arquivo .kmz, meu cérebro já foi direto pra "Google Maps! Mapa interativo! Vamos nessa!" 

Mas aí parei pra pensar direito...

**O que seria legal:**
- Se o Murilo comprasse mais terra, era só atualizar o .kmz e pronto. Escalável pra caramba.

**O que ia ser uma dor de cabeça:**
- Ia ficar complexo demais - integrar mapa completo, configurar zoom, lidar com imagens de satélite...
- As imagens de satélite da região não estavam lá essas coisas também
- Ia ter um monte de funcionalidade que o Murilo nunca ia usar mesmo
- O design do Figma mostrava uma imagem estática mesmo

Quando fui olhar as coordenadas do .kmz no mapa, tive até a impressão que a fazenda tinha crescido. Num projeto real essa seria a hora de ligar pro Murilo e confirmar. Mas pro desafio, assumi que a área de plantio era maior que a marcação.

Pensando bem nos prós e contras, decidi ir por outro caminho. Sabe aquele papo de KISS (Keep It Simple, Stupid)? Então...

## A Sacada que Fez Diferença

Decidi usar uma imagem fixa mesmo. Mas calma, não foi qualquer print jogado lá de qualquer forma. As imagens de satélite disponíveis eram meio "meh" visualmente... Foi aí que resolvi apelar pra IA e dar aquela melhorada no visual.

O processo foi tipo assim:

1. **Printei** a área da fazenda do satélite
2. **Pedi pra IA** transformar aquilo num mapa estilizado, limpo e bonito
3. **Vetorizei** o resultado (usando outra IA) e transformei em SVG

E o resultado? Um mapa leve, bonito, e que você pode dar zoom à vontade sem ficar pixelado. Fiquei orgulhoso demais do resultado!

**Original:**

<img width="387" height="627" alt="Captura de tela 2025-11-12 142336" src="https://github.com/user-attachments/assets/4fd93b75-7611-4c40-8179-9401bf1fef96" />

**Depois da transformação:**

<img width="800" height="1280" alt="Generated Image November 12, 2025 - 2_28PM-Photoroom" src="https://github.com/user-attachments/assets/d010f890-ac47-4f70-b829-070ed628c109" />

## Onde a Coisa Ficou Interessante (Aka: A Sofrência 😭)

### O Boss do Projeto: A Prancheta de Desenho

Vou ser sincero: criar o `FarmMapView` foi um cocô. Nunca tinha feito um negócio de desenho livre no Flutter antes. A ideia era tipo uma prancheta: o mapa no fundo e o usuário desenhando por cima. 

A parte que me tirou o sono (de verdade mesmo 🥲) foi fazer os desenhos se alinharem certinho com as "coordenadas" da imagem, mesmo quando o usuário dá zoom ou muda o tamanho da tela. Mas no fim deu certo, e aprendi um monte!

### Como Organizei a Bagunça (Arquitetura)

Fui de Arquitetura Limpa "Feature-First" (Nada tão diferente do padrão de apps flutter). Cada funcionalidade fica na sua própria pasta. (Eu acho que fica muito mais fácil de mexer depois...)

```
lib/features/mapa_fazenda/
```

Dentro disso, separei as responsabilidades, mas sem maluqice. Olha, arquitetura limpa seguida as cegas vira um pesadelo de over-engineering (Eu sei porque já sofri muito com isso 😭). Como as regras de negócio eram tranquilas, nem criei camada de Domínio... dava pra gerenciar tudo direitinho na apresentação.

Ficou assim:

- **data/**: Conversa com a API. O `MapaRepository` abstrai tudo do backend. Se amanhã a API mudar pra GraphQL ou gRPC, só mexo aqui e a UI continua feliz.

- **ui/**: Toda a parte visual e controle de estado.
  - **providers/**: O cérebro da operação. Usei Riverpod pra gerenciar estado. Os `mapa_state_providers.dart` são tipo os controladores, onde rola a lógica de negócio da interface. Foi a segunda parte mais trabalhosa, garantir que tudo reagisse certinho.
  
  - **widgets/**: Componentes reutilizáveis - seletor de semana, botões de filtro, essas coisas...
  
  - **map_screen.dart**: A tela principal que junta tudo.

Essa arquitetura deixa o código desacoplado e pronto pra crescer. Quer adicionar autenticação? Cria uma pasta nova em `features/` e segue a mesma linha. A solução pode ser sob medida pro Murilo, mas a base tá pronta pra escalar.

## E Aí, Como Ficou?

O app tá rodando lisinho, organizado e pronto pra evoluir. Ficou uma ferramenta que atende direitinho o que o Murilo precisa, com uma interface que não precisa de manual de instruções e um código que não vai virar aquele frankenstein daqui uns meses. (Eu espero... 😂)

![GravaodeTela2025-11-14083828-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/c0ef676b-a8bf-454e-8ba8-7a728712a764)

## Reflexão Final

Cara, esse desafio foi definitivamente um... desafio... mas foi legal demais também de resolver. Explorei áreas novas do Flutter, tive que tomar umas decisões arquiteturais difíceis e, no fim, consegui resolver um problema real de um jeito que eu achei bem pragmático. É isso aí! Menos é mais, desde que seja o "menos" certo!!! Cara, esse desafio foi definitivamente um... desafio... mas foi legal demais de resolver. Explorei áreas novas do Flutter, tive que tomar umas decisões arquiteturais difíceis e, no fim, consegui resolver um problema real de um jeito que eu achei bem pragmático. É isso aí! Menos é mais, desde que seja o "menos" certo!!!
Olha, eu sei que ainda dá pra melhorar algumas coisas - tipo criar snackbars de erro no map_screen.dart, dividir um pouco mais as responsabilidades... Mas decidi encerrar por aqui porque acho que já demonstra bem do que sou capaz (e pra eu não cair na armadilha da refatoração eterna também 😂), e tô doido pra retomar meus outros projetos em Flutter.
Enfim, espero que gostem!

---

## Adendos Técnicos e Guia de Execução

Esta seção contém informações práticas para configurar e rodar o projeto, além de algumas observações importantes sobre o ambiente de desenvolvimento e limitações conhecidas.

### Como Rodar o Projeto

Para executar a aplicação em sua máquina local, siga os passos abaixo:

1.  **Clone o Repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd lucaseneiva-desafio-tecnico-arauc
    ```

2.  **Crie o Arquivo de Credenciais (`.env`):**
    A aplicação precisa de credenciais para se comunicar com a API. Crie um arquivo chamado `.env` na raiz do projeto. Dentro dele, adicione as seguintes linhas, substituindo pelos dados que foram fornecidos a você no desafio:
    ```
    API_USERNAME=<seu_usuario_aqui>
    API_PASSWORD=<sua_senha_aqui>
    ```
    *Este passo é fundamental, pois sem ele a aplicação não conseguirá autenticar nas chamadas de rede.*

3.  **Instale as Dependências:**
    ```bash
    flutter pub get
    ```

4.  **Execute a Aplicação:**
    ```bash
    flutter run
    ```

### Geração de Código (Riverpod & BuildRunner)

O projeto utiliza o `riverpod_generator` para automatizar a criação dos *providers* de estado, o que torna o código mais limpo e seguro. Isso significa que existem arquivos gerados (com a extensão `.g.dart`).

**Importante:** Se você modificar qualquer um dos providers no arquivo `lib/features/mapa_fazenda/ui/providers/mapa_state_providers.dart`, será necessário regenerar o código correspondente. Para isso, execute o seguinte comando no terminal:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Observação Crucial sobre a Versão Web (CORS)

Durante o desenvolvimento, foi identificado que a aplicação **não funciona na plataforma web**.

*   **Motivo:** Isso ocorre devido a restrições de **CORS (Cross-Origin Resource Sharing)** impostas pela API fornecida para o desafio. A política de CORS é um mecanismo de segurança do navegador que impede que um cliente web faça requisições para um domínio diferente do seu próprio, a menos que o servidor autorize explicitamente.
*   **Análise e Decisão:** A solução para este problema reside no **backend**, que precisaria ser configurado para permitir requisições a partir do domínio da aplicação web. Dado que o foco do desafio era criar uma solução primordialmente **mobile** para o Murilo, e entendendo que a configuração de CORS é uma responsabilidade do servidor, optei por concentrar os esforços na funcionalidade principal para Android/iOS, que era o requisito central do projeto.

### Ambiente de Testes

O desenvolvimento e os testes da aplicação foram realizados primordialmente em um **Android Virtual Device (AVD)**. O GIF de demonstração e as imagens apresentadas neste README foram capturados a partir da versão rodando neste ambiente, garantindo a funcionalidade e a experiência esperada na plataforma mobile.
