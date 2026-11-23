# ==============================================================================
#  ESISA - 3ème Année | PROJET D'ANALYSE NUMÉRIQUE
#  Fichier : cholesky_gui.mpl
#  Description : Interface Graphique Interactive (Maplet) pour le solveur Cholesky
#  Réalisé par : Hamza DADI & Mohammed SENHAJI
#  Sous l'encadrement de : Prof. Jaouad BENNOUNA
# ==============================================================================

with(LinearAlgebra):
with(Maplets[Elements]):
Digits := 15:

# ------------------------------------------------------------------------------
# Moteur de calcul Cholesky pour l'interface graphique
# ------------------------------------------------------------------------------
ResoudreCholeskyGUI := proc(strA, strB)
  local A, b, n, ok, m, det_m, det_val, B, Bt, Y, X, i, p, k, lignes;
  local residu, condA, lig_exact, lig_approx, j, msg_qual;

  # 1. Parsing et validation des champs
  try
    A := Matrix(parse(strA));
    b := Vector(parse(strB));
    n := RowDimension(A);
  catch:
    return sprintf("ERREUR DE SAISIE :\nVérifiez la syntaxe des crochets.\nExemple A : [[2,1,2],[1,3,2],[2,2,3]]\nExemple b : [sqrt(2), sqrt(2)/2, 3*sqrt(2)]");
  end try;

  if ColumnDimension(A) <> n then
    return "ERREUR : La matrice A doit être carrée !";
  end if;
  if Dimension(b) <> n then
    return sprintf("ERREUR : La dimension du vecteur b (%d) ne correspond pas à la taille de A (%d x %d) !", Dimension(b), n, n);
  end if;

  lignes := [
    "======================================================================",
    sprintf("   RÉSOLUTION PAR CHOLESKY : A.X = b (Dimension n = %d)", n),
    "======================================================================",
    ""
  ];

  # 2. Vérification de la symétrie
  if not Equal(A, Transpose(A)) then
    lignes := [op(lignes), 
      "Étape 2 : Test de symétrie : ÉCHEC",
      "--> La matrice A n'est pas symétrique (A <> A^T).",
      "--> La méthode de Cholesky n'est pas applicable."
    ];
    return StringTools:-Join(lignes, "\n");
  end if;

  # 3. Critère de Sylvester pas à pas
  lignes := [op(lignes), "Étape 2 : Vérification du critère de Sylvester (Mineurs dominants) :"];
  ok := true;
  for m from 1 to n do
    det_m := simplify(Determinant(A[1..m, 1..m]));
    det_val := evalf(det_m);
    lignes := [op(lignes), sprintf("   Mineur Delta_%d = %a  (~ %.4f)", m, det_m, det_val)];
    if det_val <= 0 then
      ok := false;
    end if;
  end do;

  if not ok then
    lignes := [op(lignes), 
      "",
      "RÉSULTAT DU TEST :",
      "--> Au moins un mineur principal est <= 0.",
      "--> La méthode de Cholesky n'est pas applicable."
    ];
    return StringTools:-Join(lignes, "\n");
  end if;
  lignes := [op(lignes), "--> Tous les mineurs dominants sont > 0 : A est Symétrique Définie Positive (SDP).", ""];

  # 4. Factorisation de Cholesky (A = B . B^T)
  B := Matrix(n, n, 0);
  B[1,1] := sqrt(A[1,1]);
  for i from 2 to n do
    B[i,1] := A[i,1] / B[1,1];
  end do;
  for p from 2 to n do
    B[p,p] := sqrt(A[p,p] - add(B[p,k]^2, k=1..p-1));
    for i from p+1 to n do
      B[i,p] := (A[i,p] - add(B[i,k]*B[p,k], k=1..p-1)) / B[p,p];
    end do;
  end do;
  Bt := Transpose(B);

  lignes := [op(lignes), "Étape 3 & 4 : Matrice triangulaire inférieure B :"];
  for i from 1 to n do
    lig_exact := [seq(sprintf("%a", simplify(B[i,j])), j=1..n)];
    lig_approx := [seq(sprintf("%8.4f", evalf(B[i,j])), j=1..n)];
    lignes := [op(lignes), sprintf("   Ligne %d : [ %s ]   ~   [ %s ]", i, StringTools:-Join(lig_exact, ", "), StringTools:-Join(lig_approx, " "))];
  end do;
  lignes := [op(lignes), ""];

  # 5. Descente B . Y = b
  Y := Vector(n);
  for i from 1 to n do
    Y[i] := (b[i] - add(B[i,k]*Y[k], k=1..i-1)) / B[i,i];
  end do;
  lignes := [op(lignes), "Étape 5 : Résolution de B.Y = b (Descente) :"];
  for i from 1 to n do
    lignes := [op(lignes), sprintf("   Y[%d] = %a   (~ %.4f)", i, simplify(Y[i]), evalf(Y[i]))];
  end do;
  lignes := [op(lignes), ""];

  # 6. Remontée B^T . X = Y
  X := Vector(n);
  for i from n by -1 to 1 do
    X[i] := (Y[i] - add(B[k,i]*X[k], k=i+1..n)) / B[i,i];
  end do;
  lignes := [op(lignes), "Étape 6 : Résolution de B^T.X = Y (Remontée - Solution finale) :"];
  for i from 1 to n do
    lignes := [op(lignes), sprintf("   X[%d] = %a   (~ %.4f)", i, simplify(X[i]), evalf(X[i]))];
  end do;
  lignes := [op(lignes), ""];

  # 7. Contrôle numérique (Résidu et Conditionnement)
  residu := evalf(Norm(Multiply(A, X) - b, 2));
  condA  := evalf(ConditionNumber(evalf(A), 2));
  
  if residu < 1e-10 then
    msg_qual := "   --> Solution exacte et ultra-précise !";
  else
    msg_qual := "   --> Solution approchée.";
  end if;

  lignes := [op(lignes), 
    "----------------------------------------------------------------------",
    "QUALITÉ ET STABILITÉ NUMÉRIQUE :",
    sprintf("   Norme du résidu ||A.X - b||_2 = %e", residu),
    sprintf("   Conditionnement cond_2(A)    = %.4f", condA),
    msg_qual
  ];

  return StringTools:-Join(lignes, "\n");
