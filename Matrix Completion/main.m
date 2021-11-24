function [] = main ()

load('matrix_data.mat', 'A');
load('matrix_data.mat', 'Am');

diffnorm = zeros(1, length(Am));

for kdx = 1 : length(Am)
    TF = isnan(Am{kdx});
    
    cvx_begin
    
    variable B(10,10)
    maximize (log_det(B))
    
    subject to
    for idx = 1 : 10
        for jdx = 1 : 10
            if TF(idx, jdx) == 0
                subject to
                B(idx, jdx) == A(idx, jdx)
            end
        end
    end
    
    cvx_end
    
    Am{kdx} = B;
    
    diffnorm(1, kdx) = norm(Am{kdx} - A, 'fro');
end

figure
label = categorical({'A_1', 'A_2', 'A_3', 'A_4', 'A_5'});
b = bar(label, diffnorm);
title('Norm Difference');
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);

text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom')

figure
[X, Y] = meshgrid(1:10, 1:10);

subplot(2, 3, 1);
surf(X, Y, A, 'EdgeColor', 'black', 'FaceColor', [255,100,0]/255, 'FaceAlpha', .5, 'Marker', '.' );
title('Original Matrix');
legend('A');

subplot(2, 3, 2);
C1 = Am{1};
p1 = surf(X, Y, A, 'EdgeColor', 'black', 'FaceColor', [255,100,0]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold on
p2 = surf(X, Y, C1,'EdgeColor', 'black', 'FaceColor', [1, 255, 200]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold off
legend([p1, p2], {'A', 'A_1'});
title('A vs A_1');

subplot(2, 3, 3);
C2 = Am{2};
p1 = surf(X, Y, A, 'EdgeColor', 'black', 'FaceColor', [255,100,0]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold on
p2 = surf(X, Y, C2,'EdgeColor', 'black', 'FaceColor', [1, 255, 200]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold off
legend([p1, p2], {'A', 'A_2'});
title('A vs A_2');

subplot(2, 3, 4);
C3 = Am{3};
p1 = surf(X, Y, A, 'EdgeColor', 'black', 'FaceColor', [255,100,0]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold on
p2 = surf(X, Y, C3,'EdgeColor', 'black', 'FaceColor', [1, 255, 200]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold off
legend([p1, p2], {'A', 'A_3'});
title('A vs A_3');

subplot(2, 3, 5);
C4 = Am{4};
p1 = surf(X, Y, A, 'EdgeColor', 'black', 'FaceColor', [255,100,0]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold on
p2 = surf(X, Y, C4,'EdgeColor', 'black', 'FaceColor', [1, 255, 200]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold off
legend([p1, p2], {'A', 'A_4'});
title('A vs A_4');

subplot(2, 3, 6);
C5 = Am{5};
p1 = surf(X, Y, A, 'EdgeColor', 'black', 'FaceColor', [255,100,0]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold on
p2 = surf(X, Y, C5,'EdgeColor', 'black', 'FaceColor', [1, 255, 200]/255, 'FaceAlpha', .5, 'Marker', '.' );
hold off
legend([p1, p2], {'A', 'A_5'});
title('A vs A_5');

sgtitle('Original Matrix A vs Completed Matrices A_m');
end