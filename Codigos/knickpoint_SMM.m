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


%% Plot drainage basins



%% run knickpointfinder, ensure downstream decreasing elevation (Schwanghart and scherler 2017)
%[zs,kp] = knickpointfinder(S,DEM,'tol',30,'split',false);
%plotdz(S,DEM)
%hold on
%plotdz(S,zs)
%hold off

%% Plot knickpoints in a map
%imageschs(DEM)
%hold on 
%plot(S,'k');
%plot(kp.x,kp.y,'ko','MarkerFaceColor','w')
%hold off

%% Plot a longitudinal river profile
%plotdz(S,zs);
%hold on 
%plot(kp.distance,kp.z,'ko','MarkerFaceColor','w')
%hold off

%% Plot a longitudinal river profile in chi space
%A = flowacc(FD);
%c = chitransform(S,A,'mn',0.45);
%plotdz(S,DEM,'distance',c);
%hold on 
%[~,locb] = ismember(kp.IXgrid,S.IXgrid);
%ckp = c(locb);
%plot(ckp,kp.z,'ko','MarkerFaceColor','w')
%hold off
%xlabel('\chi [m]')

%% Export as shapefile
%MS = STREAMobj2mapstruct(S);
%shapewrite(MS,'streamnet');
%MKP = struct('X',num2cell(kp.x),'Y',num2cell(kp.y),'Geometry','Point',...
%    'dz',num2cell(kp.dz));
%shapewrite(MKP,'knickpoints');

%% Try mappinapp

%% Try flowpathapp(FD,DEM,S)
flowpathapp(FD,DEM,S)