end proc:

# ------------------------------------------------------------------------------
# Fenêtre graphique interactive Maplet
# ------------------------------------------------------------------------------
appCholesky := Maplet(
  Window('title' = "ESISA 3A - Solveur Linéaire de Cholesky (Hamza DADI & Mohammed SENHAJI - Prof. Jaouad BENNOUNA)",
    [
      [ "Matrice A (format [[a11,a12,...],[a21,a22,...],...]) :" ],
      [ TextField['TFA']('value' = "[[2,1,2],[1,3,2],[2,2,3]]", 'width' = 75) ],
      
      [ "Second membre b (format [b1, b2, ...]) :" ],
      [ TextField['TFB']('value' = "[sqrt(2), sqrt(2)/2, 3*sqrt(2)]", 'width' = 75) ],
      
      [
        Button("Système 3x3", 
               Action(
                 SetOption('target' = 'TFA', 'value' = "[[2,1,2],[1,3,2],[2,2,3]]"),
                 SetOption('target' = 'TFB', 'value' = "[sqrt(2), sqrt(2)/2, 3*sqrt(2)]")
               )),
        Button("Système 4x4", 
               Action(
                 SetOption('target' = 'TFA', 'value' = "[[3,1,0,0],[1,3,1,0],[0,1,3,1],[0,0,1,3]]"),
                 SetOption('target' = 'TFB', 'value' = "[1, 0, 0, 0]")
               )),
        Button("Test non-SDP (Erreur)", 
               Action(
                 SetOption('target' = 'TFA', 'value' = "[[1,2],[2,1]]"),
                 SetOption('target' = 'TFB', 'value' = "[1, 1]")
               ))
      ],
      
      [
        Button(">>> RÉSOUDRE (Cholesky) <<<", 
               Action(Evaluate('TBOUT' = 'ResoudreCholeskyGUI(TFA, TFB)'))),
        Button("Quitter", Shutdown())
      ],
      
      [ "Détails de l'exécution et résultats (Étapes 1 à 6) :" ],
      [ TextBox['TBOUT']('editable' = false, 'width' = 85, 'height' = 24) ]
    ]
  )
):

Maplets[Display](appCholesky);
