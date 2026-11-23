# 🎓 ESISA 3ÈME ANNÉE — MÉMO SOUTENANCE EXPRESS (COPIER-COLLER)
### Projet d'Analyse Numérique & POO : Résolution par Cholesky (A · X = b)
**Réalisateurs :** Hamza DADI & Mohammed SENHAJI  
**Encadrant :** Prof. Jaouad BENNOUNA  
**Année universitaire :** 2026 / 2027  

> 💡 **Mode d'emploi :** Gardez ce fichier ouvert sur votre écran pendant la soutenance. Chaque encadré contient exactement la commande à copier-coller ou la phrase clé à dire au professeur. Tout est écrit en texte clair, directement lisible sans aucun code bizarre.

---

## ⚡ 0. ORGANISATION DU DOSSIER & PRÉPARATION (2 MINUTES AVANT D'ENTRER)

Le dossier du projet est structuré en 5 modules indépendants :
* `📁 1_Rapports_et_Documents` : Rapport Word/PDF officiel et Guides de soutenance.
* `📁 2_Application_Maple` : Scripts Maple (Maplet graphique et script console).
* `📁 3_Application_Java` : Code source Java Swing (Examples.java) et bytecode compilé.
* `📁 4_Application_Web` : Application Web responsive (index.html) avec logo ESISA.
* `📁 5_Ressources_et_Archives` : Captures d'écran et sauvegardes.

**Dans votre terminal (PowerShell ou Invite de commandes), placez-vous à la racine :**
```powershell
cd "C:\Users\pc\Desktop\Esisa\3eme Annee Esisa\Analayse numerique\Projet cholesky"
```

---

## 🎤 1. LE PITCH ORAL D'INTRODUCTION (1 MINUTE)

> 🗣️ **Ce qu'il faut dire mot à mot au professeur Jaouad Bennouna :**
> 
> *« Bonjour Monsieur. Nous vous présentons notre projet d'Analyse Numérique portant sur la résolution directe de systèmes linéaires A · X = b par la factorisation de Cholesky A = B · B^T.*
> 
> *Dans les applications d'ingénierie (analyse des structures, data science, moindres carrés), la plupart des matrices sont symétriques définies positives (SDP). Appliquer Gauss ou LU sur ces matrices est un gaspillage de ressources : cela demande 2 fois plus d'opérations (2n³ / 3) et impose un pivotage.*
> *La méthode de Cholesky divise les calculs par deux (n³ / 3), économise la moitié de la mémoire et offre une stabilité numérique absolue sans aucun pivotage.*
> 
> *Pour valoriser ce travail, nous avons réalisé une triple implémentation complète :*
> 1. *Une Application Web moderne interactive et utilisable sans aucune installation.*
> 2. *Une Application Java Swing respectant 100% des règles pédagogiques de l'ESISA 3A.*
> 3. *Une Interface Maple (Maplet) pour le calcul formel symbolique exact avec les racines.*
> *Nous vous proposons de tester les trois immédiatement. »*

---

## 🌐 2. DÉMONSTRATION 1 : L'APPLICATION WEB (EN 30 SECONDES)

### A. Commande à copier-coller dans le terminal :
```powershell
start "" "4_Application_Web\index.html"
```
*(Ou double-cliquez directement sur le fichier `LANCER_APPLICATION_WEB.bat` à la racine).*

### B. Actions à effectuer à l'écran :
1. **Pointez le bandeau supérieur :**
   - *« Monsieur, voici notre interface web aux couleurs de l'ESISA avec le logo officiel, réalisée en HTML5, CSS3 et JavaScript pur, sans aucun serveur ni bibliothèque externe. »*
2. **Test 1 — Exercice 3x3 du cours :**
   - Cliquez sur `📚 Système 3x3` puis `🚀 RÉSOUDRE`.
   - Montrez : Delta_1=2, Delta_2=5, Delta_3=3, X=[-3.0641, -1.8856, 4.7140], résidu = 2.384 × 10⁻¹⁵.
