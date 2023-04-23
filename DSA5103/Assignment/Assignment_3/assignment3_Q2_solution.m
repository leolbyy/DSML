%% Q2(a)
clear; close all; rng('default'); 
m = 500; n = 1000;
L0 = randn(m,10)*randn(10,n);
S0 = sprandn(m,n,0.05);
M = L0 + S0;
lambda = 1/sqrt(max(m,n));
tic;
[L,S,k] = RobustPCA(M,lambda);
ttime = toc;
fprintf('\nSynthetic data: Iter=%d, Time=%2.1f',k,ttime);
fprintf('\nL error=%2.1e,S error=%2.1e',norm(L - L0,'fro'),norm(S - S0,'fro'));
%% Q2(c)
M = readmatrix('BasketballPlayer.csv');
frame_size = [918,1374];
[m,n]= size(M);
lambda = 1/sqrt(max(m,n));
tic;
[L,S,k,error] = RobustPCA(M,lambda); 
ttime = toc;
fprintf('\nReal data: Iter=%d, Time=%2.1f, r(k)=%2.1e',k,ttime,error);
fprintf('\nrank(L)=%d, nnz(S)=%d',rank(L),nnz(S));
%% Q2(d) plot 20-th frames
to_video = zeros([3,m,n]);
name_list = ["raw","L","S"];
to_video(1,:,:) = M;
to_video(2,:,:) = L;
to_video(3,:,:) = S;
to_video = to_video - min(to_video,[],"all");
to_video = to_video / max(to_video,[],"all");
for i = 1:3
        temp = to_video(i,:,20);
        temp = reshape(temp,frame_size(1),frame_size(2));
        imshow(temp);
        imwrite(temp,sprintf("frame_%d_%s.jpeg",20,name_list(i)));
end
%% Q2(e) make videos
for i = 1:3
    frame_data = to_video(i,:,:);
    VidObj = VideoWriter(name_list(i),'MPEG-4');
    VidObj.FrameRate = 15; % frame rate
    open(VidObj);
    for f = 1:n
        writeVideo(VidObj,reshape(frame_data(1,:,f),frame_size(1),frame_size(2)));
    end
    close(VidObj);
end
close all;
%% main function ADMM for Robust PCA
function [L,S,k,error] = RobustPCA(M,lambda)
sigma = 1/svds(M,1);
tau = 1.618;
[m,n] = size(M);
S = zeros(m,n);
Z = zeros(m,n);
for k = 1:200
    T0 = M - Z/sigma;
    T = T0 - S;
    [U,D,V] = svd(T,'econ'); % economy svd
    d = diag(D);
    gamma = wthresh(d,'s',1/sigma);
    L = U*diag(gamma)*V';
    S = wthresh(T0 - L,'s',lambda/sigma);
    Z = Z + tau*sigma*(L + S - M);
    if k > 1 
        succ_change_L = norm(L - Lold,'fro')/(1 + norm(L,'fro'));
        succ_change_S = norm(S - Sold,'fro')/(1 + norm(S,'fro'));
        error = max(succ_change_L,succ_change_S);
        if  error < 1e-4 
            break; 
        end
    end
    Lold = L; Sold = S;  
    sigma = min(1.1*sigma,1e6);
end
end