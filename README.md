# Reconstruction de Surfaces 3D : Approche Noise-to-Noise Mapping

Ce dépôt contient l'implémentation du projet de reconstruction de surfaces 3D à partir de nuages de points non orientés et fortement bruités. Ce travail s'appuie sur la méthode Noise-to-Noise Mapping, avec une amélioration spécifique via l'encodage positionnel.

## Objectif du Projet
L'enjeu est de transformer un nuage de points brut (issu d'un capteur LiDAR simulé) en une surface continue et propre, représentée par une fonction de distance signée (SDF). La particularité de cette approche est l'apprentissage non-supervisé : le modèle n'utilise jamais de données de référence propres (Ground Truth).

## Contribution technique : L'Encodage Positionnel

La version originale du modèle utilisant des réseaux MLP classiques souffre d'un biais spectral : le réseau a tendance à lisser excessivement les surfaces, fusionnant les structures fines (comme les lattes de la chaise Adirondack utilisée pour les tests).

### Justification théorique
Pour corriger ce lissage, j'ai implémenté une couche d'encodage harmonique. Avant d'entrer dans le réseau, les coordonnées (x, y, z) sont projetées dans un espace de plus haute dimension à l'aide de fonctions périodiques :

$$\gamma(p) = (\sin(2^0 \pi p), \cos(2^0 \pi p), \dots, \sin(2^{L-1} \pi p), \cos(2^{L-1} \pi p))$$

### Impact sur le modèle
- Augmentation de la dimensionnalité : Avec L=6, le vecteur d'entrée passe de 3 à 39 dimensions.
- Capture des hautes fréquences : Cette transformation permet au réseau de percevoir des variations spatiales plus rapides, facilitant la séparation des structures disjointes et la précision des arêtes.

## Configuration et Installation

Ce projet a été déployé et testé sur Google Cloud Platform (GCP) avec une instance GPU NVIDIA Tesla T4.

### Pré-requis
- Python 3.x
- TensorFlow 1.15 (ou compat v1)
- CUDA et noyaux personnalisés pour la perte EMD (approxmatch)
- Trimesh et Libmcubes (pour l'extraction de maillages)

## Utilisation

### 1. Préparation des données
Générer le nuage de points bruité à partir d'un fichier .off :
```bash
python3 gen_noise.py --input chair.off --output data/chair_noisy.ply
```

### 2. Entraînement
Pour lancer l'apprentissage (configuré à 50 000 itérations) :
```bash
python3 noise2noise.py --train --data_dir ./data --dataname chair_noisy --out_dir ./output_deep --CUDA 0
```
### 3. Test et Extraction (Marching Cubes)
Pour générer le maillage .obj final à partir de la SDF apprise :
```bash
python3 noise2noise.py --data_dir ./data --dataname chair_noisy --out_dir ./output_deep --save_idx -1 --CUDA 0
```
## Structure du dépôt
- noise2noise.py : Script principal incluant l'architecture du réseau et l'implémentation de l'encodage positionnel.
- approxmatch/ : Code source C++/CUDA pour le calcul de l'Earth Mover's Distance (EMD).
- im2mesh/ : Utilitaires pour l'extraction de surfaces par l'algorithme des Marching Cubes.
- data/ : Dossier contenant les nuages de points d'entrée.

## Résultats
Les maillages extraits illustrent l'évolution de la reconstruction selon le seuil d'iso-surface c. L'intégration de l'encodage positionnel a permis d'améliorer la définition topologique par rapport aux premiers tests.
