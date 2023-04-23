clear; close all; rng('default');
%% generate data
n = 1000;
p = 5000;
fprintf('n = %d, p = %d\n',n,p);
X = randn(n,p); % random feature matrix
X = zscore(X); % standardize columns of X, mean=0, std=1
beta_true = sprandn(p,1,0.05); %  some entries are be zero
Y = X*beta_true + 0.01*randn(n,1);
lambda = 0.1*norm(X'*Y,'inf'); % penalty para
%%
tolerance = 1e-6;
maxiter = 3000;
beta0 = zeros(p,1); % initialization
alpha = 1.5/eigs(X'*X,1); % step size
%% APG
t(1) = 1; t(2) = 1;
for k = 3:maxiter+1
    t(k) = (1 + sqrt(1 + 4*t(k-1)^2))/2;
end
tic;
[beta3,kkt3,iter3,runtime3] = APG(X,Y,lambda,beta0,t,alpha,tolerance,maxiter);
ttime = toc;
fprintf('APG takes %3.2f seconds, %d iterations, %2.2e error\n',ttime,iter3,kkt3(end));
%% APG with restart (every 100 iterations)
restart = 100;
kkt4 = [];
tic;
for j = 1:round(maxiter/restart)
    [beta4,kkt0,~,runtime0] = APG(X,Y,lambda,beta0,t,alpha,tolerance,restart);
    beta0 = beta4;
    kkt4 = [kkt4;kkt0];
    if j > 1
        runtime4 = [runtime4;runtime4(end) + runtime0];
    else
        runtime4 = [runtime0];
    end
    if kkt0(end) < tolerance
        break;
    end
end
ttime = toc;
fprintf('APG-restart takes %3.2f seconds, %d iterations, %2.2e error\n',ttime,length(kkt4),kkt4(end));
%% plot
figure;
semilogy(kkt3);
hold on;
semilogy(kkt4);
set(0,'defaultTextInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');
xlabel('iteration $k$');
ylabel('$\|\beta-S_{\lambda}(\beta - X^T(X\beta - Y))\|$');
tit = sprintf('$n = %d, p = %d$',n,p);
title(tit);
legend({'APG','APG-restart'});
axis square
%% plot
figure;
semilogy(runtime3,kkt3);
hold on;
semilogy(runtime4,kkt4);
xlabel('time');
ylabel('$\|\beta-S_{\lambda}(\beta - X^T(X\beta - Y))\|$');
title(tit);
legend({'APG','APG-restart'});
axis square
%% Accelerated proximal gradient
function [beta,norm_grad,k,runtime] = APG(X,Y,lambda,beta,t,alpha,tolerance,maxiter)
tstart = clock;
norm_grad = zeros(maxiter,1);
runtime = zeros(maxiter,1);
beta_old = beta;
XtX = X'*X;
XtY = X'*Y;
for k = 1:maxiter
    beta_bar = beta + (t(k) - 1)/(t(k+1))*(beta - beta_old);
    beta_new = wthresh(beta_bar - alpha*(XtX*beta_bar - XtY),'s',alpha*lambda);
    norm_grad(k) = norm(beta_new - wthresh(beta_new - (XtX*beta_new - XtY),'s',lambda));
    runtime(k) = etime(clock,tstart);
    beta_old = beta;
    beta = beta_new;
    if norm_grad(k) < tolerance
        norm_grad(k+1:end) = [];
        runtime(k+1:end) = [];
        break;
    end
end
end
