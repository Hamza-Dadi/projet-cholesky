# ÉCOLE SUPÉRIEURE D’INGÉNIERIE EN SCIENCES APPLIQUÉES (ESISA)
## DÉPARTEMENT D'INFORMATIQUE & INGÉNIERIE SYSTÈMES — 3ÈME ANNÉE
### PROJET D’ANALYSE NUMÉRIQUE : RÉSOLUTION PAR LA MÉTHODE DE CHOLESKY (A X = b)
**Guide Ultime de Préparation à la Soutenance, FAQ & Protocole de Démonstration Sans Faute**

* **Réalisé par :** Hamza DADI & Mohammed SENHAJI  
* **Sous l'encadrement de :** Prof. Jaouad BENNOUNA  
* **Année universitaire :** 2026 / 2027  

---

## TABLE DES MATIÈRES
1. **Stratégie & Déroulé du Pitch Oral (5 à 8 minutes)**
2. **Explication Complète des 6 Étapes du Tableau (Démonstrations Mathématiques)**
3. **Justification Rigoureuse de Tous les Choix Techniques (Le « Pourquoi »)**
4. **Le Grand Répertoire des 20 Questions Pièges du Professeur & Réponses Types**
5. **Protocole de Démonstration « Zéro Faute » devant le Professeur (Pas à Pas)**
6. **Fiche Mémo « Réflexes Minutes » pour la Présentation**

---

## 1. STRATÉGIE & DÉROULÉ DU PITCH ORAL (5 À 8 MINUTES)

La soutenance devant le Professeur Jaouad Bennouna doit être rythmée, mathématiquement rigoureuse et axée sur la démonstration pratique. Voici le scénario parfait minuté :

### Phase 1 : Introduction & Problématique (1 minute)
* **Accroche :** « Bonjour Monsieur. Nous vous présentons aujourd'hui notre projet d'Analyse Numérique portant sur la résolution directe de systèmes linéaires A X = b par la factorisation de Cholesky. »
* **Enjeu :** « Dans les applications industrielles (analyse structurelle, traitement du signal, apprentissage automatique), la majorité des matrices résultantes sont symétriques définies positives (SDP). Appliquer une méthode générale comme l'élimination de Gauss ou la décomposition LU sur ces matrices est un gaspillage de ressources : cela coûte deux fois plus d'opérations et exige un pivotage. Cholesky résout ce problème en exploitant la symétrie. »

### Phase 2 : Le Cœur Théorique & Algorithmique (2 minutes)
* **Théorème fondamental :** « Si A est SDP, il existe une unique matrice triangulaire inférieure B à diagonale strictement positive telle que A = B · B^T. »
* **Déroulé en 6 étapes :** 
  1. Saisie des données (a_ij, b_i).
  2. Vérification de la définie-positivité par le critère de Sylvester (Delta_m > 0).
  3. Factorisation directe colonne par colonne (b_11, b_i1, b_pp, b_ip).
  4. Affichage de B et B^T.
  5. Résolution du premier système triangulaire inférieur par descente (B Y = b).
  6. Résolution du second système triangulaire supérieur par remontée (B^T X = Y).
* **Économie :** n^3 / 3 opérations au lieu de 2n^3 / 3, et stockage mémoire divisé par 2.

### Phase 3 : Démonstration Pratique Croisée (3 minutes)
1. **Démonstration sous Maple (Maplet interactive) :**
   * Lancez `cholesky_gui.mpl`.
   * Montrez le bouton **« Exercice du cours (3x3) »** : cliquez sur Résoudre, commentez les résultats exacts (sqrt(2), sqrt(10)/2, sqrt(15)/5) et la solution exacte X = [-13*sqrt(2)/6, -4*sqrt(2)/3, 10*sqrt(2)/3]^T.
   * Montrez le bouton **« Test non-SDP »** : illustrez que l'application bloque immédiatement et affiche : *"la méthode de Cholesky n'est pas applicable"*.
   * Montrez le conditionnement cond_2(A) et la norme du résidu.
