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

cimport celllists.cell
from libcpp.vector cimport vector

cdef extern from "qcgrids/supergrid.h" namespace "qcgrids":
    cdef cppclass SupergridPoint:
        SupergridPoint(const double* cart, const double weight, const int index);


    cdef cppclass Supergrid:
        Supergrid(const celllists.cell.Cell& cell, double spacing);

        const vector[SupergridPoint]& grid_array();
        const celllists.cell.Cell* cell();
