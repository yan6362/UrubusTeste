clc; close all force; clear;
%Fiz este codigo por diversão vai todo mundo tomar no cu, não vou comentar
%e se vira, de nada att Peredo
% Vou dar uma modificada no programa do peredo para calcular o perímetro e
% área das seções de um perfil - Yan
PerfilAsa = 'BIC-C2.dat';
FileIDAsa = fopen(PerfilAsa,'r');
dataAsa = textscan(FileIDAsa,'%f %f','headerlines',1);

corda = 0.44;
pos_longarina = 0.25; % Em porcentagem da corda
pos_viga = 0.80; % Viga que fecha a caixa de torção. [Em porcentagem da corda]

Int = numel(dataAsa{1}); % Número de Pontos no arquivo do perfil
x = dataAsa{1}'; % Vetor x do perfil
% x_fit = 0:0.001:corda;
index = find(x==min(x)); 

xe = corda*dataAsa{1}(1:index); % Coordenada x, dos pontos com y>0
ye = corda*dataAsa{2}(1:index);
xi = corda*dataAsa{1}(index:Int); % Coordenada x, dos pontos com y<0
yi = corda*dataAsa{2}(index:Int);

%% MeanLine %%
% polie = polyfit(xe,ye,numel(xe));
% ye_fit = polyval(polie,x_fit);
% polii = polyfit(xi,yi,numel(xi));
% yi_fit = polyval(polii,x_fit);

% ym = (ye_fit+yi_fit)/2;
% xmean = 0.25*corda;
% ymean = ym(find(x_fit==xmean));
% fprintf('xmean = %f\n',xmean);
% fprintf('ymean = %f\n',ymean);
%%
% Encontrar ponto mais próximo da posição da longarina
[~ , indice_longarina_e] = min(abs(xe - pos_longarina*corda));
[~ , indice_longarina_i] = min(abs(xi - pos_longarina*corda));

xe(indice_longarina_e) = pos_longarina*corda; % Alterando o valor de xe, para q a longarina fique perpendicular.
longarina_xe = xe(indice_longarina_e);
xi(indice_longarina_i) = pos_longarina*corda; % Alterando o valor de xi, para q a longarina fique perpendicular.
longarina_xi = xi(indice_longarina_i);
longarina_ye = ye(indice_longarina_e);
longarina_yi = yi(indice_longarina_i);

[~ , indice_viga_e] = min(abs(xe - pos_viga*corda));
[~ , indice_viga_i] = min(abs(xi - pos_viga*corda));

xe(indice_viga_e) = pos_viga*corda; % Alterando o valor de xe, para q a viga fique perpendicular.
viga_xe = xe(indice_viga_e);
xi(indice_viga_i) = pos_viga*corda; % Alterando o valor de xi, para q a viga fique perpendicular.
viga_xi = xi(indice_viga_i);
viga_ye = ye(indice_viga_e);
viga_yi = yi(indice_viga_i);

% xe = [xe, pos_longarina*corda];

figure(1)
hold on
grid on
axis equal
scatter(xe,ye,15,'filled')
scatter(xi,yi,15,'filled')
% ponto_longarina_e = plot(pos_longarina*corda, ye(indice_longarina_e));
% ponto_longarina_e = (pos_longarina*corda, ye(indice_longarina_e));
plot([longarina_xe, longarina_xi], [longarina_ye, longarina_yi],LineWidth=2);
plot([viga_xe, viga_xi], [viga_ye, viga_yi], LineWidth=2);
plot([xe(1), xi(numel(xi))], [ye(1), yi(numel(yi))], LineWidth=2);

%% Cálculo do perímetro

per_sup = []; % Declarando a variável
per_inf = []; % Declarando a variável

% Perímetro 12o
dxe = diff(xe(indice_longarina_e:numel(xe)));
dxi = diff(xi(1:indice_longarina_i));
dye = diff(ye(indice_longarina_e:numel(xe)));
dyi = diff(yi(1:indice_longarina_i));

per_sup = hypot(dxe, dye); % Distâncias entre cada ponto do perfil
per_inf = hypot(dxi, dyi);

per_12o = sum(per_sup) + sum(per_inf) % Perímetro Total do Perfil

%  Perímetro 12i
per_12i = sqrt((xe(indice_longarina_e) - xi(indice_longarina_i))^2 + (ye(indice_longarina_e) - yi(indice_longarina_i))^2)

% Perímetro 13
dxe = diff(xe(indice_viga_e:indice_longarina_e));
dye = diff(ye(indice_viga_e:indice_longarina_e));

per_13 = sum(hypot(dxe, dye))

% Perímetro 24
dxi = diff(xi(indice_longarina_i:indice_viga_i));
dyi = diff(yi(indice_longarina_i:indice_viga_i));

per_24 = sum(hypot(dxi, dyi))

% Perímetro 34
per_34 = sqrt((xe(indice_viga_e) - xi(indice_viga_i))^2 + (ye(indice_viga_e) - yi(indice_viga_i))^2) % Perímetro da ponta

% Perímetro 35
dxe = diff(xe(1:indice_viga_e));
dye = diff(ye(1:indice_viga_e));

per_35 = sum(hypot(dxe, dye))

% Perímetro 46
dxi = diff(xi(indice_viga_i:numel(xi)));
dyi = diff(yi(indice_viga_i:numel(yi)));

per_46 = sum(hypot(dxi, dyi))

% Perímetro 56
per_56 = sqrt((xe(1) - xi(numel(xi)))^2 + (ye(1) - yi(numel(xi)))^2) % Perímetro da ponta

% Perímetro Total
dxe = diff(xe);
dxi = diff(xi);
dye = diff(ye);
dyi = diff(yi);

per_sup = hypot(dxe, dye);
per_inf = hypot(dxi, dyi);

per_tot = sum(per_sup) + sum(per_inf) + per_56 % Perímetro Total do Perfil

%% Cálculo de áreas

% Área I
xx = [(xe(indice_longarina_e:numel(xe)).'), xi(1:indice_longarina_i).'];
yy = [(ye(indice_longarina_e:numel(xe)).'), yi(1:indice_longarina_i).'];

AI = calcular_area(xx, yy)

% figure(2) % Checar se está tudo ok
% plot(xx, yy)

% Área II
xx = [(xe(indice_viga_e:indice_longarina_e).'), xi(indice_longarina_i:indice_viga_i).'];
yy = [(ye(indice_viga_e:indice_longarina_e).'), yi(indice_longarina_i:indice_viga_i).'];

AII = calcular_area(xx, yy)

% figure(3) % Checar se está tudo ok
% plot(xx, yy)

% Área III
xx = [(xe(1:indice_viga_e).'), xi(indice_viga_i:numel(xi)).'];
yy = [(ye(1:indice_viga_e).'), yi(indice_viga_i:numel(yi)).'];

AIII = calcular_area(xx, yy)

% figure(4) % Checar se está tudo ok
% plot(xx, yy)

xx = [(xe(:).'), xi(:).'];
yy = [(ye(:).'), yi(:).'];

area_tot = calcular_area(xx, yy)
area_tot_test = AI + AII + AIII % Ver se a soma das áreas está batendo

% figure(5) % Checar se está tudo ok
% plot(xx, yy)
%%
function area = calcular_area(x, y)
    % Garantir que o primeiro ponto seja repetido no final para fechar a forma
    x = [x(:); x(1)];
    y = [y(:); y(1)];
    
    % Aplicação da fórmula do polígono de Shoelace
    area = 0.5 * abs(sum(x(1:end-1) .* y(2:end) - x(2:end) .* y(1:end-1)));
end