2. **Démonstration sous Java Swing (Normes ESISA 3A) :**
   * Lancez `java -cp bin esisa.cholesky.Examples`.
   * Expliquez au professeur que le code respecte à 100% les consignes de programmation de l'ESISA 3A (classe `Examples`, constructeur d'instanciation, `double A[][]`, méthodes `exp01()`, `exp02()`, `exp03()`).
   * Montrez la dynamique du tableau `JTable` et le contrôle de précision : résidu ||A X - b|| = 2,38 × 10^-15.
3. **Application aux Moindres Carrés :**
   * Rappelez en une phrase que dans l'ajustement polynomial des dépenses (en DH), le système normal M^T M a = M^T y donne une matrice de Gram G = M^T M toujours symétrique définie positive, ce qui justifie naturellement l'emploi de Cholesky.

### Phase 4 : Conclusion & Synthèse (1 minute)
* « En conclusion, nous avons implémenté l'algorithme sous Maple pour le calcul symbolique exact, et sous Java Swing pour l'application logicielle compilée. La solution numérique est vérifiée avec une erreur inférieure à 10^-15. Nous sommes prêts à répondre à vos questions. »

---

## 2. EXPLICATION APPROFONDIE DES 6 ÉTAPES (DÉMONSTRATIONS MATHÉMATIQUES)

### Étape 1 : Saisie de a_ij et b_i
* **Ce qu'on fait :** On entre la matrice A (de taille n x n) et le vecteur second membre b (taille n).
* **Pourquoi :** Déterminer la dimension n du problème. Dans notre code, n est dynamique (`RowDimension(A)` en Maple, `A.length` en Java), ce qui rend le solveur universel.

---

### Étape 2 : Vérification SDP — Le Critère de Sylvester
* **Définition SDP :** Une matrice symétrique A est définie positive si pour tout vecteur non nul x non nul :
  x^T A x > 0
* **Critère de Sylvester :** Une matrice symétrique A est définie positive si et seulement si tous ses mineurs principaux dominants sont strictement positifs :
  Delta_m = det(A_{1..m, 1..m}) > 0 pour tout m allant de 1 à n
* **Pourquoi tester Sylvester et pas les valeurs propres ?**  
  Le calcul des valeurs propres nécessite la recherche des racines du polynôme caractéristique (méthode itérative QR, complexe et coûteuse en O(n^3)). Le critère de Sylvester ou le test des pivots Cholesky est direct et exact.
* **Le message exigé par le professeur :**  
  Si un Delta_m <= 0 ou si A <> A^T, le programme s'arrête immédiatement et envoie :  
  "la méthode de Cholesky n'est pas applicable"

---

### Étape 3 : Factorisation A = B · B^T (Origine exacte des formules)
Considérons le produit matriciel A = B · B^T où B = (b_ij) est triangulaire inférieure (b_ij = 0 si j > i).  
L'élément générique a_ij (pour i >= j) s'écrit :
a_ij = sum_{k=1}^j b_ik * b_jk

#### 1. Pour la première colonne (j = 1) :
* Pour i = 1 : a_11 = b_11 * b_11 = b_11^2  ==>  b_11 = sqrt(a_11)
* Pour i = 2, ..., n : a_i1 = b_i1 * b_11  ==>  b_i1 = a_i1 / b_11

#### 2. Pour les colonnes suivantes (p = 2, ..., n) :
* **Sur la diagonale (i = p) :**
  a_pp = sum_{k=1}^{p-1} b_pk^2 + b_pp^2  ==>  b_pp = sqrt( a_pp - sum_{k=1}^{p-1} b_pk^2 )
* **Sous la diagonale (i = p+1, ..., n) :**
  a_ip = sum_{k=1}^{p-1} b_ik * b_pk + b_ip * b_pp  ==>  b_ip = (1 / b_pp) * ( a_ip - sum_{k=1}^{p-1} b_ik * b_pk )

