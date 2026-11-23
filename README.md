# 📐 Solveur Linéaire & Prévision de Dépenses par la Méthode de Cholesky

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
👉 **[Lancer le Solveur Web de Cholesky](https://hamza-dadi.github.io/projet-cholesky/)** *(ou via le fichier local `index.html`)*  
👉 **[Lancer l'Application de Prévision de Dépenses](https://hamza-dadi.github.io/projet-cholesky/projet-cholesky/prevision_depenses.html)** *(ou via `prevision_depenses.html`)*

---

## 📖 Présentation du Projet

Ce projet a pour objectif la résolution directe de systèmes linéaires :

$$A \cdot X = b$$

lorsque la matrice $A \in \mathcal{M}_n(\mathbb{R})$ est **symétrique définie positive (SDP)**, via la factorisation de Cholesky :

$$A = B \cdot B^T$$

où $B$ est une matrice triangulaire inférieure à éléments diagonaux strictement positifs ($b_{ii} > 0$).

Le projet intègre également une **application métier concrète** : la **prévision de dépenses mensuelles** par régression polynomiale (moindres carrés). Les coefficients de la courbe minimisent l'écart quadratique et sont solution du système normal :

$$G \cdot a = r \quad 	ext{avec } G = M^T M$$

La matrice de Gram $G$ est garantie symétrique définie positive :
* **L'Étape 2 du professeur (Critère de Sylvester)** sert de vérification rigoureuse de l'intégrité des données et de l'indépendance des variables.
* **Les Étapes 3 à 6 (Cholesky, descente, remontée)** déterminent les coefficients $a$, calculent le coefficient de détermination $R^2$, projettent les dépenses futures et déclenchent une alerte en cas de dépassement de budget.

---

### Les 6 Étapes Algorithmiques Implémentées :

1. **Saisie des données :** Entrée dynamique des coefficients $a_{ij}$ et des composantes $b_i$.
2. **Vérification de la Définie-Positivité (Critère de Sylvester) :**
   $$\Delta_m = \det(A_{1..m, 1..m}) > 0 \quad (orall m \in \{1, \dots, n\})$$
   En cas de mineur négatif ou nul, l'exécution est arrêtée avec le message d'alerte : *« La méthode de Cholesky n'est pas applicable »*.
3. **Factorisation de Cholesky :**
   * Première colonne : $b_{11} = \sqrt{a_{11}}$, $b_{i1} = rac{a_{i1}}{b_{11}}$ ($i = 2, \dots, n$)
   * Colonnes suivantes ($p = 2, \dots, n$) :
     $$b_{pp} = \sqrt{a_{pp} - \sum_{k=1}^{p-1} b_{pk}^2}, \quad b_{ip} = rac{1}{b_{pp}} \left( a_{ip} - \sum_{k=1}^{p-1} b_{ik} b_{pk} 
ight) \; (i > p)$$
4. **Matrices Triangulaires :** Construction de $B$ et de sa transposée $B^T$.
5. **Descente (Substitution avant) :** Résolution de $B \cdot Y = b$.
6. **Remontée (Substitution arrière) :** Résolution de $B^T \cdot X = Y$.
7. **Contrôle de Précision :** Calcul de la norme euclidienne du résidu $\|A \cdot X - b\|_2 pprox 10^{-15}$.

---

## 🛠️ Triple Implémentation Logicielle

Le projet est décliné sur trois plateformes complémentaires :

### 1. 🌐 Applications Web Interactives (`4_Application_Web/`)
* **Solveur Linéaire Général (`index.html`) :** Saisie dynamique ($n = 2$ à $6$), interrupteur de symétrie automatique, tableau interactif des mineurs de Sylvester avec badges colorés, et boutons de préchargement direct.
* **Application Métier Prévision de Dépenses (`prevision_depenses.html`) :** Saisie de dépenses mensuelles en Dirhams (DH), ajustement polynomial (linéaire, quadratique, cubique ou sélection automatique par meilleur $R^2$), matrice de Gram $G = M^T M$, décomposition Cholesky, descente, remontée, prévision des mois à venir, seuil de budget avec alerte visuelle rouge, et tracé dynamique Canvas 100% hors-ligne.

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

## 📂 Structure du Répertoire

```text
Projet-Cholesky/
│
├── 🌐 index.html                         <-- Solveur Web Général déployé (GitHub Pages)
├── 📊 prevision_depenses.html            <-- Application Métier Prévision de Dépenses
├── 🖼️ logo_esisa.png                     <-- Logo officiel ESISA
├── ⚡ COMMANDES_RAPIDES.md                <-- Fiche express des commandes
├── 📑 SOUTENANCE_COPIER_COLLER.md        <-- Guide oral et FAQ de soutenance
├── ⚙️ LANCER_APPLICATION_WEB.bat         <-- Lanceur Web local (Solveur)
├── ⚙️ LANCER_PREVISION_DEPENSES.bat      <-- Lanceur Web local (Prévision de Dépenses)
├── ⚙️ LANCER_APPLICATION_JAVA.bat        <-- Lanceur Java Swing local (1 clic)
├── ⚙️ DEPLOYER_SUR_GITHUB.bat            <-- Script de synchronisation Git/GitHub
├── 📄 README.md                          <-- Documentation officielle du dépôt
│
├── 📁 1_Rapports_et_Documents/
│   ├── Rapport_Cholesky.pdf              (Rapport complet officiel)
│   ├── Rapport_Cholesky.docx             (Version éditable Word)
│   ├── GUIDE_SOUTENANCE_CHOLESKY.pdf     (Guide de soutenance 20 questions)
│   └── GUIDE_SOUTENANCE_CHOLESKY.docx
│
├── 📁 2_Application_Maple/
│   ├── cholesky_gui.mpl                  (Maplet interactive)
│   └── cholesky_script.mpl               (Script console exact)
│
├── 📁 3_Application_Java/
│   ├── Examples.java                     (Code source Swing ESISA 3A)
│   └── LANCER_JAVA.bat
│
├── 📁 4_Application_Web/
│   ├── index.html                        (Solveur Web standalone)
│   ├── prevision_depenses.html           (Prévision de dépenses standalone)
│   ├── LANCER_WEB.bat
│   ├── LANCER_PREVISION.bat
│   └── logo_esisa.png
│
└── 📁 5_Ressources_et_Archives/
```

---

## 🧪 Cas de Test Validés

### 🔹 Cas 1 : Système 3x3
* **Matrice A :** `[[2, 1, 2], [1, 3, 2], [2, 2, 3]]`
* **Second membre b :** `[√2, √2 / 2, 3√2]^T`
* **Mineurs de Sylvester :** $\Delta_1 = 2$, $\Delta_2 = 5$, $\Delta_3 = 3$ (SDP Validée)
* **Solution exacte :** $X = [ -13\sqrt{2}/6, \; -4\sqrt{2}/3, \; 10\sqrt{2}/3 ]^T pprox [ -3.0641, -1.8856, +4.7140 ]^T$
* **Norme du résidu :** $\|A \cdot X - b\|_2 = 2.384 	imes 10^{-15}$

### 🔹 Cas 2 : Système 4x4 Tridiagonal
* **Matrice A :** Tridiagonale avec diagonale = 3 et sous/sur-diagonales = 1
* **Second membre b :** `[1, 0, 0, 0]^T`
* **Mineurs de Sylvester :** $\Delta_1 = 3$, $\Delta_2 = 8$, $\Delta_3 = 21$, $\Delta_4 = 55$ (SDP Validée)
* **Solution exacte :** $X = [ 21/55, \; -8/55, \; 3/55, \; -1/55 ]^T pprox [ +0.3818, -0.1455, +0.0545, -0.0182 ]^T$
* **Norme du résidu :** $\|A \cdot X - b\|_2 = 4.451 	imes 10^{-16}$

### 🔹 Cas 3 : Application Métier (Prévision de Dépenses)
* **Système résolu :** $G \cdot a = r$ avec $G = M^T M$
* **Critère de Sylvester :** $\Delta_m > 0$ vérifie l'indépendance stricte des descripteurs
* **Qualité :** $R^2 \ge 0.98$ avec modèle quadratique / cubique
* **Contrôle budgétaire :** Détection automatique du dépassement de plafond mensuel

### 🔹 Cas 4 : Détection d'une Matrice Non-SDP
* **Exemple :** Matrice symétrique ayant un mineur de Sylvester $\le 0$
* **Comportement attendu :** Arrêt immédiat et affichage du message explicite *« La méthode de Cholesky n'est pas applicable »*

---

## 💻 Instructions de Lancement Local

### Lancer les Applications Web
Ouvrez `index.html` ou `prevision_depenses.html` dans votre navigateur ou exécutez :
```powershell
start "" "4_Application_Web\index.html"
start "" "4_Application_Web\prevision_depenses.html"
```
*(Ou double-cliquez sur `LANCER_APPLICATION_WEB.bat` ou `LANCER_PREVISION_DEPENSES.bat`)*

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
