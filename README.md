# 📐 Solveur Linéaire par la Méthode de Cholesky (A · X = b)

<p align="center">
  <img src="logo_esisa.png" alt="Logo ESISA" width="130" />
</p>

<p align="center">
  <strong>École Supérieure d’Ingénierie en Sciences Appliquées (ESISA) — 3ème Année</strong><br>
  <em>Module d'Analyse Numérique & Programmation Orientée Objet (POO Java)</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/ESISA-3A-003366?style=for-the-badge" alt="ESISA 3A" />
  <img src="https://img.shields.io/badge/Java-Swing-orange?style=for-the-badge&logo=openjdk" alt="Java Swing" />
  <img src="https://img.shields.io/badge/Web-HTML5%20%7C%20JS%20ES6-blue?style=for-the-badge&logo=javascript" alt="Web HTML5" />
  <img src="https://img.shields.io/badge/Calcul%20Formel-Maple%202015-red?style=for-the-badge" alt="Maple 2015" />
  <img src="https://img.shields.io/badge/Pr%C3%A9cision-10%E2%81%BB%C2%B9%E2%81%B5-green?style=for-the-badge" alt="Précision" />
</p>

---

## 👨‍💻 Informations du Projet

* **Auteurs :** **Hamza DADI** & **Mohammed SENHAJI**
* **Sous l'encadrement de :** **Prof. Jaouad BENNOUNA**
* **Année universitaire :** 2026 / 2027
* **Établissement :** ESISA, Fès, Maroc

---

## 🚀 Démonstration en Ligne (GitHub Pages)