#### Pourquoi la valeur sous la racine est-elle toujours > 0 ?
C'est le **théorème du complément de Schur**. À l'étape p, la quantité :
a_pp - sum_{k=1}^{p-1} b_pk^2 = Delta_p / Delta_{p-1}
Comme A est définie positive, par le critère de Sylvester, Delta_p > 0 et Delta_{p-1} > 0. Leur quotient est donc **strictement positif**, ce qui garantit qu'on ne prend jamais la racine d'un nombre négatif ou nul !

---

### Étape 4 : Affichage de B et B^T
* B est triangulaire inférieure à coefficients diagonaux strictement positifs.
* B^T est sa transposée (triangulaire supérieure).
* **Astuce d'ingénieur :** En mémoire machine, on n'a pas besoin de stocker B^T. Tout élément (B^T)_{ik} est simplement lu en mémoire comme B_{ki}.

---

### Étape 5 : Résolution de B Y = b (Algorithme de Descente)
Comme A X = b équivaut à B (B^T X) = b, on pose le vecteur intermédiaire Y = B^T X. On résout d'abord B Y = b.  
Le système est triangulaire inférieur.
* Pour i = 1 : y_1 = b_1 / b_11
* Pour i = 2, ..., n :
  y_i = (1 / b_ii) * ( b_i - sum_{k=1}^{i-1} b_ik * y_k )
* On parcourt les indices de haut en bas (i = 1 à n) : c'est la **substitution avant** ou **descente**.

---

### Étape 6 : Résolution de B^T X = Y (Algorithme de Remontée)
On résout maintenant B^T X = Y où B^T est triangulaire supérieure :
* Pour i = n : x_n = y_n / b_nn
* Pour i = n-1 en descendant jusqu'à 1 :
  x_i = (1 / b_ii) * ( y_i - sum_{k=i+1}^n b_ki * x_k )
* On parcourt les indices du bas vers le haut (i = n à 1) : c'est la **substitution arrière** ou **remontée**.
* Le vecteur X obtenu est la solution unique exacte de A X = b.

---

## 3. JUSTIFICATION RIGOUREUSE DE TOUS LES CHOIX TECHNIQUES

* **Cholesky plutôt que LU ou Gauss :**
  - **2 fois plus rapide** : n^3 / 3 opérations contre 2n^3 / 3 pour LU.
  - **2 fois moins de mémoire** : stockage d'une seule matrice B.
  - **Stabilité absolue** : aucun risque de division par un petit pivot, aucun pivotage partiel nécessaire.

* **Résolution par descente/remontée plutôt qu'inversion de matrice :**
  - Calculer X = A^-1 * b nécessiterait d'inverser A, ce qui coûte O(n^3) et génère d'énormes erreurs d'arrondi. La descente/remontée ne coûte que O(n^2) et est numériquement stable.

* **Maple pour le calcul symbolique :**
  - Permet de conserver les **radicaux exacts** (sqrt(2), sqrt(10)/2, sqrt(15)/5) sans subir la troncature décimale des nombres flottants.

* **Usage de `add` au lieu de `sum` en Maple :**
  - `add` est une fonction arithmétique compilée pour sommer sur des indices entiers définis. `sum` est une fonction symbolique qui tente de trouver des séries formelles, ce qui est inutile et plus lent ici.

* **Initialisation `Matrix(n, n, 0)` :**
  - Garantit que toutes les cases au-dessus de la diagonale valent strictement 0 (entier), évitant des cases indéterminées selon les versions de Maple.

* **Java Swing pour l'application logicielle :**
  - **100% natif** dans le JDK standard : aucune installation de framework externe (contrairement à JavaFX qui requiert OpenJFX et des modules). Fonctionne instantanément sur toutes les machines de l'ESISA.

* **Conventions ESISA 3A en Java :**
  - Classe `Examples` avec constructeur instanciant, méthodes de niveau package `exp01()`, tableaux avec crochets après variable `double A[][]`, respectant à la lettre les consignes pédagogiques de l'ESISA.

