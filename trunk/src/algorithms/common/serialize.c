/**************************************************************************
 *                                                                        *
 *  SPRINT: Simple Parallel R INTerface                                   *
 *  Copyright © 2012 The University of Edinburgh                          *
 *                                                                        *
 *  This program is free software: you can redistribute it and/or modify  *
 *  it under the terms of the GNU General Public License as published by  *
 *  the Free Software Foundation, either version 3 of the License, or     *
 *  any later version.                                                    *
 *                                                                        *
 *  This program is distributed in the hope that it will be useful,       *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the          *
 *  GNU General Public License for more details.                          *
 *                                                                        *
 *  You should have received a copy of the GNU General Public License     *
 *  along with this program. If not, see <http://www.gnu.or/licenses/>.   *
 *                                                                        *
 **************************************************************************/

#include "../../sprint.h"

/* When the serialize.c interface is made available to third party
 * packages this could be pulled entirely into the C layer.  As it is
 * we have to go through the interpreter. */
SEXP serialize_form(SEXP form)
{
    SEXP thunk;
    SEXP ret;
    PROTECT(thunk = allocVector(LANGSXP, 3));
    SETCAR(thunk, install("serialize"));
    SETCADR(thunk, form);
    SETCADDR(thunk, R_NilValue);

    ret = eval(thunk, R_GlobalEnv);
    UNPROTECT(1);
    return ret;
}

/* As above. */
SEXP unserialize_form(SEXP form)
{
    SEXP thunk;
    SEXP ret;
    PROTECT(thunk = allocVector(LANGSXP, 2));
    SETCAR(thunk, install("unserialize"));
    SETCADR(thunk, form);

    ret = eval(thunk, R_GlobalEnv);
    UNPROTECT(1);
    return ret;
}

SEXP getListElement(SEXP list, char *str)
{
  SEXP elmt = R_NilValue;
  SEXP names = getAttrib(list, R_NamesSymbol);
  int i;

  for (i = 0; i < length(list); i++)
    if(strcmp(CHAR(STRING_ELT(names, i)), str) == 0) {
      elmt = VECTOR_ELT(list, i);
      break;
    }
  return elmt;
}

void setListElement(SEXP list, char *str, SEXP value)
{
  SEXP names = getAttrib(list, R_NamesSymbol);
  int i;

  for (i = 0; i < length(list); i++)
    if(strcmp(CHAR(STRING_ELT(names, i)), str) == 0) {
      SET_VECTOR_ELT(list, i, value);
      break;
    }
}
