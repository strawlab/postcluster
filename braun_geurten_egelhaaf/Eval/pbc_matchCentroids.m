function [mCentroids mCosts minDistEl maxDistEl mCentDist]=pbc_matchCentroids(C)
% Matches several sets of similar centroids by globally optimal pairwise matching
% (Hungarian algorithm) using the function Hungarian()
% CALL: [mCentroids mCosts minDistEl maxDistEl mCentDist]=pbc_matchCentroids(C)
% GET:   C            contains original centroids (nbclusters row vectors, sets listed in 3rd
% GIVE:  mCentroids   matches centroids (3d data)
%        mCosts       costs of matching the mean set to the others
%        minDistEl    mean element (minimal costs for matching it to others)
%        maxDistEl    element with max costs for matching it to others
%        mCentDist    max, mean and std of distances between matches centroids
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


% Initialize variables
[num_cent num_feat num_clust] = size(C);
minSumCost = 1e6;
maxSumCost = -1;
sumCost = 0;

% Do for all sets of centroids: Calculate distances/matching costs and 
% matched centroids from other sets. Determine and store the set that 
% has minimal/maximal distance and matched centroids.
for c=1:num_clust
  % Initialize intermediate variable containing matched cntroids  
  result = zeros(num_cent, num_feat, num_clust);
  % Initialise distance variable containing distances/matching costs
  % for current set of clusters c to all the other sets
  dist = [];
  % Do for all other sets of centroids: determine distance by
  % calculating matching costs and determine matched centroids with
  % respect to current set of centroids c.
  for i=1:num_clust,
    if (c==i)
      result(:,:,i) = C(:,:,i);
    else
      distance_matrix = get_dist(C(:,:,c),C(:,:,i),num_cent);
      [MATCHING,COST] = Hungarian(distance_matrix);
      dist= [dist; COST];
      [row col]= find(MATCHING);
      for j=1:length(row);
        result(row(j),:,i) = C(col(j),:,i);
      end
    end
  end
  % dist contains distances between current set c to all the others,
  % sum up to get the overall distance.
  % Compare this distance value to those of other sets of clusters
  % in order to determine the sets that provides minimal/maximal dist
  % to others (minimal distance == mean set) and store distances and
  % matched centroids, respectively.
  sumCost = sum(dist);
  if (sumCost < minSumCost)
    mCentroids = result;
    mCosts = dist;
    minDistEl = c;
    minSumCost = sumCost;
  end
  if (sumCost > maxSumCost)
      maxDistEl = c;
      maxSumCost = sumCost;
  end
end

% Finally calculate distances (max, mean, std) between mean set
% of centroids to the other matched sets and return
mCentDist = get_cen_dist(mCentroids, minDistEl);


    

% Internal function get_dist() for calculating distance matrix containing
% squared Euclidian distances between entry i of centroids to entry j 
% of centroids2
function dist_mat = get_dist(centroids,centroids2,num_centroids)

dist_mat = ones(num_centroids,num_centroids);
dist_mat = dist_mat.*inf;

for i =1:num_centroids
    for j=1:num_centroids
        diff_C = (centroids2(j,:) -centroids(i,:));
        diff_C = sum(diff_C.^2);
        dist_mat(i,j) = diff_C;
    end
end


% Internal function get_cen_dist() for calculating squared Euclidian
% distances between set of centroid at index compElement in C with all 
% sets of centroids contained in C. Calculate and return max, mean and 
% std from distance list.
function cen_dist = get_cen_dist(C, compElement)

[num_cent num_feat num_clust] = size(C);
cen_dist = [];
for i=1:num_cent
    temp_dist_list = [];
    for j = 1:num_clust
        if (j ~= compElement)
          temp_dist = C(i,:,j) - C(i,:,compElement);
          temp_dist = sum(temp_dist.^2);
          temp_dist_list = [temp_dist_list; temp_dist];
        end
    end
    cen_dist= [cen_dist; max(temp_dist_list) mean(temp_dist_list) std(temp_dist_list)];
end

            

