function [instabVal instabStd] = pbc_calcCentroidInstability(C)
% Calculates instability value from several sets of centroids by matching 
% and determining distance costs using function pbc_matchCentroids()
% CALL: [instabVal instabStd] = pbc_calcCentroidInstability(C)
% GET:   C            contains original centroids (nbclusters row vectors, sets listed in 3rd
% GIVE:  instabVal    mean matching costs per centroid and feature
%        instabStd    std matching costs per centroid and feature
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

[mCentroids mCosts minDistEl maxDistEl mCentDist] = pbc_matchCentroids(C);

nbClusters = size(C,1);
nbFeatures = size(C,2);
normCosts = mCosts/(nbClusters*nbFeatures);
instabVal = mean(normCosts);
instabStd = std(normCosts);
