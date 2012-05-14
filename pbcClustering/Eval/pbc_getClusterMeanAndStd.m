function [clusterMean clusterStd] = pbc_getClusterMeanAndStd (clusterData, clusterInd)
% Calculates cluster mean value and std from feature data points in 
% clusterData and assignment data in clusterInd.
% clusterMean corresponds to centroids for k-means, implemented with
% Lloyds algorithm, using squared Euclidean distance.
% CALL:  [clusterMean clusterStd] = pbc_getClusterMeanAndStd (clusterData, clusterInd)
% GETS:  clusterData   feature data points as row vectors: format (n, dim)
%        clusterInd    assignment data containing running index of
%                        appropriate cluster, format (n,1), (k-means IDX)
% GIVES: clusterMean   mean of all data points assigned to one cluster
%                      (nbClusters, dim)
%        clusterStd    std of all data points assigned to one cluster
%                      (nbClusters,dim)
% NOTE:  nbClusters is calculated from max(clusterInd)
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


% First, verify formats of input data
if ((size(clusterData,1) ~= size(clusterInd,1)) || (size(clusterInd,2) ~= 1))
   error('Expecting clusterData and clusterInd to have same length and clusterInd to be 1 dim.');
end

%  Determine nb of different clusters from assignment data
nbClusters = max(clusterInd);

% Initialize resulting data arrays
clusterMean = zeros(nbClusters, size(clusterData,2));
clusterStd =  zeros(nbClusters, size(clusterData,2));

% Determine data assigned to each cluster and calculate mean and std from
% that 
for i=1:nbClusters
   pIData = clusterData(find(clusterInd==i),:);
   clusterMean(i,:) = mean(pIData);
   clusterStd(i,:) = std(pIData);
end
end