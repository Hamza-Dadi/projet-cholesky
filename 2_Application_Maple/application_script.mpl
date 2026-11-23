# =====================================================================
#  APPLICATION : PREVISION DES DEPENSES MENSUELLES
#  Methode de Cholesky (algorithme du prof) + moindres carres
#
#  Principe : on cherche le polynome  y = a0 + a1*x + ... + ad*x^d
#  qui passe au plus pres des depenses observees.
#  Les coefficients sont la solution du systeme normal  G.a = r
#  avec  G = M^T.M  (symetrique definie positive)  et  r = M^T.y.
#  On resout ce systeme par la methode de Cholesky  (G = B.B^T).
#
#  MODE D'EMPLOI :
#   1. modifier les donnees dans le bloc "1. DONNEES"
#   2. dans Maple, taper :   read "C:/projet/application_script.mpl";
#      (adapter le chemin, avec des / et pas des \ )
# =====================================================================

restart:
with(LinearAlgebra):
Digits := 15:

# ---------------------------------------------------------------------
# 1. DONNEES  (a modifier)
# ---------------------------------------------------------------------
mois   := [1, 2, 3, 4, 5, 6]:               # numeros des mois
dep    := [310, 335, 360, 372, 405, 421]:   # depenses en DH
degre  := 1:                                # 1 = droite, 2 = parabole, 3 = cubique
nbprev := 3:                                # nombre de mois a prevoir
budget := 450:                              # budget mensuel en DH (0 = pas de budget)

n := nops(mois):
if nops(dep) <> n then
  error "Il faut autant de mois que de depenses";
end if:
d1 := degre + 1:
if n < d1 then
  error "Il faut au moins %1 points pour le degre %2", d1, degre;
end if:

# ---------------------------------------------------------------------
# 2. SYSTEME NORMAL  G.a = r
# ---------------------------------------------------------------------
M := Matrix(n, d1):
for i from 1 to n do
  for j from 1 to d1 do
    M[i,j] := mois[i]^(j-1):
  end do:
end do:
G := Transpose(M) . M:
r := Transpose(M) . Vector(dep):

# ---------------------------------------------------------------------
# 3. METHODE DE CHOLESKY (etapes du prof)
# ---------------------------------------------------------------------
# Etape 2 : G doit etre symetrique definie positive (critere de Sylvester)
ok := Equal(G, Transpose(G)):
for m from 1 to d1 do
  if evalf(Determinant(G[1..m, 1..m])) <= 0 then
    ok := false:
  end if:
end do:
if not ok then
  error "La methode de Cholesky n'est pas applicable (G n'est pas definie positive)";
end if:

# Etape 3 : calcul de B
B := Matrix(d1, d1):
B[1,1] := sqrt(G[1,1]):
for i from 2 to d1 do
  B[i,1] := G[i,1] / B[1,1]:
end do:
for p from 2 to d1 do
  B[p,p] := sqrt(G[p,p] - add(B[p,k]^2, k=1..p-1)):
  for i from p+1 to d1 do
    B[i,p] := (G[i,p] - add(B[i,k]*B[p,k], k=1..p-1)) / B[p,p]:
  end do:
end do:

# Etape 5 : B.Y = r  (descente)
Y := Vector(d1):
for i from 1 to d1 do
  Y[i] := (r[i] - add(B[i,k]*Y[k], k=1..i-1)) / B[i,i]:
end do:

# Etape 6 : B^T.X = Y  (remontee) ; X contient les coefficients a0, a1, ...
X := Vector(d1):
for i from d1 to 1 by -1 do
  X[i] := (Y[i] - add(B[k,i]*X[k], k=i+1..d1)) / B[i,i]:
end do:

# ---------------------------------------------------------------------
# 4. MODELE ET QUALITE
# ---------------------------------------------------------------------
coef := map(simplify, X):
f := t -> add(coef[q+1]*t^q, q=0..degre):

yb  := add(dep[q], q=1..n) / n:
SSE := add((dep[q] - f(mois[q]))^2, q=1..n):
SST := add((dep[q] - yb)^2, q=1..n):
if SST = 0 then
  R2 := 1:
else
  R2 := 1 - SSE/SST:
end if:

# ---------------------------------------------------------------------
# 5. AFFICHAGE
# ---------------------------------------------------------------------
printf("\n==============================================\n"):
printf("  PREVISION DES DEPENSES - METHODE DE CHOLESKY\n"):
printf("==============================================\n"):
printf("Degre du modele : %d   (%d mois observes)\n", degre, n):

printf("\nSysteme normal  G.a = r :\n"):
print(G):
print(r):

printf("\nMatrice B de Cholesky (G = B.B^T) :\n"):
print(B):
printf("\nMatrice B^T :\n"):
print(Transpose(B)):

printf("\nDescente  B.Y = r :\n"):
print(Y):
printf("\nRemontee  B^T.X = Y  (coefficients du modele) :\n"):
print(coef):

printf("\nModele  y = a0 + a1*x + ... :\n"):
for u from 0 to degre do
  printf("   a%d = %.4f     (valeur exacte : %a)\n", u, evalf(coef[u+1]), coef[u+1]):
end do:
printf("\nQualite : R2 = %.5f    erreur moyenne (RMSE) = %.2f DH\n", evalf(R2), evalf(sqrt(SSE/n))):

printf("\nPrevisions :\n"):
for u from 1 to nbprev do
  xv := mois[n] + u:
  yv := evalf(f(xv)):
  if budget > 0 and yv > budget then
    printf("   mois %a : %.2f DH     <-- DEPASSEMENT du budget (%a DH)\n", xv, yv, budget):
  else
    printf("   mois %a : %.2f DH\n", xv, yv):
  end if:
end do:

# ---------------------------------------------------------------------
# 6. GRAPHIQUE : donnees, courbe ajustee, previsions, budget
# ---------------------------------------------------------------------
xmax  := evalf(max(op(mois)) + nbprev):
nuage := plots:-pointplot([seq([mois[q], dep[q]], q=1..n)],
                          symbol=solidcircle, symbolsize=15, color=red):
courbe := plot(evalf(f(t)), t = min(op(mois))..xmax, color=blue, thickness=2):
if nbprev > 0 then
  prev := plots:-pointplot([seq([mois[n]+q, evalf(f(mois[n]+q))], q=1..nbprev)],
                           symbol=solidbox, symbolsize=15, color=green):
else
  prev := NULL:
end if:
if budget > 0 then
  ligne := plot(budget, t = min(op(mois))..xmax, color=red, linestyle=dash):
else
  ligne := NULL:
end if:
plots:-display([nuage, courbe, prev, ligne],
               title="Depenses observees (rouge), modele (bleu), previsions (vert)",
               labels=["Mois", "Depenses (DH)"]);