* **Application aux Moindres Carrés :**
  - La matrice normale G = M^T M de la régression polynomiale est **toujours symétrique définie positive** dès que les points de mesure sont distincts. C'est le cas d'école réel où Cholesky est utilisé en entreprise et en R&D.

---

## 4. LE GRAND RÉPERTOIRE DES 20 QUESTIONS PIÈGES DU PROFESSEUR & RÉPONSES TYPES

### Q1. Quelle est la condition mathématique nécessaire et suffisante d'existence et d'unicité de Cholesky ?
> Réponse : « La matrice A doit être symétrique définie positive. Si cette condition est vérifiée, il existe une unique matrice triangulaire inférieure B à diagonale strictement positive (b_ii > 0) telle que A = B · B^T. »

### Q2. Comment démontrez-vous l'unicité de la matrice B ?
> Réponse : « Supposons qu'il existe deux factorisations A = B_1 · B_1^T = B_2 · B_2^T. Comme A est inversible, B_1 et B_2 le sont aussi. On en déduit :
B_2^-1 · B_1 = B_2^T · (B_1^T)^-1 = (B_1^-1 · B_2)^T.
Or B_2^-1 · B_1 est le produit de deux matrices triangulaires inférieures, donc elle est triangulaire inférieure. Son membre de droite est triangulaire supérieure. Une matrice à la fois triangulaire inférieure et supérieure est nécessairement diagonale.
Notons D = B_2^-1 · B_1. On a D = D^-1, donc D^2 = I. Comme les éléments diagonaux de B_1 et B_2 sont strictement positifs, les éléments diagonaux de D sont strictement positifs, d'où D = I. On en conclut B_1 = B_2. »

### Q3. Que se passe-t-il si la matrice est seulement semi-définie positive (au moins un pivot nul) ?
> Réponse : « Si la matrice est semi-définie positive, la factorisation A = B · B^T reste possible, mais certains éléments diagonaux b_pp deviennent nuls (b_pp = 0). Dès lors, B n'est plus inversible, l'étape suivante de division par b_pp pour calculer b_ip provoque une division par zéro, et la décomposition perd son unicité. Notre algorithme rejette ce cas à l'étape 2 via le critère de Sylvester (Delta_m <= 0). »

### Q4. Pourquoi Cholesky ne nécessite aucun pivotage alors que Gauss et LU en ont besoin ?
> Réponse : « Dans l'élimination de Gauss, un pivot petit peut provoquer une explosion des erreurs d'arrondi ou une division par zéro si un pivot s'annule, ce qui oblige à permuter les lignes (pivotage partiel).
Pour Cholesky, on a la relation :
a_ii = sum_{k=1}^i b_ik^2  ==>  b_ik^2 <= a_ii  ==>  |b_ik| <= sqrt(a_ii).
Les éléments de la matrice B sont naturellement bornés par les éléments diagonaux de A. Il n'y a donc aucun risque d'amplification d'erreurs, ce qui confère à Cholesky une stabilité numérique inconditionnelle sans aucun pivotage. »

### Q5. Comment prouver que la quantité sous la racine a_pp - sum b_pk^2 est strictement positive ?
> Réponse : « C'est une conséquence directe du théorème de Sylvester et du complément de Schur. Le pivot à l'étape p s'exprime comme le quotient de deux mineurs principaux successifs :
b_pp^2 = a_pp - sum_{k=1}^{p-1} b_pk^2 = Delta_p / Delta_{p-1}.
Comme A est SDP, Delta_p > 0 et Delta_{p-1} > 0, donc leur quotient est strictement positif. »

