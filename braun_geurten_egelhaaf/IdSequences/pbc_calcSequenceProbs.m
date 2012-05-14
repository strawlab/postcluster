function [probs] = pbc_calcSequenceProbs (idSequence, len)
% Calculates relative occurrence/probabilities for all different 
% sequences of indices of length len within idSequence
% CALL:     [probs] = pbc_calcSequenceProbs (idSequence, len)
% GETS:     idSequence   1 dim array of ids
%                          expected to range from 1 to nbIds
%           len          length of sequences to encounter
% GIVES:    probs        1 dim array of length nbIds^len containing rel.
%                          occurences/ probabilities for different
%                          sequences of ids of length len.
% NOTE:     probs is not an array of len dimensions but a 1 dim array, where the 
%           probability for a current sequence of indices is stored at index pInd
%           calculated from the current sequence by: pbc_calcIndForSequence() 
%           Use function pbc_recalcSequenceFromInd() to reconstruct the sequence
%           of indces from an index within array probs.
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
if (size(idSequence,1) < size(idSequence,2))
   idSequence = idSequence';
end

% Generate error, if not 1dim sequence is given, as expected here
if (size(idSequence,2) > 1)
   error('Expecting 1dim data');
end

% Determine nb of occurring indices
nbIds = max(idSequence);
% Initialize the appropriate resulting array with zeros
probs = zeros(nbIds^len,1);

% Go through the whole sequence and count the sub-sequences of length len
for i=1:length(idSequence)-(len-1)
  % calculate the index within the probabilities array from the
  % current part of the sequence (index i to i+len-1, length len)
  pInd=pbc_calcIndForSequence (idSequence(i:i+len-1), nbIds);
  % count the current sub sequence at the appropriate index
  probs(pInd) = probs(pInd)+1;
end
% Normalize the counts by the whole number of occurring sub sequences
probs = probs./(length(idSequence)-(len-1));
