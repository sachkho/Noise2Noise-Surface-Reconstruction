#!/bin/bash
PYTHON_EXEC="/opt/conda/envs/tf/bin/python"

echo "DÉMARRAGE DE L'ENTRAÎNEMENT (VERSION COMPATIBLE)..."
mkdir -p output_deep

# On utilise seulement les arguments autorisés
$PYTHON_EXEC -u noise2noise.py --train --dataname chair_noisy --data_dir ./data --CUDA 0 --out_dir ./output_deep --save_idx -1

# On génère le mesh final
$PYTHON_EXEC -u noise2noise.py --dataname chair_noisy --data_dir ./data --CUDA 0 --out_dir ./output_deep --save_idx -1

echo "TERMINÉ !"
