function [diffIdSeq, idChangeInds] = pbc_getDiffIdSequence (idSequence)
% Extracts sequence of changing ids from idSequence by ignoring parts 
% of constant id. 
% CALL:  [diffIdSeq, idChangeInds] = pbc_getDiffIdSequence (idSequence)
% GET:   idSequence    1d list of ids, generally containing sequences of
%                         constant id
% GIVES: diffIdSeq     1d list of ids generated from idSequence by ignoring
%                         sequences of constant id
%        idChangeInds  1d list containing the indices of the elements of
%                         diffIdSeq within idSequence
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

% Determine the indices where ids change
% NOTE: Insert non valid element at the beginning of idSequence to
%       find the very first id and to avoid the necessity to correct for
%       the -1 shift of diff.
idChangeInds = find(diff([-1; idSequence]));

% Take the ids at the position, where changes were determined
diffIdSeq = idSequence(idChangeInds,:);
