clear all
close all

H = 1.0;
W = 1.0;

% Parameter:
Rho = 1.0;
Nu  = 1.0;

% Define grid:
nx = 32;
ny = 32;
nn = nx*ny;
xq = linspace(0,1,nx); dx = 1.0 / (nx-1);
yq = linspace(0,1,ny); dy = 1.0 / (ny-1);
[XG,YG] = meshgrid(xq,yq);

% Initial condition:
P = zeros(size(XG));
U = zeros(size(XG));
V = zeros(size(XG));
iP = P; iP(:) = 1:nn;
iU = U; iU(:) = nn+1:2*nn;
iV = V; iV(:) = 2*nn+1:3*nn;
Y = PUV2Y( P, U, V);
Res = zeros(3*nn, 1);
Jac = zeros(3*nn,3*nn);

% Apply boundary condition:
Y = PUV2Y(P,U,V);

% Assemble Residual continuity equation:
for i = 2:nx-1
    for j = 2:ny-1
        
        % Retrieve the local velocity component and pressure:
        Pij  = Y(iP(j,i));
        Uij  = Y(iU(j,i));
        Vij  = Y(iV(j,i));
        Pip1 = Y(iP(j,i+1));
        Uip1 = Y(iU(j,i+1));
        Vip1 = Y(iV(j,i+1));
        Pim1 = Y(iP(j,i-1));
        Uim1 = Y(iU(j,i-1));
        Vim1 = Y(iV(j,i-1));
        Pjp1 = Y(iP(j+1,i));
        Ujp1 = Y(iU(j+1,i));
        Vjp1 = Y(iV(j+1,i));
        Pjm1 = Y(iP(j-1,i));
        Ujm1 = Y(iU(j-1,i));
        Vjm1 = Y(iV(j-1,i));
        
        % Assemble continuity equation:
        Res(iP(j,i)) = (Pip1 - 2*Pij + Pim1)/dx^2 + (Pjp1 - 2*Pij + Pjm1)/dy^2 + Rho*( ((Uip1-Uim1)/(2*dx))^2 + 2/(4*dy*dx)*(Ujp1-Ujm1)*(Vip1-Vim1) + ((Vjp1-Vjm1)/(2*dy))^2 );
        Jac(iP(j,i), iP(j,i))   =  - 2/dx^2 - 2/dy^2;
        Jac(iP(j,i), iP(j,i+1)) = 1/dx^2;
        Jac(iP(j,i), iP(j,i-1)) = 1/dx^2;
        Jac(iP(j,i), iP(j+1,i)) = 1/dy^2;
        Jac(iP(j,i), iP(j-1,i)) = 1/dy^2;
        Jac(iP(j,i), iU(j,i+1)) = -(Rho*(2*Uim1 - 2*Uip1))/(4*dx^2);
        Jac(iP(j,i), iU(j,i-1)) = (Rho*(2*Uim1 - 2*Uip1))/(4*dx^2); 
        Jac(iP(j,i), iU(j+1,i)) = -(Rho*(Vim1 - Vip1))/(2*dx*dy);
        Jac(iP(j,i), iU(j-1,i)) = (Rho*(Vim1 - Vip1))/(2*dx*dy);
        Jac(iP(j,i), iV(j,i+1)) = -(Rho*(Ujm1 - Ujp1))/(2*dx*dy);
        Jac(iP(j,i), iV(j,i-1)) = (Rho*(Ujm1 - Ujp1))/(2*dx*dy);
        Jac(iP(j,i), iV(j+1,i)) = -(Rho*(2*Vjm1 - 2*Vjp1))/(4*dy^2);
        Jac(iP(j,i), iV(j-1,i)) = (Rho*(2*Vjm1 - 2*Vjp1))/(4*dy^2);

        % Assemble momemtum-x equation:
        Res(iU(j,i)) = Uij*(Uip1-Uim1)/(2*dx) + Vij*(Ujp1-Ujm1)/(2*dy)+1/Rho*(Pip1-Pim1)/(2*dx)-Nu*( (Uip1-2*Uij+Uim1)/dx^2 + (Ujp1-2*Uij+Ujm1)/dy^2);
        Jac(iU(j,i), iP(j,i+1)) = 1/(2*Rho*dx);
        Jac(iU(j,i), iP(j,i-1)) = -1/(2*Rho*dx);
        Jac(iU(j,i), iU(j,i))   = Nu*(2/dx^2 + 2/dy^2) - (Uim1 - Uip1)/(2*dx);
        Jac(iU(j,i), iU(j,i+1)) = Uij/(2*dx) - Nu/dx^2;
        Jac(iU(j,i), iU(j,i+1)) = - Nu/dx^2 - Uij/(2*dx);
        Jac(iU(j,i), iU(j+1,i)) = Vij/(2*dy) - Nu/dy^2;
        Jac(iU(j,i), iU(j-1,i)) = - Nu/dy^2 - Vij/(2*dy);
        Jac(iU(j,i), iV(j,i))   = -(Ujm1 - Ujp1)/(2*dy);

         % Assemble momemtum-y equation:
        Res(iV(j,i)) = Uij*(Vip1-Vim1)/(2*dx) + Vij*(Vjp1-Vjm1)/(2*dy)+1/Rho*(Pjp1-Pjm1)/(2*dx)-Nu*( (Vip1-2*Vij+Vim1)/dx^2 + (Vjp1-2*Vij+Vjm1)/dy^2);
        Jac(iV(j,i), iP(j+1,i)) = 1/(2*Rho*dx);
        Jac(iV(j,i), iP(j-1,i)) = -1/(2*Rho*dx);
        Jac(iV(j,i), iU(j,i))   = -(Vim1 - Vip1)/(2*dx);
        Jac(iV(j,i), iV(j,i))   = Nu*(2/dx^2 + 2/dy^2) - (Vjm1 - Vjp1)/(2*dy);
        Jac(iV(j,i), iV(j,i+1)) = Uij/(2*dx) - Nu/dx^2;
        Jac(iV(j,i), iV(j,i-1)) = - Nu/dx^2 - Uij/(2*dx);
        Jac(iV(j,i), iV(j+1,i)) = Vij/(2*dy) - Nu/dy^2;
        Jac(iV(j,i), iV(j-1,i)) = - Nu/dy^2 - Vij/(2*dy);


    end
