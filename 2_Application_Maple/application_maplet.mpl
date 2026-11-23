# =====================================================================
#  APPLICATION AVEC INTERFACE (Maplet) : PREVISION DES DEPENSES
#  Methode de Cholesky (algorithme du prof) + moindres carres
#
#  Une fenetre s'ouvre : on saisit les mois, les depenses, le degre du
#  modele, le nombre de mois a prevoir et le budget. Le bouton "Calculer"
#  affiche la matrice B de Cholesky, les coefficients, la qualite du
#  modele, les previsions (avec alerte de depassement) et le graphique.
#
#  MODE D'EMPLOI (Maple version bureau, interface Standard) :
#      read "C:/projet/application_maplet.mpl";
#  (adapter le chemin, avec des / et pas des \ )
#  Utiliser le POINT pour les decimaux (3.5).
# =====================================================================

restart:
with(LinearAlgebra):
Digits := 15:

# ---------------------------------------------------------------------
# METHODE DE CHOLESKY (algorithme du prof) : resout A x = c
# Retourne [B, Y, X] ou FAIL si A n'est pas symetrique definie positive
# ---------------------------------------------------------------------
CholeskyProf := proc(A, c)
  local n, B, Y, X, i, p, k, m, ok;
  n := RowDimension(A);
  # Etape 2 : A symetrique definie positive ? (critere de Sylvester)
  ok := Equal(A, Transpose(A));
  for m from 1 to n do
    if evalf(Determinant(A[1..m, 1..m])) <= 0 then ok := false; end if;
  end do;
  if not ok then return FAIL; end if;
  # Etape 3 : calcul de B
  B := Matrix(n, n);
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
  # Etape 5 : B Y = c (descente)
  Y := Vector(n);
  for i from 1 to n do
    Y[i] := (c[i] - add(B[i,k]*Y[k], k=1..i-1)) / B[i,i];
  end do;
  # Etape 6 : B^T X = Y (remontee)
  X := Vector(n);
  for i from n to 1 by -1 do
    X[i] := (Y[i] - add(B[k,i]*X[k], k=i+1..n)) / B[i,i];
  end do;
  return [B, Y, X];
end proc:

# ---------------------------------------------------------------------
# MOINDRES CARRES : systeme normal G.a = r puis Cholesky
# ---------------------------------------------------------------------
Systeme := proc(xs, ys, deg)
  local n, M, i, j;
  n := nops(xs);
  M := Matrix(n, deg+1);
  for i from 1 to n do
    for j from 1 to deg+1 do
      M[i,j] := xs[i]^(j-1);
    end do;
  end do;
  return [Transpose(M) . M, Transpose(M) . Vector(ys)];
end proc:

# Retourne [coefficients, B, G]
Modele := proc(xs, ys, deg)
  local n, S, res;
  n := nops(xs);
  if nops(ys) <> n then
    error "Il faut autant de mois que de depenses";
  end if;
  if n < deg + 1 then
    error "Il faut au moins %1 points pour le degre %2", deg+1, deg;
  end if;
  S := Systeme(xs, ys, deg);
  res := CholeskyProf(S[1], S[2]);
  if res = FAIL then
    error "Cholesky non applicable : G n'est pas definie positive (donnees degenerees ?)";
  end if;
  return [map(simplify, res[3]), res[1], S[1]];
end proc:

# Valeur du polynome de coefficients coef en t
Poly := proc(coef, t)
  local q;
  add(coef[q+1]*t^q, q=0..Dimension(coef)-1);
end proc:

# ---------------------------------------------------------------------
# LECTURE DES CHAMPS DE LA FENETRE (textes -> nombres)
# ---------------------------------------------------------------------
LireListe := proc(s)
  local L;
  L := parse(sprintf("[%s]", s));
  if not type(L, list(realcons)) or nops(L) = 0 then
    error "Liste invalide : %1", s;
  end if;
  return L;
end proc:

LireEntier := proc(s)
  local v;
  v := parse(sprintf("%s", s));
  if not type(v, nonnegint) then
    error "Entier positif attendu : %1", s;
  end if;
  return v;
end proc:

LireReel := proc(s)
  local v;
  v := parse(sprintf("%s", s));
  if not type(v, realcons) then
    error "Nombre attendu : %1", s;
  end if;
  return v;
end proc:

# Matrice -> texte
MatriceEnTexte := proc(M)
  local i, j, lignes, cases;
  lignes := [];
  for i from 1 to RowDimension(M) do
    cases := [seq(sprintf("%12.5f", evalf(M[i,j])), j=1..ColumnDimension(M))];
    lignes := [op(lignes), StringTools:-Join(cases, " ")];
  end do;
  return StringTools:-Join(lignes, "\n");
end proc:

