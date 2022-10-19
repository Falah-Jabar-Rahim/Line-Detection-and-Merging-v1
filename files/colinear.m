function [MergedPL, ColinearIndexes, newMergedLines,...
   NumberOfClusters] = colinear(PL, A, cosColinearLimit, SINMAX)
%
% Description: Fuses colinar primitive segment lines that
%              are close to each other.
 
%=================================================================%
%                                                                 %
% COMPUTER-AIDED RECOGNITION OF                                   %
% MAN-MADE STRUCTURES IN AERIAL PHOTOGRAPHS                       %
%                                                                 %
% Luiz Alberto Cardoso, under supervision of Prof. Neil C. Rowe   %
%                                                                 %
% Department of Computer Science                                  %
% Naval Postgraduate School, September 1999                       %
%                                                                 %
%=================================================================%
 
% Programing Language: Matlab 5.3
% Operational System:  Windows NT 4.0
%
% This file named:    'colinear.m'
 
%-----------------------------------------------------------------%
 
n=size(PL,2);
 
% limit value of differencial angle to be considered colinear:
% global cosColinearLimit
 
% limit value of vertex distance to be considered touching:
global limitDist;
 
thetas=PL(1,:);
cosDiffThetaInBetweenPL=...
  abs(triu((cos(triu(thetas'*ones(1,size(PL,2))...
     -ones(size(PL,2),1)*thetas,1))),1));
    
distanceParameters=PL(2,:);
   diffProjToCenter=  abs(triu(distanceParameters'*ones(1,size(PL,2))...
      -ones(size(PL,2),1)*distanceParameters));
     
MergedPL=PL;
newMergedLines=[];
 
% detect pairs of primitive lines that are approximately paralel
PairsOfParalelPL=find(cosDiffThetaInBetweenPL > cosColinearLimit);
disp([int2str(length(PairsOfParalelPL)) '/' int2str((n*n -n)/2)...
      ' (' num2str(round(1000*length(PairsOfParalelPL)/((n*n -n)/2))/10)...
      '%) pairs of paralel primitive lines found.']);
 
ColinearTouchingPairs=[];
if length(PairsOfParalelPL)>0
   PossiblePairs = PairsOfParalelPL(find(diffProjToCenter(PairsOfParalelPL) < 10));
   disp([int2str(length(PossiblePairs)) '/' int2str(length(PairsOfParalelPL))...
      ' (' num2str(round(1000*length(PossiblePairs)/(length(PairsOfParalelPL)))/10)...
      '%) pairs of possible primitive lines found.']);
 
   % PairsOfParalelPL = PossiblePairs; % these are paralel and not too far (perp.)
 
   if length(PossiblePairs)>0
   [ColinearTouchingPairs,ColinearButNotNecessarilyTouchingPairs]...
      =findTouchingPairs(A, PL, PossiblePairs, n, limitDist, SINMAX);
       % ColinearTouchingPairs=intersect(PairsOfParalelPL,favorablyClosePairs(PL,limitDist));
       disp([int2str(length(ColinearTouchingPairs)) '/' int2str(length(PossiblePairs))...
          ' (' num2str(round(1000*length(ColinearTouchingPairs)/(length(PossiblePairs)))/10)...
          '%) pairs of touching primitive lines found.']);
   end
end
 
