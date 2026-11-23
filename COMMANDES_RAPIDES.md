# ⚡ COMMANDES RAPIDES DE TEST — PROJET CHOLESKY
**ESISA 3ème Année — Hamza DADI & Mohammed SENHAJI — Prof. Jaouad BENNOUNA**

---

## 1. Se positionner dans le dossier (Terminal PowerShell ou CMD)
```powershell
cd "C:\Users\pc\Desktop\Esisa\3eme Annee Esisa\Analayse numerique\Projet cholesky"
```

---

## 2. Lancer l'Application Web Générale (Solveur A · X = b)
```powershell
start "" "4_Application_Web\index.html"
```
*(Ou double-cliquez directement sur `LANCER_APPLICATION_WEB.bat`)*

---

## 3. Lancer l'Application Métier (Prévision de Dépenses par Cholesky)
```powershell
start "" "4_Application_Web\prevision_depenses.html"
```
*(Ou double-cliquez directement sur `LANCER_PREVISION_DEPENSES.bat` — également accessible via l'onglet en haut du Solveur Web)*

---

## 4. Lancer l'Application Java Swing
```powershell
cd "3_Application_Java"; java -cp bin esisa.cholesky.Examples
```
*(Ou double-cliquez directement sur `LANCER_APPLICATION_JAVA.bat`)*

---

## 5. Recompiler Java (en cas de modification)
```powershell
cd "3_Application_Java"; javac -encoding UTF-8 -d bin Examples.java
```

---

## 6. Lancer l'Interface Graphique Maple 2015 (Maplet)
*À copier-coller dans Maple et appuyer sur Entrée :*
```maple
restart: read "C:/Users/pc/Desktop/Esisa/3eme Annee Esisa/Analayse numerique/Projet cholesky/2_Application_Maple/cholesky_gui.mpl";
```

---

## 7. Lancer le Script Console Maple 2015 (Calcul exact)
*À copier-coller dans Maple et appuyer sur Entrée :*
```maple
restart: read "C:/Users/pc/Desktop/Esisa/3eme Annee Esisa/Analayse numerique/Projet cholesky/2_Application_Maple/cholesky_script.mpl";
```

---

## 8. Résultats Clés à Vérifier à l'Écran

### 🔹 Test 1 : Système linéaire 3x3
* **Mineurs :** Delta_1 = 2, Delta_2 = 5, Delta_3 = 3
* **Solution X :** `[ -3.0641,  -1.8856,  +4.7140 ]`
* **Forme exacte :** `[ -13·√2 / 6,  -4·√2 / 3,  10·√2 / 3 ]`
* **Résidu :** `2.384 × 10⁻¹⁵`

### 🔹 Test 2 : Système tridiagonal 4x4
* **Mineurs :** Delta_1 = 3, Delta_2 = 8, Delta_3 = 21, Delta_4 = 55
* **Solution X :** `[ +0.3818,  -0.1455,  +0.0545,  -0.0182 ]`
* **Fractions exactes :** `[ 21/55,  -8/55,  3/55,  -1/55 ]`
* **Résidu :** `4.451 × 10⁻¹⁶`

### 🔹 Test 3 : Test Piège non-SDP
* **Message d'alerte :** `La méthode de Cholesky n'est pas applicable (mineurs <= 0)`

### 🔹 Test 4 : Application Métier — Prévision de Dépenses (G · a = r)
* **Principe :** Ajustement polynomial de tendance par moindres carrés via G = Mᵀ · M (symétrique définie positive).
* **Étape 2 du prof :** Vérification stricte des mineurs de Sylvester sur G (Delta_1 > 0, Delta_2 > 0, etc.).
* **Résolution Cholesky :** Factorisation G = B · Bᵀ, descente B · z = r, remontée Bᵀ · a = z.
* **Sorties calculées :** Coefficients a_j, métriques de qualité (R², MAE, RMSE en DH), prévision des dépenses des mois à venir, contrôle de plafond avec alerte rouge de dépassement de budget, et graphique interactif HTML5 Canvas 100% hors-ligne.
