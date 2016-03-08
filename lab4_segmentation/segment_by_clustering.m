
% NOTA: Para los m�todos 'hierarchical' y 'watersheds' la variable de entrada
% 'number_of_cluster' no representa el n�mero directo de clusters finales.
% Ver comentarios abajo
% El input rgb_image es el nombre del archivo de la imagen
% El input feature_space es el espacio de colores en string. Ex ('rgb')
% El input clustering_method es el metodo de segmentacion en string. Ex ('kmeans')
% El input number_of_clusters es el numero de segmentaciones

function [my_segmentation clustidx] = segment_by_clustering( rgb_image, feature_space, clustering_method, number_of_clusters)

%%Read image and transform to color space

   img = imread(rgb_image);
   
if strcmp(feature_space,'rgb') == true
    
    img1 = img;
    s = size(img);
    sx = s(1,1);
    sy = s(1,2);
    
    imRsh = double(reshape(img,sx*sy,3));
    imgfeat = imRsh;
    
elseif strcmp(feature_space,'hsv') == true
    
    imghsv = rgb2hsv(img);
    img1 = imghsv;
    s = size(imghsv);
    sx = s(1,1);
    sy = s(1,2);
    imRsh = double(reshape(imghsv,sx*sy,3));
    imgfeat = imRsh;
    
elseif strcmp(feature_space,'lab') == true
    
    imglab = rgb2lab(img);                             %Comando disponible en Matlab 2014b, de no estarlo la funci�n se puede descargar libremente  
    img1 = imglab;
    s = size(imglab);
    sx = s(1,1);
    sy = s(1,2);
    imRsh = double(reshape(imglab,sx*sy,3));
    imgfeat = imRsh;
    
elseif strcmp(feature_space,'rgb+xy') == true
    
    img1 = img;
    s = size(img);
    sx = s(1,1);
    sy = s(1,2);
    cont = s(1,3);
    Mat = zeros(sx*sy,5);
    vecCont1 = zeros(sx*sy,1);
    vecCont2 = zeros(sx*sy,1);
    k = 1;
    
    for i = 1:sy
        j = 1;
        for j = 1:sx
            vecCont1((i-1)*sx+j,1) = j;
            vecCont2((i-1)*sx+j,1) = i;
        end
        k = k + 1;
    end
    
    %vecCont2(:,1) = vecCont1;
    
    for i = 1 : cont
        cmat = img(:,:,i);
        imRsh = reshape(cmat,sx*sy,1);
        Mat(:,i) = imRsh;
    end
    
    Mat(:,4) = vecCont1;
    Mat(:,5) = vecCont2;
    imgfeat = Mat;

elseif strcmp(feature_space,'hsv+xy') == true
    
    imghsv = rgb2hsv(img);
    img1 = imghsv;
    s = size(imghsv);
    sx = s(1,1);
    sy = s(1,2);
    cont = s(1,3);
    Mat = zeros(sx*sy,5);
    vecCont1 = zeros(sx*sy,1);
    vecCont2 = zeros(sx*sy,1);
    k = 1;
    
    for i = 1:sy
        j = 1;
        for j = 1:sx
            vecCont1((i-1)*sx+j,1) = j;
            vecCont2((i-1)*sx+j,1) = i;
        end
        k = k + 1;
    end
    
    %vecCont2(:,1) = vecCont1;
    
    for i = 1 : cont
        cmat = imghsv(:,:,i);
        imRsh = reshape(cmat,sx*sy,1);
        Mat(:,i) = imRsh;
    end
    
    Mat(:,4) = vecCont1;
    Mat(:,5) = vecCont2;
    imgfeat = Mat;
    
elseif strcmp(feature_space,'lab+xy') == true
    
    imglab = rgb2lab(img);
    img1 = imglab;
    s = size(imglab);
    sx = s(1,1);
    sy = s(1,2);
    cont = s(1,3);
    Mat = zeros(sx*sy,5);
    vecCont1 = zeros(sx*sy,1);
    vecCont2 = zeros(sx*sy,1);
    k = 1;
    
    for i = 1:sy
        j = 1;
        for j = 1:sx
            vecCont1((i-1)*sx+j,1) = j;
            vecCont2((i-1)*sx+j,1) = i;
        end
        k = k + 1;
    end
    
    %vecCont2(:,1) = vecCont1;
    
    for i = 1 : cont
        cmat = imglab(:,:,i);
        imRsh = reshape(cmat,sx*sy,1);
        Mat(:,i) = imRsh;
    end
    
    Mat(:,4) = vecCont1;
    Mat(:,5) = vecCont2;
    imgfeat = Mat;
    
else
imgfeat = 'null';
display('espacio inv�lido')

end



%% Clustering method

if strcmp(clustering_method,'kmeans') == true
    
   [cluster_idx, cluster_center] = kmeans(imgfeat,number_of_clusters,'distance','sqEuclidean','Replicates',3);
   pixel_labels = reshape(cluster_idx,sx,sy);

     
end 

if strcmp(clustering_method,'gmm') == true
    
    gm = gmdistribution.fit(imgfeat,number_of_clusters,'regularize',1*exp(-5));  %Comando disponible en Matlab 2012a, en versiones m�s actuales se usa el comando 'fitgmdist'
    cluster_idx = cluster(gm,imgfeat);
    pixel_labels = reshape(cluster_idx,sx,sy);
    
   
   
end 
  
if strcmp(clustering_method,'hierarchical') == true
    
    %imgg = rgb2gray(img1);
    imgP1 = impyramid(img1,'reduce');
    imgP2 = impyramid(imgP1,'reduce');
    A1 = reshape(imgP2,(length(imgP2(:,1,1))*length(imgP2(1,:,1))),3);
    dist = pdist(A1);
    Z = linkage(dist);
    t = cluster(Z,'cutoff',number_of_clusters);                          %La variable de entrada 'number_of_clusters' funciona como umbral de coeficiente de inconsistencia (ver documentaci�n) 
    A2 = reshape(t,length(imgP2(:,1,1)),length(imgP2(1,:,1)));
    imgPex = impyramid(A2,'expand');
    pixel_labels = impyramid(imgPex,'expand');
       
   
      
end 

if strcmp(clustering_method,'watershed') == true
    
    imgg = rgb2gray(img1);
    hy = fspecial('sobel');
    hx = hy';
    Iy = imfilter(double(imgg), hy, 'replicate');
    Ix = imfilter(double(imgg), hx, 'replicate');
    grad = sqrt(Ix.^2 + Iy.^2);
    
    marker = imextendedmin(grad,number_of_clusters);                    % La variable de entrada 'number_of_clusters' funciona como nivel de altura usado para ejecutar el m�todo de m�nimos extendidos 
    ngrad = imimposemin(grad,marker);
    pixel_labels = watershed(ngrad);
       
   
      
end

    
my_segmentation = pixel_labels;
%clustidx = cluster_idx;%pixel_labels;
%my_segmentation = ws;
end