# ---------------------------------------------------------------------
# TEXTE DES RESULTATS
# ---------------------------------------------------------------------
Calculer := proc(sx, sy, sd, sn, sb)
  local xs, ys, deg, nb, bud, res, coef, B, n, yb, SSE, SST, R2, lignes, u, xv, yv, q;
  try
    xs  := LireListe(sx);
    ys  := LireListe(sy);
    deg := LireEntier(sd);
    nb  := LireEntier(sn);
    bud := LireReel(sb);
    res := Modele(xs, ys, deg);
  catch:
    return sprintf("Erreur : %s", StringTools:-FormatMessage(lastexception[2..-1]));
  end try;
  coef := res[1];
  B := res[2];
  n := nops(xs);
  yb  := add(ys[q], q=1..n) / n;
  SSE := add((ys[q] - Poly(coef, xs[q]))^2, q=1..n);
  SST := add((ys[q] - yb)^2, q=1..n);
  if SST = 0 then R2 := 1; else R2 := 1 - SSE/SST; end if;
  lignes := [
    "Matrice B de Cholesky (G = B . B^T) :",
    MatriceEnTexte(B),
    "",
    "Coefficients du modele  y = a0 + a1*x + ... :",
    seq(sprintf("   a%d = %.4f", u, evalf(coef[u+1])), u=0..deg),
    "",
    sprintf("Qualite : R2 = %.5f    RMSE = %.2f DH", evalf(R2), evalf(sqrt(SSE/n))),
    "",
    "Previsions :"
  ];
  for u from 1 to nb do
    xv := xs[n] + u;
    yv := evalf(Poly(coef, xv));
    if bud > 0 and yv > bud then
      lignes := [op(lignes), sprintf("   mois %.0f : %.2f DH    <-- DEPASSEMENT du budget", evalf(xv), yv)];
    else
      lignes := [op(lignes), sprintf("   mois %.0f : %.2f DH", evalf(xv), yv)];
    end if;
  end do;
  return StringTools:-Join(lignes, "\n");
end proc:

# ---------------------------------------------------------------------
# GRAPHIQUE
# ---------------------------------------------------------------------
Graphe := proc(sx, sy, sd, sn, sb)
  local xs, ys, deg, nb, bud, res, coef, n, t, xmin, xmax, nuage, courbe, prev, ligne, u;
  try
    xs  := LireListe(sx);
    ys  := LireListe(sy);
    deg := LireEntier(sd);
    nb  := LireEntier(sn);
    bud := LireReel(sb);
    res := Modele(xs, ys, deg);
    coef := res[1];
    n := nops(xs);
    xmin := min(op(evalf(xs)));
    xmax := max(op(evalf(xs))) + nb;
    nuage := plots:-pointplot([seq([evalf(xs[u]), evalf(ys[u])], u=1..n)],
                              symbol=solidcircle, symbolsize=15, color=red);
    courbe := plot(evalf(Poly(coef, t)), t = xmin..xmax, color=blue, thickness=2);
    if nb > 0 then
      prev := plots:-pointplot([seq([evalf(xs[n]+u), evalf(Poly(coef, xs[n]+u))], u=1..nb)],
                               symbol=solidbox, symbolsize=15, color=green);
    else
      prev := NULL;
    end if;
    if bud > 0 then
      ligne := plot(evalf(bud), t = xmin..xmax, color=red, linestyle=dash);
    else
      ligne := NULL;
    end if;
    return plots:-display([nuage, courbe, prev, ligne],
                          title="Depenses (rouge), modele (bleu), previsions (vert)",
                          labels=["Mois", "Depenses (DH)"]);
  catch:
    return plot(0, t=0..1);
  end try;
end proc:

# ---------------------------------------------------------------------
# TEST SANS FENETRE (meme logique que l'interface)
# ---------------------------------------------------------------------
printf("%s\n", Calculer("1,2,3,4,5,6", "310,335,360,372,405,421", "1", "3", "450"));

# ---------------------------------------------------------------------
# FENETRE
# ---------------------------------------------------------------------
with(Maplets[Elements]):

app := Maplet(
  Window('title' = "Previsions de depenses - methode de Cholesky",
    [
      [ "Mois (x) :",
        TextField['TFX']('value' = "1,2,3,4,5,6", 'width' = 30) ],
      [ "Depenses en DH (y) :",
        TextField['TFY']('value' = "310,335,360,372,405,421", 'width' = 30) ],
      [ "Degre du modele (1, 2 ou 3) :",
        TextField['TFD']('value' = "1", 'width' = 5) ],
      [ "Mois a prevoir :",
        TextField['TFN']('value' = "3", 'width' = 5) ],
      [ "Budget mensuel en DH (0 = aucun) :",
        TextField['TFB']('value' = "450", 'width' = 10) ],
      [ Button("Calculer",
               Action(
                 Evaluate('TBR' = 'Calculer(TFX, TFY, TFD, TFN, TFB)'),
                 Evaluate('PL'  = 'Graphe(TFX, TFY, TFD, TFN, TFB)')
               )),
        Button("Quitter", Shutdown()) ],
      [ TextBox['TBR']('editable' = false, 'width' = 60, 'height' = 18) ],
      [ Plotter['PL']('width' = 480, 'height' = 320) ]
    ]
  )
):

Maplets[Display](app);
