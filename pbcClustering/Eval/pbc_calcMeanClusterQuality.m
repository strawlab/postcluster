function [qualVal qualStd] = pbc_calcMeanClusterQuality(C, IDX, SUMD)
% Calculates mean quality value for several sets of centroids and 
% assigned data based on calculating individual quality values by
% pbc_calcClusterQuality(). Gives mean of mean values of the sets,
% and std of the mean over sets
% CALL: [qualVal qualStd] = pbc_calcMeanClusterQuality(C, IDX, SUMD)
% GET:   C            contains original centroids (nbclusters row vectors,
%                     sets listed in 3rd
%        IDX          contains assignment (given by kmeans), sets listed in
%                     3rd d 
%        SUMD         contains sums of inner cluster distances (given by
%                     kmeans), sets listed in 3rd d.
% GIVE:  qualVal      mean of mean quality over sets
%        qualStd      std of mean quality over sets
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

if (size(C,3) ~= size(IDX,3) || size(C,3) ~= size(SUMD,3))
  error 'Expecting equal 3rd dimension for input data array'
end

nbFiles = size(C,3);
cqr= [];
for i=1:nbFiles
  currCq = pbc_calcClusterQuality(C(:,:,i), IDX(:,:,i), SUMD(:,:,i));
  cqr = cat(1,cqr,mean(currCq(:,4)));  
end

qualVal = mean(cqr);
qualStd = std(cqr);
