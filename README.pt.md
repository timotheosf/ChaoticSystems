# Introdução aos Sistemas Caóticos 🌀

[English version of the README content.](README.md)

<div align="center">
  <figure>
    <figcaption><h3>Seção de Poincaré para o pêndulo duplo</h3></figcaption>
    <img src="https://assets.tmfss.net/chaosminicurse/figs/poincare_img.svg" alt="poincare_section" width="500"/>
  </figure>
</div>

Este é o repositório (centralizado) contendo os materiais textuais e gráficos e as ferramentas computacionais desenvolvidas para um minicurso de *Introdução aos Sistemas Caóticos* ministrado aos alunos de graduação em Física da Universidade Federal de Viçosa. O material aborda desde a intuição física inicial, a formulação matemática do problema, implementação rigorosa de integradores simpléticos e conclui abordando problemas clássicos da área.

A parte textual foi desenvolvida utilizando o sistema [**quarto**](https://quarto.org/).

O repositório se encontra sob licença MIT, com material totalmente disponível para uso de outros alunos e professores, sem necessidade de citação da fonte.

### 📚 Programa do Curso

A ementa do curso segue um fluxo lógico estruturado entre Física, Matemática e Computação:

1. O problema da Complexidade na Física;
2. Introdução aos sistemas do pêndulo simples e do pêndulo duplo;
3. O conceito e a topologia do Espaço de Fase;
4. Sensibilidade às condições iniciais (Mapa de Poincaré e Expoentes de Lyapunov);
5. Diferenciação entre caos determinístico e imprevisibilidade;
6. Aplicações a órbitas planetárias e sistemas gravitacionais.

### 📖 Referências Principais
* Strogatz, S. (2024). *Nonlinear Dynamics and Chaos*.
* Lemos, N. (2007). *Mecânica Analítica*.
* Tao, M. (2016). *Explicit symplectic approximation of nonseparable Hamiltonians*.
* Forest, E., & Ruth, R. D. (1990). *Fourth-order symplectic integration*.
* Heyl, J. S. (2008). *The Double Pendulum Fractal*.

---

## 🌱 Contribuindo

O projeto se encontra em desenvolvimento contínuo. Qualquer pessoa que desejar pode contribuir! As seções abaixo foram colocadas com a intenção de facilitar a colaboração.

## 🌲 Árvore de diretórios

Este é um repositório relativamente complexo, pelo seu tamanho. A árvore abaixo explica cada arquivo central e diretório do projeto.

```
ChaoticSystems/
├── .github                     # GitHub actions for build
│   └── workflows/              # Workflows folder
│       └── deploy.yml          # Deploy file
├── media/                      # Images, animations and TikZ files
│   ├── ani/                    # Animations
│   │   └── ...
│   ├── figs/                   # Figures
│   │   └── ...
│   ├── logos/                  # Many logo files
│   │   └── ...
│   └── tikz/                   # TikZ files
│   │   ├── complexity.tex      # Genenerate complexity diagram for site
│   │   ├── complexity_wide.tex # Genenerate complexity diagram for presentation
│   │   └── .latexmkrc          # latexmk compiler config
│   └── latex2svg.bash          # Simple bash script to compile tikz figs and convert them to svg
├── plot/                       # Python scripts for plot svg graphics from Fortran data
│   ├── chaos_animation.py      # Animate a double pendulum pair
│   ├── dp_animation.py         # Animate a double pendulum
│   ├── phase_diagram.py        # Phase diagrams showing the double pendulum fractals
│   └── poincare_sections.py    # Draw Poincaré Sections for different energy values
├── program/                    # Fortran program files
│   ├── app/                    # Main programs
│   ├── src/                    # Source modules
│   ├── data/                   # Data from Fortran calculations
│   │   └── .gitkeep            # Keep empty folder
│   └── fpm.toml                # Config fpm to import SymplecF from GitHub
├── room/                       # Quarto ("room") files for site and presentation
│   ├── themes/                 # CSS themes for quarto
│   │   ├── dark.scss           # Dark mode theme
│   │   ├── light.scss          # Light mode theme
│   │   └── slides.css          # Quarto Presentation (in Revealjs) CSS styles
│   ├── macros/                 # Macros for Quatro project
│   │   ├── _titleIndex.qmd     # Title and index for presentation
│   │   └── shortcuts.lua       # Lua shortcodes for presentation
│   ├── chapters/               # Chapters files
│   │   └── ...
│   └── references.bib          # bib file for references (both presentation and site)
├── _quarto.yml                 # Base file for common profile properties
├── _quarto-presentation.yml    # Overwrite base file to build revealjs presentation
├── _quarto-site.yml            # Overwrite base file to build book website
├── index.qmd                   # Root file for book project
├── presentation.qmd            # Main file for presentation project
├── .gitignore                  # Gitignore unnecessary folders and files
└── README.md                   # GitHub README file
```

## 💻 SymplecF: A Biblioteca de Integração Simplética

Integradores ingênuos (como o Runge-Kutta) falham ao simular sistemas hamiltonianos caóticos a longo prazo, porque alteram continuamente a energia do sistema, sem obedecer ao Teorema de Liouville.

Para contornar este problema, desenvolvemos o repositório [**SymplecF**](https://github.com/timotheosf/SymplecF.git). É uma biblioteca construída sobre o paradigma de orientação a objetos do Fortran Moderno que oferece os métodos simpléticos principais em uma interface de faixada muito simples:
    * Verlet (2ª Ordem): O método simplético base para sistemas com Hamiltoniana separável.
    * Forest-Ruth (4ª Ordem): composição em ordem maior do Verlet, composto pela sequência de passos progressivo, retrógrado e progressivo.
    * Molei Tao (4ª Ordem): integrador em um *Espaço de Fase Estendido* para Hamiltonianas não-separáveis com método explícita (*Verlet-like*).

A biblioteca isola os procedimentos matemáticos, permitindo uso simples e rápido.

---

