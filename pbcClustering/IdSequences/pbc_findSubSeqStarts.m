function [startInds] = pbc_findSubSeqStarts (sequence, subSequence)
% Finds given id subsequences within whole sequence and returns
% their starting position/index within the sequence
% CALL:  [startInds] = pbc_findSubSeqStarts (sequence, subSequence)
% GET:   sequence      1d list of ids
%        subSequence   1d list of ids to be identified within
%                      sequence
% GIVES: startInds     1d list of indices where subsequences start within
%                      sequence
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
if (size(sequence,1) < size(sequence,2))
   sequence = sequence';
end
if (size(subSequence,1) < size(subSequence,2))
   subSequence = subSequence';
end

% Generate error, if not 1dim sequence is given, as expected here
if (size(sequence,2) > 1)
   error('Expecting 1dim data for sequence');
end
if (size(subSequence,2) > 1)
   error('Expecting 1dim data for subSequence');
end

% Proof, whether the order of input arguments is correct
if (size(sequence,1) < size(subSequence,1))
   error('Expecting subSequence to be shorter than sequence');
end

% Initialize resulting variable
startInds = [];
% Identify candidate startInds by searching just for the first element of
% subSequence and lateron verify whether the whole subSequence starts there
% or the candidarte has to be rejected.
possibleStartInds=find(sequence==subSequence(1));

% Verify or reject the candidate starting indices by looking for the whole
% subSequence
for i=1:length(possibleStartInds)
    if(possibleStartInds(i)+length(subSequence)-1 <= length(sequence))
        pSi = possibleStartInds(i);
        % Look for differences between sequence at
        % pSi:pSi+length(subSequence)-1 and the given subSequence in order to
        % store or reject pSi
        nbDiffInds=sum(abs(sequence(pSi:(pSi+length(subSequence)-1))-subSequence));
        if(nbDiffInds==0)
            startInds = [startInds;pSi];
        end
    end
end