ColinearIndexes=[];
if length(ColinearTouchingPairs)>0
   [L1, L2] = ind2sub([n n],ColinearTouchingPairs);
   selectedLines=zeros(1,n);
   selectedLines(L1)=1;
   selectedLines(L2)=1;
   ColinearIndexes=find(selectedLines);
  
   % cluster colinear pairs that touch each other
   S=clusterColinearTouchingPairs(ColinearTouchingPairs,n);
   NumberOfClusters=length(S);
   disp(['Num of Clusters Found: ' int2str(NumberOfClusters)]);
     
   unchangedList=ones(1,n);
   for i=1:NumberOfClusters,
      % disp(['Cluster #' int2str(i) ' = [' int2str(S{i}) ']'])
      [L1, L2] = ind2sub([n n],S{i});
     
       selectedLines=zeros(1,n);
       selectedLines(L1)=1;
       selectedLines(L2)=1;
      indexesOfLinesToBeMerged=find(selectedLines);
      ResultingLine=mergePrimitiveLines(PL(:,indexesOfLinesToBeMerged));
      sizeOfThisCluster=length(indexesOfLinesToBeMerged);
      thetaCluster = PL(1,indexesOfLinesToBeMerged);
            
      % only merge PL's if this cluster is fully connected
      % in the ColinearButNotNecessarilyTouchingPairs set
      AllConnections=[];
      for c1=1:length(L1),
         for c2=1:length(L2),
            if L1(c1) < L2(c2)
               AllConnections=[AllConnections sub2ind([n n],L1(c1),L2(c2))];
            end
         end
      end
     
       unchangedList(indexesOfLinesToBeMerged)=0;
       newMergedLines=[newMergedLines ResultingLine];
   end
   disp([int2str(length(find(unchangedList))) ' PL remain unchanged.']);
   disp([int2str(size(newMergedLines,2)) ' merged PL replaced the clusters.']);
 
   MergedPL=[PL(:,find(unchangedList)) newMergedLines];
else
   NumberOfClusters=0;
end % if length(ColinearTouchingPairs)>0
 
%-----------------------------------------------------------------%
function b=LineInCommon(s,t,n)
%
[L1, L2] = ind2sub([n n],[s t]);
b=(L1(1)==L1(2))|(L1(1)==L2(2))|(L1(2)==L2(1))|(L2(1)==L2(2));
 
%-----------------------------------------------------------------%
function ResultingPL=mergePrimitiveLines(PL)
%
% pixel MSE version based on function 'bestline'
%
n=size(PL,2);
if isempty(PL)
   ResultingPL=PL;
else 
   theta=PL(1,1);
   d=PL(2,1);
   base=PL(3:4,1);
   Center = base' + d*[cos(theta) sin(theta)];
   r=uint8(zeros(round(2*Center) + 1));
  
   for k=1:size(PL,2),
      theta=PL(1,k);
      d=PL(2,k);
      maxI=ceil(max(max(PL(5:6,:))));
      maxJ=ceil(max(max(PL(7:8,:))));
      LineLength=lengthOfPL(PL(:,k));
      for len=0:0.2:LineLength,
      pointNow=round([PL(5,k) PL(7,k)] + len*[-sin(theta) cos(theta)]);
          if (pointNow(1)<=maxI)&(pointNow(2)<=maxJ)&(1<=min(pointNow))
          r(pointNow(1),pointNow(2))=1;
      end
      end
   end
   ResultingPL = bestline(r,Center);
   % =[theta d base(1) base(2) LimitI(1) LimitI(2) LimitJ(1) LimitJ(2)]';
end
 
%-----------------------------------------------------------------%
function S=mergeClustersMarked(OldCluster,clustersToMerge);
% merge clusters marked:
% Eg.: From {S{1} S{2} S{3} S{4} S{5} S{6} S{7}}, marked [2 4 5]: 
%       ==>  S{1}      S{3}           S{6} S{7} SNew,
%            SNew = S{2} U S{4} U S{5}
S={};
i=1;
mergedCluster=[];
for j=1:length(OldCluster),
   if isempty(find(clustersToMerge==j))
      S{i}=OldCluster{j};
      i=i+1;
   else
      mergedCluster=[mergedCluster OldCluster{j}];
   end
end  
if ~isempty(mergedCluster)
   S{i}=sort(mergedCluster);
end
 
%-----------------------------------------------------------------%
function S=clusterColinearTouchingPairs(ColinearTouchingPairs,n)
% cluster colinear pairs that touch each other
 
