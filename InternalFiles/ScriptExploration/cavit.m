clear all
close all


% Parameter:
Rho = 1.0;
Nu  = 1.0;

% Define grid:
nx = 32;
ny = 64;
xq = linspace(0,1,nx); dx = 1.0 / (nx-1);
yq = linspace(0,1,ny); dy = 1.0 / (ny-1);
[X,Y] = meshgrid(xq,yq);

% Initial condition:
P = zeros(size(X));
U = zeros(size(X));
V = zeros(size(X));

In0 = [P(:); U(:); V(:)];
Res = @(In) ResLin(In, X, Y, Rho, Nu, dx, dy);
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton', 'FiniteDifferenceType', 'central', 'OptimalityTolerance', 1e-12, 'HessianApproximation', 'lbfgs', 'MaxFunctionEvaluations', 1e+8);
[Ou, fRes, ~, ~] = fminunc(Res, In0, options);

nn = numel(X);
P = Ou(1:nn);
U = Ou(nn+1:2*nn);
V = Ou(2*nn+1:end);
P = reshape(P, ny, nx);
U = reshape(U, ny, nx);
V = reshape(V, ny, nx);

figure()
contourf(X,Y,P)
figure()
contourf(X,Y,U)
figure()
contourf(X,Y,V)


%% Helper functions:

function [P, U, V] = applyBoundaryCondition(P, U, V, X, Y)
    P( X == 0.0 & Y == 0.0 ) = 0.0;
    U( X == 0.0 & X == 1.0 ) = 0.0;
    U( Y == 1.0 ) = 1.0;
    V( Y == 0.0 & Y == 1.0 ) = 0.0;
end

function Res = Residual(P, U, V, X, Y, Rho, Nu, dx, dy)

    % Simple algorithm:
    [P,U,V] = applyBoundaryCondition(P,U,V,X,Y);
    
    % Compute gradient of velocity and pressure:
    [Px, Py] = gradient(P, dx, dy);
    [Ux, Uy] = gradient(U, dx, dy);
    [Uxx, ~] = gradient(Ux, dx, dy);
    [~, Uyy] = gradient(Uy, dx, dy);
    [Vx, Vy] = gradient(V, dx, dy);
    [Vxx, ~] = gradient(Vx, dx, dy);
    [~, Vyy] = gradient(Vy, dx, dy);

    % Compute residual:
    ResP = Ux + Vy;
    ResU = U.*Ux + V.*Uy + 1/Rho*Px - Nu*(Uxx+Uyy);
    ResV = U.*Vx + V.*Vy + 1/Rho*Py - Nu*(Vxx+Vyy);
    ResT = ResP + ResU + ResV;
    Res = norm(ResT);

end

function Res = ResLin(In, X, Y, Rho, Nu, dx, dy)
    nn = numel(X);
    [ny, nx] = size(X);
    P = In(1:nn);
    U = In(nn+1:2*nn);
    V = In(2*nn+1:end);
    P = reshape(P, ny, nx);
    U = reshape(U, ny, nx);
    V = reshape(V, ny, nx);

    Res = Residual(P, U, V, X, Y, Rho, Nu, dx, dy);
end