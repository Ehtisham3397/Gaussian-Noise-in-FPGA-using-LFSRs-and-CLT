%% Data from model composer
U1 = out.U1.Data;
U2 = out.U2.Data;
U3 = out.U3.Data;
U4 = out.U4.Data;
U5 = out.U5.Data;
U6 = out.U6.Data;
U7 = out.U7.Data;
U8 = out.U8.Data;
U9 = out.U9.Data;
U10 = out.U10.Data;
U11 = out.U11.Data;
U12 = out.U12.Data;

%% Gaussian Distribution
G = out.G.Data;

fprintf('Gaussian mean     = %.6f\n',mean(G));
fprintf('Gaussian variance = %.6f\n',var(G));
fprintf('Gaussian std      = %.6f\n',std(G));

%%% Plot of Ideal Gaussain distribution vs the CLT based Noise generation
mu = mean(G);
sigma = std(G);

figure;

histogram(G,100,'Normalization','pdf');
hold on;

x = linspace(-5,5,1000);

pdf_theory = ...
    (1/(sigma*sqrt(2*pi))) .* ...
    exp(-(x-mu).^2/(2*sigma^2));

plot(x,pdf_theory,'LineWidth',2);
grid on;

title('12-Term CLT Gaussian Noise');
xlabel('Amplitude');
ylabel('PDF');

legend('Hardware CLT','Gaussian PDF');
%% 68-95-99.7 Test


P1 = mean(abs(G-mu) <= sigma);
P2 = mean(abs(G-mu) <= 2*sigma);
P3 = mean(abs(G-mu) <= 3*sigma);

fprintf('Within +/-1 sigma = %.3f %%\n',100*P1);
fprintf('Within +/-2 sigma = %.3f %%\n',100*P2);
fprintf('Within +/-3 sigma = %.3f %%\n',100*P3);

%% compare actual variance against theoretical variance
S = U1 + U2 + U3 + U4 + U5 + U6 + ...
    U7 + U8 + U9 + U10 + U11 + U12;

fprintf('Sum mean     = %.6f\n',mean(S));
fprintf('Sum variance = %.6f\n',var(S));

G = S - 6;

fprintf('G mean       = %.6f\n',mean(G));
fprintf('G variance   = %.6f\n',var(G));

%% 12×12 correlation matrix
U = [U1 U2 U3 U4 U5 U6 U7 U8 U9 U10 U11 U12];

R = corrcoef(U);

figure;
imagesc(R);
colorbar;
axis square;

title('Correlation Matrix of U1...U12');
xlabel('LFSR');
ylabel('LFSR');

%% correlation values
Roff = R;
Roff(1:size(Roff,1)+1:end) = 0;

[maxR,idx] = max(abs(Roff(:)));

[row,col] = ind2sub(size(Roff),idx);

fprintf('\n--- 12x12 Correlation ---\n');
fprintf('Maximum absolute off-diagonal correlation = %.6f\n',maxR);
fprintf('Occurred between U%d and U%d\n',row,col);