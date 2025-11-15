# Desafio Técnico Arauc - Gestão Agrícola para a Fazenda do Murilo 🍓


Este aqui é o README do meu projeto pro desafio da Arauc. Mas não é só mais um README genérico não, é mais uma conversa onde eu conto como pensei esse desafio. Seria legal dar uma lida, pois eu acho muito importante pra entender como a minha cabeça funciona pra resolver problemas. Passou de 5 linhas? Sim... Mas eu prometo que vale a pena 😜

## Como Tudo Começou

Quando recebi o case, a primeira coisa que fiz foi dar uma lida e tentar entender o problema proposto. O cara precisava de uma forma simples de mapear onde estavam aparecendo pragas e doenças na plantação de morangos dele. Nada de muito doido, mas tinha que funcionar bem né.

Aí bateu aquela tentação... sabe? "Ah! Vou só implementar o Figma igualzinho e usar uma lib pronta pra resolver". Mas parei pra pensar... "tá, mas será que é isso mesmo que resolve o problema?" Porque executar é fácil (qualquer um faz sinceramente...), outra coisa é tentar entender o porquê por trás da solução.

Então eu voltei pro começo e pensei: “A gente consegue fazer melhor que isso?” (Spoiler: eu acho que sim). 

## A Primeira Pequena Grande Decisão (Que Quase Me Enganou)

Assim que vi o arquivo .kmz, meu cérebro já foi direto pra "Google Maps! Mapa interativo! Bora lá!" Parecia até óbvio demais. 

Mas aí parei pra pensar direito nas implicações...

**O que seria legal nisso:**
- Se o Murilo comprasse mais terra, era só atualizar o .kmz e pronto. Escalável pra caramba.
- Na teoria, parece a solução """profissional"""

**O que ia ser uma dor de cabeça (eu acho que importa né):**
- Ia ficar mais complexo - integrar mapa completo, configurar zoom, tiles de satélite, API keys...
- Dependência total das imagens de satélite da região (imagina o google atualiza e tem uma nuvem safada tampando a fazenda do Murilo? 🤔)
- Performance? Carregar tiles de satélite só pra mostrar uma fazenda específica? overkill na minha opnião...
- Ia ter um monte de funcionalidade que o Murilo nunca ia usar mesmo (trânsito, rotas, street view...)
- Você tá me dizendo então que o Murilo pode scrollar pra Florida e dar um oi pro Mickey? Mas a gente trava a view dele na fazenda então? Mas daí vira uma imagem estática... 😑

Pensando bem nos prós e contras, decidi ir por outro caminho. Não usar o Google Maps não foi por limitação técnica não sinceramente... foi decisão de design mesmo. Sabe aquele papo de KISS (Keep It Simple, Stupid)? Então né...

## A Segunda Pequena Grande Decisão (Arquitetura)

Aqui foi outro ponto importante. Eu podia ter ido pelo caminho "rápido e safado":
- Tudo num `main.dart` gordão e cheio de vida (já vi muita gente fazendo isso em case técnico)
- Model-View-Controller básiquinho
- Estado gerenciado com setState()
- "Funciona? Funciona. Manda logo e vida que segue!" 

**Mas aí parei pra pensar né...**

Cara, case técnico não é só sobre fazer SÓ simplesmente funcionar. Não é sobre só dar ctrl+c ctrl+v do Figma pro Flutter. Eu também acho que é sobre demonstrar **como você pensa em arquitetura de software de verdade**. E mais: a Arauc é uma startup pequena. O Miguel é o único dev lá. Se ele me contratar, eu não posso entregar um código que só EU entendo, sabe? Precisa ser um código que:

1. Ele consiga entender sem ser graduado em arquitetura de software quântica
2. O cara que continuar o código no futuro não xingue a minha mãe... 😭
3. Não vire aquele código espaguete que ninguém quer mexer quando chega features novas

Por isso fui de **Clean Architecture "Feature-First"**. E É baseada na própria documentação oficial do Flutter viu... (tem até um caso de estudo deles, o Compass App, que eu estudei). A ideia é simples: cada funcionalidade vive na sua própria pasta. Responsabilidades bem separadas. Mas sem código afofado demais também.

