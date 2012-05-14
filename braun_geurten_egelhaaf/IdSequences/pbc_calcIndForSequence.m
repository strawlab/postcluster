function pInd = pbc_calcIndForSequence (idSequence, nbIds)
% Calculates a 1dim. index corresponding to the given sequence of indices.
% Used by pbc_calcSequenceProbs() to determine a unique index assigned to a
% current sequence in order to store its probability of occurencs.
% Index is calulated by:
% for d=0:len
%   pInd = pInd+((nbIds)^(len-d))*(idSequence(d)-1)
% end
% CALL:     pInd = pbc_calcIndForSequence (idSequence, nbIds)
% GETS:     idSequence   1dim array of ids expected to range from 1 to
%                          nbIds
%           nbIds        number of different occurring ids
% GIVES:    pInd         index of indSequence within an array of size
%                         nbIds^length(idSequence)
% NOTE:     Use function pbc_recalcSequenceFromInd() as reverse function
%           to reconstruct the sequence from an index.
%
% Copyright (C) 2009,  Bart Geurten, Elke Braun, Bielefeld University
%
% This program is free software; you can redistribute it and/or modify 
% it under the terms of the GNU General Public License as published 
% by the Free Software Foundation; either version 2 of the License, 
% or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, 
% but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
% See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License 
% along with this program; if not, write to the Free Software Foundation,
% Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA


% Determine length of sequence and initialize resulting index
len = length(idSequence);
pInd=1;


% calculate the running index for the given idSequence
for d=1:len
   pInd = pInd+((nbIds)^(len-d))*(idSequence(d)-1);
end
  