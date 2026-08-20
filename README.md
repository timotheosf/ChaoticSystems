# Introduction to Chaotic Systems 🌀

[Versão em português (br) do README.](README.pt.md)

<div align="center">
  <figure>
    <figcaption><h3>Poincaré section for the double pendulum</h3></figcaption>
    <img src="https://assets.tmfss.net/chaosminicurse/figs/poincare_img.svg" alt="poincare_section" width="500"/>
  </figure>
</div>

This is the (centralized) repository containing the textual and graphic materials, and the computational tools developed for a short course on *Introduction to Chaotic Systems* taught to undergraduate Physics students at the Universidade Federal de Viçosa. The material covers everything from the initial physical intuition, the mathematical formulation of the problem, rigorous implementation of symplectic integrators, and concludes by addressing classic problems in the field.

The textual part was developed using the [**quarto**](https://quarto.org/) system.

The repository is under the MIT license, with material fully available for use by other students and teachers, without the need to cite the source.

### 📚 Course Syllabus

The course syllabus follows a structured logical flow between Physics, Mathematics, and Computing:

1. The problem of Complexity in Physics;
2. Introduction to the simple pendulum and double pendulum systems;
3. The concept and topology of the Phase Space;
4. Sensitivity to initial conditions (Poincaré Map and Lyapunov Exponents);
5. Differentiation between deterministic chaos and unpredictability;
6. Applications to planetary orbits and gravitational systems.

### 📖 Main References
* Strogatz, S. (2024). *Nonlinear Dynamics and Chaos*.
* Lemos, N. (2007). *Mecânica Analítica*.
* Tao, M. (2016). *Explicit symplectic approximation of nonseparable Hamiltonians*.
* Forest, E., & Ruth, R. D. (1990). *Fourth-order symplectic integration*.
* Heyl, J. S. (2008). *The Double Pendulum Fractal*.

---

## 🌱 Contributing

The project is under continuous development. Anyone who wishes to can contribute! The sections below were included with the intention of facilitating collaboration.

## 🌲 Directory Tree

This is a relatively complex repository, due to its size. The tree below explains each core file and directory of the project.

```
ChaoticSystems/
├── .github                     # GitHub actions for build
│   └── workflows/              # Workflows folder
│       └── deploy.yml          # Deploy file
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

## 💻 SymplecF: The Symplectic Integration Library

Naive integrators (such as Runge-Kutta) fail when simulating chaotic Hamiltonian systems over the long term, because they continuously alter the system's energy, without obeying Liouville's Theorem.

To circumvent this problem, we developed the [**SymplecF**](https://github.com/timotheosf/SymplecF.git) repository. It is a library built on the object-oriented paradigm of Modern Fortran that offers the main symplectic methods in a very simple facade interface:
    * Verlet (2nd Order): The base symplectic method for systems with a separable Hamiltonian.
    * Forest-Ruth (4th Order): Higher-order composition of Verlet, consisting of a sequence of forward, backward, and forward steps.
    * Molei Tao (4th Order): Integrator in an *Extended Phase Space* for non-separable Hamiltonians with an explicit (*Verlet-like*) method.

The library isolates the mathematical procedures, allowing for simple and fast use.

---