### Q6. Pourquoi utilisez-vous le critère de Sylvester plutôt que le calcul des valeurs propres ?
> Réponse : « Calculer les valeurs propres exige de résoudre une équation caractéristique de degré n, ce qui est impossible par radicaux pour n >= 5 (Théorème d'Abel) et nécessite des algorithmes itératifs approchés coûteux en temps de calcul. Le critère de Sylvester repose sur le calcul direct de déterminants par élimination de Gauss, ce qui est exact et direct. »

### Q7. Quelle est la complexité exacte en nombre d'opérations de Cholesky ?
> Réponse : « Pour la factorisation B : environ n^3 / 6 multiplications et n^3 / 6 additions, soit n^3 / 3 flops (plus n racines carrées).
Pour la descente B Y = b : n^2 / 2 flops.
Pour la remontée B^T X = Y : n^2 / 2 flops.
Total : environ n^3 / 3 + n^2 flops. C'est exactement la moitié du coût d'une décomposition LU (2n^3 / 3 flops). »

### Q8. Comment vérifiez-vous numériquement que votre solution X est juste ?
> Réponse : « Nous calculons la norme euclidienne du résidu :
||R||_2 = ||A X - b||_2.
Dans notre test Java et Maple sur l'exercice du cours, nous obtenons ||R||_2 = 2,38 × 10^-15. Ce chiffre est de l'ordre de l'epsilon machine (10^-16 en double précision IEEE 754), ce qui démontre que la solution trouvée est numériquement parfaite. »

### Q9. Qu'est-ce que le conditionnement cond(A) et quel est son effet ?
> Réponse : « Le conditionnement en norme 2 d'une matrice SDP est le rapport entre sa plus grande et sa plus petite valeur propre :
cond_2(A) = lambda_max / lambda_min >= 1.
Il mesure la sensibilité de la solution X aux perturbations sur b ou A : ||delta X|| / ||X|| <= cond(A) * (||delta b|| / ||b||). Si cond(A) est proche de 1, le système est très bien conditionné. S'il est très grand (ex: matrice de Hilbert), on observe une perte de chiffres significatifs. »

### Q10. Quelle est la différence entre la factorisation A = B B^T et A = L D L^T ?
> Réponse : « La factorisation A = L D L^T décompose A en une matrice triangulaire inférieure à diagonale unité (L) et une matrice diagonale (D).
Le lien direct est : B = L · D^(1/2).
L'avantage de L D L^T est qu'elle ne calcule aucune racine carrée, ce qui est utile sur des processeurs embarqués lents ou pour des matrices symétriques indéfinies où D peut contenir des termes négatifs. Mais pour une matrice SDP en calcul matriciel moderne, la formulation de Cholesky B B^T est la plus compacte et canonique. »

### Q11. Dans votre application de moindres carrés, pourquoi G = M^T M est-elle SDP ?
> Réponse : « 1. Symétrie : G^T = (M^T M)^T = M^T (M^T)^T = M^T M = G.
2. Définie-positivité : Pour tout vecteur v non nul, v^T G v = (M v)^T (M v) = ||M v||_2^2 >= 0.
De plus, si la matrice M est de rang plein (ce qui est garanti dès que les mois x_i observés sont distincts), M v = 0 implique v = 0. Donc ||M v||^2 > 0 pour tout v non nul, ce qui prouve que G est strictement définie positive. »

### Q12. Pourquoi avoir utilisé `add` au lieu de `sum` dans le script Maple ?
> Réponse : « En Maple, `sum` est un opérateur de calcul formel qui cherche une formule générale ou une série indéfinie. Pour sommer des termes avec des bornes entières connues comme k = 1 .. p-1, Maple préconise `add`, qui effectue une addition arithmétique directe sans surcoût d'évaluation formelle. »

### Q13. À l'étape 6 de remontée, pourquoi divisez-vous par B[i,i] et non par un élément de B^T ?
> Réponse : « Parce que la diagonale d'une matrice et la diagonale de sa transposée sont identiques : (B^T)_{ii} = B_{ii}. On peut donc diviser indifféremment par (B^T)_{ii} ou B_{ii}. »

### Q14. Pourquoi avoir déclaré les tableaux `double A[][]` et non `double[][] A` en Java ?
> Réponse : « C'est la convention pédagogique stricte exigée en 3ème année à l'ESISA. Elle s'inspire de la syntaxe historique C/Java et fait partie intégrante du barème de notation du département d'informatique. »

### Q15. Si un élément diagonal a_ii <= 0, que peut-on déduire sans calculer aucun déterminant ?
> Réponse : « On peut affirmer immédiatement que la matrice n'est pas définie positive. En effet, en prenant le vecteur de la base canonique e_i = [0,...,1,...,0]^T, on a e_i^T A e_i = a_ii. Si A était définie positive, on aurait e_i^T A e_i > 0, donc a_ii > 0. Donc tout élément diagonal d'une matrice SDP doit être strictement positif. »

### Q16. Peut-on appliquer Cholesky à des matrices complexes ?
> Réponse : « Oui, pour les matrices hermitiennes définies positives (A = A^* = transpose(conj(A))). La décomposition s'écrit alors A = B B^* où B^* est la transconjuguée de B, et les éléments diagonaux b_ii restent réels et strictement positifs. »

### Q17. Pourquoi l'algorithme de descente s'appelle-t-il « substitution avant » ?
> Réponse : « Parce qu'on commence par la première équation qui ne contient qu'une seule inconnue (y_1 = b_1 / b_11), puis on injecte cette valeur vers l'avant dans la deuxième équation pour trouver y_2, et ainsi de suite en descendant jusqu'à y_n. »

### Q18. Pourquoi l'algorithme de remontée s'appelle-t-il « substitution arrière » ?
> Réponse : « Parce qu'on commence par la dernière équation qui ne contient que x_n (b_nn x_n = y_n), puis on remonte vers l'arrière en injectant les solutions déjà trouvées jusqu'à atteindre x_1. »

### Q19. Quel est l'intérêt de Cholesky si l'on doit résoudre A X = b pour plusieurs seconds membres b différents ?
> Réponse : « C'est un avantage majeur : la factorisation A = B B^T, qui coûte O(n^3), n'est effectuée qu'une seule fois. Ensuite, pour chaque nouveau vecteur b, la résolution par descente/remontée ne coûte que 2 × (n^2 / 2) = n^2 opérations, ce qui est quasi-instantané. »

### Q20. Quelle est la valeur ajoutée d'avoir fait à la fois Maple et Java ?
> Réponse : « Maple nous offre la puissance du calcul symbolique formel (gestion exacte des racines carrées, sans arrondi). Java nous apporte la puissance du génie logiciel (compilation binaire, typage strict, interface graphique interactive sans logiciel propriétaire lourd). C'est la passerelle idéale entre l'analyse mathématique et l'informatique appliquée enseignées à l'ESISA. »

---

## 5. PROTOCOLE DE DÉMONSTRATION « ZÉRO FAUTE » DEVANT LE PROFESSEUR (PAS À PAS)

Pour réussir la démonstration sans aucune hésitation ni bug devant M. Bennouna, suivez ce protocole précis chronométré :

### Étape 0 : Préparation 5 minutes avant d'entrer en salle
1. Ouvrez votre terminal (PowerShell ou Invite de commandes).
2. Positionnez-vous déjà dans le bon dossier :
   `cd "C:\Users\pc\Desktop\Esisa\3eme Annee Esisa\Analayse numerique\Projet cholesky"`
3. Lancez le logiciel Maple (laissez une feuille vide ouverte prête).
4. Ouvrez le fichier Word `Rapport_Cholesky.docx` et le PDF `Rapport_Cholesky.pdf` en arrière-plan.

---

### Démonstration 1 : L'Interface Maple (Maplet `cholesky_gui.mpl`)

#### 1. Lancement :
Dans Maple 2015, tapez :
```maple
restart:
read "C:/Users/pc/Desktop/Esisa/3eme Annee Esisa/Analayse numerique/Projet cholesky/cholesky_gui.mpl";
```
Appuyez sur `Entrée`. Une fenêtre grise intitulée *"ESISA 3A - Solveur Linéaire de Cholesky..."* s'ouvre au centre de l'écran.

#### 2. Test du Cas Nominal (Exercice du cours 3x3) :
* **Action :** Cliquez sur le bouton **« Exercice du cours (3x3) »**.
* **Action :** Cliquez sur le bouton **« >>> RÉSOUDRE (Cholesky) <<< »**.
* **Ce qu'il faut dire au professeur en pointant l'écran :**
  - *« Regardez Monsieur : l'étape 2 calcule les trois mineurs de Sylvester : Delta_1 = 2, Delta_2 = 5, Delta_3 = 3. Tous sont strictement positifs, donc A est bien définie positive. »*
  - *« L'étape 3 et 4 donne la matrice triangulaire inférieure B exacte avec ses racines : sqrt(2), sqrt(10)/2, sqrt(15)/5 sur la diagonale, et sa transposée B^T. »*
  - *« L'étape 5 donne la descente Y = [1, 0, 2*sqrt(30)/3]^T. »*
  - *« L'étape 6 donne la remontée X = [-13*sqrt(2)/6, -4*sqrt(2)/3, 10*sqrt(2)/3]^T. »*
  - *« Et enfin, le contrôle de qualité indique une norme de résidu inférieure à 10^-15, attestant de la perfection du calcul. »*

#### 3. Test du Cas Piège (Matrice non-SDP) :
* **Action :** Cliquez sur le bouton **« Test non-SDP (Erreur) »**.
* **Action :** Cliquez sur **« >>> RÉSOUDRE (Cholesky) <<< »**.
* **Ce qu'il faut dire :**
  - *« Nous testons maintenant une matrice non définie positive : A = [[1,2],[2,1]]. Son deuxième mineur vaut Delta_2 = 1 - 4 = -3 <= 0. »*
  - *« Comme vous l'avez demandé au tableau à l'étape 2, notre programme refuse la factorisation et affiche exactement le message : "la méthode de Cholesky n'est pas applicable". »*

#### 4. Test du Passage à l'Échelle (4x4) :
* **Action :** Cliquez sur **« Exemple 4x4 »** puis sur **« RÉSOUDRE »**.
* **Ce qu'il faut dire :**
  - *« Notre solveur est universel et s'adapte automatiquement à toute dimension n sans modification de code. »*

---

### Démonstration 2 : L'Application Java Swing (`Examples.java`)

#### 1. Lancement :
Basculez sur votre fenêtre de terminal déjà prête et tapez :
```bash
java -cp bin esisa.cholesky.Examples
```
Appuyez sur `Entrée`.

#### 2. Ce qui se passe :
1. **Dans le terminal :** Les expériences `exp01()` et `exp02()` s'exécutent en mode console.
   - Montrez au professeur que les sorties console respectent les questions de l'exercice.
2. **À l'écran :** Une fenêtre graphique moderne en Java Swing s'ouvre.
   - Soulignez : *« Monsieur, conformément aux cours de POO Java de 3ème année à l'ESISA, nous avons développé cette interface Swing avec des tableaux JTable éditables et un sélecteur dynamique de dimension. »*
3. **Action :** Cliquez sur le bouton bleu **« >>> RÉSOUDRE LE SYSTÈME PAR CHOLESKY <<< »**.
   - Pointez la section finale : *« Vérification ligne par ligne : Ligne 1, Ligne 2, Ligne 3 avec un écart de l'ordre de 10^-15 »*.
4. **Action bonus interactive :** Changez une valeur directement dans la case de la grille (par exemple remplacez `2.0` par `3.0`) et recliquez sur Résoudre pour montrer que le calcul est instantané en Java.

---

### Démonstration 3 : L'Application Web Interactive (`index.html`)

#### 1. Lancement :
Double-cliquez directement sur `index.html` dans le dossier du projet (ou dans le terminal : `start "" "index.html"`). L'interface s'ouvre instantanément dans Google Chrome ou Microsoft Edge sans aucun serveur ni installation.

#### 2. Ergonomie et Design ESISA :
* Montrez le bandeau d'en-tête intégrant le logo officiel de l'ESISA, le nom des réalisateurs (**Hamza DADI & Mohammed SENHAJI**) et de l'encadrant (**Prof. Jaouad BENNOUNA**).
* Soulignez l'architecture 'Zero-Dependency' : HTML5 sémantique, CSS3 moderne et moteur JavaScript ES6 pur exécuté à 100% côté client.
* Présentez le sélecteur dynamique de dimension (2x2 jusqu'à 6x6) et l'interrupteur de symétrie automatique qui synchronise a_ji en temps réel lors de la frappe de a_ij.

#### 3. Test du Cas Nominal (Exercice du cours 3x3) :
* Cliquez sur le bouton de raccourci **« 📚 Exercice du cours (3x3) »**.
* Cliquez sur le gros bouton d'action bleu **« 🚀 RÉSOUDRE PAR LA MÉTHODE DE CHOLESKY »**.
* Pointez les éléments clés :
  - Le tableau interactif des mineurs de Sylvester : Delta_1 = 2, Delta_2 = 5, Delta_3 = 3, tous dotés du badge vert `> 0 (OK)`.
  - Le bandeau vert de validation : *« Matrice Symétrique Définie Positive (SDP) — Méthode de Cholesky 100% Applicable »*.
  - L'affichage ordonné des matrices B, B^T, de la descente Y = [1.0000, 0.0000, 3.6515]^T et de la remontée X = [-3.0641, -1.8856, 4.7140]^T.
  - La précision numérique maximale avec ||A·X - b||_2 = 2.384 × 10^-15 et conditionnement cond_2(A) = 11.23.

#### 4. Test du Cas Piège (Non-SDP) :
* Cliquez sur le bouton **« ⚠️ Test non-SDP (Erreur) »** puis sur **« Résoudre »**.
* Montrez le blocage instantané avec la bannière rouge d'alerte : *« La méthode de Cholesky n'est pas applicable : le mineur principal d'ordre 2 est négatif (Delta_2 = -3 <= 0) »*.

---

### Démonstration 4 : L'Application Réelle aux Moindres Carrés
Si le professeur demande : *« Pourquoi Cholesky est-il utile dans la vraie vie ? »*  
Dans Maple, tapez :
```maple
read "C:/Users/pc/Desktop/Esisa/3eme Annee Esisa/Analayse numerique/Projet cholesky/application_script.mpl";
```
* Montrez le graphique tracé par Maple avec les points observés en rouge, la courbe bleue de régression ajustée par Cholesky, et les prévisions de budget en DH en vert.
* Concluez : *« Dans les équations normales de Gauss G.a = r, la matrice G = M^T M est toujours symétrique définie positive. Cholesky est donc l'algorithme standard utilisé par tous les solveurs de Data Science et de Machine Learning pour la régression polynomiale. »*

---

## 6. FICHE MÉMO « RÉFLEXES MINUTES » POUR LA SOUTENANCE

1. **Ne jamais dire :** « On a inversé la matrice B ».  
   **Toujours dire :** « On a résolu par descente et remontée ».
2. **Ne jamais hésiter sur les mineurs de Sylvester :**  
   Pour notre matrice du cours : Delta_1 = 2, Delta_2 = 5, Delta_3 = 3. Tous strictement positifs ==> SDP validée.
3. **Les valeurs clés de l'exercice à retenir par cœur :**
   * B a pour diagonale : sqrt(2), sqrt(10)/2, sqrt(15)/5.
   * Y = [1, 0, 2*sqrt(30)/3]^T.
   * X = [-13*sqrt(2)/6, -4*sqrt(2)/3, 10*sqrt(2)/3]^T  approx  [-3,0641, -1,8856, 4,7140]^T.
   * Résidu final : ||AX - b|| approx 2,38 × 10^-15.
