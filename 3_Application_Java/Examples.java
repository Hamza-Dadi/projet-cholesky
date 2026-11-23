package esisa.cholesky;

import javax.swing.*;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.DecimalFormat;

/**
 * =============================================================================
 * ESISA - 3ème Année | PROJET D'ANALYSE NUMÉRIQUE & POO JAVA
 * Sujet : Méthode de Cholesky (A = B . B^T) et Résolution de A.x = b
 * Réalisé par : Hamza DADI & Mohammed SENHAJI
 * Sous l'encadrement de : Prof. Jaouad BENNOUNA
 * Conforme aux règles & conventions de programmation ESISA 3A.
 * =============================================================================
 */
public class Examples {

    public Examples() {
        // Démonstration console des méthodes
        exp01(); // 1. Résolution du système 3x3 (mode console)
        exp02(); // 2. Test avec matrice non-SDP (mode console)
        exp04(); // 3. Résolution du système tridiagonal 4x4 (mode console)
        exp03(); // 4. Lancement de l'interface graphique Swing
    }

    // 1. Résolution console du système 3x3
    void exp01() {
        System.out.println("=======================================================");
        System.out.println("  EXP01 : Résolution du système linéaire 3x3");
        System.out.println("=======================================================");

        // 1. On demande de créer la matrice A et le second membre b .
        double A[][] = {
            {2.0, 1.0, 2.0},
            {1.0, 3.0, 2.0},
            {2.0, 2.0, 3.0}
        };

        double sqrt2 = Math.sqrt(2.0);
        double b[] = {
            sqrt2,
            sqrt2 / 2.0,
            3.0 * sqrt2
        };

        // 2. Résolution complète par Cholesky .
        CholeskyResult res = CholeskyCore.solve(A, b);

        if (!res.applicable) {
            System.out.println(res.message);
        } else {
            System.out.println(res.formatDetails(A, b));
        }
    }

    // 2. Test de détection de matrice non définie positive
    void exp02() {
        System.out.println("=======================================================");
        System.out.println("  EXP02 : Test d'une matrice non définie positive");
        System.out.println("=======================================================");

        // 1. Matrice non-SDP : det = 1 - 4 = -3 < 0
        double A[][] = {
            {1.0, 2.0},
            {2.0, 1.0}
        };
        double b[] = {1.0, 1.0};

        CholeskyResult res = CholeskyCore.solve(A, b);
        System.out.println("Résultat du test : " + res.message);
    }

    // 3. Lancement de l'interface graphique interactive Swing
    
    // 3. Résolution console du système tridiagonal 4x4
    void exp04() {
        System.out.println("=======================================================");
        System.out.println("  EXP04 : Résolution du système tridiagonal 4x4");
        System.out.println("=======================================================");

        // 1. Définition de la matrice A (4x4) et du second membre b .
        double A[][] = {
            {3.0, 1.0, 0.0, 0.0},
            {1.0, 3.0, 1.0, 0.0},
            {0.0, 1.0, 3.0, 1.0},
            {0.0, 0.0, 1.0, 3.0}
        };

        double b[] = { 1.0, 0.0, 0.0, 0.0 };

        // 2. Résolution complète par Cholesky .
        CholeskyResult res = CholeskyCore.solve(A, b);

        if (!res.applicable) {
            System.out.println(res.message);
        } else {
            System.out.println(res.formatDetails(A, b));
            System.out.println("Formes fractionnaires exactes de la solution X :");
            System.out.printf("   X[1] = %.6f  (21/55)%n", res.X[0]);
            System.out.printf("   X[2] = %.6f  (-8/55)%n", res.X[1]);
            System.out.printf("   X[3] = %.6f  ( 3/55)%n", res.X[2]);
            System.out.printf("   X[4] = %.6f  (-1/55)%n", res.X[3]);
        }
    }

    void exp03() {
        if (GraphicsEnvironment.isHeadless()) {
            System.out.println("Mode console détecté (Headless) : l'interface graphique Swing ne peut pas être affichée.");
            return;
        }
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                try {
                    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
                } catch (Exception e) {
                    // Look and feel par défaut si non disponible
                }
                CholeskyGUI frame = new CholeskyGUI();
                frame.setVisible(true);
            }
        });
    }

    public static void main(String args[]) {
        new Examples();
    }
}

