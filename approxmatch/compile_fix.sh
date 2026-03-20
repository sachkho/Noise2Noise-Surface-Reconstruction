# 1. On récupère les chemins de TensorFlow
TF_CFLAGS=$(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_compile_flags()))')
TF_LFLAGS=$(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_link_flags()))')

# 2. On localise nvcc (le compilateur NVIDIA)
NVCC=$(which nvcc)

# 3. Compilation du fichier CUDA (.cu) vers un objet (.cu.o)
$NVCC -std=c++11 -c -o tf_approxmatch_g.cu.o tf_approxmatch_g.cu \
  $TF_CFLAGS -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -D_GLIBCXX_USE_CXX11_ABI=0

# 4. Compilation du fichier C++ (.cpp) et lien final vers la bibliothèque (.so)
g++ -std=c++11 -shared -o tf_approxmatch_so.so tf_approxmatch.cpp tf_approxmatch_g.cu.o \
  $TF_CFLAGS $TF_LFLAGS -fPIC -lcudart -L$(dirname $NVCC)/../lib64 -D_GLIBCXX_USE_CXX11_ABI=0
