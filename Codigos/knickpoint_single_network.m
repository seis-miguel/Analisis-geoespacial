%DEM = GRIDobj('./DEM_alos_12.5/DEM_combinado_recortado_remuestreado.tif');
%DEM.Z(DEM.Z==-9999)
%DEM = inpaintnans(DEM);

%FD = FLOWobj(DEM,'preprocess','carve');
%S = STREAMobj(FD,'minarea',1000);
%S = klargestconncomps(S);
%% Make sure that all outlets have the same elevation
%C = griddedcontour(DEM,[25,25])
%C.Z = bwmorph(C.Z,'diag')
%S = modify(S,'upstreamto',C);

%% Make sure that all drainage basins are complete
%D = drainagebasins(FD,S);

% Get NaN mask and dilate it by one pixel.
%I = isnan(DEM);
%I = dilate(I,ones(3));
% Add border pixels to the mask
%I.Z([1 end],:) = true;
%I.Z(:,[1 end]) = true;
% Get outlines for each basin
%OUTLINES = false(DEM.size);
%for r = 1:max(D);
%OUTLINES = OUTLINES | bwperim(D.Z == r);
%end
% Calculate the fraction that each outline share with the NAN mask
%frac = accumarray(D.Z(OUTLINES),I.Z(OUTLINES),[],@mean);
% Grid the fractions
%FRAC = GRIDobj(DEM);
%FRAC.Z(:,:) = nan;
%FRAC.Z(D.Z>0) = frac(D.Z(D.Z>0));

%S = modify(S,'upstreamto',FRAC<=0.01);

%% Plot the components of the network
z = getnal(S,DEM)


%S = klargestconncomps(S,1);
imageschs(DEM);
%hold on

%hold off