Olha, arquitetura limpa seguida às cegas vira um pesadelo de abstração desnecessária, eu já sofri MUITO com isso 😭(SÉRIO). Como as regras de negócio aqui eram tranquilas, nem criei aquela camada de Domínio mega pesada... dava pra gerenciar direitinho na apresentação com Riverpod mesmo.

**Mas mano... Legal tudo isso... Bacana e tudo mais. Porém, no entanto, contudo, todavia, qual a diferença prática disso tudo?** 

Imagina: amanhã o Murilo liga e fala "cara, AMEI o app, mas agora eu quero gerenciar os insumos agrícolas também". Sem problemas. Com a arquitetura que eu fiz:
- Crio uma pasta `features/gestao_insumos/`
- Sigo a mesma estrutura que já tá lá prontinha só esperando
- Zero impacto no código do mapa (não preciso ficar com medo de quebrar algo)
- Adiciono uma rota no GoRouter
- Pronto, life goes on beautifully

Sabe qual a diferença entre isso e um protótipo? Isso aqui é código de produto. Código que tá pronto pra crescer sem virar uma bola de neve de dívida técnica.

## A Sacada que Fez Diferença: O Mapa Artesanal

Decidi usar uma imagem fixa mesmo. Mas calma, não foi qualquer print jogado lá de qualquer forma também né. Eu achei as imagens de satélite disponíveis meio "meh..." visualmente. Foi aí que resolvi apelar pra famigerada IA e dar aquela melhorada no visual.

O processo foi tipo assim:

1. **Printei** a área da fazenda do satélite
2. **Pedi pra IA** transformar aquilo num mapa estilizado, limpo e bonito
3. **Vetorizei** o resultado (usando outra IA) e transformei em SVG

**Por que SVG e não só um PNG qualquer?**
- Cara é leve pra caramba (a gente tá falando de KB, não MB)
- Dá pra dar zoom infinito sem aquela pixelização horrível
- Fica fácil customizar cores e estilos depois se precisar
- Fica com cara muito mais profissional

E o resultado? Um mapa sob medida pro Murilo. Não é genérico. É DELE. Dá até pra falar pra ele que é "uma solução gourmet". 😂 Fiquei orgulhoso demais do resultado!

**Original:**

<img width="448" height="658" alt="Captura de tela 2025-11-15 072237" src="https://github.com/user-attachments/assets/6f81f461-8194-4936-83cb-0400febe651c" />


**Depois da transformação:**

<img width="800" height="1280" alt="Generated Image November 15, 2025 - 7_23AM-Photoroom" src="https://github.com/user-attachments/assets/99d2c5da-fe98-4e4f-b611-b10131276611" />

## Onde a Coisa Ficou Interessante (A Parte Que Me Fez Sofrer 😭)

### O Boss Final do Projeto: A Prancheta de Desenho

Vou ser sincero: criar o `FarmMapView` foi... complicado. Um pouco mais complicado do que eu pensei (Quebrou o fluxo do meu vibe coding 😭).  Nunca tinha feito um negócio de desenho livre no Flutter antes. A ideia era tipo uma prancheta mesmo: o mapa no fundo e o usuário desenhando por cima, só que tinha que funcionar de verdade. 

A parte que me tirou o sono (DE VERDADE, perdi sono com isso 🥲) foi fazer os desenhos se alinharem certinho com as "coordenadas" da imagem, mesmo quando o usuário dá zoom ou muda o tamanho da tela. Transformações de matriz, offsets, scaling... Revivi as minhas aulas de matemática do ensino médio.

**Os desafios que me fizeram quebrar a cabeça:**
- Garantir que o traço desenhado mantivesse a proporção certinha com o mapa em qualquer zoom
- Serializar os dados de desenho de uma forma eficiente pra mandar pra API (sem virar um JSON gigante)
- Performance: renderizar vários traços ao mesmo tempo sem a tela começar a engasgar

Mas no fim das contas deu certo, e eu aprendi MUITO no processo! Foi o tipo de desafio que não tem um indiano resolvendo no youtube (eu procurei tá 😭)

## Como Organizei a Bagun- Digo a arquitetura:

Fui de Arquitetura Limpa "Feature-First". Estrutura final ficou assim:

