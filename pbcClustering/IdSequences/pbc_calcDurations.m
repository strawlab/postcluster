 function [allDurations startInds] = pbc_calcDurations(sequence,id)
 % Calculates the length of subsequences of constant id within the whole
 % sequence of indices.
 % CALL:  [allDurations startId] = pbc_calcDurations(sequence,id)
 % GETS:  sequence     Sequence of indices to analyse
 %        id           The current id for calculating the subsequences
 %                     If this parameter is not given, calculate length for 
 %                        all subsequences of constant id       
 % GIVES: allDurations 1 dim col vector containing the subsequence lengths
 %        startInds    1 dim col vector containing the indices within the
 %                       sequence where subsequences start
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

 % Generate error, if not 1dim sequence is given, as expected here
 if (size(sequence,2) > 1)
     error('Expecting 1dim data for sequence');
 end
 
 % Decide about necessary calculations based on input arguments
 if (nargin >= 2)
   % Determine indices of subsequences of index id within sequence
   currInds = find(sequence == id);
   [allDurations startInds] = calcDurationsFromIndLists(currInds);
 else
   % if no id is given, take subsequences of all ids one after the other
   % Note: All indices of array sequence appear within the currInds
   %       variable, but it is not possible just to insert the indices
   %       1:length(sequence) because the following processing searches for
   %       discontinuities within the currInds for determining the
   %       subsequences and their length.
   allDurations=[];
   startInds = [];
   for i =min(sequence):max(sequence)
     currInds = find(sequence == i);
     [idDur idStart] = calcDurationsFromIndLists(currInds);
     allDurations = [allDurations; idDur];
     startInds = [startInds; idStart];
   end
 end
 end
 
 % Internal function calculates durations and startings inds of 
 % continuing index blocs in currIndsList.
 function [idAllDurations idStartInds] = calcDurationsFromIndLists(currIndsList)
 
 % Note: Add non valid ind -1 in front of the index array for the
 %       following diff to work without special treatment for the very first
 %       subsequence
 currIndsList = [-1; currIndsList];
 
 % Determine the closed blocs of indices by searching for non continuing
 % indices within currIndsList.
 % Note: currSeqsStarts has to be corrected by +1 due to the non valid
 %       index at the beginning of currIndsList
 currSeqsStarts = find(diff(currIndsList)>1)+1;
 
 % Determine for each closed bloc/ subsequence the the first entry in currIndsList 
 idStartInds = currIndsList(currSeqsStarts);
 
 % Length of subsequences is given by the length of closed blocs in
 % currIndsList. This is the differences of the starts of the closed blocs.
 % Note: Add first non-valid index at the end of the currSeqsStarts array
 %       for the diff function to work without special handling of the last
 %       bloc
 idAllDurations = diff([currSeqsStarts; length(currIndsList)+1]);
 end
