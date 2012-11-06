#!/bin/bash

cd ..
cd processed

operateOnMatrices.py -O "X[0] if X[1]=='P' else 'NA'" mas5log2.hgu133plus2hsensgcdf.geneName.TXT mas5calls.hgu133plus2hsensgcdf.geneName.TXT > mas5log2.hgu133plus2hsensgcdf.geneName.P.TXT
pyFilter.py mas5log2.hgu133plus2hsensgcdf.geneName.P.TXT "'NA' not in [2-_1]" > mas5log2.hgu133plus2hsensgcdf.geneName.NoNARows.TXT