/**
 * Moteur algorithmique de calcul de Cholesky
 */
class CholeskyCore {

    // Calcul du déterminant d'une sous-matrice carrée (m x m) par élimination de Gauss
    static double determinant(double mat[][], int m) {
        double temp[][] = new double[m][m];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < m; j++) {
                temp[i][j] = mat[i][j];
            }
        }
        double det = 1.0;
        for (int i = 0; i < m; i++) {
            int pivot = i;
            for (int j = i + 1; j < m; j++) {
                if (Math.abs(temp[j][i]) > Math.abs(temp[pivot][i])) {
                    pivot = j;
                }
            }
            if (Math.abs(temp[pivot][i]) < 1e-12) {
                return 0.0;
            }
            if (pivot != i) {
                double swap[] = temp[i];
                temp[i] = temp[pivot];
                temp[pivot] = swap;
                det = -det;
            }
            det *= temp[i][i];
            for (int j = i + 1; j < m; j++) {
                double factor = temp[j][i] / temp[i][i];
                for (int k = i + 1; k < m; k++) {
                    temp[j][k] -= factor * temp[i][k];
                }
            }
        }
        return det;
    }

    // Résolution complète selon les 6 étapes du professeur
    public static CholeskyResult solve(double A[][], double b[]) {
        int n = A.length;
        CholeskyResult res = new CholeskyResult();
        res.n = n;
        res.delta = new double[n];

        // Étape 2 : Vérifier si A est symétrique
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (Math.abs(A[i][j] - A[j][i]) > 1e-8) {
                    res.applicable = false;
                    res.message = "la méthode de Cholesky n'est pas applicable (A n'est pas symétrique)";
                    return res;
                }
            }
        }

        // Étape 2 : Vérifier si A est définie positive (Critère de Sylvester)
        for (int m = 1; m <= n; m++) {
            res.delta[m - 1] = determinant(A, m);
            if (res.delta[m - 1] <= 1e-12) {
                res.applicable = false;
                res.message = "la méthode de Cholesky n'est pas applicable (mineur principal Delta_" + m + " <= 0)";
                return res;
            }
        }

        // Étape 3 : Calcul de la matrice triangulaire inférieure B
        double B[][] = new double[n][n];

        // b_11 = sqrt(a_11)
        B[0][0] = Math.sqrt(A[0][0]);

        // Première colonne : b_i1 = a_i1 / b_11
        for (int i = 1; i < n; i++) {
            B[i][0] = A[i][0] / B[0][0];
        }

        // Colonnes suivantes p de 1 à n-1 (indices 0 à n-1)
        for (int p = 1; p < n; p++) {
            double sumDiag = 0.0;
            for (int k = 0; k < p; k++) {
                sumDiag += B[p][k] * B[p][k];
            }
            double val = A[p][p] - sumDiag;
            if (val <= 1e-12) {
                res.applicable = false;
                res.message = "la méthode de Cholesky n'est pas applicable (pivot négatif ou nul sous la racine)";
                return res;
            }
            B[p][p] = Math.sqrt(val);

            for (int i = p + 1; i < n; i++) {
                double sumIp = 0.0;
                for (int k = 0; k < p; k++) {
                    sumIp += B[i][k] * B[p][k];
                }
                B[i][p] = (A[i][p] - sumIp) / B[p][p];
            }
        }
        res.B = B;

        // Étape 5 : Résoudre B Y = b (Descente)
        double Y[] = new double[n];
        for (int i = 0; i < n; i++) {
            double sumY = 0.0;
            for (int k = 0; k < i; k++) {
                sumY += B[i][k] * Y[k];
            }
            Y[i] = (b[i] - sumY) / B[i][i];
        }
        res.Y = Y;

        // Étape 6 : Résoudre B^T X = Y (Remontée)
        double X[] = new double[n];
        for (int i = n - 1; i >= 0; i--) {
            double sumX = 0.0;
            for (int k = i + 1; k < n; k++) {
                sumX += B[k][i] * X[k]; // B[k][i] correspond à (B^T)[i][k]
            }
            X[i] = (Y[i] - sumX) / B[i][i];
        }
        res.X = X;

        // Calcul de la précision : résidu R = A X - b et sa norme euclidienne
        double sumSqRes = 0.0;
        for (int i = 0; i < n; i++) {
            double ax_i = 0.0;
            for (int j = 0; j < n; j++) {
                ax_i += A[i][j] * X[j];
            }
            double diff = ax_i - b[i];
            sumSqRes += diff * diff;
        }
        res.residualNorm = Math.sqrt(sumSqRes);
        res.applicable = true;
        res.message = "Succès";

        return res;
    }
}

