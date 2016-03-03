
%% En esta sección se cargan dos fotos: cristo redentor, Río, Brasil y Luis
cristo=imread('Cristo.png'); %se guarda la imagen cristo redentor
luis1=imread('Luis1.png');%se guarda la imagen luis1
figure
imshow(cristo)
figure
imshow(luis1)



%% En esta seccion se aplican filtros PASA ABAJO y PASA ALTO a cada imagen

%Primero PASA BAJO a Luis y PASA ALTO a Cristo
LPF1=fspecial('gaussian',[10 10], 10);% LPF low pass filter
cristoLPF=imfilter(cristo,LPF1);% se aplica el filtro LPF a la imagen cristo
cristoHPF=cristo-cristoLPF;
figure
imshow(cristoHPF) 
title('Cristo Pasa Alto')

LPF2=fspecial('gaussian',[20 20], 35);% LPF low pass filter Gaussiana de tamaño 20x20 y desviación de 35
luis1LPF=imfilter(luis1,LPF2);% se aplica el filtro LPF a la imagen Luis
luis1HPF=luis1-luis1LPF;
figure
imshow(luis1LPF)
title('Luis1 Pasa Abajo')

%HI Hybrid Image
%HIcl HYbrid Image cristo-luis
size(cristoHPF)
size(luis1LPF)

HIcl=cristoHPF+imresize(luis1LPF, [470 853]);
figure;
imshow(HIcl); 
title('Cristo Pasa Alto - Luis Pasa Bajo')

%% Segundo PASA BAJO a Cristo y PASA ALTO a Luis
LPF3=fspecial('gaussian',[10 10], 10);% LPF low pass filter
luis2LPF=imfilter(luis1,LPF3);% se aplica el filtro LPF a la imagen luis
luis1HPF=luis1-luis2LPF;
figure
imshow(luis1HPF) 

LPF4=fspecial('gaussian',[20 20], 25);% LPF low pass filter Gaussiana de tamaño 20x20 y desviación de 25
cristo1LPF=imfilter(cristo,LPF4);% se aplica el filtro LPF a la imagen cristo
figure
imshow(cristo1LPF)
%HI Hybrid Image
%HIlc HYbrid Image luis-cristo 
HIlc = imresize(luis1HPF, [470 853])+cristo1LPF;

figure;
imshow(HIlc); title ('Cristo Pasa Bajo - Luis Pasa Alto')

%%
% figure
% subplot(1,5,1) ; imshow(HIcl)


% %% Piramide de imagenes
% 
% T1 = impyramid(HIcl, 'reduce');
% T2 = impyramid(T1, 'reduce');
% T3 = impyramid(T2, 'reduce');
% T4 = impyramid(T3,'reduce');
% figure(1),subplot(1,5,1); imshow(T1,'InitialMagnification',100);
% figure(1),subplot(1,5,2);imshow(T2,'InitialMagnification',100);
% figure(1),subplot(1,5,3); imshow(T3,'InitialMagnification',100);
% figure(1),subplot(1,5,4); imshow(T4,'InitialMagnification',100);
% 
% pyrms = cat(HIcl,T1,T2,T3,T4);
% figure, imshow(pyrms)

%% Piramide de imagenes

    for i = 1 : 5
    I{i} = HIcl(1 : 2*i : end, 1 : 2*i : end,:); 
    end
m = size(I{1}, 1);
newI = I{1};
for i = 2 : numel(I)
    [q,p,~] = size(I{i});
    I{i} = cat(1,repmat(zeros(1, p, 3),[m - q , 1]),I{i});
    newI = cat(2,newI,I{i});
end
figure
imshow(newI)