Accédez directement à l'application Web sans aucune installation :  
👉 **[Lancer le Solveur Web de Cholesky](https://hamza-dadi.github.io/)** *(ou via le fichier local `index.html`)*

---

## 📖 Présentation du Projet

Ce projet a pour objectif la résolution directe de systèmes linéaires généraux :

$$A \cdot X = b$$

lorsque la matrice $A \in \mathcal{M}_n(\mathbb{R})$ est **symétrique définie positive (SDP)**, via la factorisation de Cholesky :

$$A = B \cdot B^T$$

où $B$ est une matrice triangulaire inférieure à éléments diagonaux strictement positifs ($b_{ii} > 0$).

### Les 6 Étapes Algorithmiques Implémentées :
1. **Saisie des données :** Entrée dynamique des coefficients $a_{ij}$ et des composantes $b_i$.
2. **Vérification de la Définie-Positivité (Critère de Sylvester) :**
   $$\Delta_m = \det(A_{1..m, 1..m}) > 0 \quad (\forall m \in \{1, \dots, n\})$$
   En cas de mineur négatif ou nul, l'exécution est arrêtée avec le message d'alerte : *« La méthode de Cholesky n'est pas applicable »*.
3. **Factorisation de Cholesky :**
   * Première colonne : $b_{11} = \sqrt{a_{11}}$, $b_{i1} = \frac{a_{i1}}{b_{11}}$ ($i = 2, \dots, n$)
   * Colonnes suivantes ($p = 2, \dots, n$) :
     $$b_{pp} = \sqrt{a_{pp} - \sum_{k=1}^{p-1} b_{pk}^2}, \quad b_{ip} = \frac{1}{b_{pp}} \left( a_{ip} - \sum_{k=1}^{p-1} b_{ik} b_{pk} \right) \; (i > p)$$
4. **Matrices Triangulaires :** Construction de $B$ et de sa transposée $B^T$.
5. **Descente (Substitution avant) :** Résolution de $B \cdot Y = b$.
6. **Remontée (Substitution arrière) :** Résolution de $B^T \cdot X = Y$.
7. **Contrôle de Précision :** Calcul de la norme euclidienne du résidu $\|A \cdot X - b\|_2 \approx 10^{-15}$.

---

## 🛠️ Triple Implémentation Logicielle

Le projet est décliné sur trois plateformes complémentaires :

### 1. 🌐 Application Web Interactive (`4_Application_Web/index.html`)
* **100% Client-Side :** Développée en HTML5, CSS3 aux couleurs de l'ESISA et JavaScript ES6 pur sans dépendance.
* **Fonctionnalités :** Grille matricielle dynamique ($n = 2$ à $6$), interrupteur de symétrie automatique, tableau interactif des mineurs de Sylvester avec badges colorés, et boutons de préchargement rapide.

### 2. ☕ Application Java Swing (`3_Application_Java/Examples.java`)
* Conforme à 100% aux règles de programmation de l'ESISA 3A POO :
  * Classe `Examples` dont le constructeur instancie directement les tests (`exp01()`, `exp02()`, `exp04()`, `exp03()`).
  * Syntaxe rigoureuse des tableaux avec crochets après la variable (`double A[][]`, `double b[]`).
  * Transtypages directs en ligne sans variables intermédiaires superflues.
  * Interface Swing moderne avec `JTable` éditables et `JSpinner`.

### 3. 🍁 Scripts Maple 2015 (`2_Application_Maple`)
* **`cholesky_gui.mpl` :** Interface graphique interactive Maplet native compatible Maple 2015.
* **`cholesky_script.mpl` :** Script algorithmique console avec calcul symbolique formel exact (radicaux et fractions).

---

## 📁 Structure du Répertoire

```text
Projet-Cholesky/
│
├── 🌐 index.html                     <-- Application Web déployée (GitHub Pages)
├── 🖼️ logo_esisa.png                 <-- Logo officiel ESISA
├── ⚡ COMMANDES_RAPIDES.md            <-- Fiche express des commandes
├── 📝 SOUTENANCE_COPIER_COLLER.md    <-- Guide oral et FAQ de soutenance
├── ⚙️ LANCER_APPLICATION_WEB.bat     <-- Lanceur Web local (1 clic)
├── ⚙️ LANCER_APPLICATION_JAVA.bat    <-- Lanceur Java Swing local (1 clic)
├── 📄 README.md                      <-- Documentation officielle du dépôt
│
├── 📁 1_Rapports_et_Documents/
│   ├── Rapport_Cholesky.pdf          (Rapport complet officiel)
│   ├── Rapport_Cholesky.docx         (Version éditable Word)
│   ├── GUIDE_SOUTENANCE_CHOLESKY.pdf (Guide de soutenance 20 questions)
│   └── GUIDE_SOUTENANCE_CHOLESKY.docx
│
├── 📁 2_Application_Maple/
│   ├── cholesky_gui.mpl              (Maplet interactive)
│   └── cholesky_script.mpl           (Script console exact)
│
├── 📁 3_Application_Java/
│   ├── Examples.java                 (Code source Swing ESISA 3A)
│   └── LANCER_JAVA.bat
│
├── 📁 4_Application_Web/
│   ├── index.html                    (Application Web standalone)
│   └── logo_esisa.png
│
└── 📁 5_Ressources_et_Archives/
```

---

## 🧪 Cas de Test Validés

### 🔹 Cas 1 : Système 3x3 du Cours
* **Matrice A :** `[[2, 1, 2], [1, 3, 2], [2, 2, 3]]`
* **Second membre b :** `[√2, √2 / 2, 3√2]^T`
* **Mineurs de Sylvester :** $\Delta_1 = 2$, $\Delta_2 = 5$, $\Delta_3 = 3$ (SDP Validée)
* **Solution exacte :** $X = [ -13\sqrt{2}/6, \; -4\sqrt{2}/3, \; 10\sqrt{2}/3 ]^T \approx [ -3.0641, -1.8856, +4.7140 ]^T$
* **Norme du résidu :** $\|A \cdot X - b\|_2 = 2.384 \times 10^{-15}$

### 🔹 Cas 2 : Système 4x4 Tridiagonal
* **Matrice A :** Tridiagonale avec diagonale = 3 et sous/sur-diagonales = 1
* **Second membre b :** `[1, 0, 0, 0]^T`
* **Mineurs de Sylvester :** $\Delta_1 = 3$, $\Delta_2 = 8$, $\Delta_3 = 21$, $\Delta_4 = 55$ (SDP Validée)
* **Solution exacte :** $X = [ 21/55, \; -8/55, \; 3/55, \; -1/55 ]^T \approx [ +0.3818, -0.1455, +0.0545, -0.0182 ]^T$
* **Norme du résidu :** $\|A \cdot X - b\|_2 = 4.451 \times 10^{-16}$

---

## 💻 Instructions de Lancement Local

### Lancer l'Application Web
Ouvrez simplement `index.html` dans votre navigateur ou lancez :
```powershell
start "" "4_Application_Web\index.html"
```

### Compiler et Lancer l'Application Java Swing
```powershell
cd "3_Application_Java"
javac -encoding UTF-8 -d bin Examples.java
java -cp bin esisa.cholesky.Examples
```

### Exécuter dans Maple 2015
Dans votre feuille Maple :
```maple
restart: read "C:/Users/pc/Desktop/Esisa/3eme Annee Esisa/Analayse numerique/Projet cholesky/2_Application_Maple/cholesky_gui.mpl";
```
