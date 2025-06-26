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
%CS = STREAMobj2cell(S);
%h1 = subplot(1,2,1);
%hold(h1,'on');
%h2 = subplot(1,2,2);
%hold(h2,'on')
%clrs = jet(189);
%for r=1:numel(CS);
%axes(h1)
%plot(CS{r},'color',clrs(r,:));
%axes(h2)
%plotdz(CS{r},DEM,'color',clrs(r,:));
%end;
%hold(h1,'off')
%hold(h2,'on')
%axis(h1,'image')
%box(h1,'on')
%axis(h2,'image')
%set(h2,'DataAspectRatio',[1 1/16 1])
%box(h2,'on')
%%
%imageschs(DEM)
%hold on 
%plot(CS{188},'k');
%%
%% run knickpointfinder, ensure downstream decreasing elevation (Schwanghart and scherler 2017)
[zs,kp] = knickpointfinder(S,DEM,'tol',30,'split',false);
plotdz(S,DEM)
hold on
plotdz(S,zs)
hold off

%% Plot knickpoints in a map
imageschs(DEM)
hold on 
plot(CS{130},'k');
plot(kp.x,kp.y,'ko','MarkerFaceColor','w')
hold off
%% Plot a longitudinal river profile
plotdz(CS{130},DEM)
hold on
plotdz(CS{130},zs);

plot(kp.distance,kp.z,'ko','MarkerFaceColor','w')
hold off

%%
%% Export as shapefile
%MS = STREAMobj2mapstruct(CS{1});
%shapewrite(MS,'./knickpoints_shapes/streamnet_1');
%MKP = struct('X',num2cell(kp.x),'Y',num2cell(kp.y),'Geometry','Point',...
%    'dz',num2cell(kp.dz));
%shapewrite(MKP,'./knickpoints_shapes/knickpoints_1');

%% Point patterns on stream network (PPS)
P = PPS(CS{130},'pp',kp.IXgrid,'z',DEM);
dz = kp.dz;
imageschs(DEM)
hold on
plot(P)
%%
%imageschs(DEM,[],'colormap','flowcolor','ticklabels','nice')

plot(CS{130},'color',[.7 .7 .7])
hold on
plotpoints(P,'colordata',DEM,'sizedata',dz)
axis equal
h = colorbar;
h.Label.String = 'Elevation [m]';
bubblelegend('Knickpoint height [m]','Location','northwest')
%%
plotdz(P,'colordata',DEM,'sizedata',dz)
h = colorbar;
h.Label.String = "Elevation [m]";
bubblelegend('Knickpoint height [m]','Location','northwest')
%%


%%