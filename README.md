# Nao-Challenge-2021
[![Contributors](https://img.shields.io/github/contributors/AY02/Nao-Challenge-2021.svg?style=for-the-badge)](https://github.com/AY02/Nao-Challenge-2021/graphs/contributors)
[![Forks](https://img.shields.io/github/forks/AY02/Nao-Challenge-2021.svg?style=for-the-badge)](https://github.com/AY02/Nao-Challenge-2021/network/members)
[![Stargazers](https://img.shields.io/github/stars/AY02/Nao-Challenge-2021.svg?style=for-the-badge)](https://github.com/AY02/Nao-Challenge-2021/stargazers)
[![Issues](https://img.shields.io/github/issues/AY02/Nao-Challenge-2021.svg?style=for-the-badge)](https://github.com/AY02/Nao-Challenge-2021/issues)
[![MIT License](https://img.shields.io/github/license/AY02/Nao-Challenge-2021.svg?style=for-the-badge)](https://github.com/AY02/Nao-Challenge-2021/blob/main/LICENSE)
[![LinkedIn](https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555)](https://linkedin.com/in/alessio-yang-814b59201)
<p align="center">
  <a href="https://www.naochallenge.it/en/home-english">
    <img src="images/logo-nao-challenge-2021.jpg" alt="Logo" width="300" height="100">
  </a>
  <a href="http://www.veronatrento.it">
    <img src="images/logo-veronatrento.jpeg" alt="Logo" width="100" height="100">
  </a>
</p>
<h3 align="center">PROGETTO NAO CHALLENGE 2021</h3>
<p align="center">
  <a href="https://github.com/AY02/Nao-Challenge-2021"><strong>Export documentation »</strong></a>
  <br />
  <br />
  <a href="https://github.com/AY02/Nao-Challenge-2021">View Demo</a>
  ·
  <a href="https://github.com/AY02/Nao-Challenge-2021/issues">Report Bug</a>
  ·
  <a href="https://github.com/AY02/Nao-Challenge-2021/issues">Report Issues</a>
</p>
<details open="open">
  <summary>Index Table</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#setup">Setup</a></li>
        <li><a href="#implementation">Implementation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>


## About The Project
<img src="images/naochallenge-1.jpg" width="30%"></img>
<img src="images/naochallenge-2.jpg" width="30%"></img>
<img src="images/naochallenge-3.jpg" width="30%"></img>

La Nao Challenge è un contest didattico dedicato agli studenti delle scuole secondarie di secondo grado con l’obiettivo di aumentare la conoscenza dei giovani nell’impiego della robotica umanoide attraverso lo sviluppo di software e applicazioni per divulgare le potenzialità sociali della robotica.

Fasi di Nao:
* Fase I: Preselezione e brand identity della squadra
* Fase II: Semifinali
  * Prova 1: Questo è il nostro team
  * Prova 2: Nao, puoi aiutarmi a?
  * Prova 3: X-Nao
* Fase III: Finale

[Scopri di più](https://www.naochallenge.it/wp-content/uploads/2020/10/NAOch_it.pdf) sul progetto.


### Built With
Componenti per il prototipo:
* 1 [Lolin NodeMCU V3](https://www.katstores.com/sites/default/files/product-datasheets/2018-08/NodeMcu%20LOLOIN%20V3%20Datasheet.pdf)
* 3 [CZN-15E](http://www.datasheetbank.com/datasheet-download/883231/1/ETC1/CZN-15E)
* 1 [Mini Buzzer AL-60SP05](https://www.ekulit.com/transducer-with-controller/al-60sp05/#tabs1-spezifikationen)
* 1 [ServoMotor 360° Kookye](https://kookye.com/2016/02/01/kookye-360-degree-unlimited-rotation-micro-servo-motor-for-telecar-robot-helicopter)

Frameworks e piattaforme utilizzate:
* [Flutter](https://flutter.dev)
* [Arduino IDE](https://www.arduino.cc)
* [XAMPP](https://www.apachefriends.org)
* [Python3](https://www.python.org)

## Getting Started
**(QUESTO CIRCUITO E' ANCORA UN PROTOTIPO)**<br />
Innanzitutto bisogna montare i componenti elencati precedentemente su un circuito. Progettazioni in [Fritzing](https://fritzing.org):<br />
Montaggio                            |Circuito                  |Schema PCB
:---------------------------:|:--------------------------------:|:-------------------------------:
![](images/prototipo-montaggio.jpg)|![](images/prototipo-circuito.jpg)|![](images/prototipo-pcb.jpg)


### Setup
<details open="open">
  <summary>Configurazione Arduino IDE:</summary>
  <p>
    
  * Aggiungere le librerie dell'esp8266
    ![](images/arduino-ide-setup-esp-json.png)
  </p>
  <p>
    
  * Installare il componente
    ![](images/arduino-ide-setup-esp-library.png)
  </p>
  <p>
  
  * Installare la libreria di MQTT
    ![](images/arduino-ide-setup-mqtt.png)
  </p>
</details>

Configurazione Python 3:
* Installare la libreria MQTT
   ```sh
   pip3 install paho-mqtt
   ```
   
 
### Implementation
1. Clona la repo
   ```sh
   git clone https://github.com/AY02/Nao-Challenge-2021.git
   ```
2. Install NPM packages
   ```sh
   npm install
   ```
3. Enter your API in `config.js`
   ```JS
   const API_KEY = 'ENTER YOUR API';
   ```


## Usage
Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_


## Roadmap
See the [open issues](https://github.com/AY02/Nao-Challenge-2021/issues) for a list of proposed features (and known issues).


## Contributing
Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## License
Distributed under the MIT License. See `LICENSE` for more information.


## Contact
Alessio Yang:
* [Linkedin](https://linkedin.com/in/alessio-yang-814b59201)
* [Send Email](https://mail.google.com/mail/u/0/?view=cm&fs=1&to=ynglss02p17d403g@veronatrento.it&tf=1)
* [GitHub](https://github.com/AY02)


## Acknowledgements
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Img Shields](https://shields.io)
* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Pages](https://pages.github.com)
* [Animate.css](https://daneden.github.io/animate.css)
* [Loaders.css](https://connoratherton.com/loaders)
* [Slick Carousel](https://kenwheeler.github.io/slick)
* [Smooth Scroll](https://github.com/cferdinandi/smooth-scroll)
* [Sticky Kit](http://leafo.net/sticky-kit)
* [JVectorMap](http://jvectormap.com)
* [Font Awesome](https://fontawesome.com)
