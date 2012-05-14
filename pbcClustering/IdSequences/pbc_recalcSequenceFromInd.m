function [seq] = pbc_recalcSequenceFromInd(ind, len, nbIds)
% Recalculates sequence of ids (in the range 1 to nbIds) of length len 
% that corresponds to ind, as coded by 
% pbc_calcIndForSequence() used by pbc_calcSequenceProbs().
% CALL: [seq] = pbc_recalcSequenceFromInd(ind, len, nbIds)
% GETS: ind      int index to be decoded, in the range 1:nbIds^len
%       len      length of id sequence to reconstruct
%       nbIds    nb of different allowed ids
% GIVES:seq      sequence of ids of length len
% NOTE: Use together with pbc_calcSequenceProbs(), pbc_calcIndForSequence()
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


% Initialize resulting sequence of length len with zeros
seq = zeros(1,len);
% Take over starting index into temporary variable
% Correct by one, corresponds to starting with
% index 1 for the calculation within pbc_calcIndForSequence()
pInd = ind-1;
% Calculate sequence of indices
for d=1:len
  % Current step for each index depends on d, and the constant values len and
  % nbIds
  cStep = ((nbIds)^(len-d));
  % Calc current sequence element
  seq(d)= floor(pInd/cStep)+1;
  % Correct the overall index by the nb of steps taken into account for the
  % current sequence element
  pInd = pInd-((seq(d)-1)*cStep);
end
