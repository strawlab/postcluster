function [qualities] = pbc_calcClusterQuality(C, IDX, SUMD)
% Calculates cluster quality criteria from:
% centroids, assignment of data and sum of inner distances.
% sum of inner distances are taken as given from kmeans 
% (depends on the distance function used there), outer distances
% are calculated by squared euclidean formula.
%
% CALL:  [qualities] = pbc_calcClusterQuality(C, IDX, SUMD)
% GET:   C            contains original centroids (nbclusters row vectors)
%        IDX          contains assignment (given by kmeans), col vector 
%        SUMD         contains sums of inner cluster distances (given by
%                     kmeans), col. vector
% GIVE:  qualities    matrix with 4 columns and nbClusters rows
%                     1. mean inner cluster distance: mean distance between 
%                        members and centroid
%                     2. minimal outer distance: minimal distance between 
%                        centroid to other centroids
%                     3. quality1: difference between distances normed by 
%                        the maximum of both
%                     4. quality2: ration of min outer to mean inner distance
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

if (size(C,1) ~= size(SUMD,1))
  error 'Expecting equal 1st dimension for centroids and inner sums'
end

nbClusters = size(C,1);

% Calculate pairwise distances between centroids (outer distances)
Cdist = zeros(nbClusters,nbClusters);
for i=1:nbClusters-1
  for j=i+1:nbClusters
    Cdist(i,j) = sum((C(i,:)-C(j,:)).^2);
    Cdist(j,i) = Cdist(i,j);
  end
end

%determine the number of members for each cluster
nbClusterMembers = zeros(nbClusters,1);
for i=1:nbClusters
  nbClusterMembers(i) = length(find(IDX==i));
end

% determine the mean inner, minimal outer and the composed criterion for
% each cluster
qualities = zeros(nbClusters,4);
for i=1:nbClusters
  distances = [SUMD(i)/nbClusterMembers(i) min([Cdist(i,1:i-1) Cdist(i,i+1:end)])];
  qualities(i,1) = distances(1);
  qualities(i,2) = distances(2);
  qualities(i,3) = (diff(distances)/max(distances));
  qualities(i,4) = distances(2)/distances(1);
end
