# ==============================================================================
#  ESISA - 3ème Année | PROJET D'ANALYSE NUMÉRIQUE
#  Fichier : cholesky_script.mpl
#  Description : Algorithme classique de Cholesky A.X = b étape par étape
#  Réalisé par : Hamza DADI & Mohammed SENHAJI
#  Sous l'encadrement de : Prof. Jaouad BENNOUNA
#  Année universitaire : 2026 / 2027
# ==============================================================================

with(LinearAlgebra):

# ##############################################################################
#  EXERCICE 1 : SYSTEME LINEAIRE 3x3
# ##############################################################################

printf("======================================================================\n");
printf("  EXERCICE 1 : SYSTEME LINEAIRE 3x3 (A.X = b)\n");
printf("======================================================================\n");

# ------------------------------------------------------------------------------
# Étape 1 : Entrer les a_ij et les b_i
# ------------------------------------------------------------------------------
A1 := Matrix([[2, 1, 2],
              [1, 3, 2],
              [2, 2, 3]]):

b1 := Vector([sqrt(2), sqrt(2)/2, 3*sqrt(2)]):
n1 := RowDimension(A1):

printf("\nEtape 1 : Saisie de la matrice A et du vecteur b\n");
printf("Matrice A1 (taille %d x %d) :\n", n1, n1);
print(A1);
printf("Second membre b1 :\n");
print(b1);

# ------------------------------------------------------------------------------
# Étape 2 : Vérifier que A est symétrique définie positive
# (Critère de Sylvester : tous les mineurs principaux Delta_m doivent être > 0)
# ------------------------------------------------------------------------------
printf("\nEtape 2 : Verification du critere de Sylvester\n");
ok1 := Equal(A1, Transpose(A1)):
for m from 1 to n1 do
  det_m := simplify(Determinant(A1[1..m, 1..m])):
  printf("  Delta_%d = %a\n", m, det_m);
  if evalf(det_m) <= 0 then
    ok1 := false:
  end if:
end do:

if not ok1 then
  printf("\nLa methode de Cholesky n'est pas applicable\n");
else
  # ----------------------------------------------------------------------------
  # Étape 3 : Calcul de la matrice triangulaire inférieure B (A = B . B^T)
  # ----------------------------------------------------------------------------
  B1 := Matrix(n1, n1, 0):
  
  # Terme b_11 et première colonne
  B1[1,1] := sqrt(A1[1,1]):
  for i from 2 to n1 do
    B1[i,1] := A1[i,1] / B1[1,1]:
  end do:
  
  # Colonnes p de 2 à n
  for p from 2 to n1 do
    B1[p,p] := sqrt(A1[p,p] - add(B1[p,k]^2, k=1..p-1)):
    for i from p+1 to n1 do
      B1[i,p] := (A1[i,p] - add(B1[i,k]*B1[p,k], k=1..p-1)) / B1[p,p]:
    end do:
  end do:

  # ----------------------------------------------------------------------------
  # Étape 4 : Afficher B et B^T
  # ----------------------------------------------------------------------------
  printf("\nEtape 4 : Affichage des matrices triangulaires B et B^T\n");
  printf("Matrice B (forme exacte avec radicaux) =\n");
  print(map(simplify, B1));
  printf("Matrice B (valeurs approchees) =\n");
  print(evalf(B1));
  printf("Matrice B^T (transposee exacte) =\n");
  print(map(simplify, Transpose(B1)));

  # ----------------------------------------------------------------------------
  # Étape 5 : Résoudre B Y = b (Descente), afficher Y
  # ----------------------------------------------------------------------------
  Y1 := Vector(n1):
  for i from 1 to n1 do
    Y1[i] := (b1[i] - add(B1[i,k]*Y1[k], k=1..i-1)) / B1[i,i]:
  end do:

  printf("\nEtape 5 : Solution intermediaire Y (Descente B.Y = b)\n");
  printf("Vecteur Y (forme exacte) =\n");
  print(map(simplify, Y1));
  printf("Vecteur Y (valeurs approchees) =\n");
  print(evalf(Y1));

  # ----------------------------------------------------------------------------
  # Étape 6 : Résoudre B^T X = Y (Remontée), afficher X
  # ----------------------------------------------------------------------------
  X1 := Vector(n1):
  for i from n1 by -1 to 1 do
    X1[i] := (Y1[i] - add(B1[k,i]*X1[k], k=i+1..n1)) / B1[i,i]:
  end do:

  printf("\nEtape 6 : Solution finale X (Remontee B^T.X = Y)\n");
  printf("Vecteur X (forme exacte) =\n");
  print(map(simplify, X1));
  printf("Vecteur X (valeurs approchees) =\n");
  print(evalf(X1));

  # ----------------------------------------------------------------------------
  # Contrôle de précision et vérification du résidu
  # ----------------------------------------------------------------------------
  printf("\nControle de precision numrique :\n");
  residu1 := evalf(Norm(Multiply(A1, X1) - b1, 2)):
  printf("Norme euclidienne du residu ||A1.X1 - b1||_2 = %e\n", residu1);
  if residu1 < 1e-10 then
    printf("--> Solution exacte et ultra-precise verifiee !\n");
  end if;
end if:


# ##############################################################################
#  EXERCICE 2 : SYSTEME TRIDIAGONAL 4x4
# ##############################################################################

