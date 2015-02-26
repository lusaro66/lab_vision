function convertidor = y(x);
t=strcat('misc\',x); %t es el nombre compelto de la imagen x que pertenece a la carpeta misc\
r=imread(t);   %Se lee la imágen
name=strcat(t(6:11),'.jpg'); %Se asigna variable nombre concatenando nombre de la imagen con ext jpg
imwrite(r,name)    %Se guarda la imágen con ext jpg