3. **Test 2 — Système linéaire 4x4 tridiagonal :**
   - Cliquez sur le bouton `📐 Système 4x4` puis `🚀 RÉSOUDRE`.
   - **Montrez au professeur :**
     - La matrice tridiagonale A = [[3,1,0,0],[1,3,1,0],[0,1,3,1],[0,0,1,3]] et b = [1, 0, 0, 0]^T.
     - Les 4 mineurs de Sylvester : **Delta_1 = 3, Delta_2 = 8, Delta_3 = 21, Delta_4 = 55** (tous > 0, SDP validée).
     - La solution exacte avec ses formes fractionnaires :
       * X[1] = 0.381818 **(exact : 21/55)**
       * X[2] = -0.145455 **(exact : -8/55)**
       * X[3] = 0.054545 **(exact : 3/55)**
       * X[4] = -0.018182 **(exact : -1/55)**
     - Norme du résidu : **4.45 × 10⁻¹⁶** (précision absolue !).
5. **Démontrez le cas piège (Matrice non-SDP) :**
   - Cliquez sur le bouton `⚠️ Test non-SDP (Erreur)` puis sur `Résoudre`.
   - Montrez la bannière rouge d'alerte : *« La méthode de Cholesky n'est pas applicable : le mineur Delta_2 = -3 est négatif ou nul »*.

---

## ☕ 3. DÉMONSTRATION 2 : L'APPLICATION JAVA SWING (NORMES ESISA 3A)

### A. Commande à copier-coller dans le terminal :
```powershell
cd "3_Application_Java"; java -cp bin esisa.cholesky.Examples
```
*(Ou double-cliquez directement sur `LANCER_APPLICATION_JAVA.bat` à la racine).*

### B. Ce qu'il faut dire et montrer au professeur :
1. **Dans le terminal :** Montrez l'exécution en console de `exp01()` (exercice 3x3), `exp02()` (test non-SDP) et `exp04()` (système 4x4 avec fractions 21/55, -8/55, 3/55, -1/55).
2. **À l'écran (Fenêtre Swing interactive) :**
   - Cliquez sur le bouton `Exercice du cours (3x3)`.
   - Cliquez sur le bouton bleu `>>> RÉSOUDRE LE SYSTÈME PAR CHOLESKY <<<`.
3. **Pointez la conformité avec son cours de POO Java de 3ème Année :**
   - *« Monsieur, comme vous l'exigez à l'ESISA en 3ème année :*
     - *Le point d'entrée est la classe Examples dont le constructeur instancie directement l'exemple (exp01(), exp02(), exp03()).*
     - *Tous les tableaux sont déclarés avec les crochets après la variable : double A[][], double b[].*
     - *Les transtypages sont réalisés par cast direct en ligne sans variable intermédiaire superflue.*
     - *La grille JTable est dynamique et éditable en temps réel.*
     - *La précision mesurée par le résidu est de l'ordre de 10⁻¹⁵. »*

---

## 🍁 4. DÉMONSTRATION 3 : MAPLE 2015 (CALCUL SYMBOLIQUE EXACT)

### A. Commande à copier-coller dans Maple 2015 :
Dans votre feuille Maple ouverte, collez cette ligne et appuyez sur **Entrée** :
```maple
restart: read "C:/Users/pc/Desktop/Esisa/3eme Annee Esisa/Analayse numerique/Projet cholesky/2_Application_Maple/cholesky_gui.mpl";
```

### B. Ce qu'il faut faire :
1. La fenêtre Maplet **« Solveur de Cholesky - ESISA 3A »** s'ouvre.
2. Cliquez sur le bouton **« Calculer »** (la matrice du cours y est préremplie).
3. **Pointez les valeurs analytiques exactes conservées par Maple :**
   - Diagonale de B : racine(2),  racine(10)/2,  racine(15)/5
   - Descente exacte : Y = [ 1,  0,  2·racine(30)/3 ]
   - Solution exacte : X = [ -13·racine(2)/6,  -4·racine(2)/3,  10·racine(2)/3 ]

### C. (Optionnel) Script console Maple rapide :
Si le professeur préfère voir le résultat imprimé directement dans sa feuille de calcul :
```maple
read "C:/Users/pc/Desktop/Esisa/3eme Annee Esisa/Analayse numerique/Projet cholesky/2_Application_Maple/cholesky_script.mpl";
```

