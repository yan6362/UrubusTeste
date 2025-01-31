clc; clear all; close all;

% Programa baseado no livro: AIRCRAFT STRUCTURES BY T.H.G. MEGSON (4th Edition), com a finalidade de calcular a rígidez torsional de um perfil
% [Megson 19.3 - pag 575][Megson 23.3 - pag 630] da Quarta Edição

% Gmanta_carbono = 5*10^9 Gbalsa = 166000000

run("MeanLine.m");

b = 1.22; % Semi-envergadura
p = 0.75; % Porcentagem da corda analisada
z = p*b; % Posição da envergadura a ser analisada [m]

Gref = 27600*10^(6); % N/m2; % Módulo de cisalhamento de referência

% Perímetros [m]
p12O = per_12o;
p12i = per_12i;
p13 = per_13;
p34 = per_34;
p24 = per_24;
p35 = per_35;
p56 = per_56;
p46 = per_46;

% Thickness [m]
t12O = 1*10^(-3); % Bordo de ataque - Balsa 1mm
t12i = 50*10^(-3); % Esp Longarina - Depende do projeto
t13 = 0.1*10^(-3); % Fita
t34 = 2*10^(-3); % Viga que fecha a caixa de torsão - Depende do projeto
t24 = 0.1*10^(-3); % Fita
t35 = 0.1*10^(-3); % Fita
t56 = 2*10^(-3); % Bordo de fuga - Depende do projeto
t46 = 0.1*10^(-3); % Fita

% Módulo de Cisalhamento []
G12O = 166000000; % Bordo de ataque - Balsa 1mm
G12i = 5*10^9; % Longarina - Depende do projeto
G13 = 100; % Fita
G34 = 166000000; % Balsa
G24 = 100; % Fita
G35 = 100; % Fita
G56 = 166000000; % Balsa
G46 = 100; % Fita

%%
% Thickness* [m]
tt12O = G12O*t12O/Gref;
tt12i = G12i*t12i/Gref;
tt13 = G13*t13/Gref;
tt34 = G34*t34/Gref;
tt24 = G24*t24/Gref;
tt35 = G35*t35/Gref;
tt56 = G56*t56/Gref;
tt46 = G46*t46/Gref;

% delta = perimetro/Thickness*
delta12O = p12O/tt12O;
delta12i = p12i/tt12i;
delta13 = p13/tt13;
delta34 = p34/tt34;
delta24 = p24/tt24;
delta35 = p35/tt35;
delta56 = p56/tt56;
delta46 = p46/tt46;

T = 1; % Torque aplicado [N.m]

%   Matriz Principal
A = [-1, (1 / (2 * AI * Gref)) * (delta12O + delta12i), -(1 / (2 * AI * Gref)) * delta12i, 0;
    -1, -(1 / (2 * AII * Gref)) * delta12i, (1 / (2 * AII * Gref)) * (delta12i + delta13 + delta34 + delta24), 0;
    -1, 0,-(1 / (2 * AIII * Gref)) * delta34, (1 / (2 * AIII * Gref)) * (delta35 + delta56 + delta34 + delta46);
    0, 2 * AI, 2 * AII, 2 * AIII];

b = [0, 0, 0, T]';

x = inv(A) * b;

theta = x(1)*z; % Assumindo que theta varia linearmente com z (envergadura)

K = T/theta % Rígidez Torcional

% K = T/x(1)

