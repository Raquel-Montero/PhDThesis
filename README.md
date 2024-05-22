<h1 align="center">PhD Thesis</h2>
<p align="center">Raquel Montero Estebaranz</p>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
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
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

### About this repository

Here comes the information about the repository the thesis and the date of submission.
Structure of the Repository

```mermaid
graph TD;
    A(Repository) -->B(Thesis);
    B(Thesis) -->B1(pdf);
    A(Repository)-->C(Data Analysis);
    C(Data Analysis) --> D(Chapter 4);
    D(Chapter 4) --> D1(R Code);
    C(Data Analysis) --> E(Chapter 5);
    E(Chapter 5) --> E1(R Code);
    E(Chapter 5) --> E2(Julia Simulations);
    C(Data Analysis) --> F(Chapter 6);
    F(Chapter 6) --> F1(R Code);

style A fill:#fecc91, stroke:#fdb35a 
style B fill:#b2d8d8, stroke:#75b0b2
style B1 fill:#b2d8d8, stroke:#75b0b2
```
The Folder data analysis contains the data from the three core chapters of the chapters of the thesis (the rest of chapters are theory based).
