function pbc_plotStars (features,axisVals,colorflag,varargin)
% Create star plots for the feature sets.
% Each feature set is visualized by a 2D plot, where each feature gets a
% vector within an assigned segment of the plane: Length of the vector is
% determined by the absolute value of the feature.
% CALL:  pbc_plotStars (features,axisVals,colorflag,varargin)
% GET:   features: set of features, row vectors
%        axisVals: 1x4 vector containing the axis values used for each subplot
%        colorflag: 'auto' =Calculate the final colormap by repeating the default colors
%                           until the needed number (dim) is reached
%                   'pub5' = defined color for publications with 5 feature
%                            centroids
%                   'pub6' = defined color for publications with 6 feature
%                            centroids
%                   everything else jet colormap in length of dimensions
%
%         varargin :   'extraSpace' which then has to be followed by the numbers of free
%                             lines. if you want to plot for example 5 features with the
%                             position angles as there would be 6, the command would be
%                             'extraSpace',1
%                       'errorbars' which has to be followd by the (half) errorbar
%                             length to be drawn arround the central point.
%                             Errorbars are expected in same data format
%                             than feature set
%                       'nbColumns' which has to be followed be the nb columns to be
%                             drawn. Per default the nb columns and nb rows
%                             is adjusted to be rather equal.
%
% GIVES: New figure is opened with size(features,1) subplots
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


% Initialise variables and analyse optional input arguments
drawErrors = false;
extraSpace = 0;
nbColumnsSet = false;

for i=1:2:length(varargin)
    if strcmpi(varargin{i},'extraSpace'),
        extraSpace = varargin{i+1};
    else
        if strcmpi(varargin{i},'errorbars'),
            drawErrors = true;
            errors = varargin{i+1};
        else
           if strcmpi(varargin{i},'nbColumns'),
              nbColumnsSet = true;
              nbSubPlotsX = varargin{i+1};
           else
              disp('Unknown input argument')
           end
        end
    end
end

if ((drawErrors==true))
    if((size(features,1) ~= size(errors,1)) || ...
       (size(features,2) ~= size(errors,2)))
      error('Data format for errorbars differs from that of feature set')
      drawErrors = false;
    end
end    


% set default color length and colors
defLen = 5;
colors =hsv(defLen);

% determine nb of feature sets and feature dimension 
[nbFeatureSets, dim] = size(features);

    
% determine the number of subplots in x and y direction dependend on the
% overall number of features
if (~nbColumnsSet)
  nbSubPlotsX = ceil(sqrt(nbFeatureSets));
end
nbSubPlotsY = ceil(nbFeatureSets/nbSubPlotsX);

% Determine, the angle occupied by each feature dimension, by
% dividing the whole circle (2*pi) into (2*(dim+extraSpace)) pieces.
% Two pieces for the ositive and neagtive values for each dimension
% and demanded extraspace.
angle = (2*pi)/(2*(dim+extraSpace));

if strcmp(colorflag,'auto'),
    % Calculate the final colormap by repeating the default colors
    % until the needed number (dim) is reached
    cmap = [];
    if (dim >= defLen)
      r = fix(dim/defLen);
      for i= 1:r
          cmap = [cmap; colors];
      end
    end

    if (mod(dim, defLen) > 0)
      cmap = [cmap; colors(1:mod(dim, defLen),:)]  ;
    end
elseif strcmp(colorflag,'pub5')
    
    cmap = [237  32  36;...
            111 190  68;... 
             35  31  32;...
              0 113 188;...
            251 174  23]./255;  
elseif strcmp(colorflag,'pub6')
    
    cmap = [237  32  36;...
            111 190  68;... 
             35  31  32;...
              0 113 188;...
            251 174  23;...
            204   0 255]./255;  
    
else
    cmap = jet(dim);
end

% set the determined color map for a new figure
figh=figure();
set(figh,'Colormap',cmap)

% plot the feature sets independend from each other into one subplot each
for i=1:nbFeatureSets
  subplot(nbSubPlotsY,nbSubPlotsX,i);
  hold on

  % plot the colored vectors given by the feature values
  for j=1:dim,
    dirVec = [cos((j-1)*angle), sin((j-1)*angle)];
    vec = features(i,j)*dirVec;

    h1 = plot (vec(1),vec(2),'*');
    set(h1, 'Color',cmap(j,:));    
    if(drawErrors)
      h2 = line([0 vec(1)], [0 vec(2)]);
      set(h2, 'Color',cmap(j,:));    
      set(h2, 'LineStyle',':');    
      
      lVec = (features(i,j)-errors(i,j))*dirVec;
      uVec = (features(i,j)+errors(i,j))*dirVec;
      h3 = line([lVec(1) uVec(1)], [lVec(2) uVec(2)]);
      set(h3, 'Color',cmap(j,:));    
    else
      h2 = line([0 vec(1)], [0 vec(2)]);
      set(h2, 'Color',cmap(j,:));
    end
  end
  
  grid on
  hold off
  
  % set the given axis values
  axis equal
  axis(axisVals);
  set(gca,'XTick',get(gca,'YTick'));
  set(gca,'YTick', get(gca,'XTick'));
end;
