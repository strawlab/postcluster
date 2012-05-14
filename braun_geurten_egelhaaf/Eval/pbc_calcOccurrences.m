function [relativeOcc] = pbc_calcOccurrences (IDX)
% Calculates relative occurrences for the different ids within the
% cluster assignment data IDX. Calculates occurences for the ids 1 to max(IDX).
% CALL:  [relativeOcc] = pbc_calcOccurrences (IDX)
% GETS:  IDX          1dim index assignment data
% GIVES: relativeOcc  1 dim col vector of length max(IDX) containing the 
%                     relative occurence of the ids, sum(relativeOcc) = 1
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

% Generate col from row vector, if necessary
if (size(IDX,1) < size(IDX,2))
   IDX = IDX';
end

% Generate error, if not 1dim IDX is given, as expected here
if (size(IDX,2) > 1)
   error('Expecting 1dim data');
end
 
% Determine nb of different ids within IDX and initialize the
% resulting arrax appropriately.
nbStates = max(IDX);
relativeOcc = zeros(nbStates,1);

% Count occurences for each id
for i=1:nbStates
    relativeOcc(i) = length(find(IDX==i));
end
% Normalize absolute occurences by the length of the IDX data
relativeOcc=relativeOcc./length(IDX);

