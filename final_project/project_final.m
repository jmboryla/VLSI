clear all;
close all;
format long;

%Frequency Scaling and Component Scaling
K = 1200;
w = 25000*2*pi;

%Scaled Admittances
G1=K/600;
G2=K/600;
G3=K/1200;

%Capacitors
C1=7.115e-9;
C2=1.881e-9;
C3=9.538e-9;
C4=4.067e-9;
C5=37.123e-9;

%Inductors
L1=6.084e-3;
L2=23.018e-3;
L3=4.6256e-3;
L4=10.649e-3;
L5=1.166e-3;

%Input and RHS array
T=zeros(17,17);
W=zeros(17,1);
W(17,1) = 1;

D = [];
N = [];
n=10;
s =[];


for l = 0:1:n;
    s(l+1) = exp ((2*pi*l*1i)/(n+1));
end

for l = 1:1:(n+1)
    SL1=(s(l)*L1)*(w/K);
    SL2=(s(l)*L2)*(w/K);
    SL3=(s(l)*L3)*(w/K);
    SL4=(s(l)*L4)*(w/K);
    SL5=(s(l)*L5)*(w/K);
    SC1=s(l)*C1*w*K;
    SC2=s(l)*C2*w*K;
    SC3=s(l)*C3*w*K;
    SC4=s(l)*C4*w*K;
    SC5=s(l)*C5*w*K;
    
    Beta = -1/1000;
    
    T66 = SC2+SC3;
    T88 = SC4+SC5+G2;
    T99 = G2+G3;
  
    
    %Impedance Matrix
        % 1   2   3   4    5    6   7    8   9    10   11  12  13  14  15  16  17 
    T = [G1 -G1   0   0    0    0   0    0   0    0    0   0   0   0   0   0   1; %1
        -G1  G1   0   0    0    0   0    0   0    0    1   0   0   0   0   0   0; %2   
          0   0  SC1 -SC1  0    0   0    0   0    0   -1   0   0   0   0   0   0; %3
          0   0 -SC1 SC1   0    0   0    0   0    0    0   1   0   1   0   0   0; %4
          0   0   0   0   SC2 -SC2  0    0   0    0    0  -1   0   0   0   0   0; %5
          0   0   0   0  -SC2  T66  0    0   0    0    0   0   1   0   0   0   0; %6
          0   0   0   0    0    0  SC4 -SC4  0    0    0   0   0  -1   0   0   0; %7
          0   0   0   0    0    0 -SC4  T88 -G2   0    0   0   0   0   1   0   0; %8
          0   0   0   0    0    0   0   -G2 T99  -G3   0   0   0   0   0   0   0; %9
          0   0   0   0    0    0   0    0  -G3   G3   0   0   0   0   0   1   0; %10
          0   1  -1   0    0    0   0    0   0    0  -SL1  0   0   0   0   0   0; %L1
          0   0   0   1   -1    0   0    0   0    0    0 -SL2  0   0   0   0   0; %L2
          0   0   0   0    0    1   0    0   0    0    0   0 -SL3  0   0   0   0; %L3
          0   0   0   1    0    0  -1    0   0    0    0   0   0 -SL4  0   0   0; %L4
          0   0   0   0    0    0   0    1   0    0    0   0   0   0 -SL5  0   0; %L5
          0   0   0   0    0    0   0    0   1   Beta  0   0   0   0   0   0   0; %OP
          1   0   0   0    0    0   0    0   0    0    0   0   0   0   0   0   0];%E
      
    D(l) = det(T);
    X=T\W;
    N(l) = D(l) * (X(10));
    
end

for j = 0:1:n
    sumN = 0;
    sumD = 0;
    for k = 1:1:(n+1)
        sumN = sumN + N(k)*(1/s(k)^j);
        sumD = sumD + D(k)*(1/s(k)^j);
    end
    num(j+1) = sumN/(n+1);
    den(j+1) = sumD/(n+1);
end

num = real(num);
den = real(den);
num = [0 0 0 num(4) 0 num(6) 0 num(8) 0 0 0];
den = [0 den(2) den(3) den(4) den(5) den(6) den(7) den(8) den(9) den(10) 0];
num = fliplr((num));
den = fliplr((den));

sys = tf(num,den)
P = bodeoptions;
P.PhaseVisible = 'off';


bode(sys,{.4,1.6},P),grid;
