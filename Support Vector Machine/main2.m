function [] = main2 ()

fid = fopen('datafile2.txt');
data = textscan(fid, '%f%f%f');

X = data{1};
Y = data{2};
class = data{3};

class1 = zeros(0, 0);
class0 = zeros(0, 0);

idx1 = 0;
idx0 = 0;

for idx = 1 : length(class)
    if abs(class(idx) - 1) < abs(class(idx) - 0)
        idx1 = idx1 + 1;
        class1(1, idx1) = X(idx);
        class1(2, idx1) = Y(idx);
    
    else
        idx0 = idx0 + 1;
        class0(1, idx0) = X(idx);
        class0(2, idx0) = Y(idx);
    end
end

%%%%% Support Vector Machine (SVM) %%%%%
[a0,  b0 ] = svm(X, Y, class,  0);
[a5,  b5 ] = svm(X, Y, class,  5);
[a10, b10] = svm(X, Y, class, 10);

f0xy = @(x,y) x.*a0(1,1) + y.*a0(2,1) + b0 - 1;
g0xy = @(x,y) x.*a0(1,1) + y.*a0(2,1) + b0 + 1;
h0xy = @(x,y) x.*a0(1,1) + y.*a0(2,1) + b0;

f5xy = @(x,y) x.*a5(1,1) + y.*a5(2,1) + b5 - 1;
g5xy = @(x,y) x.*a5(1,1) + y.*a5(2,1) + b5 + 1;
h5xy = @(x,y) x.*a5(1,1) + y.*a5(2,1) + b5;

f10xy = @(x,y) x.*a10(1,1) + y.*a10(2,1) + b10 - 1;
g10xy = @(x,y) x.*a10(1,1) + y.*a10(2,1) + b10 + 1;
h10xy = @(x,y) x.*a10(1,1) + y.*a10(2,1) + b10;

%%%%% Graph Plots %%%%%
figure
subplot(1,3,1)
plot(class1(1,:), class1(2,:), 'r*', 'MarkerSize', 8);
hold on
plot(class0(1,:), class0(2,:), 'b*', 'MarkerSize', 8);
hold on
fimplicit(f0xy, '--k', 'LineWidth', 1.5);
hold on
fimplicit(g0xy, '--k', 'LineWidth', 1.5);
hold on
fimplicit(h0xy, 'k', 'LineWidth', 1.5);
xlim([-0.5 0.5]);
ylim([-0.5 0.5]);
legend('Class 1', 'Class 0', 'location', 'northwest');
title('\gamma = 0');

subplot(1,3,2)
plot(class1(1,:), class1(2,:), 'r*', 'MarkerSize', 8);
hold on
plot(class0(1,:), class0(2,:), 'b*', 'MarkerSize', 8);
hold on
fimplicit(f5xy, '--k', 'LineWidth', 1.5);
hold on
fimplicit(g5xy, '--k', 'LineWidth', 1.5);
hold on
fimplicit(h5xy, 'k', 'LineWidth', 1.5);
xlim([-0.5 0.5]);
ylim([-0.5 0.5]);
legend('Class 1', 'Class 0', 'location', 'northwest');
title('\gamma = 5');

subplot(1,3,3)
plot(class1(1,:), class1(2,:), 'r*', 'MarkerSize', 8);
hold on
plot(class0(1,:), class0(2,:), 'b*', 'MarkerSize', 8);
hold on
fimplicit(f10xy, '--k', 'LineWidth', 1.5);
hold on
fimplicit(g10xy, '--k', 'LineWidth', 1.5);
hold on
fimplicit(h10xy, 'k', 'LineWidth', 1.5);
xlim([-0.5 0.5]);
ylim([-0.5 0.5]);
legend('Class 1', 'Class 0', 'location', 'northwest');
title('\gamma = 10');

sgtitle('Support Vector Machine of dataset2.txt')

end