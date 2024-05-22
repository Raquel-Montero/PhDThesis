<h1 align="center">PhD Thesis</br> Mood alternations: a synchronic and diachronic study of negated complement clauses</h1>
<p align="center"><em>Raquel Montero Estebaranz</em></p>


### About this repository

This repository contains my PhD Thesis, which was written between the years 2020-2024 at the University of Konstanz under the supervision of George Walkden and Maribel Romero (mentor: Henri Kauhanen), as well as the data and code I used.  

#### Structure of the Repository

```mermaid
graph TD;
    A(Repository) --> Q(Data);
    Q(Data) --> Q1(Corpus Queries);
    Q(Data) --> Q2(Annotated Data);
    Q(Data) --> Q3(Guidelines);
    A(Repository)--> C(Data Analysis);
    C(Data Analysis) --> D(Chapter 4);
    D(Chapter 4) --> D1(R Code);
    C(Data Analysis) --> E(Chapter 5);
    E(Chapter 5) --> E1(R Code);
    E(Chapter 5) --> E2(Julia Simulations);
    C(Data Analysis) --> F(Chapter 6);
    F(Chapter 6) --> F1(R Code);
    A(Repository) --> B(Thesis);
    B(Thesis) --> B1(pdf);
    B(Thesis) --> B2(Latex Code);

style A fill:#fecc91, stroke:#fdb35a
style Q fill:#C1E1C1, stroke:#93C572
style Q1 fill:#C1E1C1, stroke:#93C572
style Q2 fill:#C1E1C1, stroke:#93C572
style Q3 fill:#C1E1C1, stroke:#93C572
style B fill:#b2d8d8, stroke:#75b0b2
style B1 fill:#b2d8d8, stroke:#75b0b2
style B2 fill:#b2d8d8, stroke:#75b0b2
```

The repository is divided into three main folders: 
1. **Thesis**: contains the thesis itself.
2. **Data**: contains the (annotated) data to study the diachronic behaviour of mood selection, information on the queries run to extract the data from the CDH corpus and the annotation guidelines that were followed.
3. **Data Analysis**: R and Julia code used to analyze the data and run simulations.

### Corpora
 
-  *Corpus del Diccionario histórico de la lengua española*: most of the data used was extracted from the CDH. I would like to thank the creators for their work and for making this resource freely available for research.
  
    Real Academia Española (2013): *Corpus del Diccionario histórico de la lengua española (CDH)* [en linea]. <https://apps.rae.es/CNDHE>

### Other Resources
The materials in this thesis have greatly benefited from a number of free sofware resources, which I would also like to acknowledge.

- <img src="https://github.com/Raquel-Montero/PhDThesis/assets/115950103/d85b05d0-d867-4008-b3ae-552aa00ea72f"  width="30" height="20">  $\LaTeX$: for typesetting the thesis.
-  <img src="https://github.com/Raquel-Montero/PhDThesis/assets/115950103/d2c9b14f-b22e-42cc-bb00-8e9cf368dfc0"  width="20" height="20"> R: for the statistical analysis.
- <img src="https://github.com/Raquel-Montero/PhDThesis/assets/115950103/62fd1199-b53a-457b-a15a-ae20ef1d3b39"  width="20" height="20"> Krita: for the images/diagrams (and for making my life happier in general :blush:).