S{1}=ColinearTouchingPairs(1); % clusters: S{1}, S{2}, ...
for k=2:length(ColinearTouchingPairs),
   included=0;
   clustersToMerge=[];
   i=1;
   while i<=length(S), % test if pertain to any cluster
      j=1;
      touchingInThisCluster=0;
       while j<=length(S{i})&not(touchingInThisCluster),
         if LineInCommon(ColinearTouchingPairs(k),S{i}(j),n)
            touchingInThisCluster=1;
            % mark to merge the clusters
            clustersToMerge = [clustersToMerge i];
            if not(included) %
               S{i} = [S{i} ColinearTouchingPairs(k)];
               included=1;
            end
          end % if Touching(ColinearTouchingPairs(k),S{i}(j))
        
      j=j+1;
      end % while j<=length(S{i})&not(touchingInThisCluster)
      i=i+1;
   end % i<=length(S)
         
   if not(included)
      S{length(S)+1}=ColinearTouchingPairs(k);
   else
      S=mergeClustersMarked(S,clustersToMerge);       
   end % not(included)
end % for k=2:length(ColinearTouchingPairs)
 
%-----------------------------------------------------------------%
function [TouchingPairs, ColinearButNotNecessarilyTouchingPairs]...
   =findTouchingPairs(A, PL, PairsOfParalelPL, n, limitDist, SINMAX)
%
% find pairs of aligned PL that are enough close to each other
% by ONE of their extremities
%
 
R = 1;
 
limitDist2=limitDist*limitDist;
TouchingPairs=[];
ColinearButNotNecessarilyTouchingPairs=[];
 
[P, Q, LostPL] = pixelPL(PL,size(A));
 