end

% Apply boundary condition:
% 1 - U(Y=1.0) = 1.0;
[ii,jj] = find(YG == 1.0);
ii = iU(ii,jj);
Jac(ii,:) = 0.0; Jac(ii,ii) = 1.0; Res(ii) = 1.0;

% 2 - U(X=0.0 | X=1.0) = 0.0;
[ii,jj] = find(XG == 0.0 | XG == 1.0);
ii = iU(ii,jj);
Jac(ii,:) = 0.0; Jac(ii,ii) = 1.0; Res(ii) = 0.0;

% 3 - V(Y=0.0 | Y=1.0) = 0.0;
[ii,jj] = find(YG == 0.0 | YG == 1.0);
ii = iV(ii,jj);
Jac(ii,:) = 0.0; Jac(ii,ii) = 1.0; Res(ii) = 0.0;

% 4 - P(X=0.0 & Y=0.0) = 0.0;
[ii,jj] = find(XG == 0.0 & YG == 0.0);
ii = iP(jj,ii);
Jac(ii,:) = 0.0; Jac(ii,ii) = 1.0; Res(ii) = 0.0; 

DY = -Jac\Res;

function Y = PUV2Y(P, U, V)
    Y = [P(:); U(:); V(:)];
end

% % Assemble Residual continuity equation: dU/dx + dV/dy = 0
% for i = 2:nx-1
%     for j = 1:ny
%         
%     end
% end