---

## 📊 5. LA FICHE DES VALEURS DU COURS (À RETENIR PAR CŒUR)

| Grandeur | Forme exacte symbolique (Maple) | Valeur décimale (Web & Java) |
| :--- | :---: | :---: |
| **Matrice A** | Ligne 1 : [2, 1, 2]<br>Ligne 2 : [1, 3, 2]<br>Ligne 3 : [2, 2, 3] | Matrice 3x3 Symétrique |
| **Second membre b** | [ racine(2),  racine(2)/2,  3·racine(2) ] | [1.4142,  0.7071,  4.2426] |
| **Mineurs de Sylvester** | Delta_1 = 2,  Delta_2 = 5,  Delta_3 = 3 | Tous > 0  ==>  Matrice bien SDP |
| **Diagonale de B** | b_11 = racine(2)<br>b_22 = racine(10)/2<br>b_33 = racine(15)/5 | b_11 = 1.4142<br>b_22 = 1.5811<br>b_33 = 0.7746 |
| **Vecteur Descente Y** | [ 1,  0,  2·racine(30)/3 ] | Y = [1.0000,  0.0000,  3.6515] |
| **Solution x_1** | -13·racine(2) / 6 | **x_1 = -3.0641** |
| **Solution x_2** | -4·racine(2) / 3 | **x_2 = -1.8856** |
| **Solution x_3** | 10·racine(2) / 3 | **x_3 = +4.7140** |
| **Résidu ||A·X - b||** | 0 (théorique parfait) | **2.384 × 10⁻¹⁵** (limite machine IEEE 754) |

---



---

### B. Système Tridiagonal 4x4

| Grandeur | Forme fractionnaire exacte | Valeur numérique |
| :--- | :---: | :---: |
| **Matrice A (4x4)** | Diagonale = 3, Sous/Sur-diagonale = 1 | Tridiagonale Toeplitz symétrique |
| **Second membre b** | [ 1,  0,  0,  0 ]^T | Vecteur unitaire premier axe |
| **Mineurs de Sylvester** | Delta_1 = 3, Delta_2 = 8, Delta_3 = 21, Delta_4 = 55 | Récurrence : Delta_m = 3·Delta_(m-1) - Delta_(m-2) |
| **Diagonale de B** | b_11 = √3, b_22 = √(8/3), b_33 = √(21/8), b_44 = √(55/21) | [ 1.7321, 1.6330, 1.6202, 1.6183 ] |
| **Descente Y** | [ 1/√3, -1/√(24), ..., ... ] | Y = [ 0.5774, -0.2041, 0.0772, -0.0294 ] |
| **Solution X[1]** | **21 / 55** (égal à Delta_3 / Delta_4) | **+0.381818** |
| **Solution X[2]** | **-8 / 55** (égal à -Delta_2 / Delta_4) | **-0.145455** |
| **Solution X[3]** | **3 / 55** (égal à Delta_1 / Delta_4) | **+0.054545** |
| **Solution X[4]** | **-1 / 55** (égal à -Delta_0 / Delta_4) | **-0.018182** |
| **Résidu ||A·X - b||** | 0 (théorique) | **4.451 × 10⁻¹⁶** |

## 🎯 6. LES 10 QUESTIONS PIÈGES DU PROFESSEUR & RÉPONSES DU TAC AU TAC

### Q1. Quelle est la condition d'applicabilité de Cholesky ?
> **Réponse :** « La matrice A doit être **symétrique définie positive (SDP)**. C'est-à-dire A égale à sa transposée (A = A^T) et pour tout vecteur x non nul, le produit x^T · A · x est strictement positif (> 0). En pratique, on la vérifie par le **critère de Sylvester** : tous les mineurs principaux dominants doivent être strictement positifs (Delta_m > 0). »

