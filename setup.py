from setuptools import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy

# On définit uniquement les extensions Cython nécessaires pour im2mesh
extensions = [
    Extension("im2mesh.utils.libmesh.triangle_hash", ["im2mesh/utils/libmesh/triangle_hash.pyx"]),
    Extension("im2mesh.utils.libmise.mise", ["im2mesh/utils/libmise/mise.pyx"]),
    Extension("im2mesh.utils.libsimplify.simplify_mesh", ["im2mesh/utils/libsimplify/simplify_mesh.pyx"]),
    Extension("im2mesh.utils.libvoxelize.voxelize", ["im2mesh/utils/libvoxelize/voxelize.pyx"]),
]

setup(
    name='Noise2NoiseMapping_Utils',
    ext_modules=cythonize(extensions),
    include_dirs=[numpy.get_include()]
)