```
lib/features/mapa_fazenda/
├── data/
│   ├── drawing_adapter.dart      # Serializa/deserializa desenhos
│   └── map_repository.dart       # Abstração da API
├── domain/
│   ├── entities/
│   │   ├── drawing.dart          # Modelo de desenho
│   │   └── stroke.dart           # Modelo de traço
│   └── repositories/
│       └── map_repository_interface.dart
└── presentation/
    ├── controllers/              # Lógica de negócio (Riverpod)
    │   ├── date_controller.dart
    │   ├── drawing_controller.dart
    │   └── map_ui_controller.dart
    ├── providers/                # State management
    ├── screens/
    │   └── map_screen.dart      # Tela principal
    └── widgets/                  # Componentes reutilizáveis
        ├── farm_map_view.dart
        ├── filter_buttons.dart
        └── week_selector.dart
```

**Por que essa organização faz sentido?**

- **data/**: Conversa com a API. O `MapaRepository` abstrai tudo do backend. Se amanhã a API mudar pra GraphQL ou sei lá o que, só mexo aqui e a UI continua feliz da vida sem saber de nada.

- **domain/**: As entidades e interfaces. O coração da regra de negócio mesmo. 

- **presentation/**: Tudo que é visual e interação com o usuário. Os controllers com Riverpod gerenciam o estado de forma type-safe e reativa (sem aquele setState da vida que vira bagunça).

**Comparando com MVC tradicional só pra deixar claro:**
- Em MVC, com o tempo tudo vira aquele "God Controller" gigante que ninguém quer mexer
- Aqui, as responsabilidades são separadas de um jeito que faz sentido
- Quer testar? Tranquilo... cada controller é independente
- Feature nova? Cria uma pasta nova, vida que segue, zero conflito com o resto

Essa arquitetura não é over-engineering não. É o que eu chamo de **engenharia preventiva** mesmo. A diferença é que uma te salva no futuro, a outra te enterra em dívida técnica. E sim, eu vi os vídeos do Filipe Deschamps provocando geral sobre isso

## Algumas Decisões Técnicas Importantes

### Por que Riverpod e não outra coisa?

Podia ter ido de Provider simples, BLoC, GetX, ou até ficar no velho e bom setState(). Mas Riverpod oferece umas paradas que fazem diferença:
- **Type safety**: O compilador te grita na cara se você fizer merda (e isso é BOM)
- **Testabilidade**: Os providers são injetados, fica moleza mockar tudo nos testes
- **Performance**: Só reconstrói o que realmente mudou, nada de rebuild em tudo
- **Code generation**: Menos código repetitivo chato de escrever, mais segurança

É praticamente o futuro do state management em Flutter. E já que é pra demonstrar o que eu sei fazer, fui no que tem de mais moderno mesmo.

### Tratamento de Erro e Loading States

Todo provider tem seus estados de loading/erro direitinho. Nada daquela tela branca travada enquanto carrega. Experiência do usuário importa, né?

### Onde Ficam os Dados?

A API guarda tudo na nuvem. Localmente, só rola um cache temporário enquanto o cara tá editando. Simples e funciona.

## E Aí, Como Ficou?

O app tá rodando lisinho, organizado e pronto pra evoluir. Ficou uma ferramenta que atende direitinho o que o Murilo precisa, com uma interface que não precisa de manual de 50 páginas pra usar e um código que não vai virar aquele espaguete daqui uns meses (eu espero... 😂).

**Ah, e sobre as cores...**
O Figma tinha aquele esquema de azul pra pragas e vermelho pra doenças. Mas eu resolvi experimentar uma coisa diferente: destaca só o que você tá olhando no momento (fica vermelho) e deixa o resto em cinza. Achei que ficava menos cluttered visualmente, sabe? Tipo, ao invés de ter duas cores competindo pela atenção do cara, você foca numa coisa de cada vez. Testei e achei interessante também. Nesse caso ficaria pra colher o feedback e ver qual funciona melhor. 

![Gravação de Tela 2025-11-15 100724](https://github.com/user-attachments/assets/a0cc38ec-aa9e-4342-b2b9-26de8c8023b1)


## Se Eu Tivesse Mais Tempo... (E menos preguiça)

Toda solução sempre tem espaço pra melhorar, né? Se tivesse mais tempo sobrando, eu:

1. **Mais Testes automatizados**: Unit tests pros controllers, widget tests pra UI crítica (Eu so fiz testes pro date_adapter)
2. **Tratamento de erros mais caprichado**: Snackbars mais informativos, retry automático quando a rede falhar
3. **Modo offline**: Cache local com sincronização automática quando a conexão voltar
4. **Acessibilidade**: Garantir que funciona legal com screen readers e tal
5. **Animações mais suaves**: Umas transições mais fluidas entre os estados
6. **Refatoração**: Ainda dá pra quebrar alguns widgets em componentes menores

Mas olha, eu preferi entregar uma solução **completa e que funciona** do que metade com testes e metade bugada. Saber priorizar também é uma skill, né?

---

## Reflexão Final

Cara, esse desafio me fez pensar muito sobre a diferença entre **executar** e **resolver de verdade**. Qualquer um consegue pegar um Figma e transformar em Flutter. Mas quantos param pra pensar:
- "Essa solução vai escalar ou vai virar uma bomba-relógio?"
- "Isso resolve o problema de verdade ou só o problema aparente?"
- "Daqui 6 meses, outro dev vai me xingar por causa desse código?"

Eu podia ter escolhido o caminho mais rápido e fácil. Mas escolhi o caminho mais **certo**. E aprendi pra caramba no processo.

Foi desafiador, frustrante em alguns momentos (aquele `FarmMapView` me assombrou...), mas gratificante demais quando tudo se encaixou. É isso que eu gosto em desenvolvimento: resolver problemas de verdade, não só bater tecla e vibe coding.

É isso aí! Menos é mais, desde que seja o "menos" certo!!!

---

## A Prova Final: O Valor de uma Arquitetura Bem Pensada

Lembra de toda aquela discussão ali em cima sobre Google Maps vs SVG? Aquela "dicotomia shakespeariana" (fui chique agora 😂) entre um mapa estático focado e um mapa interativo complexo? Pois então, o resultado mais dahora da arquitetura que eu escolhi é que **essa decisão vira reversível**.

Vamos imaginar um cenário: o app do Murilo faz sucesso, ele espalha no grupo do zap dos produtores de morango, e de repente a parada cresce. Agora a prioridade mudou pra uma plataforma multi-fazendas onde ter um mapa interativo de verdade faz sentido.

**E aí, ferrou tudo? Tem que reescrever o app inteiro?**

Nops. Em uma arquitetura mal pensada, sim, seria uma reescrita massiva e dolorida. Mas aqui? A migração seria surpreendentemente tranquila:

1. **Abrir UM único arquivo**: `lib/features/mapa_fazenda/presentation/widgets/farm_map_view.dart`
2. **Trocar uma linha**: Substituir o widget `SvgPicture` por um `GoogleMap`
3. **Adaptar as coordenadas**: Ajustar a lógica de conversão de toques dentro deste mesmo widget (antes era relativa ao SVG, agora seria relativa à API do mapa)

**E o mais importante - o que NÃO mudaria?**

- O `FarmDrawings controller` (toda a lógica de estado dos desenhos)
- O `mapRepositoryProvider` (comunicação com a API)
- Toda a camada de `data` e `domain` (as regras de negócio)

Esses componentes, que são o coração do aplicativo, continuariam felizes da vida sem saber de nada. A UI poderia ser completamente transformada e a lógica de negócios nem ia perceber.

Isso não é mera coincidência do destino meu amigo. É arquitetura limpa e desacoplada. Adapta, escala e evolui **sem quebrar tudo**.

Tcharam! Simple as that. 

---

## Adendos Técnicos e Guia de Execução

### Como Rodar o Projeto

1.  **Clone o Repositório:**
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd lucaseneiva-desafio-tecnico-arauc
    ```

2.  **Crie o Arquivo `.env`:**
    ```
    API_USERNAME=<seu_usuario>
    API_PASSWORD=<sua_senha>
    ```

3.  **Instale as Dependências:**
    ```bash
    flutter pub get
    ```

4.  **Execute:**
    ```bash
    flutter run
    ```

### Geração de Código (Riverpod)

Se modificar providers, regenere o código:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Observação sobre Web (CORS)

A aplicação **não funciona na web** devido a restrições de CORS da API fornecida. Isso é uma limitação do backend, não do código. A solução seria configurar headers CORS no servidor.

O desenvolvimento focou em **mobile (Android/iOS)**, que era o requisito principal do desafio.

### Ambiente de Testes

Todo desenvolvimento e testes foram feitos em **Android Virtual Device (AVD)**. O GIF de demonstração foi capturado dessa plataforma.

---

**Espero que gostem! 🚀**