for k=1:length(PairsOfParalelPL),
  
   % find lines L1, L2
   [L1, L2] = ind2sub([n n],PairsOfParalelPL(k));
  
   if ((L1==35) & (L2==40))
      flag=1;
   else
      flag=0;
   end
  
   % compute the pixels hit by the endpoints of L1 and L2
   [iP1, jP1] = integerEndPoints(PL, L1, size(A));
   [iP2, jP2] = integerEndPoints(PL, L2, size(A));
              
   % dij = distance(L1Pi, L2Pj)
   d11=sqrt((PL(5,L1)-PL(5,L2))*(PL(5,L1)-PL(5,L2)) + (PL(7,L1)-PL(7,L2))*(PL(7,L1)-PL(7,L2)));
   d22=sqrt((PL(6,L1)-PL(6,L2))*(PL(6,L1)-PL(6,L2)) + (PL(8,L1)-PL(8,L2))*(PL(8,L1)-PL(8,L2)));
   d12=sqrt((PL(5,L1)-PL(6,L2))*(PL(5,L1)-PL(6,L2)) + (PL(7,L1)-PL(8,L2))*(PL(7,L1)-PL(8,L2)));
   d21=sqrt((PL(6,L1)-PL(5,L2))*(PL(6,L1)-PL(5,L2)) + (PL(8,L1)-PL(7,L2))*(PL(8,L1)-PL(7,L2)));
   [dSort,sIndex]=sort([d11 d12 d22 d21]);
   mind=dSort(1);
   % min=d(i,i) => d(j,j) should be max;
   % min=d(i,j) => d(j,i) should be max, i,j in {1,2}
   otherIndex=mod((sIndex(1)-1)+2,4)+1;
  
   % compute which endpoint of L1 and L2 are the ones "touching" each other
   L1g = floor((sIndex(1)-1)/2) + 1;           
   L2g = 1 + ((sIndex(1)==2)|(sIndex(1)==3));
  
   % find all other PL that have an endpoint in their neighborhood
   PLinNeighborhood = union(neighborPL(iP1(L1g), jP1(L1g), P, R),...
                            neighborPL(iP2(L2g), jP2(L2g), P, R));
   OtherPLinNeighborhood = setdiff(PLinNeighborhood, [L1 L2]);
  
   % only proceed with search if both conditions are met
   if (sIndex(4)==otherIndex)&isempty(OtherPLinNeighborhood)
     % disp(num2str(100*k/length(PairsOfParalelPL)));
    
     % posOK=' Good position ';
    
      % hij = perpendicular distance(Lj'Pi, Lj)
      h11 = sigdistoline(PL([5 7],L2)',PL(:,L1)); % dist from L1P2 to L1
      h22 = sigdistoline(PL([6 8],L1)',PL(:,L2)); % dist from L1P2 to L2
      h12 = sigdistoline(PL([5 7],L1)',PL(:,L2)); % dist from L1P1 to L2
      h21 = sigdistoline(PL([6 8],L2)',PL(:,L1)); % dist from L2P2 to L1
  
      Len1=lengthOfPL(PL(:,L1));
      Len2=lengthOfPL(PL(:,L2));
     
      L1withinL2=((h12*h22 <= 0)|((max(abs([h11 h22])) < limitDist)))&... %(Len2 > Len1)))&...
                   ((max(abs([h12/d11 h22/d21])) < SINMAX)|...
                   (max(abs([h12/d12 h22/d22])) < SINMAX));
      L2withinL1=((h11*h21 <= 0)|((max(abs([h11 h21])) < limitDist)))&... %(Len1 > Len2)))&...
                   ((max(abs([h11/d11 h21/d12])) < SINMAX)|...
                   (max(abs([h11/d21 h21/d22])) < SINMAX));    
     
      if L1withinL2|L2withinL1
         ColinearButNotNecessarilyTouchingPairs...
            =[ColinearButNotNecessarilyTouchingPairs PairsOfParalelPL(k)];
         if mind < min([Len1 Len2])       
            TouchingPairs = [TouchingPairs PairsOfParalelPL(k)];
          end % if (mind < min([Len1 Len2]))        
      end % if L1withinL2|L2withinL1
   else
      % posOK=' Bad position ';
   end % if (sIndex(4)==otherIndex)
end % for k=1:length(PairsOfParalelPL),
 
%-----------------------------------------------------------------%
 
function pairs = favorablyClosePairs(PL,limitDist)
 
n=size(PL,2);
limitDist2=limitDist*limitDist;
%
Delta11I=ones(n,1)*PL(5,:) - PL(5,:)'*ones(1,n);
Delta11J=ones(n,1)*PL(7,:) - PL(7,:)'*ones(1,n);
D11=Delta11I.*Delta11I + Delta11J.*Delta11J;
% rem: sqrt(D11(k,k)) = 0, D11 symetric
 
Delta22I=ones(n,1)*PL(6,:) - PL(6,:)'*ones(1,n);
Delta22J=ones(n,1)*PL(8,:) - PL(8,:)'*ones(1,n);
D22=Delta22I.*Delta22I + Delta22J.*Delta22J;
% rem: sqrt(D12(k,k)) = 0, D22 symetric
 
Delta12I=ones(n,1)*PL(5,:) - PL(6,:)'*ones(1,n);
Delta12J=ones(n,1)*PL(7,:) - PL(8,:)'*ones(1,n);
D12=Delta12I.*Delta12I + Delta12J.*Delta12J;
% rem: sqrt(D12(k,k)) = ||L(k)|| D12 potentially not symetric
 
D=zeros(n,n,4);
D(:,:,1)=D11;
D(:,:,2)=D12;
D(:,:,3)=D22;
D(:,:,4)=D12';
[minD,minIndex]=min(D,[],3);
[maxD,maxIndex]=max(D,[],3);
 
otherIndex=mod((minIndex-1)+2,4)+1;
 
pairs=intersect(find(minD<limitDist2),find((maxIndex-otherIndex)==0));
 
%-----------------------------------------------------------------%
% Debug functions
 
function debugShowCluster(S)
%
str='S = {';
for k=1:length(S),
   str=[str ' [' int2str(S{k}) ']'];
end
disp([str ' }'])  
     
 
%=================================================================%
% End of file 'colinear.m'