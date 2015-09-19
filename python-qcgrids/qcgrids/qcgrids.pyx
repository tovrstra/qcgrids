# -*- coding: utf-8 -*-
# QCGrids is a numerical integration library for quantum chemistry.
# Copyright (C) 2011-2015 Toon Verstraelen
#
# This file is part of QCGrids.
#
# QCGrids is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# QCGrids is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>
#--
'''Python wrapper for the QCGrids library'''


import numpy as np
cimport numpy as np
np.import_array()

cimport supergrid
cimport subgrid

cimport celllists.celllists as celllists

from horton.grid.cext import dot_multi

from cpython.ref cimport PyTypeObject
from libc.string cimport memcpy
from cpython cimport Py_INCREF

cdef extern from "numpy/arrayobject.h":
    object PyArray_NewFromDescr(PyTypeObject* subtype, np.dtype descr,
                                int nd, np.npy_intp* dims, np.npy_intp* strides,
                                void* data, int flags, object obj)


__all__ = ['Supergrid', 'Subgrid']


def check_array_arg(name, arg, expected_shape):
    if not arg.flags['C_CONTIGUOUS']:
        raise TypeError('Argument %s must be C_CONTIHUOUS.' % arg)
    for i, n in enumerate(expected_shape):
        if n >= 0 and arg.shape[i] != n:
            raise TypeError(('Axis %i of argument %s has length %i but while '
                             'expecting %i') % (i, name, arg.shape[i], n))


cdef class Supergrid:
    def __cinit__(self, celllists.Cell cell, double spacing=1):
        self._this = new supergrid.Supergrid(cell._this[0], spacing)

    def __init__(self, celllists.Cell cell, double spacing=1):
        pass

    def __dealloc__(self):
        if self._this != NULL:
            del self._this

    property npoint:
        def __get__(self):
            return self._this.grid_array().size()

    property cell:
        def __get__(self):
            cdef celllists.Cell result = celllists.Cell.__new__(celllists.Cell, initvoid=True)
            result._this = self._this.cell()
            return result

    property grid_array:
        def __get__(self):
            cdef np.npy_intp dims[1]
            dims[0] = self._this.grid_array().size()
            cdef np.dtype dtype = np.dtype([
                ('cart', np.double, 3),
                ('icell', np.intc, 3),
                ('weight', np.double),
                ('index', np.intc),
            ], align=True)
            assert dtype.itemsize == sizeof(subgrid.SupergridPoint)
            Py_INCREF(dtype)
            result = PyArray_NewFromDescr(
                <PyTypeObject*> np.ndarray,
                dtype,
                1,
                dims,
                NULL,
                <void*> self._this.grid_array().data(),
                0,
                None)
            np.set_array_base(result, self)
            return result

    property points:
        def __get__(self):
            return self.grid_array['cart']

    property weights:
        def __get__(self):
            return self.grid_array['weight']



cdef packed struct subgrid_point:
  double cart[3]
  double distance
  double weight
  int index


cdef class Subgrid:
    def __cinit__(self, np.ndarray[double, ndim=1] center not None):
        check_array_arg('center', center, (3,))
        self._this = new subgrid.Subgrid(&center[0])

    def __init__(self, np.ndarray[double, ndim=1] center not None):
        pass

    def __dealloc__(self):
        if self._this != NULL:
            del self._this

    property npoint:
        def __get__(self):
            return self._this.grid_array().size()

    property center:
        def __get__(self):
            cdef np.ndarray[double, ndim=1] center = np.zeros(3, float)
            memcpy(&center[0], self._this.center(), sizeof(double)*3);
            return center

    property grid_array:
        def __get__(self):
            cdef np.npy_intp dims[1]
            dims[0] = self._this.grid_array().size()
            cdef np.dtype dtype = np.dtype([
                ('cart', np.double, 3),
                ('distance', np.double),
                ('weight', np.double),
                ('index', np.intc),
            ], align=True)
            assert dtype.itemsize == sizeof(subgrid.SubgridPoint)
            Py_INCREF(dtype)
            result = PyArray_NewFromDescr(
                <PyTypeObject*> np.ndarray,
                dtype,
                1,
                dims,
                NULL,
                <void*> self._this.grid_array().data(),
                0,
                None)
            np.set_array_base(result, self)
            return result

    property points:
        def __get__(self):
            return self.grid_array['cart']

    property distances:
        def __get__(self):
            return self.grid_array['distance']

    property weights:
        def __get__(self):
            return self.grid_array['weight']

    property indices:
        def __get__(self):
            return self.grid_array['index']

    def append(self, np.ndarray[double, ndim=1] cart not None,
               double distance, double weight, int index):
        check_array_arg('cart', cart, (3,))
        self._this.emplace_back(&cart[0], distance, weight, index);

    def iadd_super(self, np.ndarray[double, ndim=1] super_array not None,
                   np.ndarray[double, ndim=1] sub_array not None):
        check_array_arg('super_array', super_array, (-1,))
        check_array_arg('sub_array', sub_array, (-1,))
        self._this.iadd_super(&super_array[0], &sub_array[0]);

    def take_sub(self, np.ndarray[double, ndim=1] super_array not None,
                 np.ndarray[double, ndim=1] sub_array not None):
        check_array_arg('super_array', super_array, (-1,))
        check_array_arg('sub_array', sub_array, (-1,))
        self._this.take_sub(&super_array[0], &sub_array[0]);

    def integrate(self, *factors):
        args = list(factors)
        args.append(self.weights)
        return dot_multi(args)