### Q2. Pourquoi Cholesky ne nécessite aucun pivotage (contrairement à Gauss) ?
> **Réponse :** « Parce que pour toute matrice SDP, chaque coefficient b_ik vérifie la relation : la somme des b_ik au carré égale a_ii, ce qui implique que la valeur absolue de b_ik est toujours inférieure ou égale à racine(a_ii). Tous les éléments de B sont naturellement bornés par la diagonale de A. Il n'y a donc aucun risque d'explosion numérique, ce qui confère à Cholesky une stabilité absolue sans permutation de lignes. »

### Q3. Comment prouver que la quantité sous la racine est toujours strictement positive ?
> **Réponse :** « Par le complément de Schur et le critère de Sylvester. Le carré du pivot b_pp² s'exprime comme le quotient de deux mineurs successifs : b_pp² = Delta_p / Delta_(p-1). Comme la matrice est SDP, Delta_p > 0 et Delta_(p-1) > 0, donc leur rapport est obligatoirement strictement positif. »

### Q4. Pourquoi résoudre par descente et remontée plutôt que d'inverser B ?
> **Réponse :** « Inverser la matrice B demande un coût élevé en O(n³) opérations et accumule des erreurs d'arrondi. La méthode de substitution (descente puis remontée) ne demande que O(n²) opérations et conserve l'exactitude de calcul avec un résidu de 10⁻¹⁵. »

### Q5. Quelle est la complexité exacte de Cholesky comparée à LU ?
> **Réponse :** « La factorisation de Cholesky demande n³ / 3 opérations élémentaires (flops). LU et Gauss en demandent 2n³ / 3. Cholesky est donc **deux fois plus rapide** et divise l'occupation mémoire par deux en ne stockant que la partie triangulaire. »

### Q6. Que se passe-t-il si un mineur est nul (Delta_m = 0) ?
> **Réponse :** « La matrice n'est plus strictement définie positive. Le terme diagonal b_mm s'annule, ce qui provoque une division par zéro lors du calcul des termes suivants. Notre programme détecte cette situation dès l'étape 2 et bloque l'exécution en affichant : la méthode de Cholesky n'est pas applicable. »

### Q7. Pourquoi avoir utilisé le critère de Sylvester au lieu du calcul des valeurs propres ?
> **Réponse :** « Trouver les valeurs propres impose de calculer les racines du polynôme caractéristique de degré n, ce qui est impossible par une formule directe pour n supérieur ou égal à 5 (Théorème d'Abel). Le critère de Sylvester repose sur le calcul direct de déterminants, qui est une méthode algébrique exacte et rapide. »

### Q8. Dans quelle application réelle rencontre-t-on toujours des matrices SDP ?
> **Réponse :** « Dans les équations normales de la régression linéaire et des moindres carrés : la matrice s'écrit A = M^T · M. Dès que les colonnes de M sont indépendantes, ce produit est obligatoirement SDP. Cholesky est l'algorithme standard employé dans les bibliothèques de Machine Learning et de traitement du signal. »

### Q9. Pourquoi avoir développé trois implémentations (Maple, Java, Web) ?
> **Réponse :**
> - **Maple :** Pour la rigueur analytique avec conservation des racines exactes (racine de 2).
> - **Java Swing :** Pour l'application logicielle de bureau conforme aux normes de POO ESISA 3A.
> - **Web (HTML/JS) :** Pour une démonstration universelle et réactive sur n'importe quel ordinateur ou écran sans installation.

### Q10. Comment démontrez-vous que votre solution numérique est correcte ?
> **Réponse :** « En calculant la norme euclidienne du résidu ||A · X - b||. Nous obtenons 2.384 × 10⁻¹⁵, ce qui correspond à la limite de précision d'un nombre flottant en double précision standard IEEE 754. »

---

## 🏆 7. CONCLUSION DE LA SOUTENANCE (30 SECONDES)

> 🗣️ **Phrase de conclusion pour clore la présentation :**
> 
> *« En conclusion, nous avons validé la chaîne algorithmique complète : vérification préalable par le critère de Sylvester, décomposition triangulaire B · B^T, descente et remontée. La concordance exacte entre Maple, Java et le Web confirme la robustesse de notre projet avec une précision de 10⁻¹⁵.*
> *Nous vous remercions pour votre attention et nous sommes à votre disposition pour vos questions. »*
