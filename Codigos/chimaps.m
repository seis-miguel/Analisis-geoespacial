DEM = GRIDobj('./DEM_alos_12.5/DEM_combinado_recortado_remuestreado.tif');
info(DEM);
DEM.Z(DEM.Z==-9999);
DEM = inpaintnans(DEM);
FD = FLOWobj(DEM,'preprocess','carve');
S = STREAMobj(FD,'minarea',1000);
figure
%imageschs(DEM, [], 'colormap',[1 1 1],'colorbar',false);
C = griddedcontour(DEM, [50,50]);
C.Z = bwmorph(C.Z, 'diag');
S = modify(S, 'upstreamto',C);


hold on 
[X,Y] = contour(DEM,[0,0])
%plot(X,Y,'b')
%plot(S,'k','LineWidth',1.0)
hold off
%imagesc(DEM)
% Get drainage basins
D = drainagebasins(FD,S);

% Get NAN mask and dilate t by one pixel.
I = isnan(DEM);
I = dilate(I,ones(3));

% Add border pixels to the mask
I.Z([1 end],:) = true;
I.Z(:,[1 end]) = true;

% Get outlines for each basin
OUTLINES = false(DEM.size);
for r = 1:max(D);
OUTLINES = OUTLINES | bwperim(D.Z == r);
end

% Calculate the fraction that each outline shares with NaN mask
frac = accumarray(D.Z(OUTLINES),I.Z(OUTLINES),[],@mean);

% Grid the fractions
FRAC = GRIDobj(DEM);
FRAC.Z(:,:) = nan;
FRAC.Z(D.Z>0) = frac(D.Z(D.Z>0));
A = flowacc(FD);
%imageschs(DEM,FRAC)
%hold on 
%plot(S,'W')

flowpathapp(FD,DEM,S)
c = chitransform(S,A,'mn',0.4776);
min = 0
max = 15000

imageschs(DEM,[],'colormap',[1 1 1],'colorbar',false,'ticklabel','nice');
hold on
plotc(S,c)
colormap("jet")
clim([0 10000])
colorbar
hold off