/**
 * Structure contenant les résultats intermédiaires et finaux
 */
class CholeskyResult {
    int n;
    boolean applicable;
    String message;
    double delta[];
    double B[][];
    double Y[];
    double X[];
    double residualNorm;

    public String formatDetails(double A[][], double b[]) {
        StringBuilder sb = new StringBuilder();
        DecimalFormat df = new DecimalFormat("0.0000");
        DecimalFormat sci = new DecimalFormat("0.000E0");

        sb.append("======================================================================\n");
        sb.append("         RÉSULTATS DÉTAILLÉS DE LA MÉTHODE DE CHOLESKY\n");
        sb.append("======================================================================\n\n");

        sb.append("Étape 2 : Critère de Sylvester (Mineurs principaux dominants) :\n");
        for (int m = 1; m <= n; m++) {
            sb.append("   Delta_").append(m).append(" = ").append(df.format(delta[m - 1]))
              .append(delta[m - 1] > 0 ? " > 0 (OK)\n" : " <= 0 (ÉCHEC)\n");
        }
        sb.append("--> Matrice A bien symétrique définie positive.\n\n");

        sb.append("Étape 4 : Matrice triangulaire inférieure B (A = B . B^T) :\n");
        for (int i = 0; i < n; i++) {
            sb.append("   [ ");
            for (int j = 0; j < n; j++) {
                sb.append(String.format("%10s", df.format(B[i][j]))).append(" ");
            }
            sb.append(" ]\n");
        }
        sb.append("\nMatrice transposée B^T :\n");
        for (int i = 0; i < n; i++) {
            sb.append("   [ ");
            for (int j = 0; j < n; j++) {
                sb.append(String.format("%10s", df.format(B[j][i]))).append(" ");
            }
            sb.append(" ]\n");
        }

        sb.append("\nÉtape 5 : Résolution du système triangulaire inférieur B . Y = b (Descente) :\n");
        for (int i = 0; i < n; i++) {
            sb.append("   Y[").append(i + 1).append("] = ").append(df.format(Y[i])).append("\n");
        }

        sb.append("\nÉtape 6 : Résolution du système triangulaire supérieur B^T . X = Y (Remontée) :\n");
        for (int i = 0; i < n; i++) {
            sb.append("   X[").append(i + 1).append("] = ").append(df.format(X[i])).append("\n");
        }

        sb.append("\n----------------------------------------------------------------------\n");
        sb.append("Contrôle de précision numérique :\n");
        sb.append("   Norme du résidu ||A.X - b||_2 = ").append(sci.format(residualNorm)).append("\n");
        sb.append("   Précision : ").append(residualNorm < 1e-10 ? "Excellente (< 10^-10)" : "Standard").append("\n");

        sb.append("\nVérification ligne par ligne A.X vs b :\n");
        for (int i = 0; i < n; i++) {
            double ax_i = 0.0;
            for (int j = 0; j < n; j++) {
                ax_i += A[i][j] * X[j];
            }
            sb.append("   Ligne ").append(i + 1).append(" : A*X = ").append(df.format(ax_i))
              .append("  |  b = ").append(df.format(b[i]))
              .append("  |  Écart = ").append(sci.format(Math.abs(ax_i - b[i]))).append("\n");
        }

        return sb.toString();
    }
}

/**
 * Interface graphique Swing complète et interactive
 */
class CholeskyGUI extends JFrame {

    private JSpinner spinN;
    private JTable tableA;
    private JTable tableB;
    private DefaultTableModel modelA;
    private DefaultTableModel modelB;
    private JTextArea textOutput;

