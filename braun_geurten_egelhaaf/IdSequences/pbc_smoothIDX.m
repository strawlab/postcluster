function [sIDX exchangedIds] = pbc_smoothIDX (IDX, trustedLength)
% Smoothes IDX file, index sequences, by identifying subsequences whose 
% lengths are shorter than trustedLength and exchanging the originals ids
% by the ids of the surrounding trusted sequences.
% CALL:  [sIDX exchangedIds] = pbc_smoothIDX (IDX, trustedLength)
% GET:   IDX            1d list of (cluster assignment) ids
%        trustedLength  minimal length of trusted sequences
% GIVES: sIDX           1d list of smoothed ids, eliminated short sequences
%
%        exchangedIds   1d list of changed entries.
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


% Initialize counters and variables
currentCent = IDX(1);
currentLength = 1;
blocs= zeros(length(IDX),2);
blocs(1,1) = 1;
blocInd = 1;

% First run through the data identifies trusted blocs
for i=2:length(IDX)
  if (IDX(i) == currentCent) 
     % within a bloc, increase current length counter
     currentLength= currentLength+1;
  else
     % new bloc starts; was last one of at least trusted length?
    if (currentLength >= trustedLength)
      % Memorize the lengh of the last bloc in col 2 of blocs array
      % and increase the trusted blocs index
      blocs(blocInd,2) = currentLength;
      blocInd = blocInd+1;
    end
    % Memorize the current IDX index at the current trusted blocs
    % index. It is probably a starting index for a new trusted bloc   
    blocs(blocInd,1) = i;
    currentLength = 1;
    currentCent = IDX(i);
  end
end

% Handle the last/current bloc
if (currentLength >= trustedLength)
  blocs(blocInd,2) = currentLength;
else
    blocInd = blocInd-1;
end

% Trusted blocs are identified and described by blocs array.
% Go for filling gaps
nbBlocs = blocInd;

% Initialize resulting arrays
sIDX = zeros(size(IDX));
exchangedIds = [];

% Handle special case of first data entries has to be filled
if (blocs(1,1) > 1)
  fillLen = blocs(1,1)-1;
  sIDX(1:fillLen) =  ones(fillLen,1)*IDX(blocs(1,1));
end;

% Second run through the data/blocs array for copying trusted data and filling gaps
for i=1:nbBlocs
  % determine indizes of trusted bloc i with IDX data and copy it. 
  sInd = blocs(i,1);
  fInd = blocs(i,1)+blocs(i,2)-1;
  sIDX(sInd:fInd) = IDX(sInd:fInd);
  % Fill the gap after bloc i
  if(i < nbBlocs)
     % if there is a following bloc (i+1), use its data also
     if (fInd+1 < blocs(i+1,1))
       fillLen = blocs(i+1,1)-(fInd+1);
       exchangedIds  = [exchangedIds; IDX(fInd+1:blocs(i+1,1)-1)];
       sIDX(fInd+1:fInd+1+floor(fillLen/2)-1) =  ones(floor(fillLen/2),1)*IDX(fInd);
       sIDX(fInd+1+floor(fillLen/2):blocs(i+1,1)-1) = ones(ceil(fillLen/2),1)*IDX(blocs(i+1,1));
     end
  else
     % if it is the last use data of bloc i
     if (fInd < length(IDX))
       fillLen = length(IDX)-fInd;
       exchangedIds  = [exchangedIds; IDX(fInd+1:end)];
       sIDX(fInd+1:end) =  ones(fillLen,1)*IDX(fInd);
     end      
  end;
end;  
  
  
  
  
