function [] = main1 ()

load('data1.mat', 'A');
load('data1.mat', 'b');
load('data1.mat', 'c');

%%% Optimal Point - CVX
cvx_begin

variable x(100, 1)

g = 0;
for idx = 1 : 500
    g = g + log(b(idx,1) - A(idx,:) * x);
end

p = c' * x - g;

minimize(p)

cvx_end

%%% Exact Line Search
%%%% Initialize Variables
x_exact = zeros(100, 1);
g_exact = 0;
for idx = 1 : 500
    g_exact = g_exact + log(b(idx,1) - A(idx,:) * x_exact);
end
f_exact = c' * x_exact - g_exact;

jdx = 0;

jdx_array = jdx;
f_exact_array = f_exact;

while abs(f_exact - p) > 1
    jdx = jdx + 1;
    
    % Gradient of f
    del_f = 0;
    for idx = 1 : 500
        del_f = del_f + (1 / (b(idx,1) - A(idx,:) * x_exact)) * A(idx,:)';
    end
    del_f = - (c + del_f);
    
    % Exact Line Search
    cvx_begin
    
    variable t
    xx_exact = x_exact + t * del_f;
    g_exact = 0;
    for idx = 1 : 500
        g_exact = g_exact + log(b(idx,1) - A(idx,:) * xx_exact);
    end
    f_exact = c' * xx_exact - g_exact;
    
    minimize(f_exact)
    
    cvx_end

    jdx_array = horzcat(jdx_array, jdx);
    f_exact_array = horzcat(f_exact_array, f_exact);
    x_exact = xx_exact;
end

f_exact_array = f_exact_array - p;
plot(jdx_array, f_exact_array, 'LineWidth', 1.5);
hold on

%%% Backtracking Line Search
x_backtrack = zeros(100, 1);
g_backtrack = 0;
for idx = 1 : 500
    g_backtrack = g_backtrack + log(b(idx,1) - A(idx,:) * x_backtrack);
end
f_backtrack = c' * x_backtrack - g_backtrack;

kdx = 0;

kdx_array = kdx;
f_backtrack_array = f_backtrack;

while abs(f_backtrack - p) > 1
    kdx = kdx + 1;
    
    % Gradient of f
    del_f = 0;
    for idx = 1 : 500
        del_f = del_f + (1 / (b(idx,1) - A(idx,:) * x_backtrack)) * A(idx,:)';
    end
    del_f = - (c + del_f);
    
    % Backtracking Line Search
    t = 1;
    while true
        xx_backtrack = x_backtrack + t * del_f;
        gg_backtrack = 0;
        for idx = 1 : 500
            gg_backtrack = gg_backtrack + log(b(idx,1) - A(idx,:) * xx_backtrack);
        end
        ff_backtrack = c' * xx_backtrack - gg_backtrack;
        
        g_backtrack = 0;
        for idx = 1 : 500
            g_backtrack = g_backtrack + log(b(idx,1) - A(idx,:) * x_backtrack);
        end
        f_backtrack = c' * x_backtrack - g_backtrack;
        
        if ff_backtrack < f_backtrack - 0.1 * t * (del_f' * del_f)
            break
        else
            t = 0.5 * t;
        end
    end
    x_backtrack = xx_backtrack;
    
    kdx_array = horzcat(kdx_array, kdx);
    f_backtrack_array = horzcat(f_backtrack_array, ff_backtrack);
end

f_backtrack_array = f_backtrack_array - p;
plot(kdx_array, f_backtrack_array, 'LineWidth', 1.5);

end