    public CholeskyGUI() {
        setTitle("ESISA 3A - Solveur Linéaire de Cholesky (Hamza DADI & Mohammed SENHAJI - Prof. Jaouad BENNOUNA)");
        setSize(950, 720);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        initUI();
        chargerExempleCours();
    }

    private void initUI() {
        setLayout(new BorderLayout(10, 10));

        // Panneau supérieur : Configuration et presets
        JPanel topPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 12, 10));
        topPanel.setBorder(BorderFactory.createTitledBorder("1. Configuration du Système"));

        topPanel.add(new JLabel("Dimension n :"));
        spinN = new JSpinner(new SpinnerNumberModel(3, 2, 8, 1));
        topPanel.add(spinN);

        JButton btnResize = new JButton("Changer dimension");
        topPanel.add(btnResize);

        // Boutons de chargement rapide (Presets)
        JButton btnExCours = new JButton("Système 3x3");
        JButton btnEx4x4 = new JButton("Système 4x4");
        JButton btnNonSDP = new JButton("Cas non-SDP");

        topPanel.add(new JSeparator(SwingConstants.VERTICAL));
        topPanel.add(btnExCours);
        topPanel.add(btnEx4x4);
        topPanel.add(btnNonSDP);

        add(topPanel, BorderLayout.NORTH);

        // Panneau central : Tables pour A et b
        JPanel centerPanel = new JPanel(new GridLayout(1, 2, 15, 0));
        centerPanel.setBorder(BorderFactory.createEmptyBorder(0, 10, 0, 10));

        // Matrice A
        JPanel panelA = new JPanel(new BorderLayout(5, 5));
        panelA.setBorder(BorderFactory.createTitledBorder("Matrice A (symétrique définie positive)"));
        tableA = new JTable();
        tableA.setRowHeight(28);
        panelA.add(new JScrollPane(tableA), BorderLayout.CENTER);
        centerPanel.add(panelA);

        // Second membre b
        JPanel panelB = new JPanel(new BorderLayout(5, 5));
        panelB.setBorder(BorderFactory.createTitledBorder("Second membre b"));
        tableB = new JTable();
        tableB.setRowHeight(28);
        panelB.add(new JScrollPane(tableB), BorderLayout.CENTER);
        centerPanel.add(panelB);

        // Panneau du bouton de résolution et résultats
        JPanel mainCenter = new JPanel(new BorderLayout(10, 10));
        mainCenter.add(centerPanel, BorderLayout.NORTH);
        centerPanel.setPreferredSize(new Dimension(900, 200));

        // Bouton de calcul
        JButton btnResoudre = new JButton(">>> RÉSOUDRE LE SYSTÈME PAR CHOLESKY <<<");
        btnResoudre.setFont(new Font("Arial", Font.BOLD, 15));
        btnResoudre.setBackground(new Color(24, 116, 205));
        btnResoudre.setForeground(Color.WHITE);
        btnResoudre.setFocusPainted(false);
        btnResoudre.setPreferredSize(new Dimension(900, 42));

        JPanel panelBtn = new JPanel(new FlowLayout(FlowLayout.CENTER));
        panelBtn.add(btnResoudre);
        mainCenter.add(panelBtn, BorderLayout.CENTER);

        // Zone de sortie console
        textOutput = new JTextArea();
        textOutput.setFont(new Font("Consolas", Font.PLAIN, 13));
        textOutput.setEditable(false);
        textOutput.setBackground(new Color(248, 249, 250));
        JScrollPane scrollOut = new JScrollPane(textOutput);
        scrollOut.setBorder(BorderFactory.createTitledBorder("Détails d'exécution et solutions (Étapes 1 à 6)"));
        scrollOut.setPreferredSize(new Dimension(900, 360));
        mainCenter.add(scrollOut, BorderLayout.SOUTH);

        add(mainCenter, BorderLayout.CENTER);

        // Actions
        btnResize.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                int n = ((Integer) spinN.getValue()).intValue();
                creerGrilles(n);
            }
        });

        btnExCours.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                chargerExempleCours();
            }
        });

        btnEx4x4.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                chargerExemple4x4();
            }
        });

        btnNonSDP.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                chargerExempleNonSDP();
            }
        });

        btnResoudre.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                resoudreAction();
            }
        });
    }

    private void creerGrilles(int n) {
        String colsA[] = new String[n];
        for (int i = 0; i < n; i++) colsA[i] = "Col " + (i + 1);
        modelA = new DefaultTableModel(colsA, n);
        tableA.setModel(modelA);

        String colsB[] = {"b_i"};
        modelB = new DefaultTableModel(colsB, n);
        tableB.setModel(modelB);

        // Centrer les valeurs
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int i = 0; i < n; i++) {
            tableA.getColumnModel().getColumn(i).setCellRenderer(centerRenderer);
        }
        tableB.getColumnModel().getColumn(0).setCellRenderer(centerRenderer);
    }

    private void chargerExempleCours() {
        spinN.setValue(3);
        creerGrilles(3);

        double dataA[][] = {
            {2.0, 1.0, 2.0},
            {1.0, 3.0, 2.0},
            {2.0, 2.0, 3.0}
        };
        double sqrt2 = Math.sqrt(2.0);
        double dataB[] = {sqrt2, sqrt2 / 2.0, 3.0 * sqrt2};

        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                modelA.setValueAt(dataA[i][j], i, j);
            }
            modelB.setValueAt(dataB[i], i, 0);
        }
        textOutput.setText("Exemple du cours chargé (3x3). Cliquez sur 'RÉSOUDRE'.");
    }

    private void chargerExemple4x4() {
        spinN.setValue(4);
        creerGrilles(4);

        // Matrice tridiagonale 4x4 symétrique définie positive
        double dataA[][] = {
            {3.0, 1.0, 0.0, 0.0},
            {1.0, 3.0, 1.0, 0.0},
            {0.0, 1.0, 3.0, 1.0},
            {0.0, 0.0, 1.0, 3.0}
        };
        double dataB[] = {1.0, 0.0, 0.0, 0.0};

        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                modelA.setValueAt(dataA[i][j], i, j);
            }
            modelB.setValueAt(dataB[i], i, 0);
        }
        textOutput.setText("Système tridiagonal 4x4 chargé. Cliquez sur 'RÉSOUDRE'.");
    }

    private void chargerExempleNonSDP() {
        spinN.setValue(2);
        creerGrilles(2);

        double dataA[][] = {
            {1.0, 2.0},
            {2.0, 1.0}
        };
        double dataB[] = {1.0, 1.0};

        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                modelA.setValueAt(dataA[i][j], i, j);
            }
            modelB.setValueAt(dataB[i], i, 0);
        }
        textOutput.setText("Matrice non-SDP chargée (déterminant = -3 < 0). Test d'interdiction de Cholesky.");
    }

    private void resoudreAction() {
        if (tableA.isEditing()) tableA.getCellEditor().stopCellEditing();
        if (tableB.isEditing()) tableB.getCellEditor().stopCellEditing();

        int n = ((Integer) spinN.getValue()).intValue();
        double A[][] = new double[n][n];
        double b[] = new double[n];

        try {
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    Object val = modelA.getValueAt(i, j);
                    if (val == null) throw new Exception("Case vide en A[" + (i + 1) + "][" + (j + 1) + "]");
                    A[i][j] = Double.parseDouble(val.toString());
                }
                Object valB = modelB.getValueAt(i, 0);
                if (valB == null) throw new Exception("Case vide en b[" + (i + 1) + "]");
                b[i] = Double.parseDouble(valB.toString());
            }
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Erreur de saisie : " + ex.getMessage(), "Format invalide", JOptionPane.ERROR_MESSAGE);
            return;
        }

        CholeskyResult res = CholeskyCore.solve(A, b);
        if (!res.applicable) {
            textOutput.setText("ATTENTION :\n" + res.message + "\n\nLa factorisation A = B.B^T ne peut pas être effectuée.");
            JOptionPane.showMessageDialog(this, res.message, "Méthode non applicable", JOptionPane.WARNING_MESSAGE);
        } else {
            textOutput.setText(res.formatDetails(A, b));
        }
    }
}
