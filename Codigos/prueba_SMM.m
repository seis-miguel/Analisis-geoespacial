DEM = GRIDobj('/home/equipo/Documentos/maestria_migue/materias/analisis geoespacial/proyecto/prueba_topotoolbox/DEM_alos_12.5/DEM_combinado_recortado_remuestreado.tif');
imagesc(DEM)
%imageschs(DEM,min(gradient8(DEM),1))
%DEMf = fillsinks(DEM);
%FD = FLOWobj(DEMf);
%A = flowacc(FD);
%imageschs(DEM,dilate(sqrt(A),ones(5)),'colormap',flipud(copper));
%DB = drainagebasins(FD);
%DB = shufflelabel(DB);
%nrDB = numel(unique(DB.Z(:)))-1; % nr of drainage basins
%STATS = regionprops(DB.Z,'PixelIdxList','Area','Centroid');
%imageschs(DEM,DB);
%hold on 
%for run = 1:nrDB;
%    if STATS(run).Area*DB.cellsize^2 > 10e6;
%        [x,y] = ind2coord(DB,...
%            sub2ind(DB.size,...
%            round(STATS(run).Centroid(2)),...
%            round(STATS(run).Centroid(1))));
%        text(x,y,....
%            num2str(round(STATS(run).Area * DB.cellsize^2/1e6)),...
%            'BackgroundColor',[1 1 1]);
%    end
%end
%hold off
%title('drainage basins (numbers refer to drainage basin area in km^2)')
%D = flowdistance(FD);
%imageschs(DEM,D);
%[~,IX] = max([STATS.Area]);
%hist(D.Z(DB.Z == IX),1000);
%xlabel=('distance to outlet [m]');
%ylabel('# cells');
% Calculate flow accumulation
%A = flowacc(FD);
% Note that flowacc returns the number of cells draining
% In a cell. Here we choose a minimum drainage area of 10000 cells.
%W = A>10000;
% Create an instalce of STREAMobj
%S = STREAMobj(FD,W);
% and plot it
%plot(S)
%S = klargestconncomps(S,1)
%plot(S)
% let's plot flow distance along the stream network versus elevation
%plotdz(S,DEM)