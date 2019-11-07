format long;

%Linear spaces for output values
voltage= linspace(10000, 40000, 30000);
f=linspace(10000, 40000, 30000);
R2sense = linspace(10000, 40000, 30000);
C2sense = linspace(10000, 40000, 30000);

%Admittances
G1=1/600;
G2=1/600;
G3=1/1200;

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
T=zeros(9,9);
Tr2=zeros(9,9);
Tc2=zeros(9,9);
B=zeros(9,1);
B(9,1)=1;


for y = 1:1:30000
    S=(2 .* pi .*f(y) .* 1i);
    SL1=1/(S.*L1);
    SL2=1/(S.*L2);
    SL3=1/(S.*L3);
    SL4=1/(S.*L4);
    SL5=1/(S.*L5);
    SC1=S.*C1;
    SC2=S.*C2;
    SC3=S.*C3;
    SC4=S.*C4;
    SC5=S.*C5;
    JW = 2 .* pi .* 25e3;
    %Impedance Matrix
    T = [-G1  G1+SL1    -SL1      0         0       0           0       0           0;
          0   -SL1    SL1+SC1   -SC1        0       0           0       0           0;
          0     0       -SC1 SC1+SL2+SL4  -SL2      0          -SL4     0           0;
          0     0         0     -SL2      SL2+SC2  -SC2         0       0           0;
          0     0         0       0       -SC2  SC2+SC3+SL3     0       0           0;
          0     0         0     -SL4        0       0        SL4+SC4  -SC4          0;
          0     0         0       0         0       0         -SC4 SC4+G2+SL5+SC5   0;
          0     0         0       0         0       0           0      -G2        -G3;
          1     0         0       0         0       0           0       0           0;];
      
    Tr2 =[0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0     -G2^2    0;
          0     0      0       0      0       0      0      G2^2    0;
          0     0      0       0      0       0      0       0      0;];
     
    Tc2 =[0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       S     -S       0      0       0      0;
          0     0      0      -S      S       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;
          0     0      0       0      0       0      0       0      0;];
      
    %Outputs values to array x
    X=T\B;
    Xr2=-T\(Tr2*X);
    Xc2=-T\(Tc2*X);
    
    voltage(y)=X(9);
    
    %Saves sensitivity values to R2sense and C2sense
    R2sense(y)=Xr2(9);
    C2sense(y)=Xc2(9);
end

 dB=20.* log10(voltage);

 %dB of output voltage plot
 subplot(3,2,1); 
 plot (f, abs(dB))
 title('dB of Output Voltage')
 xlabel('Freq(Hz)')
 ylabel('Voltage Gain')
 
 %Phase angle of output voltage
 subplot(3,2,2); 
 plot (f, angle(voltage))
 title('Phase angle of Output Voltage')
 xlabel('Freq(Hz)')
 ylabel('Phase Angle')
 
 %R2 sensitivity graph
 dBR2 = 20.* log10(R2sense);
 subplot(3,2,3)
 plot (f,abs(dBR2))
 title('R2 Sensitivity')
 xlabel('Freq(Hz)')
 
 %R2 sensitivity phase angle graph
 subplot(3,2,5)
 plot (f,angle(R2sense))
 title('R2 Sensitivity Angle')
 xlabel('Freq(Hz)')
 
 %C2 sensitivity graph
 dBC2 = 20.* log10(C2sense);
 subplot(3,2,4)
 plot (f,abs(dBC2))
 title('C2 Sensitivity')
 xlabel('Freq(Hz)')
 
 %C2 sensitivity phase graph
 subplot(3,2,6)
 plot (f,angle(C2sense))
 title('C2 Sensitivity Angle')
 xlabel('Freq(Hz)')