printf("\n======================================================================\n");
printf("  EXERCICE 2 : SYSTEME 4x4 TRIDIAGONAL (A.X = b)\n");
printf("======================================================================\n");

# ------------------------------------------------------------------------------
# Étape 1 : Saisie de la matrice A et du second membre b (Cas 4x4)
# ------------------------------------------------------------------------------
A2 := Matrix([[3, 1, 0, 0],
              [1, 3, 1, 0],
              [0, 1, 3, 1],
              [0, 0, 1, 3]]):

b2 := Vector([1, 0, 0, 0]):
n2 := RowDimension(A2):

printf("\nEtape 1 : Saisie de la matrice A et du vecteur b\n");
printf("Matrice A2 (taille %d x %d) :\n", n2, n2);
print(A2);
printf("Second membre b2 :\n");
print(b2);

# ------------------------------------------------------------------------------
# Étape 2 : Vérifier que A est symétrique définie positive
# (Critère de Sylvester : tous les mineurs principaux Delta_m doivent être > 0)
# ------------------------------------------------------------------------------
printf("\nEtape 2 : Verification du critere de Sylvester\n");
ok2 := Equal(A2, Transpose(A2)):
for m from 1 to n2 do
  det_m := simplify(Determinant(A2[1..m, 1..m])):
  printf("  Delta_%d = %a\n", m, det_m);
  if evalf(det_m) <= 0 then
    ok2 := false:
  end if:
end do:

if not ok2 then
  printf("\nLa methode de Cholesky n'est pas applicable\n");
else
  # ----------------------------------------------------------------------------
  # Étape 3 : Calcul de la matrice triangulaire inférieure B (A = B . B^T)
  # ----------------------------------------------------------------------------
  B2 := Matrix(n2, n2, 0):
  
  # Terme b_11 et première colonne
  B2[1,1] := sqrt(A2[1,1]):
  for i from 2 to n2 do
    B2[i,1] := A2[i,1] / B2[1,1]:
  end do:
  
  # Colonnes p de 2 à n
  for p from 2 to n2 do
    B2[p,p] := sqrt(A2[p,p] - add(B2[p,k]^2, k=1..p-1)):
    for i from p+1 to n2 do
      B2[i,p] := (A2[i,p] - add(B2[i,k]*B2[p,k], k=1..p-1)) / B2[p,p]:
    end do:
  end do:

  # ----------------------------------------------------------------------------
  # Étape 4 : Afficher B et B^T
  # ----------------------------------------------------------------------------
  printf("\nEtape 4 : Affichage des matrices triangulaires B et B^T\n");
  printf("Matrice B (forme exacte avec radicaux) =\n");
  print(map(simplify, B2));
  printf("Matrice B (valeurs approchees) =\n");
  print(evalf(B2));
  printf("Matrice B^T (transposee exacte) =\n");
  print(map(simplify, Transpose(B2)));

  # ----------------------------------------------------------------------------
  # Étape 5 : Résoudre B Y = b (Descente), afficher Y
  # ----------------------------------------------------------------------------
  Y2 := Vector(n2):
  for i from 1 to n2 do
    Y2[i] := (b2[i] - add(B2[i,k]*Y2[k], k=1..i-1)) / B2[i,i]:
  end do:

  printf("\nEtape 5 : Solution intermediaire Y (Descente B.Y = b)\n");
  printf("Vecteur Y (forme exacte) =\n");
  print(map(simplify, Y2));
  printf("Vecteur Y (valeurs approchees) =\n");
  print(evalf(Y2));

  # ----------------------------------------------------------------------------
  # Étape 6 : Résoudre B^T X = Y (Remontée), afficher X
  # ----------------------------------------------------------------------------
  X2 := Vector(n2):
  for i from n2 by -1 to 1 do
    X2[i] := (Y2[i] - add(B2[k,i]*X2[k], k=i+1..n2)) / B2[i,i]:
  end do:

  printf("\nEtape 6 : Solution finale X (Remontee B^T.X = Y)\n");
  printf("Vecteur X (forme fractionnaire exacte) =\n");
  print(map(simplify, X2));
  printf("Vecteur X (valeurs approchees) =\n");
  print(evalf(X2));

  printf("\nDetails des composantes de la solution X :\n");
  printf("  X[1] = %a  (valeur approchee : %.6f)\n", simplify(X2[1]), evalf(X2[1]));
  printf("  X[2] = %a  (valeur approchee : %.6f)\n", simplify(X2[2]), evalf(X2[2]));
  printf("  X[3] = %a  (valeur approchee : %.6f)\n", simplify(X2[3]), evalf(X2[3]));
  printf("  X[4] = %a  (valeur approchee : %.6f)\n", simplify(X2[4]), evalf(X2[4]));

  # ----------------------------------------------------------------------------
  # Contrôle de précision et vérification du résidu
  # ----------------------------------------------------------------------------
  printf("\nControle de precision numerique :\n");
  residu2 := evalf(Norm(Multiply(A2, X2) - b2, 2)):
  printf("Norme euclidienne du residu ||A2.X2 - b2||_2 = %e\n", residu2);
  if residu2 < 1e-10 then
    printf("--> Solution exacte et ultra-precise verifiee avec succes !\n");
  end if;
end if:
