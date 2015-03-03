%% En esta sección se cargan dos fotos: cicla y moto 
cristo=imread('data\Cristo.png'); %se guarda la imagen bycicle en la varibale cicla
luis1=imread('data\Luis1.png');%se guarda la imagen motorcycle en la variable moto
figure
imshow(cristo)
figure
imshow(luis1)


%% En esta seccion se aplican filtros PASA ABAJO y PASA ALTO a cada imagen
LPF1=fspecial('gaussian',[10 10], 10);% LPF low pass filter
cristoLPF=imfilter(cristo,LPF1);% se aplica el filtro LPF a la imagen cicla
cristoHPF=cristo-cristoLPF;
figure
imshow(cristoHPF) 

LPF2=fspecial('gaussian',[20 20], 25);% LPF low pass filter
luis1LPF=imfilter(luis1,LPF2);% se aplica el filtro LPF a la imagen moto
figure
imshow(luis1LPF)

HIcl=cristoHPF+luis1LPF;

figure
imshow(HIcl)


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